# Bash Preferences and Defensive Patterns

This section outlines conventions and defensive programming techniques for bash scripting.

**These preferences should be followed for all new bash scripts and when refactoring existing ones within this project.**

---

## 1. Function Naming Convention

- **Convention**: Function names should be prefixed with `fct_` followed by a descriptive, lowercase, snake_case name (e.g., `fct_calculate_total`).
- **Declaration**: Use the `name() { ... }` syntax. Avoid the `function` keyword for broader POSIX compatibility, though it's accepted in Bash.
- **Consistency**: Emphasize project-level consistency in naming.

```bash
# USE:
fct_clean_up_temporary_files() {
    # Function body
}

# NOT:
# function CleanUpTemporaryFiles { ... }
# other_prefix_myFunction() { ... }
```

---

## 2. Variable Handling

- **Quoting**: Always use double quotes with braces for variable expansion (e.g., `"${variable}"`) to prevent word splitting and pathname expansion. Braces also help disambiguate variables when adjacent to other characters (e.g., `"${variable}_suffix"`).
- **Paths**: Path variables must always be quoted and use braces.
- **Output**: Prefer `printf` over `echo` for safer and more portable string output.
- **Defaults**: Use `${VAR:-default}` for optional variables with defaults.

```bash
# USE:
printf '%s\n' "${variable}"
cp "${source_file}" "${destination_directory}/"
filename="report_${year}.txt"
mv "${filename}" "${archive_dir}/${filename}"

# Default values
: "${VERBOSE:=0}"
: "${REQUIRED_VAR:?REQUIRED_VAR is not set}"

# NOT:
# echo $variable
# cp $source $destination
# filename="report_$year.txt" # Potentially problematic if $year_txt exists
```

---

## 3. Error Handling and Script Rigidity

- **Shebang**: Start all scripts with `#!/usr/bin/env bash`.
- **Strict Mode**: Enable strict mode at the beginning of all scripts.
  ```bash
  set -Eeuo pipefail
  set -o errtrace  # ERR traps inherit to functions
  ```
  - `-e`: Exit immediately if a command exits with a non-zero status.
  - `-u`: Treat unset variables and parameters as an error when performing expansion.
  - `-o pipefail`: The return value of a pipeline is the status of the last command to exit with a non-zero status.
  - `-E` / `-o errtrace`: Inherit ERR trap in functions and subshells.

- **Explicit Error Handling**: For commands that are expected to fail, handle these failures explicitly to prevent `set -e` from exiting the script prematurely.

  ```bash
  # USE:
  if ! command_that_might_fail --option; then
      printf 'Command failed, but we are handling it.\n' >&2
      # Perform alternative actions or log the error
  fi

  # OR, if you just want to ignore the failure:
  command_that_might_fail --another-option || true
  ```

- **Cleanup Traps**: Use `trap` to ensure cleanup actions are performed when the script exits, regardless of whether it's a normal exit, an error, or an interrupt.

  ```bash
  # Setup traps
  trap 'fct_cleanup_resources' EXIT
  trap 'fct_on_error "${LINENO}" "${BASH_COMMAND}"' ERR
  trap 'fct_on_signal INT' INT
  trap 'fct_on_signal TERM' TERM

  fct_cleanup_resources() {
      local exit_status=$?
      set +e  # Never mask original exit status
      printf 'Cleaning up resources...\n' >&2
      rm -f "${TEMP_FILE_1}" "${TEMP_FILE_2}"
      return "${exit_status}"
  }

  fct_on_error() {
      local exit_status=$?
      local line_no="${1:-?}"
      local command="${2:-?}"
      trap - ERR  # Prevent recursive trapping
      printf 'Error (exit %d) at line %s: %s\n' "${exit_status}" "${line_no}" "${command}" >&2
      exit "${exit_status}"
  }
  ```

---

## 4. Variable Scoping and Naming

- **Global Variables**:
  - Declare global constants as `readonly` and in `UPPERCASE_SNAKE_CASE`.
  - Initialize them as early as possible.
  ```bash
  # USE:
  readonly SCRIPT_NAME="$(basename "$0")"
  readonly DEFAULT_CONFIG_PATH="/etc/my_app/config.conf"
  ```
- **Local Variables**:
  - Always declare variables within functions as `local` to limit their scope.
  - Use `lowercase_snake_case` for local variable names.
  ```bash
  fct_process_data() {
      local input_file="${1}"
      local line_count=0
      # ...
  }
  ```

---

## 5. Command Substitution

