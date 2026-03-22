import { tool } from "@opencode-ai/plugin"
import { $ } from "bun"

const PRESETS: Record<string, { include: string[]; exclude: string[] }> = {
  code: { 
    include: ["*.ts", "*.tsx", "*.js", "*.jsx", "*.py", "*.go", "*.rs"], 
    exclude: ["*.test.*", "*.spec.*"] 
  },
  tests: { 
    include: ["*_test.*", "*.spec.*", "__tests__/**", "test/**", "tests/**"], 
    exclude: [] 
  },
  configs: { 
    include: ["*.json", "*.yaml", "*.yml", "*.toml", "*.ini"], 
    exclude: ["*lock*", "*.min.*"] 
  },
  docs: { 
    include: ["*.md", "*.rst", "docs/**"], 
    exclude: [] 
  },
}

export default tool({
  description: "Fast ripgrep search with presets.",

  args: {
    query: tool.schema.string().describe("Search query"),
    mode: tool.schema.enum(["content", "files"]).default("content"),
    preset: tool.schema.enum(["code", "tests", "configs", "docs"]).optional(),
    caseSensitive: tool.schema.boolean().default(false),
    regex: tool.schema.boolean().default(false),
    context: tool.schema.number().default(2),
    maxResults: tool.schema.number().default(50),
    cwd: tool.schema.string().optional(),
  },

  async execute(args: any, ctx: any) {
    const baseDir = ctx?.directory || ctx?.worktree || "."
    const dir = args?.cwd ? `${ctx?.worktree}/${args.cwd}` : baseDir
    
    const preset = args?.preset && PRESETS[args.preset]
    
    // Always exclude these
    const alwaysExclude = ["node_modules", ".git", "dist", "build", ".next", "coverage"]
    
    const includeGlobs = preset ? preset.include : []
    const excludeGlobs = preset ? [...alwaysExclude, ...preset.exclude] : alwaysExclude
    
    // Build glob args with single quotes (safer in shell)
    let globArgs = ""
    for (const g of includeGlobs) globArgs += ` -g '${g}'`
    for (const g of excludeGlobs) globArgs += ` -g '!${g}'`
    
    const caseArg = args?.caseSensitive ? "" : "-i"
    const regexArg = args?.regex ? "" : "-F"
    const max = Math.min(args?.maxResults || 50, 200)
    const ctxLines = Math.min(Math.max(args?.context || 2, 0), 5)

    if (args?.mode === "files") {
      const cmd = `rg --files ${globArgs} ${dir} 2>/dev/null | head -${max}`
      const result = await $`sh -c ${cmd}`.text()
      return `${result || "No files found"}`
    }

    // content mode - escape single quotes in query
    const query = (args?.query || "").replace(/'/g, "'\"'\"'")
    const cmd = `rg ${regexArg} ${caseArg} -n -C ${ctxLines} ${globArgs} -- '${query}' ${dir} 2>/dev/null | head -${max}`
    const result = await $`sh -c ${cmd}`.text()
    return `${result || "No matches found"}`
  },
})