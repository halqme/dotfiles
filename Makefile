.PHONY: sync build clean

sync:
	home-manager switch --flake .#hal -b backup

build:
	home-manager build --flake .#hal

clean:
	home-manager expire-generations '-5 second'
	nix-collect-garbage -d
	nix-env --profile ~/.local/state/nix/profiles/home-manager --delete-generations +5
	nix-env --profile ~/.local/state/nix/profiles/profile --delete-generations +5
	nix-env --profile ~/.local/state/nix/profiles/channels --delete-generations +5