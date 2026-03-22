---
description: Create a PR from current branch
agent: general
---

Create a pull request for the current branch. The root branch defaults to "main" but can be specified as an argument.

Usage: /create-pr [root-branch]

Steps to follow:
1. Determine the root branch (use argument if provided, otherwise default to "main")
2. Get current branch name using git branch --show-current
3. Run the /check command to check for issues (syntax, lint, tests)
4. If issues found, report them and stop - do not create PR
5. Get all commits between root branch and current branch: git log <root-branch>..HEAD --oneline
6. Read the diff to understand changes: git diff <root-branch>...HEAD
7. Draft PR summary:
   - Use bullet points for key changes
   - Include any context reviewers might need
   - Reference any related issues if identifiable
8. Push branch to remote if not already pushed: git push -u origin <current-branch>
9. Create PR using: gh pr create --title "<title>" --body "<body>"
10. Return the PR URL

Important:
- ONLY create the PR if review passes
- Be thorough in step 3 review - check for lint, tests, typecheck
- The PR body should focus on WHY not just WHAT