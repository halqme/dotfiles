{ config, lib, ... }:

let
  # casks, fonts, masApps を Nix から集約
  casks = config.my.gui.casks;
  fonts = config.my.gui.fonts;
  masApps = config.my.gui.masApps;

  # Brewfile を生成（cask + font + mas）
  brewfileContent = lib.concatStringsSep "\n" (
    (map (cask: "cask \"${cask}\"") casks)
    ++ (map (font: "cask \"${font}\"") fonts)
    ++ (map (name: "mas \"${name}\", id: ${toString masApps.${name}}") (builtins.attrNames masApps))
  );
in
{
  # .Brewfile をホームディレクトリに生成
  home.file.".Brewfile".text = brewfileContent;

  home.activation.brewSync = ''
    set -e

    # PATH に homebrew を追加
    export PATH="/usr/bin:/usr/local/bin:$HOME/.nix-profile/bin:/opt/homebrew/bin:$HOME/.homebrew/bin:$PATH"

    # brew バイナリを検索
    BREW_BIN=$(command -v brew || true)
    if [ -z "$BREW_BIN" ]; then
      for path in /opt/homebrew/bin/brew /usr/local/bin/brew "$HOME/.homebrew/bin/brew" "$HOME/.nix-profile/bin/brew"; do
        if [ -x "$path" ]; then
          BREW_BIN="$path"
          break
        fi
      done
    fi

    if [ -z "$BREW_BIN" ]; then
      echo "brew not found. Skipping brew sync."
      exit 0
    fi

    BREWFILE="$HOME/.Brewfile"
    HASH_FILE="$HOME/.local/state/nix/brew-hash"

    if [ ! -f "$BREWFILE" ]; then
      echo ".Brewfile not found. Skipping brew sync."
      exit 0
    fi

    # 現在の Brewfile のハッシュを計算
    CURRENT_HASH=$(sha256sum "$BREWFILE" | awk '{print $1}')

    # 前回のハッシュと比較
    if [ -f "$HASH_FILE" ] && [ "$(cat "$HASH_FILE")" = "$CURRENT_HASH" ]; then
      echo "📦 Brew configuration unchanged. Skipping brew bundle..."
      exit 0
    fi

    echo "🚀 Brew configuration changed. Running brew bundle..."

    # フォント tap を有効化
    $BREW_BIN tap homebrew/cask-fonts >/dev/null 2>&1 || true

    # brew bundle を実行
    if $BREW_BIN bundle --file="$BREWFILE"; then
      echo "✅ Brew bundle completed successfully."
    else
      echo "❌ Brew bundle failed."
      exit 1
    fi

    # ハッシュを保存
    echo "$CURRENT_HASH" > "$HASH_FILE"
    echo "💾 Saved brew-hash for next comparison."
  '';
}