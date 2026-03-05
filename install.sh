#! /bin/bash

# Update package lists and install essential tools
sudo apt-get update && sudo apt-get install -y \
    bc \
    bat \
    exa \
    fd-find \
    ripgrep

# Create symbolic links for configuration files
ln -fsn ~/dotfiles/bash/my.bashrc ~/.bashrc
ln -fsn ~/dotfiles/input/.inputrc ~/.inputrc

echo "✓ Dotfiles installation complete!"
echo "✓ Installed modern CLI tools: bat, exa, fd-find, ripgrep"
echo "✓ Configured bash and input settings"
echo ""
echo "Restart your shell or run 'source ~/.bashrc' to use the new configuration."