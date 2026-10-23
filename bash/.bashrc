# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bashrc.pre.bash"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bashrc.post.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bashrc.post.bash"
[ ! -f "$HOME/.cargo/env" ] || . "$HOME/.cargo/env"

if command -v mise >/dev/null; then
  if [ -z "${_MISE_ACTIVATED:-}" ]; then
    export _MISE_ACTIVATED=1
    eval "$(mise activate bash)"
  fi
fi

# Vite+ bin (https://viteplus.dev)
[ ! -f "$HOME/.config/vite-plus/env" ] || . "$HOME/.config/vite-plus/env"
