#!/usr/bin/env bash
# Install lazygit + the AI integration (lazygit-ai) on a new machine.
#
#   cd ~/dotfiles && ./scripts/lazygit_install.sh
#
# What it does
#   1. Installs lazygit, gh, jq, perl (brew / pacman+yay / apt) and the Claude Code CLI if missing
#   2. `stow .` so ~/.config/lazygit/config.yml and ~/.local/bin/lazygit-ai point into this repo
#   3. macOS only: links ~/Library/Application Support/lazygit/config.yml -> ~/.config/lazygit/config.yml
#      (lazygit on macOS reads its config from Library/Application Support, not ~/.config)
#   4. Checks `gh auth status` and `claude --version`; tells you what to log in to
#
# Nothing here touches git repos, pushes, or force-anything. Safe to re-run.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
OS="$(uname -s)"

say()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# ---- 1. packages -----------------------------------------------------------------------------
missing=()
for p in lazygit gh jq perl stow; do have "$p" || missing+=("$p"); done

if [ "${#missing[@]}" -gt 0 ]; then
  say "Installing: ${missing[*]}"
  if [ "$OS" = "Darwin" ]; then
    have brew || { warn "Homebrew missing. Install from https://brew.sh then re-run."; exit 1; }
    brew install "${missing[@]}"
  elif have pacman; then
    sudo pacman -S --needed --noconfirm "${missing[@]}"
  elif have apt-get; then
    # lazygit is not in Debian/Ubuntu repos before 24.04; fall back to the GitHub release binary.
    pkgs=(); for p in "${missing[@]}"; do [ "$p" = lazygit ] || pkgs+=("$p"); done
    [ "${#pkgs[@]}" -gt 0 ] && sudo apt-get install -y "${pkgs[@]}"
    if ! have lazygit; then
      ver="$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": *"v\K[^"]*')"
      arch="$(uname -m)"; case "$arch" in x86_64) arch=x86_64 ;; aarch64|arm64) arch=arm64 ;; esac
      tmp="$(mktemp -d)"
      curl -Lo "$tmp/lg.tgz" "https://github.com/jesseduffield/lazygit/releases/download/v${ver}/lazygit_${ver}_Linux_${arch}.tar.gz"
      tar -xzf "$tmp/lg.tgz" -C "$tmp" lazygit && sudo install "$tmp/lazygit" /usr/local/bin/lazygit && rm -rf "$tmp"
    fi
  else
    warn "Unknown package manager. Install manually: ${missing[*]}"; exit 1
  fi
fi

if ! have claude; then
  say "Installing Claude Code CLI (native installer)"
  curl -fsSL https://claude.ai/install.sh | bash
  export PATH="$HOME/.local/bin:$PATH"
fi

# ---- 2. stow ----------------------------------------------------------------------------------
say "Stowing dotfiles from $DOTFILES"
mkdir -p "$HOME/.local/bin" "$HOME/.config"
# A plain file left from a manual install would block stow; move it aside.
for f in "$HOME/.local/bin/lazygit-ai" "$HOME/.config/lazygit/config.yml"; do
  if [ -f "$f" ] && [ ! -L "$f" ]; then mv "$f" "$f.pre-stow.$(date +%Y%m%d%H%M%S)"; warn "moved existing $f aside"; fi
done
(cd "$DOTFILES" && stow .)

# ---- 3. macOS config location -------------------------------------------------------------------
if [ "$OS" = "Darwin" ]; then
  appdir="$HOME/Library/Application Support/lazygit"
  mkdir -p "$appdir"
  if [ -f "$appdir/config.yml" ] && [ ! -L "$appdir/config.yml" ]; then
    mv "$appdir/config.yml" "$appdir/config.yml.bak.$(date +%Y%m%d%H%M%S)"; warn "backed up previous macOS lazygit config"
  fi
  ln -sfn "$HOME/.config/lazygit/config.yml" "$appdir/config.yml"
  say "macOS: $appdir/config.yml -> ~/.config/lazygit/config.yml"
fi

# ---- 4. checks ----------------------------------------------------------------------------------
say "lazygit $(lazygit --version 2>/dev/null | grep -o 'version=[^,]*')"
say "lazygit-ai at $(command -v lazygit-ai)"
if gh auth status >/dev/null 2>&1; then say "gh: logged in"; else warn "gh not logged in -> run: gh auth login"; fi
if claude --version >/dev/null 2>&1; then
  say "claude $(claude --version 2>/dev/null)"
  warn "If Claude is not logged in yet, run: claude   (once, interactive) and sign in with your subscription."
else
  warn "claude CLI not on PATH; open a new shell or add ~/.local/bin to PATH."
fi
say "Done. Open lazygit in any repo and press ctrl+a."
