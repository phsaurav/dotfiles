---
name: skill-creator
description: Create new skills or modify existing skills for OpenCode. Use when users want to create a skill from scratch, edit an existing skill, or optimize a skill's description for better triggering.
license: MIT
---

## Overview

This skill helps you create and iterate on OpenCode skills. Skills are reusable instructions stored in SKILL.md files that agents can load on demand.

## Skill Structure

```
~/.config/opencode/skills/<skill-name>/
└── SKILL.md
```

The SKILL.md file contains:
1. YAML frontmatter (name, description required)
2. Markdown instructions

## Creating a Skill

### Step 1: Understand Intent

Ask clarifying questions:
1. What should this skill enable the agent to do?
2. When should this skill trigger? (user phrases/contexts)
3. What's the expected workflow or output?
4. Are there existing files or examples to reference?

### Step 2: Choose Location

Skills can be placed in:
- Project: `.opencode/skills/<name>/SKILL.md` (project-specific)
- Global: `~/.config/opencode/skills/<name>/SKILL.md` (user-wide)

Ask the user which location they prefer.

### Step 3: Write the Skill

Draft the SKILL.md with:

**Frontmatter:**
```yaml
---
name: <skill-name>
description: <when to trigger, what it does>
---
```

**Guidelines for frontmatter:**
- `name`: 1-64 chars, lowercase alphanumeric with single hyphens, matches directory name
- `description`: 1-1024 chars, specific enough for correct triggering. Include BOTH what the skill does AND when to use it. Be slightly "pushy" to prevent undertriggering.

**Body content:**
- Keep it under 500 lines ideally
- Use imperative form for instructions
- Explain the "why" behind instructions, not just "MUST" commands
- Include examples when helpful
- Structure with clear headings

### Step 4: Test and Iterate

After creating the skill:
1. Ask the user to test it in a new session (skills are loaded on-demand)
2. Gather feedback on whether it triggered correctly and produced good output
3. Iterate on the description and instructions

## Improving Description Triggering

The `description` field is the primary triggering mechanism. To optimize:

1. **Include trigger contexts**: "Use this skill when the user mentions X, Y, or Z"
2. **Be specific but not narrow**: Cover variations in how users might phrase requests
3. **Avoid undertriggering**: Slightly pushy descriptions work better

Example transformation:
- Weak: "How to create git releases"
- Better: "Create consistent releases and changelogs. Use this skill when preparing a tagged release, mentioning versioning, or asking about changelog generation."

## Modifying Existing Skills

When editing an existing skill:
1. Read the current SKILL.md first
2. Understand what's working and what needs change
3. Make targeted improvements without overhauling unnecessarily
4. Preserve the skill name unless user explicitly wants to rename

## Best Practices

1. **Keep it focused**: One skill per workflow, not overlapping concerns
2. **Explain reasoning**: Help models understand why instructions matter
3. **Use concrete examples**: Abstract instructions are harder to follow
4. **Test edge cases**: Consider variations in user prompts
5. **Document assumptions**: Note any prerequisites or dependencies

## Permission Configuration (Optional)

Tell users they can control skill access in opencode.json:

```json
{
  "permission": {
    "skill": {
      "*": "allow",
      "internal-*": "deny",
      "experimental-*": "ask"
    }
  }
}
```

## Troubleshooting

If a skill doesn't appear:
1. Verify SKILL.md is all caps
2. Check frontmatter has name and description
3. Ensure skill names are unique
4. Check permissions—denied skills are hidden