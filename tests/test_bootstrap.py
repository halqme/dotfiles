#!/usr/bin/env python3
"""Exercise bootstrap in temporary homes without installing system packages."""

import json
import os
import platform
import re
import shutil
import subprocess
import sys
import tempfile
import textwrap
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MISE = shutil.which("mise")
ZSH = shutil.which("zsh")


class BootstrapTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not MISE or not ZSH:
            raise RuntimeError("These tests require mise >= 2026.10.14 and Zsh on PATH")
        version = subprocess.check_output([MISE, "--version"], text=True)
        match = re.match(r"(\d+)\.(\d+)\.(\d+)", version)
        if not match or tuple(map(int, match.groups())) < (2026, 10, 14):
            raise RuntimeError(
                "These tests require mise >= 2026.10.14; found " + version.strip()
            )

    def setUp(self):
        temporary = tempfile.TemporaryDirectory(prefix="bootstrap-test-")
        self.addCleanup(temporary.cleanup)
        self.work = Path(temporary.name).resolve()
        self.home = self.work / "home with spaces"
        self.repo = self.home / ".dotfiles"
        self.config = self.repo / "mise"
        self.config.mkdir(parents=True)
        for name in (
            "config.toml",
            "config.linux.toml",
            "config.macos.toml",
            "miserc.toml",
        ):
            shutil.copy2(ROOT / "mise" / name, self.config / name)
        shutil.copytree(ROOT / "mise" / "plugins", self.config / "plugins")
        self.repo.joinpath("config").symlink_to(
            ROOT / "config", target_is_directory=True
        )

        self.bin = self.work / "bin"
        self.bin.mkdir()
        for name in (
            "bash",
            "sh",
            "git",
            "mkdir",
            "mktemp",
            "rm",
            "cat",
            "chmod",
            "uname",
        ):
            executable = shutil.which(name)
            if not executable:
                self.fail("Missing test prerequisite: " + name)
            self.bin.joinpath(name).symlink_to(Path(executable).resolve())
        if MISE:
            self.bin.joinpath("mise").symlink_to(Path(MISE).resolve())
        self.downloads = self.work / "downloads.jsonl"
        self.records = self.work / "records"
        self.records.mkdir()
        # BSD mktemp can ignore TMPDIR; failed assertions must not leak installers.
        self.addCleanup(self.cleanup_downloads)
        self.tmp = self.work / "tmp"
        self.tmp.mkdir()
        # Do not inherit credentials, activation hooks, or package managers from the caller.
        self.env = {
            "HOME": str(self.home),
            "PATH": str(self.bin),
            "SHELL": ZSH,
            "TERM": "dumb",
            "LANG": "C.UTF-8",
            "TMPDIR": str(self.tmp),
            "XDG_CONFIG_HOME": str(self.home / ".config"),
            "XDG_CACHE_HOME": str(self.home / ".cache"),
            "XDG_DATA_HOME": str(self.home / ".local/share"),
            "XDG_STATE_HOME": str(self.home / ".local/state"),
            "MISE_CONFIG_DIR": str(self.config),
            "MISE_DATA_DIR": str(self.home / ".local/share/mise"),
            "MISE_STATE_DIR": str(self.home / ".local/state/mise"),
            "MISE_CACHE_DIR": str(self.home / ".cache/mise"),
            "MISE_TRUSTED_CONFIG_PATHS": str(self.repo),
            "MISE_TASK_RUN_AUTO_INSTALL": "false",
            "MISE_YES": "1",
            "MISE_COLOR": "0",
            "NO_COLOR": "1",
            "GIT_CONFIG_NOSYSTEM": "1",
            "GIT_TERMINAL_PROMPT": "0",
            "GIT_ALLOW_PROTOCOL": "file",
            "HOMEBREW_PREFIX": str(self.work / "homebrew"),
            "TEST_DOWNLOADS": str(self.downloads),
            "TEST_RECORDS": str(self.records),
            "TEST_TEMP_ROOT": str(self.work.parent),
            "TEST_VP_STUB": str(self.work / "vp-stub"),
        }
        self.write_vp_stub()
        self.write_executable("curl", self.fake_curl())

    def run_command(self, command, *, selected=None, overrides=None, success=True):
        env = self.env.copy()
        if selected:
            env.update(MISE_AUTO_ENV="false", MISE_ENV=selected)
        for key, value in (overrides or {}).items():
            if value is None:
                env.pop(key, None)
            else:
                env[key] = value
        result = subprocess.run(
            command,
            check=False,
            cwd=self.home,
            env=env,
            text=True,
            capture_output=True,
            timeout=30,
        )
        diagnostic = " ".join(command) + "\n" + result.stdout + result.stderr
        if success:
            self.assertEqual(result.returncode, 0, diagnostic)
        else:
            self.assertNotEqual(result.returncode, 0, diagnostic)
        return result

    def mise(self, *args, **kwargs):
        return self.run_command([MISE, *args], **kwargs)

    def bootstrap_dotfiles(self, **kwargs):
        return self.mise(
            "bootstrap",
            "--only",
            "dotfiles,mise-shell-activate",
            "--yes",
            **kwargs,
        )

    def assert_link(self, target, source):
        path = self.home / target
        self.assertTrue(path.is_symlink(), str(path) + " is not a symlink")
        self.assertEqual(path.resolve(), (self.repo / source).resolve())
        self.assertTrue(path.exists(), str(path) + " has a missing source")

    def write_vp_stub(self):
        self.work.joinpath("vp-stub").write_text(
            textwrap.dedent("""\
            #!/bin/sh
            set -eu
            printf '%s\\n' "$*" >> "$TEST_RECORDS/vp-args"
            state="$TEST_RECORDS/vp-installed"
            if [ ! -f "$state" ]; then
              : > "$state"
            fi
            name_of() {
              spec=$1
              case "$spec" in
                @*/*@*) printf '%s' "${spec%@*}" ;;
                @*) printf '%s' "$spec" ;;
                *@*) printf '%s' "${spec%%@*}" ;;
                *) printf '%s' "$spec" ;;
              esac
            }
            if [ "${1:-}" = "list" ]; then
              printf '%s\\n' '['
              first=1
              while IFS= read -r line || [ -n "$line" ]; do
                [ -n "$line" ] || continue
                name=$(name_of "$line")
                case "$line" in
                  "$name") version=0.0.0 ;;
                  *) version=${line#"$name"@} ;;
                esac
                if [ "$first" -eq 1 ]; then
                  first=0
                else
                  printf '%s\\n' ','
                fi
                printf '  {"name": "%s", "version": "%s"}' "$name" "$version"
              done < "$state"
              printf '\\n]\\n'
              exit 0
            fi
            if [ "${1:-}" = "install" ]; then
              test "${TEST_VP_INSTALL_FAIL:-0}" = 0 || exit 31
              shift
              while [ "$#" -gt 0 ]; do
                case "$1" in
                  -*) shift ;;
                  *)
                    spec=$1
                    name=$(name_of "$spec")
                    tmp=$(mktemp)
                    while IFS= read -r line || [ -n "$line" ]; do
                      [ -n "$line" ] || continue
                      current=$(name_of "$line")
                      if [ "$current" != "$name" ]; then
                        printf '%s\\n' "$line" >> "$tmp"
                      fi
                    done < "$state"
                    printf '%s\\n' "$spec" >> "$tmp"
                    cat "$tmp" > "$state"
                    rm -f "$tmp"
                    shift
                    ;;
                esac
              done
              exit 0
            fi
            exit 0
            """)
        )

    def set_vp_packages(self, packages):
        path = self.config / "config.toml"
        lines = [
            line
            for line in path.read_text().splitlines(keepends=True)
            if not line.startswith('"vp:')
        ]
        headers = [
            index
            for index, line in enumerate(lines)
            if line.strip() == "[bootstrap.packages]"
        ]
        if len(headers) != 1:
            self.fail("shared config must contain one [bootstrap.packages] table")
        header_at = headers[0]
        lines[header_at + 1 : header_at + 1] = [
            f'"vp:{name}" = "{version}"\n' for name, version in packages
        ]
        path.write_text("".join(lines))

    def vp_invocations(self):
        path = self.records / "vp-args"
        if not path.exists():
            return []
        return path.read_text().splitlines()

    def vp_installs(self):
        return [line for line in self.vp_invocations() if line.startswith("install ")]

    def write_executable(self, name, content):
        path = self.bin / name
        path.write_text(content)
        path.chmod(0o755)
        return path

    def download_records(self):
        if not self.downloads.exists():
            return []
        return [json.loads(line) for line in self.downloads.read_text().splitlines()]

    def cleanup_downloads(self):
        for record in self.download_records():
            Path(record["destination"]).unlink(missing_ok=True)

    def assert_installers_cleaned_up(self):
        records = self.download_records()
        self.assertTrue(records, "The fixture did not exercise a download")
        for record in records:
            path = Path(record["destination"])
            self.assertFalse(
                path.exists(), "Temporary installer was not removed: " + str(path)
            )

    def fake_curl(self):
        return (
            "#!"
            + sys.executable
            + "\n"
            + textwrap.dedent('''\
            import json
            import os
            from pathlib import Path
            import sys

            args = sys.argv[1:]
            url = next(arg for arg in args if arg.startswith("https://"))
            destination = Path(args[args.index("-o") + 1])
            if (destination.is_symlink() or not destination.is_file()
                    or Path(os.environ["TEST_TEMP_ROOT"]) not in destination.resolve().parents
                    or destination.stat().st_size != 0):
                raise SystemExit("Installer destination must be a new temporary file")
            with open(os.environ["TEST_DOWNLOADS"], "a") as log:
                log.write(json.dumps({"url": url, "args": args,
                                      "destination": str(destination)}) + "\\n")
            if os.environ.get("TEST_DOWNLOAD_FAIL") == "1":
                destination.write_text("partial download\\n")
                sys.exit(22)
            if url == "https://hermes-agent.nousresearch.com/install.sh":
                script = """set -eu
            printf '%s\\n' "$@" > "$TEST_RECORDS/hermes-args"
            test "${TEST_INSTALL_FAIL:-0}" = 0 || exit 31
            mkdir -p "$HOME/.local/bin"
            printf '#!/bin/sh\\nexit 0\\n' > "$HOME/.local/bin/hermes"
            chmod +x "$HOME/.local/bin/hermes"
            """
            elif url == "https://vite.plus":
                script = """set -eu
            printf '%s\\n' "$VP_HOME" "$VP_NODE_MANAGER" > "$TEST_RECORDS/vite-env"
            test "${TEST_INSTALL_FAIL:-0}" = 0 || exit 31
            mkdir -p "$VP_HOME/bin"
            cat "$TEST_VP_STUB" > "$VP_HOME/bin/vp"
            chmod +x "$VP_HOME/bin/vp"
            """
            else:
                raise SystemExit("Unexpected installer URL: " + url)
            destination.write_text(script)
            ''')
        )

    def test_native_config_discovery_survives_initial_bootstrap(self):
        expected = "macos" if platform.system() == "Darwin" else "linux"
        before = json.loads(self.mise("config", "ls", "--json").stdout)
        self.assertEqual(
            {Path(item["path"]).name for item in before},
            {"config.toml", "config." + expected + ".toml"},
        )
        self.bootstrap_dotfiles()
        after = json.loads(
            self.mise(
                "config",
                "ls",
                "--json",
                overrides={"MISE_CONFIG_DIR": None},
            ).stdout
        )
        self.assertEqual(
            {Path(item["path"]).resolve() for item in after},
            {
                self.config / "config.toml",
                self.config / ("config." + expected + ".toml"),
            },
        )
        self.mise(
            "bootstrap",
            "dotfiles",
            "status",
            "--missing",
            overrides={"MISE_CONFIG_DIR": None},
        )
        self.assert_link(
            ".config/zsh/platform",
            "config/zsh/" + ("darwin" if expected == "macos" else "linux"),
        )

    def test_login_shell_paths_follow_platform_configuration(self):
        for selected, expected in (("linux", "/usr/bin/zsh"), ("macos", "/bin/zsh")):
            with self.subTest(platform=selected):
                status = json.loads(
                    self.mise(
                        "bootstrap",
                        "user",
                        "status",
                        "--json",
                        selected=selected,
                    ).stdout
                )
                self.assertEqual(status["login_shell"]["shell"], expected)

    def test_linux_bootstrap_preserves_local_settings_and_is_idempotent(self):
        originals = {
            ".zshenv": "export KEEP_ZSHENV=yes\n",
            ".zprofile": "export KEEP_ZPROFILE=yes\n",
            ".zshrc": "export KEEP_ZSHRC=yes\n",
            ".gitconfig": "[alias]\n    local = status --short\n",
        }
        for name, content in originals.items():
            self.home.joinpath(name).write_text(content)
        self.bootstrap_dotfiles(selected="linux")
        self.assert_link(".config/zsh/platform", "config/zsh/linux")
        self.assert_link(".config/zsh/.p10k.zsh", "config/zsh/.p10k.zsh")
        self.assert_link(".config/git/dotfiles.gitconfig", "config/git/config")
        self.assert_link(".fx/AGENTS.md", "config/agents/AGENTS.md")
        self.assert_link(".claude/CLAUDE.md", "config/agents/AGENTS.md")
        self.assertFalse(self.home.joinpath(".config/nix").exists())
        self.assertFalse(self.home.joinpath(".ssh/config").exists())
        self.assertFalse(self.home.joinpath(".config/git/darwin.gitconfig").exists())
        for key, value in {
            "alias.local": "status --short",
            "user.name": "HAL",
            "user.useConfigOnly": "true",
            "init.defaultBranch": "main",
            "rebase.updateRefs": "true",
        }.items():
            result = self.run_command(
                [
                    str(self.bin / "git"),
                    "config",
                    "--global",
                    "--includes",
                    "--get",
                    key,
                ]
            )
            self.assertEqual(result.stdout.strip(), value)
        for key in ("commit.gpgsign", "user.signingkey", "core.fsmonitor"):
            self.run_command(
                [
                    str(self.bin / "git"),
                    "config",
                    "--global",
                    "--includes",
                    "--get",
                    key,
                ],
                success=False,
            )
        snapshot = {name: self.home.joinpath(name).read_bytes() for name in originals}
        for name, content in originals.items():
            self.assertIn(content, snapshot[name].decode())
        self.bootstrap_dotfiles(selected="linux")
        self.assertEqual(
            snapshot,
            {name: self.home.joinpath(name).read_bytes() for name in originals},
        )
        self.mise("bootstrap", "dotfiles", "status", "--missing", selected="linux")

    def test_macos_links_stay_platform_specific(self):
        self.bootstrap_dotfiles(selected="macos")
        self.assert_link(".config/zsh/platform", "config/zsh/darwin")
        self.assert_link(".config/nix", "config/nix")
        self.assert_link(".config/git/dotfiles.gitconfig", "config/git/config")
        self.assert_link(".config/git/darwin.gitconfig", "config/git/darwin.gitconfig")
        self.assert_link(".ssh/config", "config/ssh/config")
        self.assert_link(".config/direnv/direnvrc", "config/direnv/direnvrc")
        self.assertFalse(self.home.joinpath(".config/home-manager").exists())
        for key, value in {
            "user.name": "HAL",
            "core.fsmonitor": "true",
            "commit.gpgsign": "true",
            "gpg.format": "ssh",
        }.items():
            result = self.run_command(
                [
                    str(self.bin / "git"),
                    "config",
                    "--global",
                    "--includes",
                    "--get",
                    key,
                ]
            )
            self.assertEqual(result.stdout.strip(), value)
        self.assert_link(".fx/AGENTS.md", "config/agents/AGENTS.md")
        self.assert_link(".claude/CLAUDE.md", "config/agents/AGENTS.md")
        tasks = json.loads(self.mise("tasks", "ls", "--json", selected="macos").stdout)
        names = {task["name"] for task in tasks}
        self.assertIn("install:vite-plus", names)
        self.assertNotIn("install:vp-globals", names)
        self.assertIn("brew-bundle", names)
        self.assertNotIn("install:hermes", names)

    @unittest.skipUnless(platform.system() == "Darwin", "macOS bootstrap task")
    def test_macos_bootstrap_uses_the_linked_brewfile(self):
        self.write_executable(
            "brew",
            '#!/bin/sh\nprintf \'%s\\n\' "$@" > "$TEST_RECORDS/brew-args"\n',
        )
        self.bootstrap_dotfiles(selected="macos")
        self.mise("bootstrap", "--only", "task", "--yes", selected="macos")
        self.assertEqual(
            self.records.joinpath("brew-args").read_text().splitlines(),
            [
                "bundle",
                "install",
                "--file",
                str(self.home / ".config/homebrew/Brewfile"),
            ],
        )

    def test_dry_run_does_not_write_managed_targets(self):
        result = self.mise("bootstrap", "--dry-run", "--yes")
        self.assertIn(".zshrc", result.stdout + result.stderr)
        for name in (
            ".zshenv",
            ".zprofile",
            ".zshrc",
            ".gitconfig",
            ".config/zsh",
            ".config/mise",
        ):
            self.assertFalse(
                self.home.joinpath(name).exists(), name + " was created during dry-run"
            )
        self.assertEqual(self.download_records(), [])

    def test_conflicting_file_is_preserved_and_can_be_resolved(self):
        target = self.home / ".tmux.conf"
        target.write_text("# local configuration\n")
        self.mise(
            "bootstrap",
            "dotfiles",
            "apply",
            "~/.tmux.conf",
            "--yes",
            selected="linux",
            success=False,
        )
        self.assertFalse(target.is_symlink())
        self.assertEqual(target.read_text(), "# local configuration\n")
        target.unlink()
        self.mise(
            "bootstrap", "dotfiles", "apply", "~/.tmux.conf", "--yes", selected="linux"
        )
        self.assert_link(".tmux.conf", "config/tmux.conf")

    def test_plugin_repositories_clone_pinned_refs_and_converge(self):
        repos = json.loads(
            self.mise(
                "bootstrap",
                "repos",
                "status",
                "--json",
                selected="linux",
            ).stdout
        )["repos"]
        self.assertEqual(
            {item["path_raw"]: (item["url"], item["ref"]) for item in repos},
            {
                "~/.local/share/zsh/powerlevel10k": (
                    "https://github.com/romkatv/powerlevel10k.git",
                    "v1.20.0",
                ),
                "~/.local/share/zsh/fzf-tab": (
                    "https://github.com/Aloxaf/fzf-tab.git",
                    None,
                ),
                "~/.local/share/zsh/zsh-autosuggestions": (
                    "https://github.com/zsh-users/zsh-autosuggestions.git",
                    "v0.7.1",
                ),
                "~/.local/share/zsh/zsh-fast-syntax-highlighting": (
                    "https://github.com/zdharma-continuum/fast-syntax-highlighting.git",
                    None,
                ),
            },
        )
        git = str(self.bin / "git")
        seed = self.work / "plugin-source"
        self.run_command([git, "init", "--initial-branch=main", str(seed)])
        for ref in ("v1.20.0", "v0.7.1", None):
            self.run_command(
                [
                    git,
                    "-C",
                    str(seed),
                    "-c",
                    "user.name=Bootstrap Test",
                    "-c",
                    "user.email=bootstrap@example.invalid",
                    "-c",
                    "commit.gpgsign=false",
                    "commit",
                    "--allow-empty",
                    "-m",
                    ref or "main",
                ]
            )
            if ref:
                self.run_command([git, "-C", str(seed), "tag", ref])
        config = self.config / "config.linux.toml"
        content = config.read_text()
        for item in repos:
            self.assertEqual(Path(item["path"]), self.home / item["path_raw"][2:])
            content = content.replace(item["url"], seed.as_uri())
        config.write_text(content)
        self.mise("bootstrap", "--only", "repos", "--yes", selected="linux")
        for item in repos:
            with self.subTest(plugin=item["path_raw"]):
                expected = self.run_command(
                    [
                        git,
                        "-C",
                        str(seed),
                        "rev-parse",
                        item["ref"] or "HEAD",
                    ]
                ).stdout
                actual = self.run_command(
                    [
                        git,
                        "-C",
                        item["path"],
                        "rev-parse",
                        "HEAD",
                    ]
                ).stdout
                self.assertEqual(actual, expected)
        self.mise("bootstrap", "--only", "repos", "--yes", selected="linux")
        self.mise("bootstrap", "repos", "status", "--missing", selected="linux")

    def test_bootstrap_tasks_install_safely_and_leave_existing_tools_alone(self):
        self.mise("bootstrap", "--only", "task", "--yes", selected="linux")
        self.assertTrue(os.access(self.home / ".vite-plus/bin/vp", os.X_OK))
        self.assertEqual(
            self.records.joinpath("vite-env").read_text().splitlines(),
            [
                str(self.home / ".vite-plus"),
                "no",
            ],
        )
        downloads = self.download_records()
        self.assertEqual({item["url"] for item in downloads}, {"https://vite.plus"})
        for item in downloads:
            self.assertIn("=https", item["args"])
            self.assertIn("--tlsv1.2", item["args"])
        self.assert_installers_cleaned_up()
        self.assertEqual(self.vp_installs(), [])
        self.mise("bootstrap", "--only", "task", "--yes", selected="linux")
        self.assertEqual(
            self.download_records(), downloads, "Existing tools were downloaded again"
        )
        self.assertEqual(self.vp_installs(), [])

    def test_vp_packages_install_once_and_upgrade_only_unpinned(self):
        self.set_vp_packages([("demo-tool", "latest"), ("pinned-tool", "1.2.3")])
        self.mise("bootstrap", "--only", "packages", "--yes", selected="linux")
        self.assertEqual(
            sorted(self.vp_installs()),
            ["install -g demo-tool", "install -g pinned-tool@1.2.3"],
        )
        downloads = self.download_records()
        installs = self.vp_installs()
        self.mise("bootstrap", "--only", "packages", "--yes", selected="linux")
        self.assertEqual(self.download_records(), downloads)
        self.assertEqual(self.vp_installs(), installs)
        before = len(self.vp_invocations())
        self.mise("bootstrap", "packages", "upgrade", "--yes", selected="linux")
        new = self.vp_invocations()[before:]
        self.assertIn("update -g demo-tool", new)
        self.assertFalse(any(line.startswith("install ") for line in new))
        self.assertFalse(
            any("pinned-tool" in line and line.startswith("update ") for line in new)
        )

    def test_vp_packages_reconcile_pins_and_keep_unlisted_packages(self):
        self.set_vp_packages([("pinned-tool", "1.2.3"), ("floating-tool", "latest")])
        state = self.records / "vp-installed"
        state.write_text("pinned-tool@1.2.3\nkept-tool@9.9.9\n")
        self.mise("bootstrap", "--only", "packages", "--yes", selected="linux")
        self.assertEqual(self.vp_installs(), ["install -g floating-tool"])
        self.assertEqual(
            state.read_text().splitlines(),
            ["pinned-tool@1.2.3", "kept-tool@9.9.9", "floating-tool"],
        )
        self.set_vp_packages([("pinned-tool", "4.0.0"), ("floating-tool", "latest")])
        self.mise("bootstrap", "--only", "packages", "--yes", selected="linux")
        self.assertEqual(
            self.vp_installs(),
            ["install -g floating-tool", "install -g pinned-tool@4.0.0"],
        )
        self.assertIn("kept-tool@9.9.9", state.read_text().splitlines())
        installs = self.vp_installs()
        self.mise("bootstrap", "--only", "packages", "--yes", selected="linux")
        self.assertEqual(self.vp_installs(), installs)
        self.assertIn("kept-tool@9.9.9", state.read_text().splitlines())

    def test_vp_packages_fail_without_installing_and_can_retry(self):
        self.set_vp_packages([("demo-tool", "latest")])
        self.mise(
            "plugins",
            "link",
            "-f",
            "vp",
            str(self.config / "plugins" / "vp"),
        )
        self.mise(
            "bootstrap", "packages", "apply", "--yes", selected="linux", success=False
        )
        self.assertEqual(self.vp_installs(), [])
        self.assertFalse((self.records / "vp-installed").exists())

        self.mise("run", "--skip-tools", "install:vite-plus", selected="linux")
        broken = self.home / ".vite-plus" / "bin" / "vp"
        broken.write_text(
            "#!/bin/sh\nprintf '%s\\n' \"$*\" >> \"$TEST_RECORDS/vp-args\"\nprintf 'nope\\n'\nexit 0\n"
        )
        broken.chmod(0o755)
        self.mise(
            "bootstrap", "packages", "apply", "--yes", selected="linux", success=False
        )
        self.assertEqual(self.vp_installs(), [])
        self.assertFalse((self.records / "vp-installed").exists())

        broken.unlink()
        self.mise("bootstrap", "--only", "packages", "--yes", selected="linux")
        self.assertEqual(self.vp_installs(), ["install -g demo-tool"])

    def test_vp_package_dry_run_does_not_install(self):
        self.set_vp_packages([("demo-tool", "latest")])
        self.mise("run", "--skip-tools", "install:vite-plus", selected="linux")
        self.mise(
            "plugins",
            "link",
            "-f",
            "vp",
            str(self.config / "plugins" / "vp"),
        )
        self.mise(
            "bootstrap",
            "packages",
            "apply",
            "--dry-run",
            "--yes",
            selected="linux",
        )
        self.assertEqual(self.vp_installs(), [])
        state = self.records / "vp-installed"
        self.assertFalse(state.exists() and state.read_text().strip())

    def test_tools_already_on_path_are_not_downloaded(self):
        self.write_executable(
            "vp", "#!/bin/sh\nif [ \"$1\" = list ]; then printf '[]\\n'; fi\nexit 0\n"
        )
        self.mise("bootstrap", "--only", "task", "--yes", selected="linux")
        self.assertEqual(self.download_records(), [])
        self.assertEqual(list(self.records.iterdir()), [])

    def test_download_failure_is_cleaned_up_and_allows_retry(self):
        self.mise(
            "run",
            "--skip-tools",
            "install:vite-plus",
            selected="linux",
            overrides={"TEST_DOWNLOAD_FAIL": "1"},
            success=False,
        )
        self.assertFalse(self.home.joinpath(".vite-plus/bin/vp").exists())
        self.assertFalse(self.records.joinpath("vite-env").exists())
        self.assert_installers_cleaned_up()
        self.mise("run", "--skip-tools", "install:vite-plus", selected="linux")
        self.assertTrue(os.access(self.home / ".vite-plus/bin/vp", os.X_OK))
        self.assert_installers_cleaned_up()

    def test_installer_failure_is_cleaned_up_and_allows_retry(self):
        self.mise(
            "run",
            "--skip-tools",
            "install:vite-plus",
            selected="linux",
            overrides={"TEST_INSTALL_FAIL": "1"},
            success=False,
        )
        self.assertTrue(self.records.joinpath("vite-env").exists())
        self.assertFalse(self.home.joinpath(".vite-plus/bin/vp").exists())
        self.assert_installers_cleaned_up()
        self.mise("run", "--skip-tools", "install:vite-plus", selected="linux")
        self.assertTrue(os.access(self.home / ".vite-plus/bin/vp", os.X_OK))
        self.assert_installers_cleaned_up()

    def test_linux_shell_loads_without_optional_tools_or_mac_credentials(self):
        self.bootstrap_dotfiles(selected="linux")
        self.write_executable("podman", "#!/bin/sh\nexit 0\n")
        self.run_command(
            [
                ZSH,
                "-f",
                "-c",
                """
            source "$HOME/.zshenv"
            source "$HOME/.zshrc"
            [[ $EDITOR == nvim ]] || exit 1
            [[ ":$PATH:" == *":$HOME/.local/bin:"* ]] || exit 2
            [[ $aliases[ll] == 'ls -lh' ]] || exit 3
            [[ $aliases[d] == podman ]] || exit 4
            [[ -z ${SSH_AUTH_SOCK-} ]] || exit 5
        """,
            ],
            selected="linux",
        )

    def test_plugin_loader_prefers_homebrew_and_falls_back_to_local(self):
        plugin = "bootstrap-fixture-plugin"
        local = self.home / ".local/share/zsh" / plugin / "plugin.zsh"
        brew = Path(self.env["HOMEBREW_PREFIX"]) / "share" / plugin / "plugin.zsh"
        for path, origin in ((local, "local"), (brew, "homebrew")):
            path.parent.mkdir(parents=True)
            path.write_text("export PLUGIN_ORIGIN=" + origin + "\n")
        script = """
            source "$HOME/.dotfiles/config/zsh/lib/loader.zsh"
            zsh_source_plugin bootstrap-fixture-plugin plugin.zsh || exit 1
            [[ $PLUGIN_ORIGIN == $EXPECTED_ORIGIN ]] || exit 2
            if zsh_source_plugin bootstrap-fixture-plugin missing.zsh; then exit 3; fi
            [[ $PLUGIN_ORIGIN == $EXPECTED_ORIGIN ]] || exit 4
        """
        self.run_command(
            [ZSH, "-f", "-c", script], overrides={"EXPECTED_ORIGIN": "homebrew"}
        )
        brew.unlink()
        self.run_command(
            [ZSH, "-f", "-c", script], overrides={"EXPECTED_ORIGIN": "local"}
        )

    def test_zsh_configuration_has_valid_syntax(self):
        for path in sorted((ROOT / "config/zsh").rglob("*.zsh")):
            with self.subTest(path=path.relative_to(ROOT)):
                self.run_command([ZSH, "-n", str(path)])


if __name__ == "__main__":
    unittest.main(verbosity=2)
