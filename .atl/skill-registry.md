# Skill Registry

Project: Wezternconf
Generated: 2026-04-04

## Sources Scanned
- Global skills: `/home/kevin/.config/opencode/skills`
- Global skills: `/home/kevin/.gemini/skills`
- Project skills: none found
- Project convention files: none found in project root

## User Skills
| Skill | Source | Trigger |
|---|---|---|
| `branch-pr` | global (`opencode`) | Creating a pull request, opening a PR, or preparing changes for review |
| `go-testing` | global (`opencode`) | Writing Go tests, using teatest, or adding test coverage |
| `issue-creation` | global (`opencode`) | Creating a GitHub issue, reporting a bug, or requesting a feature |
| `judgment-day` | global (`opencode`) | User asks for judgment day / dual review / adversarial review |
| `skill-creator` | global (`opencode`) | Creating new AI agent skills or documenting reusable agent patterns |

## Project Conventions
- No project-level convention files detected (`AGENTS.md`, `agents.md`, `CLAUDE.md`, `.cursorrules`, `GEMINI.md`, `copilot-instructions.md`).
- No additional project-specific skills detected.

## Compact Rules

### `branch-pr`
- Every PR MUST link an approved issue.
- Every PR MUST have exactly one `type:*` label.
- Branch names MUST match `type/description` using lowercase `a-z0-9._-`.

### `go-testing`
- Prefer table-driven tests for Go.
- Test Bubbletea state transitions directly when applicable.
- Use golden files only when output stability matters.

### `issue-creation`
- Use issue templates; blank issues are disabled.
- New issues start with `status:needs-review`.
- Questions belong in Discussions, not Issues.

### `judgment-day`
- Launch two blind parallel reviewers.
- Synthesize confirmed vs suspect findings before fixing.
- Re-judge after fixes when critical findings exist.

### `skill-creator`
- Create skills only for repeatable, non-trivial workflows.
- Keep `SKILL.md` explicit about triggers and critical patterns.
- Prefer local references/assets instead of bloating the main skill file.