- **Syntax**: Always use the `$(command)` syntax for command substitution. It is more readable and nests better than backticks.

  ```bash
  # USE:
  local current_date=$(date +%Y-%m-%d)
  local num_files=$(find . -type f -name "*.log" | wc -l)

  # NOT:
  # local current_date=`date +%Y-%m-%d`
  ```

- **Handle failures**: Check command output validity

  ```bash
  result=$(command -v node) || {
      log_error "node command not found"
      return 1
  }
  ```

---

## 6. Conditional Expressions

- **Tests**: Prefer `[[ ... ]]` for conditional expressions involving string comparisons, file tests, and pattern matching. It is more robust and feature-rich than `[ ... ]`.

  ```bash
  # USE:
  if [[ -f "${file_path}" && "${user_name}" == "admin" ]]; then
      # ...
  fi

  if [[ "${input_string}" =~ ^[0-9]+$ ]]; then
      printf 'Input is numeric.\n'
  fi

  # AVOID:
  # if [ -f "$file_path" -a "$user_name" = "admin" ]; then ... fi
  ```

- **Arithmetic**: Use `(( ... ))` for arithmetic expressions and comparisons.

  ```bash
  # USE:
  local counter=0
  ((counter++))
  if (( counter > 10 )); then
      # ...
  fi

  # AVOID:
  # counter=$[$counter+1]
  # if [ "$counter" -gt 10 ]; then ... fi
  ```

---

## 7. IFS Manipulation

- **Localization**: When modifying the Internal Field Separator (`IFS`), always save its original value and restore it as soon as it's no longer needed.
- **Subshells**: Alternatively, perform operations requiring a modified `IFS` within a subshell to automatically localize the change.

  ```bash
  # USE: Save and restore
  local old_ifs="${IFS}"
  IFS=","
  # Example: reading CSV fields into an array
  # local line="field1,field2,field3"
  # read -ra fields <<< "${line}"
  IFS="${old_ifs}"

  # USE: Subshell for localization
  # (
  #   IFS=":"
  #   # Commands using modified IFS, e.g., splitting PATH
  #   for item in $PATH; do printf '%s\n' "$item"; done
  # )
  # IFS remains unchanged here

  # BEST: Use NUL-safe iteration
  while IFS= read -r -d '' file; do
      printf 'Processing: %s\n' "${file}"
  done < <(find /path -type f -print0)
  ```

---

## 8. Loops and Iteration

- **Reading Lines**: When reading input line by line (e.g., from a file or command output), prefer a `while read` loop.
  - Use `read -r` to prevent backslash interpretation.
  - Ensure the last line is processed even if it doesn't end with a newline by checking `read`'s exit status or by appending `|| [[ -n "${line}" ]]` if appropriate.

  ```bash
  # USE:
  while IFS= read -r line || [[ -n "${line}" ]]; do
      printf 'Processing line: %s\n' "${line}"
  done < "input.txt"

  # Processing command output:
  find . -type f -print0 | while IFS= read -r -d $'\0' file_path; do
      printf 'Found file: %s\n' "${file_path}"
  done

  # Reading into arrays:
  mapfile -t lines < <(some_command)
  readarray -t numbers < <(seq 1 10)
  ```

---

## 9. Script Arguments

- **Parsing**: For scripts that accept options and arguments, manual parsing with `case` statements is preferred for clarity and POSIX compatibility. Use `getopts` for shorter scripts.

  ```bash
  # Manual parsing (preferred for complex scripts)
  fct_parse_arguments() {
      POSITIONAL_ARGS=()

      while [[ $# -gt 0 ]]; do
          case "$1" in
              -v|--verbose)
                  VERBOSE=1
                  shift
                  ;;
              -o|--output)
                  if [[ $# -lt 2 ]]; then
                      die "Option --output requires a value." 2
                  fi
                  OUTPUT_FILE="${2}"
                  shift 2
                  ;;
              -o=*)
                  OUTPUT_FILE="${1#*=}"
                  shift
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

  # getopts example (for shorter scripts)
  while getopts ":vo:" opt; do
      case ${opt} in
          v) VERBOSE=1 ;;
          o) OUTPUT_FILE="${OPTARG}" ;;
          \?) printf 'Invalid option: %s\n' "-${OPTARG}" >&2; exit 1 ;;
          :) printf 'Option -%s requires an argument.\n' "${OPTARG}" >&2; exit 1 ;;
      esac
  done
  shift $((OPTIND -1))
  ```

---

## 10. Script Exit

