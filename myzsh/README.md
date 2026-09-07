# Zsh configuration

A modular Zsh configuration with a Git-aware prompt, completion, vi keybindings,
directory helpers, and command aliases.

The configuration expects this repository at `~/dotfiles` because
[`zshrc`](zshrc) sets `ZSHHOME=$HOME/dotfiles/myzsh`.

## Installation

There is currently no Make target for Zsh. Link the entry file manually, then
start a new shell:

```sh
ln -fsn ~/dotfiles/myzsh/zshrc ~/.zshrc
exec zsh
```

## Requirements

- Zsh
- Git for repository information in the prompt and Git helpers
- Python available at `/usr/bin/python` for `chcd`
- Common Unix tools used by individual aliases

The `:prezto:` style settings are harmless without Prezto; this configuration
does not install or source Prezto itself.

## Structure

| Path | Purpose |
| --- | --- |
| [`zshrc`](zshrc) | Entry point, history, aliases, module loading, and vi mode |
| [`conf/prompt.zsh`](conf/prompt.zsh) | Prompt rendering and Git status |
| [`conf/completion.zsh`](conf/completion.zsh) | Completion behavior |
| [`conf/directory.zsh`](conf/directory.zsh) | Directory navigation helpers |
| [`conf/editor.zsh`](conf/editor.zsh) | Command-line editing behavior |
| [`conf/gitalias.zsh`](conf/gitalias.zsh) | Git aliases |
| [`conf/terminal.zsh`](conf/terminal.zsh) | Terminal behavior and colors |
| [`conf/bashrun.zsh`](conf/bashrun.zsh) | Bash command compatibility helpers |
| [`func/`](func/) | Autoloaded Zsh and Git functions |
| [`prog/chcd.py`](prog/chcd.py) | Directory matcher used by `chcd` |

## Everyday commands

| Command | Purpose |
| --- | --- |
| `..`, `...`, `....`, `.4`, `.5` | Move up one or more directory levels |
| `chcd NAME` | Find and enter a matching directory |
| `g` and the aliases in `conf/gitalias.zsh` | Short Git commands |
| `tm` | Attach to an existing tmux session or create one |
| `v`, `v-split`, `v-tsplit`, `v-vsplit` | Open Vim using tabs or splits |

History is stored in `~/.histfile`. The shell uses vi keybindings, enables
`autocd`, and deliberately does not share history live between shells.

`chcd.py` uses a fixed `/usr/bin/python` shebang. On systems that provide only
`python3`, install a compatibility link or update that shebang locally.

## Local customization

If `~/workplace.zsh` exists, it is sourced last. Put machine- or work-specific
settings there so the tracked files can remain portable.
