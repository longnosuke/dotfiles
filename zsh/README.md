# Zsh and completion

`zsh/.zshrc`, `.zprofile`, and `.zshenv` are the canonical Zsh startup files.
The active home files are symlinks created by `scripts/link-dotfiles.sh`.
Shared login and Bash setup lives in the `shell` and `bash` packages.

Oh My Zsh loads the `git` and `z` plugins. Starship owns the prompt.
`zsh-completions` supplies completion definitions, `fzf-tab` displays them on
Tab, and `zsh-autosuggestions` supplies inline history suggestions.
`zsh-autocomplete`, Powerlevel10k, and experimental menu colors are inactive.

Native `ak completion zsh` and `cf complete zsh` scripts provide CLI subcommands
and flag descriptions when those CLIs are installed.

## Use completion

1. Type `ak `, `ak kit `, `cf dns records `, or a command followed by `--`.
2. Press Tab to open fzf-tab and type to filter results.
3. Navigate with arrow keys or Tab/Shift+Tab.
4. Press Enter to insert a selection; press Enter again to execute.
5. Press Esc to cancel the menu.

The right-side preview uses half the width and wraps long lines. Directories
show a detailed listing; text files show their first 200 lines. Binary and empty
files show file-type information. Commands and flags show their full completion
descriptions. The file preview is plain text, without syntax highlighting.
Selecting an item does not execute it.

## Private shell settings

Credentials, account identifiers, and project-specific aliases live in the
Git-ignored `private/.config/zsh/local.zsh` package file. Its active home path,
`~/.config/zsh/local.zsh`, is a symlink. Zsh loads it if present. Maintain
mode `600` and transfer it separately on another machine.

To add or update a credential, edit that private file:

```sh
nvim ~/.config/zsh/local.zsh
```

After saving, interactive Zsh terminals check the file before their next prompt
and command. Changed or added exports load automatically. Activate this loader
once in existing terminals with `exec zsh`; new terminals enable it at startup.
Already-running programs keep their inherited environment until restarted.
To remove a loaded variable, add `unset VARIABLE_NAME`; deleting its export line
alone does not clear it from an existing shell. Syntax errors skip the reload
and show a warning without printing the private file's contents.

For example, add `export CLOUDFLARE_API_TOKEN='replace-with-your-token'` there.
The existing `TUNNEL_TOKEN` is for cloudflared tunnel
connectors; `CLOUDFLARE_API_TOKEN` is for Cloudflare API/CLI operations.
Saved CLI logins remain managed by their applications.

The tracked Git configuration includes `~/.gitconfig.local` for identity and
authentication; that path links to the ignored `private/.gitconfig.local` file.
See the root README for setup and syncing.

After editing startup files, open a new terminal or run `exec zsh`. Restart
instead of repeatedly sourcing `.zshrc`, which can initialize plugins twice.

Homebrew completion directories must pass `compaudit`; do not disable its
checks. If `/opt/homebrew/share` is group-writable, remove that permission before
restarting Zsh. fzf-tab loads after completion initialization and before the
autosuggestion and syntax-highlighting widget wrappers.

References: [fzf-tab](https://github.com/Aloxaf/fzf-tab),
[Cloudflare shell completion](https://developers.cloudflare.com/cf/get-started/#set-up-shell-completion).
