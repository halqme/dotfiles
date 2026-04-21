{
  lib,
  ...
}: {
  imports = [
    ./config.nix
    ./env.nix
    ./git.nix
    ./packages.nix
    ./programs.nix
    ./shell.nix
  ];

  xdg.enable = true;

  home.activation.brewBundle = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Brewfile Check"
    BREWFILE="$HOME/.config/homebrew/Brewfile"
    HASH_FILE="$HOME/.local/share/home-manager/brew-hash"

    if [ -f "$BREWFILE" ] ; then
      mkdir -p "$(dirname "$HASH_FILE")"
      NEW_HASH=$(/usr/bin/shasum "$BREWFILE" | /usr/bin/cut -d' ' -f1)
      OLD_HASH=""
      if [ -f "$HASH_FILE" ] ; then
        OLD_HASH=$(cat "$HASH_FILE")
      fi

      if [ "$NEW_HASH" != "$OLD_HASH" ] ; then
        echo "Brewfile changed, running brew bundle..."
        /opt/homebrew/bin/brew bundle --cleanup --global || true
        echo "$NEW_HASH" > "$HASH_FILE"
        else
        echo "Brewfile unchanged, skipping brew bundle."
      fi
    fi
  '';
}
