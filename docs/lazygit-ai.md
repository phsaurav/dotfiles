# lazygit + Claude Code: AI commits and PRs

Set up on 2026-10-22. One keybinding (`ctrl+a`) inside lazygit gives AI-written commit messages
and AI-written pull requests. Everything runs through the **Claude Code CLI on the existing
subscription**, so there is no API key to manage, and through `gh` for anything GitHub.

- Config: [`.config/lazygit/config.yml`](../.config/lazygit/config.yml)
- Helper script: [`.local/bin/lazygit-ai`](../.local/bin/lazygit-ai)
- Installer: [`scripts/lazygit_install.sh`](../scripts/lazygit_install.sh)

---

## 1. New device in 3 steps

```bash
git clone https://github.com/phsaurav/dotfiles ~/dotfiles
~/dotfiles/scripts/lazygit_install.sh      # installs lazygit, gh, jq, claude; stows; fixes macOS config path
gh auth login && claude                    # log in once to GitHub and to Claude (subscription), then quit claude
```

Open lazygit in any repo, press `ctrl+a`. Done.

Manual equivalent, if you prefer not to run the script:

| Step | Command |
|---|---|
| Packages | `brew install lazygit gh jq` (macOS) / `pacman -S lazygit github-cli jq` (Arch) |
| Claude Code CLI | `curl -fsSL https://claude.ai/install.sh \| bash`, then run `claude` once and sign in |
| Link files | `cd ~/dotfiles && stow .` gives `~/.config/lazygit/config.yml` and `~/.local/bin/lazygit-ai` |
| macOS only | `ln -sfn ~/.config/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml` because lazygit on macOS reads from Library, not `~/.config` |
| PATH | `~/.local/bin` must be on PATH (already in `.zshrc`) |

---

## 2. Keymap

Press `ctrl+a` in any lazygit panel. A menu opens:

| Key | Action | AI? | Side effects |
|---|---|---|---|
| `c` | **Pick from AI subject lines**: 5 one-line Conventional Commit subjects for the staged diff. Choose one, then *Commit* as-is or *Edit first* (opens your git editor). | Haiku | `git commit` |
| `f` | **Full AI message**: subject + short bullet body, opened in your git editor. | Haiku | `git commit` |

Editor rule for `c` → *Edit first* and `f`: **save = commit, quit without saving (`:q!`) = abort.**
(`git commit -e` cannot do this: it writes the message before the editor opens, so `:q!` still
commits. `lazygit-ai commit-edit` opens the file itself and commits only if the mtime changed.)
Lines starting with `#` in the editor are stripped. The editor is whatever `git var GIT_EDITOR`
resolves to: `GIT_EDITOR` > `core.editor` > `VISUAL` > `EDITOR` > `vi`.
| `p` | **AI pull request**: pick the target branch, Claude drafts title + body, you review in `$EDITOR`, choose draft / ready / web, it pushes and runs `gh pr create`, then copies the PR URL to the clipboard. | Sonnet | `git push`, `gh pr create` |

In every list and menu, `/` starts a **fuzzy** filter (`gui.filterMode: fuzzy`), so `/rls` finds
`release-1`, `/ecs` finds `add/ezycourse-ecs`. `Esc` clears it.

Built-in lazygit PR keys still work in the branches panel: `o` create PR in browser, `G` open the
branch's PR, `ctrl+y` copy PR URL, `O` PR options. lazygit shows PR numbers next to branches on its
own (cached in `github_pull_requests.json` next to the config; not something you edit).

---

## 3. How it fits together

```
lazygit (config.yml, customCommands)
   │  ctrl+a → menu
   ├─ c / f ──► lazygit-ai commit-options | commit-edit ──► claude -p (haiku) ──► [editor, commit only if saved] ──► git commit
   └─ p ──────► lazygit-ai bases  (target picker)
                lazygit-ai pr <base> ──► claude -p (sonnet) ──► $EDITOR ──► git push ──► gh pr create ──► pbcopy
```

`claude -p` is called with:

