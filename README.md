# dotfiles (Home Manager)

Home Manager を使用した macOS (Main) および Linux (Minimal) の環境設定リポジトリです。

## 構成

- `config/`: 共通のドットファイル（Zsh, Tmux, Neovim, Ghostty 等）
- `hosts/`: ホストごとの Home Manager 設定
    - `macos/`: macOS 用のメイン環境
    - `linux/`: Linux 用の最小限環境

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
実行するユーザー名がflakeで定義されており、アーキテクチャも同一であることを確認してください。

#### 初回
```bash
nix run home-manager/master -- switch --flake .
```

#### 2回目以降
```bash
home-manager switch --flake .
```

### 4. クリーンアップ
```bash
home-manager expire-generations '-1 day'
nix-env --profile ~/.local/state/nix/profiles/home-manager --delete-generations +5
nix-collect-garbage -d
```
