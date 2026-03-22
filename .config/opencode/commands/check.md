---
description: Check codebase for lint/test issues
agent: general
---

Check the codebase for lint errors, syntax issues, and test failures.

Steps to follow:
1. Check for linting issues - look for package.json scripts or config files:
   - Look for "lint", "lint:check", "typecheck" scripts
   - Check for .eslintrc, .prettierrc, tsconfig.json, ruff.toml, etc.
   - Run appropriate linter if available

2. Run syntax/type checks if available:
   - Check for TypeScript: npx tsc --noEmit or npm run typecheck
   - Check for Python: ruff check or pylint
   - Check for other language-specific linters

3. Run tests if available:
   - Check for package.json "test" script
   - Check for pytest, jest, vitest, or other test frameworks
   - Run tests and report any failures

4. Look for common issues:
   - Unused imports or variables
   - TODO/FIXME comments that might indicate incomplete work
   - Console.log or debug statements left in code
   - Security concerns (hardcoded secrets, unsafe operations)

5. Report findings as a summary:
   - List all issues found by category
   - Highlight critical issues
   - Suggest fixes where obvious

Return a clear PASS or FAIL status with the summary.