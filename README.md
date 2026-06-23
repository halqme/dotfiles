# dotfiles (Home Manager)

Home Manager を使用した macOS (Main) および Linux (Minimal) の環境設定リポジトリです。

## 構成

- `config/`: 共通のドットファイル（Zsh, Tmux, Neovim, Ghostty 等）
- `modules/common/`: 全環境で共有する Home Manager モジュール
- `modules/platform/`: OS ごとの差分モジュール
- `hosts/`: ホストごとの差分設定
  - `macbook/`: macOS 用のメイン環境
  - `actions/`: GitHub Actions 用の最小限環境

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
cd ~/.config/home-manager
```

環境（ユーザー名とホスト名）に一致する設定が `flake.nix` に定義されている場合、以下のコマンドのみで適用されます。

```bash
home-manager switch
```

一致する設定がない場合や、明示的に指定したい場合は `#` で設定名を指定します。

```bash
home-manager switch --flake .#hal@MacBook-Pro.local
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

### 5. `/nix` が空になる場合

macOS のアップデート後に `/nix` が空になって見えることがありますが、ほとんどの場合は `Nix Store` の APFS volume が未マウントになっているだけです。

まずは volume の状態を確認します。

```bash
diskutil apfs list
```

`Nix Store` が `Not Mounted` になっている場合は、ディスクユーティリティから再マウントすることで対処できます。

再マウント後、もし`nix` コマンドが見つからない場合は以下の通りパスを補完することで対処可能です。

```bash
export path=(
  "$HOME/.nix-profile/bin"
  "$HOME/.nix-profile/home-path/bin"
  "/nix/var/nix/profiles/default/bin"
  $path
)
```
