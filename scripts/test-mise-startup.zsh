#!/usr/bin/env zsh
set -eu
repo_dir="${0:A:h:h}"
scratch_dir=$(mktemp -d)
trap 'command rm -rf -- "$scratch_dir"' EXIT
mkdir -p "$scratch_dir/bin"
export MISE_STARTUP_CALLS="$scratch_dir/mise-calls"
cat > "$scratch_dir/bin/mise" <<'STUB'
#!/bin/sh
printf '%s\n' "$*" >> "$MISE_STARTUP_CALLS"
STUB
chmod +x "$scratch_dir/bin/mise"
ln -s "$repo_dir/shell/.profile" "$scratch_dir/.profile"
ln -s "$repo_dir/bash/.bashrc" "$scratch_dir/.bashrc"
export HOME="$scratch_dir"
export PATH="$scratch_dir/bin:/usr/bin:/bin"
unset _MISE_ACTIVATED BASH_ENV
zsh -fc 'source "$HOME/.profile"; (( ! $+functions[_mise_hook] ))'
if [[ -e "$MISE_STARTUP_CALLS" ]]; then
  print -u2 -- 'Shared profile incorrectly activates mise in zsh.'
  exit 1
fi
sh -c '. "$HOME/.profile"'
[[ ! -e "$MISE_STARTUP_CALLS" ]]
bash --noprofile --norc -c 'source "$1/bash/.bash_profile"; source "$HOME/.bashrc"' -- "$repo_dir"
[[ $(<"$MISE_STARTUP_CALLS") == 'activate bash' ]]
print -r -- 'Mise startup checks passed: shared profile stays shell-neutral; Bash activates once.'
