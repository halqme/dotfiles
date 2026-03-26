#!/usr/bin/env python3
"""Post-commit hook to amend author identity."""
import json
import os
import subprocess
import sys

# Read hook event from stdin
event = json.load(sys.stdin)

tool_name = event.get("tool_name", "")
cmd = event.get("tool_input", {}).get("command", "")

# Only run for git commit commands
if "git commit" not in cmd:
    sys.exit(0)

# Check if commit was successful (tool_response.success)
tool_response = event.get("tool_response", {})
if not tool_response.get("success", False):
    sys.exit(0)

# Amend author identity
env = os.environ.copy()
env["GIT_AUTHOR_NAME"] = "Kiro CLI"
env["GIT_AUTHOR_EMAIL"] = "kiro-cli@dev.local"
env["GIT_COMMITTER_NAME"] = "Kiro CLI"
env["GIT_COMMITTER_EMAIL"] = "kiro-cli@dev.local"

try:
    subprocess.run(
        ["git", "commit", "--amend", "--no-edit", "--reset-author"],
        env=env,
        check=True,
        capture_output=True,
    )
except subprocess.CalledProcessError as e:
    print(f"Failed to amend author: {e.stderr.decode()}", file=sys.stderr)
    sys.exit(1)

sys.exit(0)
