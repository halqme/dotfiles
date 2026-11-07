# dotfiles

[mise bootstrap](https://mise.jdx.dev/bootstrap.html) manages packages, dotfile links, shell activation, and setup tasks. Nix itself is installed outside this repository and used per project (for example, `use flake` in a project's `.envrc`).

| Component | Responsibility |
| --- | --- |
| `mise/config.toml` | Shared dotfiles, Git defaults, Zsh activation, Vite+, and global packages |
| `mise/config.linux.toml` | Linux packages and Zsh plugins |
| `mise/config.macos.toml` | Development tool defaults, Homebrew packages, macOS settings, Git signing, SSH, direnv, and Nix config links |
| `config/` | Shell, prompt, editor, terminal, Git, SSH, direnv, and global agent instructions |

Platform configs load automatically through `mise/miserc.toml`. On macOS, mise provides personal defaults for Go, Nim, and Rust; each project's `mise.toml` can select its own versions.

## Linux setup (Tumbleweed)

Run as your regular user, not root. Start with a Tumbleweed installation and a user with sudo access:

```sh
sudo zypper install git-core curl
installer="$(mktemp)"
curl --proto '=https' --tlsv1.2 -fsSL https://mise.run -o "$installer"
less "$installer"
sh "$installer"
rm "$installer"
export PATH="$HOME/.local/bin:$PATH"

git clone https://github.com/HALQME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
MISE_CONFIG_DIR="$HOME/.dotfiles/mise" mise bootstrap --dry-run
MISE_CONFIG_DIR="$HOME/.dotfiles/mise" mise bootstrap
```

Use **mise 2026.10.14 or newer** for `zypper:` support. Read the config and dry run before applying. Bootstrap installs the Vite+ CLI, then installs the `vp:` entries in `[bootstrap.packages]`. Use `--skip packages` to leave package installation out.

The initial `MISE_CONFIG_DIR` selects both shared and platform configuration. After the links are installed, plain `mise bootstrap` loads them from `~/.config/mise`. `MISE_CONFIG_FILE` selects only one file, so do not use it for the initial platform bootstrap.

mise installs global CLI packages through the available manager: `zypper` on Tumbleweed, `apt` on Debian/Ubuntu. Entries for an unavailable manager are skipped. Bootstrap does not perform a distribution upgrade or install compilers; update Tumbleweed with `sudo zypper dup` and add project build dependencies as needed.

### Zsh and Powerlevel10k

Bootstrap sets the login shell to `/usr/bin/zsh` on Linux and `/bin/zsh` on macOS. The selected path must be executable and listed in `/etc/shells`. On Linux, bootstrap links the existing `.p10k.zsh` and clones Powerlevel10k, fzf-tab, autosuggestions, and fast-syntax-highlighting under `~/.local/share/zsh`. Linux loads those plugins directly; macOS keeps using Homebrew. Existing shell startup files are preserved outside mise's marked blocks. A conflicting whole-file dotfile stops the run rather than being overwritten; review and merge it manually.

Log out and back in after applying. Choose a Nerd Font in your terminal for the existing p10k icons; for SSH, the font is configured on the client. Run `p10k configure` only if you want to change the shared prompt configuration.

Git defaults on every platform include the HAL identity from `config/git/config`. Review the identity before applying on another person's account. SSH keys, Git signing, and credentials are not copied or generated.

### Global agent instructions and Vite+

Bootstrap links `config/agents/AGENTS.md` to `~/.fx/AGENTS.md` and `~/.claude/CLAUDE.md`. Before installing packages, it links `mise/plugins/vp` and installs the Vite+ CLI when `vp` is missing.

- [Vite+](https://viteplus.dev/guide/) uses the official installer under `~/.vite-plus`. Bootstrap leaves its global Node.js takeover disabled. The existing Zsh configuration sources `~/.vite-plus/env`; use `vp env on` if you want Vite+ to own global Node.js management.
- Global CLIs are `vp:` entries in `[bootstrap.packages]`, alongside the Homebrew and zypper entries. `"latest"` is installed only when missing. An exact version is installed when it is missing or the installed version differs. Removing an entry does not uninstall the package.

An existing Vite+ install is left alone. Update it with `vp upgrade`, and update unpinned global packages with `vp update -g` or `mise bootstrap packages upgrade`. Bootstrap neither copies tokens nor migrates conversation data.

## macOS setup

Install mise and clone the repository as above, then preview and apply:

```sh
MISE_CONFIG_DIR="$HOME/.dotfiles/mise" mise bootstrap --dry-run
MISE_CONFIG_DIR="$HOME/.dotfiles/mise" mise bootstrap
```

Install the macOS development tool defaults with `mise install`. Everyday CLI tools (including aria2 and gat) and Zsh plugins remain Homebrew bootstrap packages. Bootstrap also installs Vite+, the `vp:` global packages, and the GUI applications and fonts in the Brewfile. Removing a Formula or a global package from the configuration does not uninstall an existing copy; verify `mise which go`, `mise which nim`, and `mise which rustc` after installation before removing old Homebrew versions.

On macOS, bootstrap also links `config/git/darwin.gitconfig` (Secretive SSH signing), `~/.ssh/config`, and the direnv configuration. mise installs direnv; `config/direnv/direnvrc` adds `use_age` for age-encrypted `.env.age` files. See [`docs/git&verify.md`](docs/git&verify.md) for SSH keys and Git signing.

Bootstrap links `config/nix` to `~/.config/nix`, which enables `nix-command` and flakes. Project toolchains belong in each project's flake.

## Updates and checks

```sh
cd ~/.dotfiles
git pull
mise bootstrap --dry-run
mise bootstrap
mise doctor
mise bootstrap status
```

`"latest"` leaves a system package unpinned; bootstrap installs missing packages rather than upgrading the whole OS. Plugin repositories without a pinned ref can be refreshed explicitly with `mise bootstrap --update`.

Run the isolated bootstrap checks with mise 2026.10.14 or newer, Zsh, Git, and Python 3.8+ available:

```sh
python3 -B tests/test_bootstrap.py
```

The checks use temporary homes and real mise commands for config discovery,
links, shell activation, conflicts, and repeat runs. Plugin repositories are
cloned from local Git fixtures with distinct pinned refs. Installer downloads
and the macOS `brew` command use local fixtures to check arguments, failure
handling, and cleanup without running remote installers or real package
managers. CI runs them on macOS and Linux.
