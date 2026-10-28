# Dotfiles

Active configuration lives here. GNU Stow links individual files into the home
directory, so editing either path updates the same file.

| Package | Active configuration |
| --- | --- |
| `shell`, `bash`, `zsh` | Shared profile and Bash/Zsh startup files |
| `git` | Git preferences and global ignore rules |
| `starship` | Prompt configuration |
| `ghostty` | Terminal preferences and Dark Islands theme |
| `mise` | Global runtime versions and Mise settings |
| `zed` | Settings, keymap, and custom theme |
| `nvim` | Neovim configuration, plugin settings, and lockfiles |
| `tmux`, `wezterm` | Existing tmux and WezTerm configurations |

`aerospace`, `alacritty`, and `vimrc` remain optional packages. Existing fonts
and wallpapers stay in their directories.

## Set up or restore links

On macOS with Homebrew installed:

```sh
cd ~/Github/dotfiles
brew bundle
bash scripts/link-dotfiles.sh --simulate --verbose
bash scripts/link-dotfiles.sh
exec zsh
```

Install Oh My Zsh at `~/.oh-my-zsh` using its
[official instructions](https://ohmyz.sh/#install). Homebrew supplies completion
and suggestion plugins; Starship supplies the prompt. Optional phpenv, Cargo,
Bun, Vite+, OrbStack, and Amazon Q integrations require their own local
installations. Generated integrations remain owned by those tools.

The Brewfile also installs Neovim and tmux. Install the GUI applications
separately when needed: `brew install --cask ghostty zed wezterm`.
After linking Mise's configuration, run `mise install` to install its configured
runtimes and tools. Already installed versions are reused.
Shared login setup adds `~/.local/bin` and `~/bin` to PATH for standalone CLIs
and personal scripts in both Bash and Zsh.

The script refuses conflicting ordinary files. Back them up and compare them
with this repository before retrying; do not use `stow --adopt` blindly.
Use `DOTFILES_TARGET=/path/to/staging` to inspect links in an existing temporary
directory. Optional packages can be linked with
`stow --no-folding --target="$HOME" PACKAGE` from this directory.

## Private settings

- `private/.config/zsh/local.zsh`: shell credentials, account identifiers, and
  machine-specific project aliases. Linked to `~/.config/zsh/local.zsh` and
  loaded by the tracked Zsh configuration.
- `private/.gitconfig.local`: Git identity, signing key selection, and credential
  helpers. Linked to `~/.gitconfig.local` and included by the Git configuration.
- Authentication stores, histories, databases, caches, and generated integrations
  remain outside this repository.

The entire `private/` package is Git-ignored and its directory is mode `700`.
The link script includes it only when present. Keep private files at mode `600`
and transfer them separately on another machine; Git will not sync them.
Git signing requires its local signing provider. Zed's PHP stub include path
is machine-specific and may need adjusting on another machine.

When replacing an existing Git configuration, retain its identity and credential
helpers in the private Git file. The shared configuration enables SSH commit
signing; set `commit.gpgsign` to `false` in the private file if this machine has
not configured a signing key.

tmux's Pomodoro helpers run through the home-directory links created by Stow.
On macOS, its copy-mode `y` binding uses `pbcopy`; other platforms use `xclip`.

## Editing and syncing

Edit linked files normally, then inspect changes here:

```sh
git status --short
git diff
```

Symlinks keep local paths unified. GitHub sync still requires an explicit commit
and push; it is not automatic. Pull reviewed changes on another machine and run
the link script again if files were added or removed. Never force-add the
ignored private package or machine backups to Git.

See [Zsh and completion](zsh/README.md) for shell and preview details.
