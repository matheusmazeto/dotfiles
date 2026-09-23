---
name: code-review
description: Review a branch, pull request, or working-tree diff for correctness, regressions, security and data risks, missing tests, and mismatches with its issue or specification. Use when asked to review code changes.
---

# Code review

Review the requested changes without editing files. Start by reading the repository's `AGENTS.md`, `CLAUDE.md`, or other applicable contributor instructions. Inspect the working tree, including staged, unstaged, and untracked changes when they are in scope.

## Choose the comparison

- Use the base commit, branch, tag, or merge base supplied by the user.
- If no base is supplied, review the current staged and unstaged changes against `HEAD`.
- Include committed branch changes only when the user asks for a branch or pull request review.
- Find the issue or specification when one is available. If none can be found, state that the review checks the implementation but cannot verify its fit to an unavailable specification.

## Inspect the changes

Prioritize concrete defects that could cause incorrect behavior, regressions, security problems, data loss, or missing validation. Check nearby code and call sites where needed. Run focused read-only checks or tests when they materially help confirm a finding; do not change the working tree.

Report findings first, ordered by severity. For each finding, include a short title, the affected file and line, the triggering condition, and the user-visible impact. Cite the relevant requirement or repository rule when applicable. Do not report speculative concerns as confirmed bugs. If no actionable findings remain, say so and mention any important coverage limits.
