# Homebrew
export BREW_HOME="$(brew --prefix)"

# Additional completion definitions, available when Oh My Zsh runs compinit.
fpath=("$BREW_HOME/share/zsh-completions" $fpath)

# Oh My Zsh plugins
export ZSH="$HOME/.oh-my-zsh"
plugins=(git z)
source "$ZSH/oh-my-zsh.sh"

# PHPENV
export PATH="$HOME/.phpenv/bin:$PATH"
if command -v phpenv >/dev/null 2>&1; then
  eval "$(phpenv init -)"
fi


# Starship.rs
eval "$(starship init zsh)"

# Jetbrains alias
alias webstorm='open -na "WebStorm.app" --args .'
alias rubymine='open -na "RubyMine.app" --args .'
alias phpstorm='open -na "PhpStorm.app" --args .'
alias clion='open -na "CLion.app" --args .'

# Local credentials and machine-specific aliases stay outside Git.
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/reload-private.zsh"


# bison
export PATH="$(brew --prefix bison)/bin:$PATH"


# tmux
alias ta="tmux attach"
alias tn="tmux new -s"
alias tl="tmux list-sessions"

# Alias
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'


# quickly compile c code and exe using gcc
run_c() {
    g++ "$1" -o "$1.exe" && ./"$1.exe"
}

# fzf [https://github.com/junegunn/fzf]
source <(fzf --zsh)


# PostgreSQL
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/postgresql@16/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql@16/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/postgresql@16/lib/pkgconfig"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

# Vite+ bin (https://viteplus.dev)
[[ ! -f "$HOME/.config/vite-plus/env" ]] || . "$HOME/.config/vite-plus/env"

# opencode
export PATH=$HOME/.opencode/bin:$PATH

# Bypass an existing mise function, which may reference a removed binary.
# Activate project runtimes after the other PATH additions.
if command -v mise >/dev/null 2>&1; then
  eval "$(command mise activate zsh)"
fi

# Native command and flag descriptions for Tab completion.
# Load after PATH setup so completion uses the installed CLI versions.
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/codex.zsh"
if (( $+commands[ak] )); then
  source <(AK_NO_AUTO_UPDATE=1 ak completion zsh)
fi
if (( $+commands[cf] )); then
  source <(cf complete zsh)
fi

# Let fzf-tab select completions instead of Oh My Zsh's native menu.
zstyle -d ':completion:*:*:*:*:*' menu
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
source "$BREW_HOME/share/fzf-tab/fzf-tab.zsh"

# Preview directories, text files, or the full completion description on the right.
zstyle ':fzf-tab:*' fzf-flags --preview-window=right:50%:wrap
zstyle ':fzf-tab:complete:*:*' fzf-preview '
  if [[ -n $realpath && -d $realpath ]]; then
    command ls -lah -- "$realpath"
  elif [[ -n $realpath && -f $realpath ]]; then
    if LC_ALL=C command grep -Iq . -- "$realpath"; then
      command head -n 200 -- "$realpath"
    else
      command file -b -- "$realpath"
    fi
  else
    print -r -- "$desc"
  fi
'

# Load these after fzf-tab so their widget wrappers remain active.
source "$BREW_HOME/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$BREW_HOME/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
