# Dotfiles

Nix Flake + Home Manager + Homebrew でmacOS環境を管理

## 構成

| レイヤ        | 管理対象                                     |
| ------------- | -------------------------------------------- |
| Home Manager  | ユーザー環境 / dotfiles / シェル / CLIツール |
| Homebrew cask | GUIアプリ                                    |
| Homebrew mas  | Mac App Store アプリ                         |

## セットアップ

```bash
# Nixのインストール
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

# Home Managerのインストール
nix run home-manager/master -- init --switch

# このリポジトリをクローン
git clone <repo-url> ~/dotfiles
cd ~/dotfiles

# 初回適用
## flakes, nix-commandの有効化
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
## 実行
nix-shell -p home-manager.out --run 'home-manager switch --flake .#hal'
```

## 使い方

```bash
# 設定を適用
make switch

# ビルドのみ
make build

# ガベージコレクション
make clean
```

## ディレクトリ構造

```
.
├── flake.nix           # Flake設定
├── home/               # Home Manager設定
│   ├── default.nix
│   ├── dev/             # パッケージやツール、変数など
│   ├── shell/           # シェル設定
│   └── git/             # Git設定
├── hosts/                # ホスト別設定
│   └── macbook/
│       └── home.nix
├── modules/             # 再利用可能なモジュール
│   ├── config-files/   # dotfilesリンク管理
│   └── gui/            # Homebrew管理
└── config/              # 実際の設定ファイル
```
