# dotfiles

[mise bootstrap](https://mise.jdx.dev/bootstrap.html) manages packages, dotfile links, shell activation, and setup tasks. Linux can be set up without Nix or Home Manager. The macOS Home Manager configuration remains available separately.

| Component | Responsibility |
| --- | --- |
| `mise/config.toml` | Shared dotfiles and Zsh activation |
| `mise/config.linux.toml` | Linux packages, Git defaults, Zsh plugins, Hermes Agent, Vite Plus |
| `mise/config.macos.toml` | Homebrew packages, macOS settings, links for Nix / Home Manager |
| `config/` | Shell, prompt, editor, and terminal configuration |
| `config/home-manager/` | Optional Home Manager configuration |

Platform configs load automatically through `mise/miserc.toml`. Language runtimes belong in each project's `mise.toml`, not the global configuration.

## Linux setup (Tumbleweed, no Nix)

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

Use **mise 2026.10.14 or newer** for `zypper:` support. Read the config and dry run before applying; bootstrap downloads and executes the official Hermes and Vite Plus installers. Use `--skip task` on the apply command to leave those applications out.

The initial `MISE_CONFIG_DIR` selects both shared and platform configuration. After the links are installed, plain `mise bootstrap` loads them from `~/.config/mise`. `MISE_CONFIG_FILE` selects only one file, so do not use it for the initial platform bootstrap.

mise installs global CLI packages through the available manager: `zypper` on Tumbleweed, `apt` on Debian/Ubuntu. Entries for an unavailable manager are skipped. Bootstrap does not perform a distribution upgrade or install compilers; update Tumbleweed with `sudo zypper dup` and add project build dependencies as needed.

### Zsh and Powerlevel10k

Bootstrap sets the login shell to `/usr/bin/zsh` on Linux and `/bin/zsh` on macOS. The selected path must be executable and listed in `/etc/shells`. On Linux, bootstrap links the existing `.p10k.zsh` and clones Powerlevel10k, fzf-tab, autosuggestions, and fast-syntax-highlighting under `~/.local/share/zsh`. Linux loads those plugins directly; macOS keeps using Homebrew. Existing shell startup files are preserved outside mise's marked blocks. A conflicting whole-file dotfile stops the run rather than being overwritten; review and merge it manually.

Log out and back in after applying. Choose a Nerd Font in your terminal for the existing p10k icons; for SSH, the font is configured on the client. Run `p10k configure` only if you want to change the shared prompt configuration.

Git defaults on Linux include the HAL identity from `config/git/config`, delta, and Git LFS. Review the identity before applying on another person's account. SSH keys, Git signing, and credentials are not copied or generated.

### Hermes Agent and Vite Plus

Linux bootstrap runs these tasks once the base configuration is in place:

```sh
mise run install:hermes
mise run install:vite-plus
```

- [Hermes Agent](https://hermes-agent.nousresearch.com/docs/getting-started/installation/) uses the official installer in non-interactive mode, without browser or computer-use tools. It may download managed runtimes and dependencies. Run `hermes setup` afterward to choose authentication and models; no gateway service is enabled by this bootstrap. Additional features can require native build or system dependencies.
- [Vite Plus](https://viteplus.dev/guide/) uses the official installer under `~/.vite-plus`. Bootstrap leaves its global Node.js takeover disabled. The existing Zsh configuration sources `~/.vite-plus/env`; use `vp env on` if you want Vite Plus to own global Node.js management.

Existing commands are left alone. Updates are explicit: `hermes update` and `vp upgrade`. Bootstrap neither copies tokens nor migrates conversation data.

## macOS setup

Install mise and clone the repository as above, then preview and apply:

```sh
MISE_CONFIG_DIR="$HOME/.dotfiles/mise" mise bootstrap --dry-run
MISE_CONFIG_DIR="$HOME/.dotfiles/mise" mise bootstrap
```

The macOS task installs GUI applications and fonts through `brew bundle`. The separate Home Manager setup is only needed for the generated Git/SSH and Nix-specific configuration used on the existing Macs:

```sh
home-manager switch --flake ~/.dotfiles/config/home-manager#hal@MacBook-Pro.local
```

See [`docs/git&verify.md`](docs/git&verify.md) for SSH keys and Git signing. Linux does not run Home Manager or link the Nix configuration.

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
