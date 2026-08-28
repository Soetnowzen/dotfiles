#!/usr/bin/env bash
# Apply a Solarized dark/light tmux theme matching the terminal background.
#
# Usage: apply-theme.sh [light|dark|auto]   (default: auto)
#
# auto resolves in this order:
#   1. $TMUX_THEME, if set to light/dark  — explicit override
#   2. OSC 11 query of the terminal background — needs a real tty, so this
#      only works when run from an interactive shell, NOT from tmux
#      run-shell (the server process has no controlling terminal)
#   3. Time of day — light between $TMUX_LIGHT_START and $TMUX_LIGHT_END

LIGHT_START=${TMUX_LIGHT_START:-7}   # inclusive
LIGHT_END=${TMUX_LIGHT_END:-18}      # exclusive

detect_by_osc11() {
    local response="" old_stty char

    old_stty=$(stty -g < /dev/tty 2>/dev/null) || return 2
    stty raw -echo min 0 time 2 < /dev/tty 2>/dev/null || return 2

    if [ -n "$TMUX" ]; then
        # DCS passthrough: doubles the leading ESC so the outer terminal sees it
        printf '\ePtmux;\e\033]11;?\007\e\\' > /dev/tty
    else
        printf '\033]11;?\007' > /dev/tty
    fi

    # Read until BEL or ST (ESC \) with per-char timeout
    while IFS= read -r -n 1 -t 0.2 char < /dev/tty 2>/dev/null; do
        response+="$char"
        [[ "$response" == *$'\a'*     ]] && break
        [[ "$response" == *$'\033\\'* ]] && break
    done

    stty "$old_stty" < /dev/tty 2>/dev/null

    # Parse rgb:RRRR/GGGG/BBBB (4-digit 16-bit hex per channel)
    if [[ "$response" =~ rgb:([0-9a-fA-F]+)/([0-9a-fA-F]+)/([0-9a-fA-F]+) ]]; then
        local r=$((16#${BASH_REMATCH[1]:0:2}))
        local g=$((16#${BASH_REMATCH[2]:0:2}))
        local b=$((16#${BASH_REMATCH[3]:0:2}))
        local lum=$(( (r * 299 + g * 587 + b * 114) / 1000 ))
        [ "$lum" -gt 127 ] && echo light || echo dark
        return 0
    fi

    return 2  # no usable response
}

detect_by_clock() {
    local hour=$((10#$(date +%H)))
    if [ "$hour" -ge "$LIGHT_START" ] && [ "$hour" -lt "$LIGHT_END" ]; then
        echo light
    else
        echo dark
    fi
}

resolve_theme() {
    case "${1:-auto}" in
        light|dark) echo "$1"; return ;;
    esac

    case "$TMUX_THEME" in
        light|dark) echo "$TMUX_THEME"; return ;;
    esac

    detect_by_osc11 || detect_by_clock
}

apply_dark() {
    tmux set -g status-style                "bg=#073642,fg=#839496"
    tmux set -g window-status-style         "fg=#839496,bg=#073642"
    tmux set -g window-status-current-style "fg=#073642,bg=#268bd2,bold"
    tmux set -g window-status-bell-style    "fg=#fdf6e3,bg=#dc322f,bold"
    tmux set -g message-style               "bg=#073642,fg=#b58900"
    tmux set -g message-command-style       "fg=#268bd2,bg=#073642"
    tmux set -g mode-style                  "bg=#b58900,fg=#002b36"
    tmux set -g pane-active-border-style    "fg=#268bd2"
    tmux set -g pane-border-style           "fg=#073642"
    tmux setenv -g TERM_THEME dark
}

apply_light() {
    tmux set -g status-style                "bg=#eee8d5,fg=#657b83"
    tmux set -g window-status-style         "fg=#657b83,bg=#eee8d5"
    tmux set -g window-status-current-style "fg=#eee8d5,bg=#268bd2,bold"
    tmux set -g window-status-bell-style    "fg=#fdf6e3,bg=#dc322f,bold"
    tmux set -g message-style               "bg=#eee8d5,fg=#b58900"
    tmux set -g message-command-style       "fg=#268bd2,bg=#eee8d5"
    tmux set -g mode-style                  "bg=#b58900,fg=#fdf6e3"
    tmux set -g pane-active-border-style    "fg=#268bd2"
    tmux set -g pane-border-style           "fg=#93a1a1"
    tmux setenv -g TERM_THEME light
}

# Nothing to style if no server is running
tmux has-session 2>/dev/null || exit 0

if [ "$(resolve_theme "$1")" = light ]; then
    apply_light
else
    apply_dark
fi
