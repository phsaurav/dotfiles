---
description: Run tests with coverage
agent: tester
---

Execute a comprehensive test analysis for this project.

**Discovery Phase:**
1. Identify the project type and test framework (Jest, Vitest, pytest, Go, Cargo, etc.)
2. Locate test configuration files and test directories
3. Determine the appropriate test command

**Execution:**
- Run the full test suite with coverage enabled
- Use framework-appropriate flags for verbose output

**Analysis:**
1. Parse pass/fail counts and coverage metrics
2. For each failure:
   - Identify file and line number
   - Analyze the assertion error
   - Determine root cause (test issue vs code issue)
3. Identify slow tests (>1s execution time)
4. Flag flaky or skipped tests

**Deliverable:**
Provide a structured report including:
- Project info and test framework detected
- Test discovery summary (directories, file count, patterns)
- Execution summary (total, passed, failed, skipped, duration)
- Coverage report if available
- Detailed failure analysis with root cause and suggested fixes
- Performance notes for slow tests
- Actionable recommendations prioritized by severity

End with a clear verdict: [PASS], [FAIL], or [WARN].
