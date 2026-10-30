# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/profile.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/profile.pre.bash"
# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/profile.post.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/profile.post.bash"
[ ! -f "$HOME/.cargo/env" ] || . "$HOME/.cargo/env"

# Make standalone CLIs and personal scripts available in both Bash and Zsh.
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

if command -v mise >/dev/null; then
  if [ -z "${_MISE_ACTIVATED:-}" ]; then
    export _MISE_ACTIVATED=1
    eval "$(command mise activate bash)"
  fi
fi

export BASH_ENV="$HOME/.bashrc"

# Vite+ bin (https://viteplus.dev)
[ ! -f "$HOME/.config/vite-plus/env" ] || . "$HOME/.config/vite-plus/env"
