# Git configuration

Git defaults, aliases, Gitk settings, identity overrides, and template hooks.

## Installation

From the repository root:

```bash
make git
```

This target:

- Links [`.gitconfig`](.gitconfig) to `~/.gitconfig`.
- Copies [`.gitconfig-personal`](.gitconfig-personal) to
  `~/.gitconfig-personal` only when that file does not already exist.
- Links the main hooks into `~/.git_template/hooks` and makes them executable.
- Links [`.gitk`](.gitk) to `~/.gitk`.

After installation, replace the placeholder name and email in
`~/.gitconfig-personal`.

## Configuration behavior

The main configuration provides colored output, Vim as the editor and diff
tool, `diff3` merge conflicts, rerere, and a large set of aliases for branches,
commits, diffs, logs, rebases, and Gerrit review refs. The personal template
also enables automatic remote setup on first push.

Run the following to inspect an alias without opening the configuration:

```bash
git config --get alias.NAME
```

Conditional includes load `~/.gitconfig-personal` for repositories below
`~/projects`, `~/code`, and `~/dev`. Repositories below `~/work` instead load
`~/.gitconfig-work`; create that file when a separate work identity or behavior
is needed:

```ini
[user]
    name = Your Work Name
    email = you@example.com
```

## Hooks

| Hook | Purpose |
| --- | --- |
| [`pre-commit`](pre-commit) | Checks conflict markers, debug statements, likely secrets, large files, and whitespace; warns on direct commits to protected branches |
| [`commit-msg`](commit-msg) | Checks subject length, capitalization, imperative wording, and supported conventional-commit formatting |
| [`pre-push`](pre-push) | Warns about force pushes to protected branches |

The other `pre-commit-*` files are focused variants retained for manual use.

Git's template directory applies hooks when a repository is created or cloned.
It does not retrofit existing repositories. Install the configured hooks into
the current repository with:

```bash
make install-hooks
```

Hook warnings and failures are intentional workflow checks. Read the emitted
message before bypassing a hook with `--no-verify`.
