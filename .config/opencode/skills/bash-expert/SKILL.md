---
name: bash-expert
description: Create and refactor Bash scripts following conventions (strict mode, fct_ naming, quoting). Includes shellcheck linting. Use when creating shell scripts, refactoring existing scripts, debugging shell errors, or linting scripts.
---

# Bash Expert Skill

Use this skill whenever the user asks to create/update/refactor a Bash script (`.sh`) or lint shell scripts.

## When to Use This Skill

- Creating new bash scripts from templates
- Refactoring existing scripts
- Writing production automation scripts
- Building CI/CD pipeline scripts
- Creating system administration utilities
- Implementing error-resilient deployment automation
- Linting scripts with shellcheck

## Core Principles

### Strict Mode (Required)

Enable bash strict mode at the start of every script:

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
set -o errtrace  # ERR traps inherit to functions
```

**Key flags:**
- `set -E` / `set -o errtrace`: Inherit ERR trap in functions
- `set -e`: Exit on any error (command returns non-zero)
- `set -u`: Exit on undefined variable reference
- `set -o pipefail`: Pipe fails if any command fails (not just last)

### Function Naming Convention

**Convention**: `fct_<descriptive_snake_case>()`

```bash
# USE:
fct_clean_up_temporary_files() {
    # Function body
}

# NOT:
# function CleanUpTemporaryFiles { ... }
# other_prefix_myFunction() { ... }
```

### Variable Safety

Always quote variables to prevent word splitting and globbing:

```bash
# Wrong - unsafe
cp $source $dest

# Correct - safe
cp "${source}" "${dest}"

# Required variables - fail with message if unset
: "${REQUIRED_VAR:?REQUIRED_VAR is not set}"
```

### Conditional Expressions

Prefer `[[ ]]` for Bash-specific features, `[ ]` for POSIX:

```bash
# Bash - safer
if [[ -f "${file}" && -r "${file}" ]]; then
    content=$(<"${file}")
fi

# Test for existence before operations
if [[ -z "${VAR:-}" ]]; then
    printf 'VAR is not set or is empty\n' >&2
fi
```

## Workflow

### Creating/Refactoring Scripts

1. Copy `scripts/pref_bash_script_template.sh` to the target path and rename it.
2. Update the SCRIPT INFO / USAGE header blocks.
3. Implement behavior in `fct_execute_this`, keep `fct_main` + `trap` structure.
4. Follow the detailed conventions in `references/pref_bash.md`.
5. Run shellcheck linting.

### Linting Scripts

Run shellcheck on scripts using the provided wrapper:

```bash
# Lint all scripts in scripts/ directory (default)
.opencode/skill/bash/scripts/run_shellck.sh

# Lint specific files or directories
.opencode/skill/bash/scripts/run_shellck.sh path/to/script.sh
```

## Key Patterns

### Pattern 1: Safe Script Directory Detection

```bash
SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_NAME="${SCRIPT_PATH##*/}"

fct_get_script_dir() {
    local source="${SCRIPT_PATH}"
    local dir="${source%/*}"
    if [[ "${dir}" == "${source}" ]]; then
        dir="."
    fi
    (cd "${dir}" >/dev/null 2>&1 && pwd -P)
}
SCRIPT_DIR="$(fct_get_script_dir)"
```

### Pattern 2: Error Trapping and Cleanup

```bash
trap 'cleanup' EXIT
trap 'fct_on_error "${LINENO}" "${BASH_COMMAND}"' ERR
trap 'fct_on_signal INT' INT
trap 'fct_on_signal TERM' TERM

cleanup() {
    local exit_status=$?
    set +e  # Never mask original exit status
    if [[ -n "${TMP_DIR}" && -d "${TMP_DIR}" ]]; then
        rm -rf "${TMP_DIR}" 2>/dev/null || true
    fi
    return "${exit_status}"
}
```

### Pattern 3: Safe Temporary File Handling

```bash
# Use mktemp with trap for guaranteed cleanup
TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/${SCRIPT_NAME}.XXXXXXXX")" || die "Failed to create temp dir." 1
trap 'rm -rf -- "$TMP_DIR"' EXIT
```

### Pattern 4: Robust Argument Parsing

```bash
fct_parse_arguments() {
    POSITIONAL_ARGS=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -v|--verbose)
                VERBOSE=1
                shift
                ;;
            -o|--output)
                OUTPUT_FILE="${2}"
                shift 2
                ;;
            -h|--help)
                usage
                fct_exit 0
                ;;
            --)
                shift
                POSITIONAL_ARGS+=("$@")
                break
                ;;
            *)
                die "Unknown option: $1" 2
                ;;
        esac
    done
}
```

### Pattern 5: Structured Logging

```bash
fct_log() {
    local level="${1}"
    shift
    local message="$*"
    local ts
    ts="$(date '+%Y-%m-%d %H:%M:%S%z')"
    printf '[%s] [%s] %s: %s\n' "${ts}" "${SCRIPT_NAME}" "${level}" "${message}" >&2
}

