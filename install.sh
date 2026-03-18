#! /bin/bash

# Update package lists and install essential tools
sudo apt-get update && sudo apt-get install -y \
    bc \
    bat \
    exa \
    fd-find \
    ripgrep \
    curl

# Install GitHub CLI (gh)
if ! command -v gh &>/dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update && sudo apt-get install -y gh
fi

# Authenticate with GitHub via browser if not already logged in
if command -v gh &>/dev/null && ! gh auth status &>/dev/null; then
    echo "Opening browser for GitHub authentication..."
    gh auth login --web -h github.com --git-protocol https
fi

# Install GitHub Copilot CLI extension
if command -v gh &>/dev/null && ! gh extension list 2>/dev/null | grep -q 'copilot'; then
    gh extension install github/gh-copilot
fi

# Create symbolic links for configuration files
ln -fsn ~/dotfiles/bash/my.bashrc ~/.bashrc
ln -fsn ~/dotfiles/input/.inputrc ~/.inputrc

echo "✓ Dotfiles installation complete!"
echo "✓ Installed modern CLI tools: bat, exa, fd-find, ripgrep"
echo "✓ Installed GitHub CLI + Copilot extension"
echo "✓ Configured bash and input settings"
echo ""
echo "  GitHub authentication was handled during install (browser OAuth)."
echo "Restart your shell or run 'source ~/.bashrc' to use the new configuration."