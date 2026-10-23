#!/usr/bin/env zsh
set -eu

loader="${0:A:h:h}/zsh/.config/zsh/reload-private.zsh"
scratch_dir=$(mktemp -d)
trap 'command rm -rf -- "$scratch_dir"' EXIT
export XDG_CONFIG_HOME="$scratch_dir/config"
mkdir -p "$XDG_CONFIG_HOME/zsh"
settings="$scratch_dir/private.zsh"
ln -s "$settings" "$XDG_CONFIG_HOME/zsh/local.zsh"
DOTFILES_RELOAD_TEST_COUNT=0

print -rl -- 'export DOTFILES_RELOAD_TEST_VALUE=first' \
  '(( DOTFILES_RELOAD_TEST_COUNT += 1 ))' > "$settings"
source "$loader"
[[ ${(j: :)precmd_functions} == _dotfiles_reload_private ]]
[[ ${(j: :)preexec_functions} == _dotfiles_reload_private ]]
# Exercise reload cases directly; interactive hook behavior is checked separately.
precmd_functions=()
preexec_functions=()
[[ $DOTFILES_RELOAD_TEST_VALUE == first ]]
[[ $(zsh -fc 'print -r -- "$DOTFILES_RELOAD_TEST_VALUE"') == first ]]
_dotfiles_reload_private
(( DOTFILES_RELOAD_TEST_COUNT == 1 ))

# Equal-length rapid edits must be detected even within the same clock second.
print -rl -- 'export DOTFILES_RELOAD_TEST_VALUE=later' \
  '(( DOTFILES_RELOAD_TEST_COUNT += 1 ))' > "$settings"
_dotfiles_reload_private
[[ $DOTFILES_RELOAD_TEST_VALUE == later ]]
(( DOTFILES_RELOAD_TEST_COUNT == 2 ))

# Editors commonly replace the destination of a symlink with an atomic rename.
print -r -- 'export DOTFILES_RELOAD_TEST_VALUE=final' > "$settings.next"
mv "$settings.next" "$settings"
_dotfiles_reload_private
[[ $DOTFILES_RELOAD_TEST_VALUE == final ]]

print -r -- 'export DOTFILES_RELOAD_TEST_VALUE="invalid' > "$settings"
_dotfiles_reload_private 2> "$scratch_dir/errors"
[[ $DOTFILES_RELOAD_TEST_VALUE == final ]]
grep -q 'syntax error' "$scratch_dir/errors"
! grep -q 'invalid' "$scratch_dir/errors"
_dotfiles_reload_private 2> "$scratch_dir/errors"
[[ ! -s "$scratch_dir/errors" ]]

print -r -- 'unset DOTFILES_RELOAD_TEST_VALUE' > "$settings"
_dotfiles_reload_private
[[ ! -v DOTFILES_RELOAD_TEST_VALUE ]]

print -r -- 'false' > "$settings"
_dotfiles_reload_private 2> "$scratch_dir/errors"
grep -q 'reported an error' "$scratch_dir/errors"

rm "$settings"
source "$loader"
source "$loader"
[[ ${(j: :)precmd_functions} == _dotfiles_reload_private ]]
[[ ${(j: :)preexec_functions} == _dotfiles_reload_private ]]
print -r -- 'Private reload checks passed: edits, caching, atomic saves, errors, unset, and hook registration.'
