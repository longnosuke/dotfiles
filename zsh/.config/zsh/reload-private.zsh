# Reload private exports before prompts and commands when their contents change.
autoload -Uz add-zsh-hook

_dotfiles_reload_private() {
  local _dotfiles_private_file="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/local.zsh"
  local _dotfiles_private_checksum

  [[ -r $_dotfiles_private_file ]] || return 0
  _dotfiles_private_checksum=$(command cksum < "$_dotfiles_private_file" 2>/dev/null) || return 0
  [[ $_dotfiles_private_checksum != "${_DOTFILES_PRIVATE_CHECKSUM-}" ]] || return 0

  # Remember failed saves too, so a malformed file produces one warning per edit.
  typeset -g _DOTFILES_PRIVATE_CHECKSUM="$_dotfiles_private_checksum"
  if ! command zsh -fn "$_dotfiles_private_file" >/dev/null 2>&1; then
    print -ru2 -- 'Private shell settings have a syntax error; reload skipped.'
    return 0
  fi

  # Export listings and error messages must not expose credentials.
  if ! source "$_dotfiles_private_file" >/dev/null 2>&1; then
    print -ru2 -- 'Private shell settings reported an error; check local.zsh.'
  fi
  return 0
}

_dotfiles_reload_private
add-zsh-hook precmd _dotfiles_reload_private
add-zsh-hook preexec _dotfiles_reload_private
