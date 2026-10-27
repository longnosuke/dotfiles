# Keep maintenance commands independent of project-specific Codex profiles.
codex() {
  case "${1:-}" in
    update|doctor|completion|--help|-h|--version|-V)
      command codex "$@"
      return $?
      ;;
  esac

  # Preserve the existing local MCP profile for this checkout only.
  local repo_root
  repo_root="$(command git -C "$PWD" rev-parse --show-toplevel 2>/dev/null)"
  if [[ "$repo_root" == "$HOME/Github/stackx-track" ]]; then
    command codex -p stackx-track "$@"
  else
    command codex "$@"
  fi
}

# Use the installed CLI's completions after compinit has defined compdef.
if (( $+commands[codex] && $+functions[compdef] )); then
  source <(command codex completion zsh)
fi
