---
name: git-agent-commit
description: Git commit identity for agent-authored changes
---

When making git commits, always use this form:

```bash
GIT_AUTHOR_NAME="Kiro CLI" \
GIT_AUTHOR_EMAIL="kiro-cli@dev.local" \
GIT_COMMITTER_NAME="Kiro CLI" \
GIT_COMMITTER_EMAIL="kiro-cli@dev.local" \
git commit -m "..."
```
