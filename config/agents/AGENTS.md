## Development Workflow

- **Git:** Keep each commit to one logical concern and follow repository commit conventions. Commits made by the Agent must disable signing for that invocation with `-c commit.gpgSign=false` and `--no-gpg-sign`.

### Browser Use

Use `agent-browser` to see and operate browser. Before the first use, run `agent-browser skills get core` and follow them.

### Computer Use

Use `agent-desktop` to see and operate desktop apps. Before the first use, run `agent-desktop skills get desktop` and `agent-desktop skills get platform`, and follow them.

## Linear

- Tasks and shared context live in Linear (workspace: halm). Linear is the source of truth, not chat.
- Before working, read the issue (description and all comments) and the `Agent Shared Context` document.
- Record progress, decisions with reasons, and questions as issue comments. After editing a description, add a one-line comment saying what changed.
- End every comment with `— by <your name>`.
- Never mark an issue Done. The human does.
- Follow the `coordinate-in-linear` skill for the full procedure.

## Terminal Multiplexer

Use `rex` to use a terminal multiplexer. Before the first use, run `rex help` and `rex skill show` and follow them.
