import { tool } from "@opencode-ai/plugin"
import path from "path"

const PRESETS = {
  code: {
    includeGlobs: ["src/**", "app/**", "lib/**", "packages/**"],
    excludeGlobs: ["**/*.test.*", "**/*.spec.*", "**/__tests__/**"],
  },
  tests: {
    includeGlobs: ["test/**", "tests/**", "__tests__/**", "**/*.test.*", "**/*.spec.*"],
    excludeGlobs: [],
  },
  configs: {
    includeGlobs: ["*.json", "*.yaml", "*.yml", "*.toml", "*.ini", ".env*"],
    excludeGlobs: ["package-lock.json", "pnpm-lock.yaml", "yarn.lock"],
  },
  docs: {
    includeGlobs: ["docs/**", "*.md", "README*"],
    excludeGlobs: ["node_modules/**"],
  },
}

const DEFAULT_EXCLUDES = [
  "node_modules/**",
  "dist/**",
  "build/**",
  ".next/**",
  "coverage/**",
  "vendor/**",
  "**/*.min.*",
  "**/*.generated.*",
  "pnpm-lock.yaml",
  "package-lock.json",
  "yarn.lock",
  ".git/**",
  "**/*.log",
]

const FILE_TYPE_MAP: Record<string, string> = {
  ts: "typescript",
  tsx: "typescript",
  js: "js",
  jsx: "js",
  py: "py",
  rs: "rust",
  go: "go",
  java: "java",
  rb: "ruby",
  php: "php",
  c: "c",
  cpp: "cpp",
  h: "c",
  hpp: "cpp",
  cs: "csharp",
  swift: "swift",
  kt: "kotlin",
  scala: "scala",
  lua: "lua",
  sh: "shell",
  bash: "shell",
  zsh: "shell",
}

export default tool({
  description: `Search codebase using ripgrep with structured JSON output.

Supports two modes:
- "content": Search inside file contents (default)
- "files": Search file paths/names only

Use presets for common searches:
- "code": Source code only (src, app, lib, packages)
- "tests": Test files only
- "configs": Configuration files
- "docs": Documentation files

Returns structured results with file paths, line numbers, snippets, and match information.`,

  args: {
    query: tool.schema.string().describe("Search query (literal string or regex depending on 'regex' param)"),
    mode: tool.schema.enum(["content", "files"]).default("content").describe("Search mode: 'content' searches inside files, 'files' searches file paths/names"),
    preset: tool.schema.enum(["", "code", "tests", "configs", "docs"]).optional().describe("Use preset include/exclude patterns"),
    caseSensitive: tool.schema.boolean().default(false).describe("Case-sensitive search"),
    word: tool.schema.boolean().default(false).describe("Match whole words only"),
    regex: tool.schema.boolean().default(false).describe("Treat query as regex pattern"),
    includeGlobs: tool.schema.array(tool.schema.string()).optional().describe("Glob patterns to include (e.g., ['src/**', '*.ts'])"),
    excludeGlobs: tool.schema.array(tool.schema.string()).optional().describe("Glob patterns to exclude (e.g., ['dist/**', '*.min.*'])"),
    fileTypes: tool.schema.array(tool.schema.string()).optional().describe("File types to search (e.g., ['ts', 'tsx', 'js'])"),
    contextLines: tool.schema.number().min(0).max(5).default(0).describe("Lines of context before/after match"),
    maxResults: tool.schema.number().min(1).max(100).default(20).describe("Maximum results to return"),
    cwd: tool.schema.string().optional().describe("Working directory (defaults to session directory)"),
  },

  async execute(args, context) {
    const workDir = args.cwd ? path.resolve(context.worktree, args.cwd) : context.worktree
    const resolvedWorkDir = path.resolve(workDir)

    if (!resolvedWorkDir.startsWith(context.worktree)) {
      return JSON.stringify({ error: "Invalid working directory: must be inside workspace" }, null, 2)
    }

    try {
      if (args.mode === "files") {
        return await searchFiles(args, resolvedWorkDir)
      } else {
        return await searchContent(args, resolvedWorkDir)
      }
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : String(error)
      return JSON.stringify({ error: errorMessage }, null, 2)
    }
  },
})

