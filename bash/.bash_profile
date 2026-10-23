source ~/.profile
[ ! -f "$HOME/.cargo/env" ] || . "$HOME/.cargo/env"

# Bash config loader
if [ -f ~/.bashrc ]; then
  # shellcheck disable=SC1090
  . ~/.bashrc
fi

# Vite+ bin (https://viteplus.dev)
[ ! -f "$HOME/.config/vite-plus/env" ] || . "$HOME/.config/vite-plus/env"
