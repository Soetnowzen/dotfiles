#! /bin/bash

# Update package lists and install essential tools
sudo apt-get update && sudo apt-get install -y \
    bc \
    bat \
    eza \
    fd-find \
    ripgrep \
    curl

# Create symbolic links for configuration files
ln -fsn ~/dotfiles/bash/my.bashrc ~/.bashrc
ln -fsn ~/dotfiles/input/.inputrc ~/.inputrc

echo "✓ Dotfiles installation complete!"
echo "✓ Installed modern CLI tools: bat (batcat), eza (exa), fd-find (fdfind), ripgrep (rg)"
echo "✓ Configured bash and input settings"
echo ""
echo "To enable GitHub Copilot CLI, run: make copilot"
echo "Restart your shell or run 'source ~/.bashrc' to use the new configuration."