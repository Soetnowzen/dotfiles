# Emacs configuration

A modular Emacs setup centered on Evil, Ivy/Counsel, Projectile, Org mode,
Elfeed, and a Solarized-derived theme.

## Installation

From the repository root:

```bash
make emacs
```

This links the entire directory to `~/.emacs.d`. Existing content at that path
must be moved or backed up manually before installation.

On first startup, Emacs may contact GNU ELPA, MELPA, and the Org archive to
install packages through `use-package`.

The current MELPA and Org archive URLs use plain HTTP. Review and change them to
HTTPS in [`init.el`](init.el) before bootstrapping packages on an untrusted
network.

## Structure

[`init.el`](init.el) adds [`scripts/`](scripts/) to `load-path` and loads the
active `init-*.el` modules. Important modules include:

| Module | Purpose |
| --- | --- |
| [`init-use-package.el`](scripts/init-use-package.el) | Bootstraps `use-package` and package installation |
| [`init-evil.el`](scripts/init-evil.el) | Vim emulation, surrounding text objects, and folding behavior |
| [`init-keybindings.el`](scripts/init-keybindings.el) | Leader and window-management bindings |
| [`init-ivy.el`](scripts/init-ivy.el) | Ivy, Counsel, and Smex completion |
| [`init-projectile.el`](scripts/init-projectile.el) | Project discovery and navigation |
| [`init-org.el`](scripts/init-org.el) | Org agenda, TODO states, and refile behavior |
| [`init-elfeed.el`](scripts/init-elfeed.el) | RSS feeds and Elfeed bindings |
| [`init-theme.el`](scripts/init-theme.el) | Theme and mode-line configuration |
| [`init-whitespace.el`](scripts/init-whitespace.el) | Visible tabs and trailing whitespace |
| [`init-helpful.el`](scripts/init-helpful.el) | Enhanced function and variable help |
| [`init-which-key.el`](scripts/init-which-key.el) | Discoverable keybinding hints |

Commented `require` forms in `init.el` are disabled modules. Uncomment one to
activate it when its dependencies are available.

## Keybindings

The main leader key is `SPC` in Evil normal mode.

| Binding | Purpose |
| --- | --- |
| `jj` or `jk` | Leave insert mode |
| `C-h`, `C-j`, `C-k`, `C-l` | Move between windows |
| `SPC f` | Find a file with Counsel |
| `SPC p` | Find a file in the current Projectile project |
| `SPC P` | Switch Projectile projects |
| `SPC r` | Open Elfeed |
| `SPC c` | Toggle the current line comment |
| `SPC z a` | Toggle the current fold |

Use `which-key` after a prefix to discover the complete active map.

## Local data and customization

- Backups are written below `~/.emacs.d/.backups`.
- Auto-save files are written below `~/.emacs.d/.auto-saves`.
- Org agenda paths and Elfeed subscriptions are configured in their respective
  modules and are machine-specific.
- Projectile currently searches below `~/Documents/Code`.
- The `custom-set-variables` block in `init.el` is managed by Emacs Customize;
  avoid maintaining duplicate Custom blocks by hand.

`init-folding.el` is currently only a placeholder; active folding is provided
by `hideshow` setup elsewhere in the configuration.