```
--tools "" --no-session-persistence --setting-sources "" --strict-mcp-config --system-prompt "..."
```

Meaning: no tools (Claude cannot run anything), no hooks, no MCP servers, no saved session, no
`CLAUDE.md` or settings pulled in (verified: a planted `CLAUDE.md` instruction in a test repo was
ignored). It is a pure text-in, text-out call that reads the diff and writes a message. Typical
latency: 5 to 8 s for a commit message, 10 to 20 s for a PR description.

---

## 4. The helper script: `lazygit-ai`

```
lazygit-ai commit-options       N one-line commit subjects for staged changes (one per line)
lazygit-ai commit-full          full commit message (subject + body) for staged changes
lazygit-ai commit-edit [msg]    open msg (or a fresh commit-full) in the git editor; commit ONLY if saved
lazygit-ai bases                candidate PR target branches (default first, then staging/develop/dev, rest)
lazygit-ai pr [base]            draft PR title/body, review in $EDITOR, push, gh pr create, copy URL
```

Works from any terminal too, not only inside lazygit.

### Environment variables

| Variable | Default | Purpose |
|---|---|---|
| `LGAI_MODEL` | `haiku` | Model for commit messages |
| `LGAI_PR_MODEL` | `sonnet` | Model for PR descriptions |
| `LGAI_OPTIONS` | `5` | Number of subject-line candidates |
| `LGAI_MAX_DIFF` | `60000` | Max diff characters sent to Claude; longer diffs are cut with a `[diff truncated]` note, the file list is always sent in full |
| `LGAI_TIMEOUT` | `90` | Seconds before a hung Claude call is killed (perl `alarm`, since macOS has no `timeout`) |
| `LGAI_ALLOW_SECRETS` | unset | Set to `1` to bypass the secrets guard for one run |

Set them for one run: `LGAI_MODEL=sonnet lazygit`, or export in `.zshrc` to make them permanent.

### What the context sent to Claude contains

Commits: current branch, last 8 commit subjects (style reference), `git diff --cached --stat`,
`git diff --cached` (truncated as above). PRs: branch and target, commit subjects + bodies in the
range, `--stat`, diff of `origin/<base>...HEAD`.

### Output style rules baked into the prompts

- Commit subject: Conventional Commits, imperative, max 60 chars. Body omitted for small changes;
  otherwise at most 4 one-line bullets with only what the subject cannot say (a non-obvious why,
  a behavior change, a migration or config step). No paragraphs.
- PR: title (max 60), then `**TL;DR:**` one sentence, `## Changes` (bullets, `### area`
  subsections only when 2+ areas, max 8 bullets, max 15 words each), `## Notes` only if breaking /
  migration / config changes, `## Testing` max 3 bullets. No paragraphs.

Tune by editing the prompt strings in `lazygit-ai` (`commit-options`, `commit-full`, `pr` cases).

---

## 5. Safety properties

| Concern | How it is handled |
|---|---|
| History rewriting | Only plain `git commit`, `git fetch`, `git push`. Never `--force`, `--amend`, `--no-verify`, rebase or reset. `disableForcePushing: true` also blocks lazygit's own force push. |
| Hooks | pre-commit and commit-msg hooks run as normal. |
| PR creation | Only after you confirm `d`/`r`/`w` at the prompt. A rejected push stops the flow before `gh pr create`. `gh` refuses to open a second PR for the same branch. |
| Claude capabilities | No tools, no MCP, no hooks, no persisted session. Prompt injection via diff content can only affect the text you then review. |
| Temp files | PR draft lives in a `mktemp -d` dir (mode 0700), deleted after the PR is created, kept only if you abort (path is printed). |
| Shell injection | Messages and branch names pass through lazygit's `quote` and are quoted in the script. |
| Large diffs | Collected into variables, never piped through `head` (which used to SIGPIPE git and make lazygit show an error). |

### Secrets guard

Before any diff is sent to Claude, `lazygit-ai` refuses and lists the hits if it sees:

