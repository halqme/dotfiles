# dotfiles (Home Manager)

Home Manager を使用した macOS (Main) および Linux (Minimal) の環境設定リポジトリです。

## 構成

- `config/`: 共通のドットファイル（Zsh, Tmux, Neovim, Ghostty 等）
- `hosts/`: ホストごとの Home Manager 設定
    - `macos/`: macOS 用のメイン環境
    - `linux/`: Linux 用の最小限環境（サンプル程度）

## セットアップ

### 1. Nix のインストール
```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```

### 2. Flake の有効化
```bash
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

### 3. 設定の適用

リポジトリを `~/.config/home-manager` にクローンして実行します。

```bash
git clone https://github.com/HALQME/dotfiles.git ~/.config/home-manager
```

```bash
cd ~/.config/home-manager
nix run home-manager/master -- switch --flake .
```

最初の実行時にhome-managerがインストールされるため、2回目以降は、`nix run` を省略することができます。

また、どのディレクトリからでも、（ユーザー名とホストのアーキテクチャが一意になる場合は）
```bash
home-manager switch
```
のみで更新することも可能です。

### 4. クリーンアップ
```bash
nix run home-manager/master -- expire-generations '-1 day'
nix-env --profile ~/.local/state/nix/profiles/home-manager --delete-generations +5
nix-collect-garbage -d
```
