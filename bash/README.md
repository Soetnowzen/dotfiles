# Bash configuration

Personal Bash configuration with a Git-aware prompt, command timing, shared
history, safer command wrappers, completions, and workflow helpers.

The configuration expects this repository at `~/dotfiles`. `my.bashrc` sources
files from `~/dotfiles/bash` and some helpers refer to other repository paths.

## Installation

From the repository root, link the Bash configuration:

```bash
make bash
source ~/.bashrc
```

On Ubuntu or Debian, `./install.sh` also installs the modern command-line tools
and links both the Bash and Readline configurations:

```bash
./install.sh
```

The installer replaces `~/.bashrc` with a symbolic link. Use `make backup`
first when an existing configuration must be preserved.

## Requirements

- Bash 5.0 or newer (`EPOCHREALTIME` is used for command timing)
- `git` for repository information in the prompt
- `tput`, normally provided by `ncurses`, for terminal colors
- A terminal with UTF-8 and color support

Optional tools enable additional behavior:

| Tool | Integration |
| --- | --- |
| `batcat` | Replaces `cat` when available |
| `eza` or `exa` | Replaces `ls` when available |
| `fdfind` | Replaces `find` when available |
| `rg` | Replaces `grep` when available |
| `docker` and `docker-compose` | Docker helpers and completions |
| `tmux` | Session and theme helpers |
| `gh` with `gh-copilot` | Copilot aliases; install with `make copilot` |
| `code` | Opens Git worktrees from `wtcode` |

The command replacements print the command they execute to standard error.
When a modern replacement is unavailable, the corresponding standard command
is used instead.

## Prompt

The prompt displays relevant context without invoking unnecessary processes:

- Time, user, host, current directory, and the previous command's exit status
- Git branch, upstream divergence, stash, worktree count, file status, and
  changed-line counts
- Python virtual environment, Node.js version, container, SSH, and root status
- Directory-stack depth and running or stopped jobs
- Elapsed time for commands that exceed a configurable threshold

Long paths are shortened according to terminal width. Git worktrees under a
`.worktrees` directory receive a compact repository/worktree path.

### Configuration

Set these variables before sourcing `~/.bashrc`, for example in
`~/.bashrc.work`:

| Variable | Default | Purpose |
| --- | --- | --- |
| `BASH_SHARE_HISTORY` | `1` | Set to `0` to stop reloading history from other shells at every prompt |
| `PROMPT_MIN_TIME_MS` | `500` | Minimum command duration shown in the prompt; set to `0` to show all commands |
| `PROMPT_PATH_MAX` | Half the terminal width | Maximum displayed path length before shortening |

`~/.bashrc.work` is sourced near the beginning of the configuration and is not
tracked by this repository. It is the intended place for machine- or
work-specific environment variables and aliases.

## Included helpers

The most commonly useful commands are:

| Command | Purpose |
| --- | --- |
| `.. [directory]` | Move up one level, to `/`, or to a named parent directory |
| `p`, `o`, `d` | Push, pop, and display the directory stack |
| `mark NAME`, `jump NAME`, `marks` | Create and use shell-local directory bookmarks |
| `wt [NAME]` | List Git worktrees or enter one under `.worktrees` |
| `wtcode NAME` | Open a worktree in VS Code |
| `extract FILE` | Extract common archive formats |
| `watch_files 'COMMAND' FILE...` | Re-run a command when any listed file changes |
| `password_gen [LENGTH]` | Generate a random password; the default length is 20 |
| `most_used_cmd` | Show the ten most frequently used commands |
| `tm` | Create or attach to tmux and apply the matching terminal theme |

There are also completions for Git, SSH, Docker, Yarn, Make, and several common
Unix commands. Docker shortcuts include `dps`, `dimg`, `dlog`, `dxec`,
`dstart`, `dstop`, and `dclean`. Run `type COMMAND` or `declare -f COMMAND` to
inspect the exact alias or function loaded in the current shell.

