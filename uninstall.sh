#!/usr/bin/env bash
# uninstall.sh — Remove WezTerm Dropdown symlinks from the system.
#
# Removes all symlinks created by install.sh.
# If a .bak backup exists, it is restored automatically.

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[uninstall]${NC} $*"; }
warn() { echo -e "${YELLOW}[warn]${NC}      $*"; }

# safe_unlink <link_path>
# Removes the symlink and restores a .bak backup if one exists.
safe_unlink() {
    local link="$1"

    if [[ -L "$link" ]]; then
        rm "$link"
        info "Removed symlink: $link"
        if [[ -e "${link}.bak" ]]; then
            mv "${link}.bak" "$link"
            info "Restored backup: ${link}.bak → $link"
        fi
    elif [[ -e "$link" ]]; then
        warn "Not a symlink, skipping: $link"
    else
        warn "Does not exist, skipping: $link"
    fi
}

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  WezTerm Dropdown — Uninstall"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

safe_unlink "$HOME/.config/wezterm/wezterm.lua"
safe_unlink "$HOME/.config/wezterm/dropdown.lua"
safe_unlink "$HOME/.config/wezterm/bin/wezterm-toggle.sh"
safe_unlink "$HOME/.local/share/kwin/scripts/wezterm-dropdown"

echo ""
info "Done. Remember to remove the KDE keyboard shortcut manually:"
echo "     System Settings → Shortcuts → search 'WezTerm'"
echo ""
