{lib, ...}: {
  imports = [
    ./config.nix
    ./env.nix
    ./git.nix
    ./packages.nix
    ./programs.nix
    ./shell.nix
  ];

  xdg.enable = true;

  home.activation.brewBundle = lib.hm.dag.entryAfter ["linkGeneration"] ''
    echo "Brewfile Check"
    BREWFILE="$HOME/.config/homebrew/Brewfile"
    HASH_FILE="$HOME/.local/share/home-manager/brew-hash"

    if [ ! -f "$BREWFILE" ]; then
      echo "No Brewfile found at $BREWFILE, skipping."
      exit 0
    fi

    mkdir -p "$(dirname "$HASH_FILE")"

    OLD_HASH=""
    if [ -f "$HASH_FILE" ]; then
      OLD_HASH=$(cat "$HASH_FILE")
    fi

    CURRENT_HASH=$(/usr/bin/shasum "$BREWFILE" | /usr/bin/cut -d' ' -f1)

    if [ "$CURRENT_HASH" != "$OLD_HASH" ]; then
      echo "Brewfile changed, running brew bundle..."
      if /opt/homebrew/bin/brew bundle --cleanup --global; then
        NEW_HASH=$(/usr/bin/shasum "$BREWFILE" | /usr/bin/cut -d' ' -f1)
        echo "$NEW_HASH" > "$HASH_FILE"
        echo "brew bundle succeeded, hash updated."
      else
        echo "brew bundle failed. Skipping hash update."
        exit 1
      fi
    else
      echo "Brewfile unchanged, skipping brew bundle."
    fi
  '';
}