- **Explicit Exit**: Always explicitly exit scripts with an appropriate status code.
  - `exit 0` for success.
  - `exit N` (where N is 1-255) for errors. Use distinct codes for different error types if useful.
  ```bash
  # USE:
  if some_condition_is_met; then
      printf 'Operation successful.\n'
      exit 0
  else
      printf 'Error: Condition not met.\n' >&2
      exit 1 # General error
  fi
  ```

- **Sourced vs Executed**: Handle both cases gracefully:

  ```bash
  IS_SOURCED=0
  if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
      IS_SOURCED=1
  fi
  readonly IS_SOURCED

  fct_exit() {
      local code="${1:-0}"
      if [[ "${IS_SOURCED}" -eq 1 ]]; then
          return "${code}"
      fi
      exit "${code}"
  }
  ```

---

## 11. Idempotency

- **Principle**: Design operations to be idempotent where possible. Running an idempotent operation multiple times should produce the same end state without unintended side effects. This is crucial for reliable automation.
- **Examples**:
  - Creating a directory only if it doesn't exist:
    ```bash
    ensure_directory() {
        local dir="${1}"
        if [[ -d "${dir}" ]]; then
            log_debug "Directory already exists: ${dir}"
            return 0
        fi
        mkdir -p "${dir}" || {
            log_error "Failed to create directory: ${dir}"
            return 1
        }
    }
    ```
  - Adding a line to a file only if it's not already present:
    ```bash
    ensure_line_in_file() {
        local config_file="${1}"
        local setting_line="${2}"
        if ! grep -qFx "${setting_line}" "${config_file}"; then
            printf '%s\n' "${setting_line}" >> "${config_file}"
        fi
    }
    ```

---

## 12. Temporary Files and Directories

- **Secure Creation**: Use `mktemp` to securely create temporary files and directories. This avoids race conditions and predictability issues.

  ```bash
  # USE:
  temp_file=$(mktemp) || { printf 'Failed to create temp file.\n' >&2; exit 1; }
  trap 'rm -f "${temp_file}"' EXIT

  temp_dir=$(mktemp -d) || { printf 'Failed to create temp directory.\n' >&2; exit 1; }
  trap 'rm -rf "${temp_dir}"' EXIT

  # With informative naming:
  TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/${SCRIPT_NAME}.XXXXXXXX")" || die "Failed to create temp dir." 1
  ```

---

## 13. Logging

- **Structured Logging**: Implement consistent logging with timestamps and levels.
- **Output**: Send logs to stderr so stdout can be reserved for machine-readable output.

  ```bash
  fct_log() {
      local level="${1}"
      shift
      local message="$*"
      local ts
      ts="$(date '+%Y-%m-%d %H:%M:%S%z')"
      printf '[%s] [%s] %s: %s\n' "${ts}" "${SCRIPT_NAME}" "${level}" "${message}" >&2
  }

  log_debug() { [[ "${VERBOSE:-0}" -eq 1 ]] && fct_log "DEBUG" "$@"; }
  log_info() { fct_log "INFO" "$@"; }
  log_warn() { fct_log "WARN" "$@"; }
  log_error() { fct_log "ERROR" "$@"; }
  ```

---

## 14. Comments and Documentation

- **Clarity**: Write comments to explain complex logic, assumptions, or non-obvious steps.
- **Style**:
  - Use `#` for full-line or end-of-line comments.
  - Comment functions to describe their purpose, arguments, and any side effects or return values.
  - Use `# Why:` comments to explain rationale for non-obvious decisions.

  ```bash
  # This is a full-line comment explaining the next block of code.
  local important_variable="value" # End-of-line comment for this variable.

  # fct_process_item: Processes a single item.
  # Arguments:
  #   $1: The item ID to process.
  # Outputs:
  #   Writes processing status to stdout.
  # Returns:
  #   0 on success, 1 on failure.
  fct_process_item() {
      # ...
  }
  ```

---

## 15. Static Analysis

