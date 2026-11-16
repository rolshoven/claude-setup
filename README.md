# claude-setup

My Claude Code configuration, packaged as named bundles that can be installed
into `~/.claude` on any machine with one command.

## Install

On a new machine (needs `git` and `python3`):

```bash
curl -fsSL https://raw.githubusercontent.com/rolshoven/claude-setup/main/install.sh | bash -s -- --all
```

This clones the repo to `~/.claude-setup` and runs `setup-claude`. Replace
`--all` with `--bundle NAME` to install just one bundle.

From a checkout:

```bash
./setup-claude --list                  # show available bundles
./setup-claude --all                   # install everything
./setup-claude --bundle protect-env    # install one bundle (repeatable)
./setup-claude --all --dry-run         # show what would change
```

Installing is additive and idempotent: existing keys in `settings.json` are
kept, list entries are appended only when missing, and the previous file is
saved as `settings.json.bak` whenever it changes. Files that already exist
with different content, and conflicting scalar settings, are left alone unless
you pass `--force`. The target defaults to `$CLAUDE_CONFIG_DIR` or `~/.claude`
and can be changed with `--claude-dir`.

## Bundles

| Bundle | What it does |
| --- | --- |
| `protect-env` | Deny rules for `.env` files plus a `PreToolUse` hook on `Read`/`Grep` that blocks any `.env*` file except `.env.example` / `.sample` / `.template`. |
| `protect-secrets` | Deny rules for `*.pem`, `*.key` and `~/.ssh/**`. |

## Adding a bundle

Create `bundles/<name>/bundle.json`:

```json
{
  "description": "One line shown by --list",
  "files": {
    "hooks/my-hook.py": "hooks/my-hook.py"
  },
  "settings": {
    "hooks": {
      "PreToolUse": [
        {
          "matcher": "Bash",
          "hooks": [
            { "type": "command", "command": "python3 {{CLAUDE_DIR}}/hooks/my-hook.py" }
          ]
        }
      ]
    }
  }
}
```

- `files` maps a path inside the bundle directory to a path under the Claude
  config directory. File modes are preserved.
- `settings` is a fragment merged into `settings.json`.
- `{{CLAUDE_DIR}}` in settings strings is replaced with the target directory
  (`~/.claude` by default).

Both keys are optional; `--all` picks up every directory under `bundles/`
automatically.
