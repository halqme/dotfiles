# home-manager

## usgae

### first time
```bash
# install nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)

# enable flake, command
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf

# clone
git clone https://github.com/HALQME/dotfiles ~/.config/home-manager

# run
nix run home-manager/master -- switch
# restart terminal
exec $SHELL -l
```

### on update

```bash
home-manager switch
```