- **Tooling**: Strongly recommend using `shellcheck` (available at [https://www.shellcheck.net/](https://www.shellcheck.net/)) to lint all Bash scripts. It helps identify common pitfalls, syntax errors, and stylistic issues.
- **Integration**: Integrate `shellcheck` into your development workflow, e.g., as a pre-commit hook or part of CI/CD pipelines.
- **Convenience wrapper**: Use `scripts/run_shellck.sh` to automatically detect and lint shell scripts:

  ```bash
  # Lint all scripts in scripts/ directory (default)
  ./scripts/run_shellck.sh

  # Lint specific files or directories
  ./scripts/run_shellck.sh path/to/script.sh
  ./scripts/run_shellck.sh scripts/ other/dir/
  ```

---

## 16. Dependency Checking

- **Check Early**: Validate required dependencies at script start to fail fast with actionable errors.

  ```bash
  fct_require_command() {
      local cmd="${1}"
      local hint="${2:-}"

      if ! command -v "${cmd}" >/dev/null 2>&1; then
          if [[ -n "${hint}" ]]; then
              die "Missing required command: ${cmd}. ${hint}"
          fi
          die "Missing required command: ${cmd}."
      fi
  }

  fct_check_dependencies() {
      fct_require_command "jq" "Install: brew install jq (macOS) or apt-get install jq (Debian/Ubuntu)"
      fct_require_command "curl"
      fct_require_command "git"
  }
  ```

---

## 17. Dry-Run Support

- **Preview Mode**: Support dry-run mode to let users preview changes without executing them.

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
  run_cmd chown "${owner}" "${target}"
  ```

---

## 18. Safe File Operations

- **Atomic Writes**: Write to a temporary file first, then rename atomically.
- **Safe Moves**: Check existence before moving to avoid overwriting.

  ```bash
  # Atomic file writes
  atomic_write() {
      local target="${1}"
      local tmpfile
      tmpfile=$(mktemp) || return 1

      # Write to temp file first
      cat > "${tmpfile}"

      # Atomic rename
      mv "${tmpfile}" "${target}"
  }

  # Safe move without overwriting
  safe_move() {
      local source="${1}"
      local dest="${2}"

      if [[ ! -e "${source}" ]]; then
          log_error "Source does not exist: ${source}"
          return 1
      fi

      if [[ -e "${dest}" ]]; then
          log_error "Destination already exists: ${dest}"
          return 1
      fi

      mv "${source}" "${dest}"
  }
  ```

---

## 19. Process Orchestration

- **Background Processes**: Track and manage background processes safely.

  ```bash
  PIDS=()

  cleanup_processes() {
      for pid in "${PIDS[@]}"; do
          if kill -0 "${pid}" 2>/dev/null; then
              kill -TERM "${pid}" 2>/dev/null || true
          fi
      done
  }
  trap cleanup_processes SIGTERM SIGINT

  # Start background tasks
  background_task &
  PIDS+=($!)

  another_task &
  PIDS+=($!)

  # Wait for all background processes
  wait
  ```

---

## 20. Testing and Validation

- **Validate Inputs**: Always validate function arguments and file operations.

  ```bash
  validate_file() {
      local file="${1}"
      local message="${2:-File not found: ${file}}"

      if [[ ! -f "${file}" ]]; then
          log_error "${message}"
          return 1
      fi
      return 0
  }

  process_files() {
      local input_dir="${1}"
      local output_dir="${2}"

      # Validate inputs
      [[ -d "${input_dir}" ]] || { log_error "input_dir not a directory"; return 1; }

      # Create output directory if needed
      mkdir -p "${output_dir}" || { log_error "Cannot create output_dir"; return 1; }

      # Process files safely
      while IFS= read -r -d '' file; do
          log_info "Processing: ${file}"
          # Do work
      done < <(find "${input_dir}" -maxdepth 1 -type f -print0)

      return 0
  }
  ```

---

## 21. Named Parameters Pattern

- **Flexibility**: Support named parameters for complex functions.

  ```bash
  process_data() {
      local input_file=""
      local output_dir=""
      local format="json"

      # Parse named parameters
      while [[ $# -gt 0 ]]; do
          case "$1" in
              --input=*)
                  input_file="${1#*=}"
                  ;;
              --output=*)
                  output_dir="${1#*=}"
                  ;;
              --format=*)
                  format="${1#*=}"
                  ;;
              *)
                  log_error "Unknown parameter: $1"
                  return 1
                  ;;
          esac
          shift
      done

      # Validate required parameters
      [[ -n "${input_file}" ]] || { log_error "--input is required"; return 1; }
      [[ -n "${output_dir}" ]] || { log_error "--output is required"; return 1; }
  }
  ```

---

## Summary Checklist

| Category | Requirement |
|----------|-------------|
| **Strict Mode** | `set -Eeuo pipefail` required |
| **Quoting** | Always `"${variable}"` |
| **Conditionals** | Prefer `[[ ]]` over `[ ]` |
| **Functions** | `fct_` prefix, `local` for internal vars |
| **Variables** | `readonly` for constants, `local` in functions |
| **Errors** | Traps for EXIT, ERR, INT, TERM |
| **Logging** | Structured logs to stderr |
| **Temp Files** | Use `mktemp`, cleanup with trap |
| **Dependencies** | Check upfront with `command -v` |
| **Idempotency** | Safe to rerun multiple times |
| **Linting** | Run `shellcheck` on all scripts |