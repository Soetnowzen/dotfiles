# GitHub Copilot CLI integration
# Requires: gh CLI with gh-copilot extension
# Install: make copilot

if command -v gh &>/dev/null && gh extension list 2>/dev/null | grep -q 'copilot'; then
    # Inline shell suggestions (natural language -> command)
    alias '??'='gh copilot suggest -t shell'
    alias 'git?'='gh copilot suggest -t git'
    alias 'gh?'='gh copilot suggest -t gh'

    # Explain a command
    alias 'explain?'='gh copilot explain'
fi
