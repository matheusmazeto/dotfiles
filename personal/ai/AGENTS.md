# Global AI instructions

These instructions are shared by Codex, OpenCode, and Claude Code.

- Communicate in Portuguese unless the user asks for another language.
- Never use the em dash character. Use a plain dash instead.
- Preserve existing user changes and avoid unrelated edits.
- Before making destructive changes, verify the exact target and ask for confirmation when the scope is unclear.
- Prefer simple, robust, maintainable solutions over clever or fragile ones.
- Reproduce bugs as closely as possible to the end-user experience before fixing them.
- Validate changes with the most relevant available checks before declaring the work complete.
- Do not modify changelogs or generated files manually.

Project-specific instructions take precedence when working inside a repository that provides its own `AGENTS.md` or `CLAUDE.md`.

## Safety

Never run the following commands without explicit user confirmation:

- `rm -rf` - recursively and forcibly deletes files and directories;
- `rm -f` - forcibly deletes files without prompting;
- `rm -r` / `rm -R` - recursively deletes directories;
- `unlink` - removes a filesystem link;
- `find ... -delete` - deletes files selected by a search expression;
- `git reset --hard` - discards tracked working-tree and index changes;
- `git clean -fd` / `git clean -fdx` - deletes untracked files and directories;
- `git checkout -- .` - discards tracked working-tree changes;
- `git restore .` - discards tracked working-tree changes;
- `git push --force` / `git push --force-with-lease` - rewrites remote branch history;
- `git push --delete` - deletes a remote branch or tag;
- `git branch -D` - force-deletes a branch without requiring it to be merged;
- `git tag -d` - deletes a local tag;
- `git filter-repo` / `git filter-branch` - rewrites repository history;
- `git reflog expire` / `git gc --prune=now` - can remove recovery data from Git;
- recursive `mv`, `cp`, `install`, `chmod`, or `chown` - may overwrite or alter many files.

Do not enable unrestricted agent execution unless the user explicitly requests it:

- `--dangerously-skip-permissions` - bypasses the agent's permission checks;
- `--full-auto` - enables unattended execution with reduced approval barriers;
- equivalent unrestricted, no-approval, or auto-approve modes in any coding agent.

When the user explicitly requests an unrestricted mode, state that permission
checks are being bypassed and verify the target project before proceeding.

Ask for confirmation before running these history or state-changing operations:

- `git rebase`;
- `git revert`;
- `git merge`;
- `git commit --amend`;
- non-trivial `git reset`.

Before any approved destructive operation, show the complete command, explain the exact target, and verify the current Git status.

Permission-bypass flags must not be added to aliases, scripts, skills, or project configuration by default.