- **File names** (staged or in the PR range): `.env*`, `*.pem`, `*.key`, `*.p12`, `*.pfx`, `*.jks`,
  `*.keystore`, `id_rsa`/`id_ed25519`/…, anything containing `secret`, `credential`, `password`,
  `token`, `*.tfvars`, `ovh.conf`, `.npmrc`, `.pypirc`, `.netrc`, `kubeconfig*`.
  Files ending in `.example`, `.sample`, `.template`, `.dist` are allowed.
- **Added lines, high confidence** (every file): AWS `AKIA…`/`ASIA…` keys, `-----BEGIN … PRIVATE KEY`,
  GitHub `ghp_…`/`gho_…`, `sk-…` API keys, Slack `xox…`, Google `AIza…`, full three-part JWTs.
- **Added lines, generic** (code and config only, skipped in `.md`/`.mdx`/`.rst`/`.txt` where sample
  JSON is common): `password = "…"`, `token: "…"`, `api_key=…` style assignments with 8+ char values.
- Values that look like placeholders are ignored everywhere: `example`, `...`, `xxx`, `placeholder`,
  `your-`, `<…>`, `changeme`, `dummy`, `redacted`, `***`.

```
lazygit-ai: possible secrets in the diff, refusing to send it to Claude:
  file: .env
  src/aws.py:42:AWS_KEY = "AKIA..."
Unstage them, or re-run with LGAI_ALLOW_SECRETS=1 if these are false positives.
```

Hits show `path:line` with the real line number in the file.

---

## 6. Troubleshooting

| Symptom | Cause / fix |
|---|---|
| `ctrl+a` does nothing | Config not loaded. macOS: check `~/Library/Application Support/lazygit/config.yml` is a symlink to `~/.config/lazygit/config.yml` (`lazygit -cd` prints the dir lazygit uses). Linux: `~/.config/lazygit/config.yml`. |
| "has a validation error" on start | YAML typo. `lazygit --config` prints the defaults for reference. Note: a `commandMenu` entry may only have `key` and `description`, no `context`. |
| Menu shows "command failed" | Run the same `lazygit-ai …` command in a terminal in that repo to see stderr. |
| `Claude did not answer within 90s` | Network or Claude outage. Raise `LGAI_TIMEOUT` or retry. |
| `No staged changes` | Stage with space / `a` first; the AI reads the staged diff only. |
| `gh pr create` fails | Not a GitHub remote, `gh auth login` not done, or a transient GitHub 502; retry. |
| Claude says not logged in | Run `claude` once interactively and sign in with the subscription. |
| `.env.example` flagged | Should not happen (allowed suffixes). Anything else false-positive: `LGAI_ALLOW_SECRETS=1 lazygit`. |

### Smoke test on a new machine

```bash
mkdir /tmp/lg && cd /tmp/lg && git init -q && echo hi > a.txt && git add a.txt
lazygit-ai commit-options      # expect 5 subject lines in ~7 s
echo "X=1" > .env && git add .env && lazygit-ai commit-options   # expect the secrets guard to refuse
```

---

## 7. Design notes and known limits

- Why a script plus `menuFromCommand` instead of a plugin: lazygit has no plugin system; custom
  commands are the supported extension point and need no lazygit changes or rebuilds. This also
  means a new side panel (like Files / Branches / Commits / Stash) cannot be added, so a
  repo-wide PR list panel was considered and dropped; lazygit's own `G` / `ctrl+y` / `o` cover
  the per-branch PR actions.
- Why not `--bare` on `claude -p`: `--bare` disables OAuth, which the subscription login uses.
  The flag set used instead gets the same isolation while keeping subscription auth.
- `w` (web) in the PR flow opens GitHub's form instead of creating the PR, so there is no URL to
  copy at that point.
- Haiku is used for commits for speed; switch with `LGAI_MODEL=sonnet` if a repo needs more care.
- Ideas not implemented yet: fill `.github/PULL_REQUEST_TEMPLATE.md` when present; ticket ID from
  branch name as a trailer; AI quick review of the staged diff in a popup; AI reword of an
  unpushed commit (guarded by `git merge-base --is-ancestor`).