Directory bookmarks are exported only within the current shell and its child
processes; they are not persisted between sessions.

For example, rerun a focused test whenever either its source or test changes:

```bash
watch_files 'make test' src/example.c tests/example_test.c
```

## History and safety behavior

- History is stored in `~/.bash_history_extended`, with timestamps and a
  50,000-entry limit.
- Duplicate commands and commands beginning with a space are omitted.
- `rm`, `mv`, `cp`, and `ln` request confirmation in potentially destructive
  cases.
- `mkdir` creates missing parent directories and reports created paths.
- `histexpand` is disabled, so `!123` history expansion is unavailable.

## Files

| Path | Purpose |
| --- | --- |
| `my.bashrc` | Main configuration, aliases, functions, and shell options |
| `configurations/prompt.bash` | Prompt renderer and Git status collection |
| `scripts/` | Completions and focused workflow helpers |
| `solarized-dark.reg` | Solarized Dark colors for the Windows Console registry |

## PuTTY color setup

To apply a palette manually in PuTTY:

1. Load a saved session.
2. Open **Window > Appearance** and select a monospace font such as Consolas
   or Lucida Console.
3. Open **Window > Colours** and enter one of the palettes below.
4. Return to **Session** and save the session.

### Ubuntu palette

| Name | R | G | B |
| --- | ---: | ---: | ---: |
| Default Foreground | 238 | 238 | 236 |
| Default Bold Foreground | 238 | 238 | 236 |
| Default Background | 48 | 10 | 36 |
| Default Bold Background | 48 | 10 | 36 |
| Cursor Text | 255 | 255 | 255 |
| Cursor Colour | 187 | 187 | 187 |
| ANSI Black | 46 | 52 | 54 |
| ANSI Black Bold | 85 | 87 | 83 |
| ANSI Red | 204 | 0 | 0 |
| ANSI Red Bold | 239 | 41 | 41 |
| ANSI Green | 78 | 154 | 6 |
| ANSI Green Bold | 138 | 226 | 52 |
| ANSI Yellow | 196 | 160 | 0 |
| ANSI Yellow Bold | 255 | 233 | 79 |
| ANSI Blue | 52 | 101 | 164 |
| ANSI Blue Bold | 114 | 159 | 207 |
| ANSI Magenta | 117 | 80 | 123 |
| ANSI Magenta Bold | 173 | 127 | 168 |
| ANSI Cyan | 6 | 152 | 154 |
| ANSI Cyan Bold | 52 | 226 | 226 |
| ANSI White | 211 | 215 | 207 |
| ANSI White Bold | 238 | 238 | 236 |

### Solarized Dark palette

| Name | R | G | B |
| --- | ---: | ---: | ---: |
| Default Foreground | 131 | 148 | 150 |
| Default Bold Foreground | 147 | 161 | 161 |
| Default Background | 0 | 43 | 54 |
| Default Bold Background | 7 | 54 | 66 |
| Cursor Text | 0 | 43 | 54 |
| Cursor Colour | 238 | 232 | 213 |
| ANSI Black | 7 | 54 | 66 |
| ANSI Black Bold | 0 | 43 | 54 |
| ANSI Red | 220 | 50 | 47 |
| ANSI Red Bold | 203 | 75 | 22 |
| ANSI Green | 133 | 153 | 0 |
| ANSI Green Bold | 88 | 110 | 117 |
| ANSI Yellow | 181 | 137 | 0 |
| ANSI Yellow Bold | 101 | 123 | 131 |
| ANSI Blue | 38 | 139 | 210 |
| ANSI Blue Bold | 131 | 148 | 150 |
| ANSI Magenta | 211 | 54 | 130 |
| ANSI Magenta Bold | 108 | 113 | 196 |
| ANSI Cyan | 42 | 161 | 152 |
| ANSI Cyan Bold | 147 | 161 | 161 |
| ANSI White | 238 | 232 | 213 |
| ANSI White Bold | 253 | 246 | 227 |
