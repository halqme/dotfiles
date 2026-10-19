# Home Manager checks

Run from this directory with Nix flakes enabled:

```sh
nix flake check path:. --no-write-lock-file --print-build-logs
```

Checks are available for `aarch64-darwin` and `x86_64-linux`:

- `configuration` evaluates both host configurations and checks identities,
  Home Manager assertions, shared settings, macOS Git signing and SSH settings,
  and the absence of macOS credential requirements on Linux. It also evaluates
  the configuration builder with invalid names and explicit state-version
  overrides.
- `use-age` runs the generated direnv configuration for the native host using
  real age and direnv binaries. It checks default and explicit filenames,
  missing files, decryption errors, retry, and temporary plaintext cleanup.
  A failing dotenv function is injected to check error-status propagation.

Runtime fixtures use a temporary HOME and a generated test identity. The checks
do not activate Home Manager or read the user's keys. CI runs these checks on
macOS and Linux, then builds the corresponding activation package.
