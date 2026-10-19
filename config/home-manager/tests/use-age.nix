{
  pkgs,
  direnvrc,
}:
pkgs.runCommand "home-manager-use-age-tests" {
  nativeBuildInputs = [pkgs.age pkgs.direnv];
} ''
  set -euo pipefail

  export HOME="$NIX_BUILD_TOP/home"
  export XDG_CONFIG_HOME="$HOME/.config"
  export TMPDIR="$NIX_BUILD_TOP/age-tmp"
  mkdir -p "$XDG_CONFIG_HOME/age" "$TMPDIR" project
  cd project

  age-keygen -o "$XDG_CONFIG_HOME/age/identity.age"
  recipient="$(age-keygen -y "$XDG_CONFIG_HOME/age/identity.age")"
  printf '%s\n' "HOME_MANAGER_TEST_SECRET='a value with spaces'" > plaintext.env
  age -r "$recipient" -o .env.age plaintext.env
  cp .env.age "custom file.age"
  printf '%s\n' 'not an age file' > invalid.age

  eval "$(direnv stdlib)"
  source ${direnvrc}

  fail() {
    echo "$*" >&2
    exit 1
  }

  assert_no_temporary_plaintext() {
    test -z "$(find "$TMPDIR" -mindepth 1 -print -quit)" ||
      fail "use_age left a temporary plaintext file behind"
  }

  (
    echo "use_age: missing input is a no-op"
    export HOME_MANAGER_TEST_SECRET=unchanged
    use_age missing.age
    test "$HOME_MANAGER_TEST_SECRET" = unchanged
    assert_no_temporary_plaintext
  )

  (
    echo "use_age: default input exports dotenv values"
    unset HOME_MANAGER_TEST_SECRET
    use_age
    test "$(printenv HOME_MANAGER_TEST_SECRET)" = "a value with spaces"
    assert_no_temporary_plaintext
  )

  (
    echo "use_age: explicit paths support spaces"
    unset HOME_MANAGER_TEST_SECRET
    use_age "custom file.age"
    test "$(printenv HOME_MANAGER_TEST_SECRET)" = "a value with spaces"
    assert_no_temporary_plaintext
  )

  (
    echo "use_age: decryption failure does not export values and permits retry"
    unset HOME_MANAGER_TEST_SECRET
    if use_age invalid.age; then
      fail "use_age accepted invalid ciphertext"
    else
      test "$?" -eq 1
    fi
    test -z "''${HOME_MANAGER_TEST_SECRET+x}"
    assert_no_temporary_plaintext

    use_age
    test "$(printenv HOME_MANAGER_TEST_SECRET)" = "a value with spaces"
    assert_no_temporary_plaintext
  )

  (
    echo "use_age: missing identity fails without leaving plaintext"
    export HOME="$NIX_BUILD_TOP/no-identity"
    unset HOME_MANAGER_TEST_SECRET
    if use_age; then
      fail "use_age succeeded without an identity"
    else
      test "$?" -eq 1
    fi
    test -z "''${HOME_MANAGER_TEST_SECRET+x}"
    assert_no_temporary_plaintext
  )

  (
    echo "use_age: dotenv failure is propagated after cleanup"
    dotenv() { return 23; }
    if use_age; then
      fail "use_age swallowed the dotenv failure"
    else
      test "$?" -eq 23
    fi
    assert_no_temporary_plaintext
  )

  touch "$out"
''
