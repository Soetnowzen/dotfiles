# Vim configuration

A Vim configuration with Vundle-managed plugins, Solarized colors, custom
syntax files, folding, comment toggling, and extensive navigation mappings.

## Installation

From the repository root:

```bash
make vim
```

The target links [`my.vimrc`](my.vimrc) to `~/.vimrc`, installs Vundle when it
is absent, links the custom syntax and configuration files below `~/.vim`, and
runs `PluginInstall`.

Requirements:

- Vim
- Git and network access for initial plugin installation
- A terminal with 256-color support for the configured terminal theme

To refresh plugins later, run `:PluginUpdate` inside Vim.

## Structure

| Path | Purpose |
| --- | --- |
| [`my.vimrc`](my.vimrc) | Main settings, mappings, commands, and autocommands |
| [`configurations/vundle.vim`](configurations/vundle.vim) | Plugin list, Solarized setup, and plugin configuration |
| [`configurations/folding.vim`](configurations/folding.vim) | Language-specific folding expressions |
| [`configurations/toggle_comments.vim`](configurations/toggle_comments.vim) | Comment markers and toggling across file types |
| [`syntax/`](syntax/) | Custom syntax definitions linked into `~/.vim/syntax` |

## Highlights

- Leader key: `,`
- `jj` or `jk` leaves insert mode.
- `C-h`, `C-j`, `C-k`, and `C-l` move between windows.
- Arrow keys resize the current window.
- `H` and `L` select the previous and next tabs.
- `ToSnakeCase` and `ToCamelCase` transform identifiers.
- Custom mappings support window swapping and selected-region diffs.
- Search is incremental, uses smart case, and defaults to very-magic regular
  expressions.
- Tabs remain literal tabs with a displayed width of two columns.
- English spell checking and visible whitespace are enabled.

## Plugins

Vundle installs integrations including Fugitive, GitGutter, ALE, NERDTree,
Airline, vim-orgmode, Python/C++ syntax enhancements, WindowSwap, and
linediff. The source of truth is the `Plugin` list in
[`configurations/vundle.vim`](configurations/vundle.vim).

Some installed plugins intentionally use their defaults and have no dedicated
configuration. Language-specific tools such as `ghcmod-vim` may require their
own external executables.

## Customization

Edit `configurations/vundle.vim` for plugins and theme behavior. Put reusable
filetype syntax in `syntax/`, and keep general mappings or editor options in
`my.vimrc`. Running `make vim` again refreshes the symlinks without replacing
an existing Vundle checkout.
