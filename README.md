# 🏠 Dotfiles

> Personal configuration files for a productive development environment

A comprehensive collection of configuration files for various tools and applications, designed to provide a consistent and efficient development experience across different systems.

## ✨ Features

- **Modern CLI Tools**: Integrated support for `bat`, `exa`, `fd`, `ripgrep`
- **Enhanced Vi Mode**: Comprehensive vi-mode navigation in bash and readline
- **Git Integration**: Advanced git aliases and visual status indicators
- **Cross-Platform**: Support for Linux, macOS, and Windows (WSL/MSYS2)
- **Easy Installation**: Simple makefile-based installation with safety features

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install essential configurations
make essential

# Or install everything
make all
```

## 📦 What's Included

### Core Configurations
- **Bash** (`bash/`) - Enhanced shell with modern CLI tools, improved history, and productivity aliases
- **Vim** (`vim/`) - Feature-rich vim configuration with syntax highlighting and plugins
- **Git** (`gitconfig/`) - Advanced git configuration with aliases and hooks
- **Tmux** (`tmux/`) - Terminal multiplexer configuration
- **Input** (`input/`) - Readline configuration with vi-mode enhancements

### Development Tools
- **GDB** (`gdb/`) - Debugger configuration
- **Emacs** (`emacs/`) - Emacs configuration with packages

### Platform-Specific
- **Mintty** (`mintty/`) - Terminal emulator for Windows
- **SumatraPDF** (`sumatra_pdf/`) - PDF viewer configuration for Windows
- **Vimperator** (`vimperator/`) - Firefox extension configuration

### System Tools
- **Tcsh** (`tcsh/`) - C shell configuration
- **Keyboard** (`keyboard/`) - Keyboard layout configuration

## 🛠 Installation Options

### Essential Setup (Recommended)
```bash
make essential  # Installs bash, vim, git, tmux, input
```

### Individual Components
```bash
make bash       # Install bash configuration
make vim        # Install vim configuration
make git        # Install git configuration
# ... see 'make help' for all options
```

### Utility Commands
```bash
make help       # Show all available targets
make check      # Check what's currently installed
make backup     # Backup existing configs before installing
make clean      # Uninstall (remove symlinks)
make update     # Update repository
```

## 🎯 Key Features

### Enhanced Bash Experience
- **Modern CLI tools** with automatic fallbacks
- **Improved history** management and search
- **Git-aware prompt** with execution timing
- **Comprehensive aliases** for common tasks
- **Directory bookmarks** (mark/jump/marks)

### Vi-Mode Enhancements
- **Full vim navigation** in command mode (gg, G, w, b, etc.)
- **Visual mode indicators** with colors
- **Smart completion** with case-insensitive matching
- **History search** with arrow keys

### Git Integration
- **Visual status indicators** in `exa` listings
- **Comprehensive aliases** (gs, gd, glog, etc.)
- **Pre-commit hooks** for conflict prevention
- **Enhanced diff and log formatting**

## 📋 Requirements

### Essential
- `bash` 4.0+
- `git`
- `make`

### Optional (for enhanced features)
- `bat` - Syntax highlighting for cat
- `exa` - Modern ls replacement  
- `fd` / `fdfind` - Fast find alternative
- `ripgrep` (`rg`) - Fast text search
- `vim` - Text editor
- `tmux` - Terminal multiplexer

### Installation of Modern Tools
```bash
# Ubuntu/Debian
sudo apt install bat exa fd-find ripgrep

# macOS
brew install bat exa fd ripgrep

# Arch Linux  
sudo pacman -S bat exa fd ripgrep
```

## 🔧 Customization

### Local Overrides
Create `~/.bashrc.work` for work-specific configurations that won't be tracked:

```bash
# ~/.bashrc.work
export WORK_SPECIFIC_VAR="value"
alias work-command="some command"
```

### Directory Bookmarks
```bash
mark project    # Bookmark current directory as 'project'
jump project    # Jump to bookmarked directory
marks           # List all bookmarks
```

## 🔍 What's Different

This dotfiles collection focuses on:
- **Productivity**: Fast, efficient tools and workflows
- **Modern tooling**: Integration with contemporary CLI tools
- **Safety**: Backup and uninstall options
- **Documentation**: Self-documenting with help systems
- **Cross-platform**: Works across different operating systems

## 📝 License

MIT License - feel free to use and modify as needed.

## 🤝 Contributing

Suggestions and improvements welcome! Please feel free to:
- Open issues for bugs or feature requests
- Submit pull requests for improvements
- Share your own dotfile ideas
