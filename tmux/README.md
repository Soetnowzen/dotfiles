# tmux configuration

A tmux setup optimized for keyboard navigation, nested sessions, and automatic
Solarized light/dark status themes.

## Installation

From the repository root:

```bash
make tmux
```

This links [`my-tmux.conf`](my-tmux.conf) to `~/.tmux.conf`. Reload an existing
session with `C-a r`, or start tmux through the Bash `tm` helper to apply the
terminal-aware theme.

## Keybindings

The prefix is `C-a` instead of tmux's default `C-b`.

| Binding | Purpose |
| --- | --- |
| `C-a r` | Reload `~/.tmux.conf` |
| `Alt-h`, `Alt-j`, `Alt-k`, `Alt-l` | Select a pane without the prefix |
| `Alt-Left`, `Alt-Down`, `Alt-Up`, `Alt-Right` | Resize panes |
| `Alt-n`, `Alt-p` | Select the next or previous window |
| `Alt-c` | Create a window |
| `Alt-d` | Detach the client |
| `Alt-|`, `Alt--` | Split the current pane |
| `F12` | Toggle nested-session mode |

Windows and panes are numbered from 1, mouse support is enabled, and the scroll
history limit is 10,000 lines.

## Nested sessions

`F12` disables the outer session's prefix and key table so keystrokes can reach
an inner tmux session. The status bar changes while this mode is active. Press
`F12` again to restore the outer session.

## Theme selection

[`apply-theme.sh`](apply-theme.sh) accepts `light`, `dark`, or `auto`:

```bash
~/dotfiles/tmux/apply-theme.sh dark
```

Automatic selection checks, in order:

1. `TMUX_THEME=light` or `TMUX_THEME=dark`.
2. The terminal background through an OSC 11 query when a controlling terminal
   is available.
3. The local time, using a light theme from 07:00 through 17:59 by default.

Set `TMUX_LIGHT_START` and `TMUX_LIGHT_END` to change the fallback hours. OSC 11
detection cannot run from the tmux server's `run-shell`; invoke the script from
an interactive shell when terminal-background detection is desired.

Alt bindings depend on the terminal forwarding Meta/Alt key sequences and may
need terminal-specific adjustment.