async function searchFiles(args: Record<string, any>, workDir: string): Promise<string> {
  const includeGlobs = buildIncludeGlobs(args)
  const excludeGlobs = buildExcludeGlobs(args)

  const rgArgs = ["--files"]
  
  for (const pattern of includeGlobs) {
    rgArgs.push("-g", pattern)
  }
  for (const pattern of excludeGlobs) {
    rgArgs.push("-g", `!${pattern}`)
  }

  const query = args.query.toLowerCase()
  
  const result = await runRipgrep(rgArgs, workDir)
  const lines = result.trim().split("\n").filter(Boolean)
  
  const matchedFiles = lines
    .map(file => ({
      file: file,
      basename: path.basename(file),
    }))
    .filter(item => item.basename.toLowerCase().includes(query))
    .slice(0, args.maxResults || 20)

  const output = {
    query: args.query,
    mode: "files",
    totalMatches: matchedFiles.length,
    truncated: lines.filter(line => line.toLowerCase().includes(query)).length > matchedFiles.length,
    results: matchedFiles.map(item => ({ file: item.file })),
  }

  return JSON.stringify(output, null, 2)
}

async function searchContent(args: Record<string, any>, workDir: string): Promise<string> {
  const includeGlobs = buildIncludeGlobs(args)
  const excludeGlobs = buildExcludeGlobs(args)

  const rgArgs = ["--json"]
  
  if (!args.caseSensitive) {
    rgArgs.push("-i")
  }
  
  if (args.word) {
    rgArgs.push("-w")
  }
  
  if (!args.regex) {
    rgArgs.push("-F")
  }
  
  if (args.contextLines && args.contextLines > 0) {
    rgArgs.push("-C", String(args.contextLines))
  }
  
  for (const pattern of includeGlobs) {
    rgArgs.push("-g", pattern)
  }
  for (const pattern of excludeGlobs) {
    rgArgs.push("-g", `!${pattern}`)
  }
  
  if (args.fileTypes && args.fileTypes.length > 0) {
    for (const ft of args.fileTypes) {
      const mappedType = FILE_TYPE_MAP[ft] || ft
      rgArgs.push("-t", mappedType)
    }
  }
  
  rgArgs.push("--", args.query)

  const result = await runRipgrep(rgArgs, workDir)
  const parsed = parseRipgrepJson(result, args.maxResults || 20)

  return JSON.stringify(parsed, null, 2)
}

function buildIncludeGlobs(args: Record<string, any>): string[] {
  const globs: string[] = []
  
  if (args.preset && PRESETS[args.preset as keyof typeof PRESETS]) {
    globs.push(...PRESETS[args.preset as keyof typeof PRESETS].includeGlobs)
  }
  
  if (args.includeGlobs) {
    globs.push(...args.includeGlobs)
  }
  
  return globs
}

function buildExcludeGlobs(args: Record<string, any>): string[] {
  const globs: string[] = [...DEFAULT_EXCLUDES]
  
  if (args.preset && PRESETS[args.preset as keyof typeof PRESETS]) {
    globs.push(...PRESETS[args.preset as keyof typeof PRESETS].excludeGlobs)
  }
  
  if (args.excludeGlobs) {
    globs.push(...args.excludeGlobs)
  }
  
  return globs
}

async function runRipgrep(args: string[], cwd: string): Promise<string> {
  try {
    const result = await Bun.$`rg ${args}`.cwd(cwd).quiet()
    return result.stdout.toString()
  } catch (error: any) {
    if (error.exitCode === 1) {
      return ""
    }
    throw error
  }
}

function parseRipgrepJson(output: string, maxResults: number): Record<string, any> {
  const lines = output.trim().split("\n").filter(Boolean)
  const results: Record<string, any>[] = []
  lettotalMatches = 0
  
  for (const line of lines) {
    try {
      const parsed = JSON.parse(line)
      
      if (parsed.type === "match") {
        totalMatches++
        
        if (results.length < maxResults) {
          const data = parsed.data
          const match: Record<string, any> = {
            file: data.path.text,
            line: data.line_number,
            column: data.submatches[0]?.start || 0,
            match: data.lines.text.trim(),
            snippet: data.lines.text.trim(),
          }
          
          if (data.submatches && data.submatches.length > 0) {
            match.submatches = data.submatches.map((sm: any) => ({
              match: sm.match.text,
              start: sm.start,
              end: sm.end,
            }))
          }
          
          results.push(match)
        }
      }
    } catch {
      // Skip unparseable lines
    }
  }
  
  return {
    query: "",
    mode: "content",
    totalMatches,
    truncated: totalMatches > maxResults,
    results,
  }
}