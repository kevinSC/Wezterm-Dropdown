#!/usr/bin/env bash
# wezterm-toggle.sh — Drop-down terminal toggle with multi-monitor support
# Dependencies: kdotool, kscreen-doctor, python3, wezterm
#
# Virtual desktop behaviour: the window is marked STICKY (on all desktops)
# so activating it never triggers a desktop switch — it always appears on
# whichever virtual desktop is currently active.

set -uo pipefail

# ── Configuration ─────────────────────────────────────────────────────────── #
readonly CLASS="wezterm-dropdown"
readonly CONFIG="$HOME/.config/wezterm/dropdown.lua"
readonly POLL_INTERVAL=0.05
readonly POLL_MAX=160

# ── Helpers ───────────────────────────────────────────────────────────────── #

# screen_for_point <mx> <my>
# Prints "X Y W H" of the monitor containing the given point.
# kscreen-doctor embeds ANSI colour codes — Python strips them before parsing.
screen_for_point() {
    python3 - "$1" "$2" << 'PYEOF'
import subprocess, re, sys
mx, my = int(sys.argv[1]), int(sys.argv[2])
raw  = subprocess.run(['kscreen-doctor', '-o'], capture_output=True, text=True).stdout
text = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])').sub('', raw)
for line in text.splitlines():
    m = re.search(r'Geometry:\s+(\d+),(\d+)\s+(\d+)x(\d+)', line)
    if m:
        x, y, w, h = map(int, m.groups())
        if x <= mx < x + w and y <= my < y + h:
            print(x, y, w, h)
            break
PYEOF
}

# mouse_screen — prints "X Y W H" of the monitor where the mouse cursor is.
mouse_screen() {
    local loc mx my
    loc=$(kdotool getmouselocation 2>/dev/null)
    mx=$(grep -oP 'x:\K[0-9]+' <<< "$loc")
    my=$(grep -oP 'y:\K[0-9]+' <<< "$loc")
    screen_for_point "$mx" "$my"
}

# animate <wid> <x> <y> <w> <h> <in|out>
# Slides the window in (from above) or out (upward), then minimises on 'out'.
# Uses cubic easing: ease-out for 'in' (fast start, soft landing),
# ease-in for 'out' (slow start, fast exit) — feels natural, not mechanical.
animate() {
    python3 - "$@" << 'PYEOF'
import subprocess, time, sys
wid           = sys.argv[1]
x, y, w, h    = int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4]), int(sys.argv[5])
direction     = sys.argv[6]
STEPS, DURATION = 28, 0.22

def move(cy):
    subprocess.run(['kdotool', 'windowmove', wid, str(x), str(cy)], capture_output=True)

for i in range(STEPS + 1):
    t = i / STEPS
    if direction == 'in':
        ease = 1 - (1 - t) ** 3        # ease-out cubic
        cy = y - h + int(h * ease)
    else:
        ease = t ** 3                   # ease-in cubic
        cy = y - int(h * ease)
    move(cy)
    time.sleep(DURATION / STEPS)

if direction == 'in':
    move(y)
else:
    subprocess.run(['kdotool', 'windowminimize', wid], capture_output=True)
PYEOF
}

# ── Main ──────────────────────────────────────────────────────────────────── #
WINDOW_ID=$(kdotool search --class "$CLASS" 2>/dev/null | head -n 1)

# Case 1: Not running — launch, move off-screen immediately, slide in
if [[ -z "$WINDOW_ID" ]]; then
    read -r TX TY TW TH < <(mouse_screen)
    wezterm --config-file "$CONFIG" start \
        --always-new-process --class "$CLASS" --workspace "dropdown" &

    # Poll every 50ms (up to 8s) — catch the window the moment it appears
    # so we can move it off-screen before the user ever sees it.
    NEW_ID=""
    for (( i=0; i<POLL_MAX; i++ )); do
        NEW_ID=$(kdotool search --class "$CLASS" 2>/dev/null | head -n 1)
        [[ -n "$NEW_ID" ]] && break
        sleep "$POLL_INTERVAL"
    done

    if [[ -n "$NEW_ID" && -n "$TX" ]]; then
        kdotool windowstate --add NO_BORDER "$NEW_ID"
        # STICKY = on all virtual desktops: activating the window will never
        # switch the active desktop — it appears on whichever one you're on.
        kdotool windowstate --add STICKY    "$NEW_ID"
        kdotool windowmove   "$NEW_ID" "$TX" "$((TY - TH))"
        kdotool windowsize   "$NEW_ID" "$TW" "$TH"
        sleep 0.05
        animate "$NEW_ID" "$TX" "$TY" "$TW" "$TH" in
    fi
    exit 0
fi

# Case 2: Active and focused — slide it up and hide
if [[ "$WINDOW_ID" == "$(kdotool getactivewindow 2>/dev/null)" ]]; then
    read -r CX CY CW CH < <(
        kdotool getwindowgeometry "$WINDOW_ID" 2>/dev/null \
        | awk '/Position/{split($2,p,","); x=p[1]; y=p[2]}
               /Geometry/{split($2,g,"x"); w=g[1]; h=g[2]}
               END{print x, y, w, h}'
    )
    animate "$WINDOW_ID" "$CX" "$CY" "$CW" "$CH" out
    exit 0
fi

# Case 3: Exists but hidden — teleport to current monitor and slide in
read -r TX TY TW TH < <(mouse_screen)
if [[ -n "$TX" ]]; then
    # Set geometry before minimising so KDE records the new position
    kdotool windowmove     "$WINDOW_ID" "$TX" "$((TY - TH))"
    kdotool windowsize     "$WINDOW_ID" "$TW" "$TH"
    kdotool windowminimize "$WINDOW_ID" 2>/dev/null
    sleep 0.15
    kdotool windowactivate "$WINDOW_ID" 2>/dev/null
    sleep 0.05
    animate "$WINDOW_ID" "$TX" "$TY" "$TW" "$TH" in
else
    kdotool windowactivate "$WINDOW_ID"
fi
