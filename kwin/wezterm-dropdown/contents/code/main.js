// KWin script — WezTerm Dropdown Toggle
// Registers a keyboard shortcut (Meta+Space) to toggle the wezterm-dropdown window.
//
// NOTE: This script handles show/hide of an ALREADY RUNNING instance.
// The initial launch (and slide-in animation) is handled by wezterm-toggle.sh,
// which should be bound to the same shortcut via KDE System Settings → Shortcuts.
// Both work together: the shell script spawns+animates, the KWin script manages
// the window state for subsequent toggles.

function toggleWezTermDropdown() {
    print("WezTerm Toggle: Triggered");
    var found = false;
    var clients = workspace.clientList();

    for (var i = 0; i < clients.length; i++) {
        var client = clients[i];
        if (client.resourceClass === "wezterm-dropdown") {
            found = true;
            if (workspace.activeClient === client) {
                print("WezTerm Toggle: Hiding active window");
                client.minimized = true;
            } else {
                print("WezTerm Toggle: Showing/activating window");
                client.minimized = false;
                workspace.activeClient = client;
            }
            break;
        }
    }

    if (!found) {
        // Window not found — the shell script handles the initial spawn.
        // KWin scripts are restricted from arbitrary execution in newer versions,
        // so we rely on the bash script for first launch via the KDE shortcut.
        print("WezTerm Toggle: Window not found. Ensure wezterm-toggle.sh was run.");
    }
}

// Register shortcut directly in KWin
registerShortcut(
    "Toggle WezTerm Dropdown",
    "Toggle the WezTerm dropdown window",
    "Meta+Space",
    toggleWezTermDropdown
);
