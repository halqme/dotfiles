.PHONY: sync build clean

sync:
	home-manager switch

build:
	home-manager build

clean:
	home-manager expire-generations '-1 day'
	nix-collect-garbage -d
	nix-env --profile ~/.local/state/nix/profiles/home-manager --delete-generations +5