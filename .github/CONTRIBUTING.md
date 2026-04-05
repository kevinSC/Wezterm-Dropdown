# Contribution Guidelines

Thank you for your interest in contributing to **WezTerm Dropdown**! 

This project aims to deliver the most fluid, native, and bug-free dropdown terminal experience for KDE Plasma Wayland. To keep the project focused, performant, and aligned with its core vision, all contributors are asked to follow these guidelines.

## The Core Vision
1. **Desktop Native**: We rely on KWin APIs and native Wayland protocols. No X11 hacks.
2. **Minimal and Fast**: Performance and smooth easing animations are a priority. Bloated dependencies or complex configuration scripts will not be merged.
3. **Opinionated Defaults**: The behavior (sliding from the top, following the mouse) is designed to be frictionless. Suggestions that fundamentally alter this paradigm without adding a toggle or preserving the original feel will be rejected.

## How to Contribute (Without Stepping on Toes)

### 1. Open an Issue First! (CRITICAL)
Before you start writing code for a new feature or a major refactor, **open an issue to discuss it**. 
As the author, I have a specific roadmap and architectural direction for this tool. By discussing your idea first:
- You ensure your PR will actually be merged.
- We can align on the technical approach.
- You save yourself wasted time!

### 2. Bugs over Features
If you found a bug (e.g., race conditions, multi-monitor quirks on edge cases), bug fix PRs are **highly appreciated** and will be reviewed quickly. 

### 3. Keep PRs Atomic
One feature or bug fix per Pull Request. Do not mix formatting changes with logic changes. If your PR changes more than what the title claims, it will be closed and you'll be asked to split it.

### 4. Code Style & Conventions
- **Bash Scripts**: Run `shellcheck` before submitting. Keep scripts POSIX-compliant where possible, though Bash 4+isms are acceptable if justified.
- **KWin Scripts**: Ensure compatibility with KDE Plasma 6. Do not introduce legacy Plasma 5 `workspace.clientList()` logic.
- **Commit Messages**: Use Conventional Commits (e.g., `feature: add support for hyprland`, `fix: resolve race condition in KWin dbus`).

Thank you for reading, and happy hacking!
