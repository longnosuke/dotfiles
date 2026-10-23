#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
target_dir="${DOTFILES_TARGET:-$HOME}"

if ! command -v stow >/dev/null 2>&1; then
  printf '%s\n' 'Install GNU Stow first: brew install stow' >&2
  exit 1
fi

if [[ ! -d "$target_dir" ]]; then
  printf 'Target directory does not exist: %s\n' "$target_dir" >&2
  exit 1
fi

# Stow reports conflicting files instead of adopting or overwriting them.
packages=(shell bash zsh git starship ghostty mise zed nvim tmux wezterm)
if [[ -d "$repo_dir/private" ]]; then
  packages+=(private)
fi

exec stow --dir="$repo_dir" --target="$target_dir" --no-folding --restow \
  "$@" "${packages[@]}"