log_info() { fct_log "INFO" "$@"; }
log_warn() { fct_log "WARN" "$@"; }
log_error() { fct_log "ERROR" "$@"; }
log_debug() { [[ "${VERBOSE:-0}" -eq 1 ]] && fct_log "DEBUG" "$@"; }
```

### Pattern 6: Dependency Checking

```bash
fct_require_command() {
    local cmd="${1}"
    local hint="${2:-}"

    if ! command -v "${cmd}" >/dev/null 2>&1; then
        if [[ -n "${hint}" ]]; then
            die "Missing required command: ${cmd}. ${hint}" 4
        fi
        die "Missing required command: ${cmd}." 4
    fi
}

fct_check_dependencies() {
    fct_require_command "jq" "Install: brew install jq"
    fct_require_command "curl"
}
```

### Pattern 7: Dry-Run Support

```bash
DRY_RUN="${DRY_RUN:-0}"

run_cmd() {
    if [[ "${DRY_RUN}" -eq 1 ]]; then
        log_info "[DRY RUN] Would execute: $*"
        return 0
    fi
    "$@"
}

# Usage
run_cmd cp "${source}" "${dest}"
run_cmd rm "${file}"
```

### Pattern 8: Idempotent Operations

```bash
# Ensure directory exists (safe to rerun)
ensure_directory() {
    local -r dir="${1}"
    if [[ -d "${dir}" ]]; then
        log_debug "Directory already exists: ${dir}"
        return 0
    fi
    mkdir -p "${dir}" || { log_error "Failed to create directory: ${dir}"; return 1; }
}

# Add line to file only if not present
ensure_line_in_file() {
    local file="${1}"
    local line="${2}"
    if ! grep -qFx "${line}" "${file}"; then
        printf '%s\n' "${line}" >> "${file}"
    fi
}
```

### Pattern 9: Safe Array Handling

```bash
# Safe array iteration
declare -a items=("item 1" "item 2" "item 3")

for item in "${items[@]}"; do
    printf 'Processing: %s\n' "${item}"
done

# Reading output into array safely
mapfile -t lines < <(some_command)
readarray -t numbers < <(seq 1 10)
```

### Pattern 10: Process Orchestration

```bash
PIDS=()

cleanup() {
    for pid in "${PIDS[@]}"; do
        if kill -0 "${pid}" 2>/dev/null; then
            kill -TERM "${pid}" 2>/dev/null || true
        fi
    done
}
trap cleanup SIGTERM SIGINT

# Start background tasks
background_task &
PIDS+=($!)
another_task &
PIDS+=($!)

wait
```

## Best Practices Summary

1. **Strict mode required** - `set -Eeuo pipefail`
2. **Quote all variables** - `"${variable}"` prevents word splitting
3. **Use [[]] conditionals** - More robust than [ ]
4. **fct_ prefix for functions** - Consistent naming convention
5. **Implement error trapping** - Catch and handle errors gracefully
6. **Validate all inputs** - Check file existence, permissions, formats
7. **Use functions for reusability** - Prefix with meaningful names
8. **Implement structured logging** - Include timestamps and levels
9. **Support dry-run mode** - Allow users to preview changes
10. **Handle temporary files safely** - Use mktemp, cleanup with trap
11. **Design for idempotency** - Scripts should be safe to rerun
12. **Test error paths** - Ensure error handling works correctly
13. **Use `command -v`** - Safer than `which` for checking executables
14. **Prefer printf over echo** - More predictable across systems

## Reference Files

- `references/pref_bash.md` - Detailed conventions and best practices
- `scripts/pref_bash_script_template.sh` - Production-ready template script
- `scripts/run_shellck.sh` - Shellcheck wrapper script