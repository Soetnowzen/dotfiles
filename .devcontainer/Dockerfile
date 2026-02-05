# Use Debian as base image for dotfiles testing
FROM debian:bookworm

# Add metadata to the image to describe that the container is used for testing
LABEL description="Devcontainer for testing dotfiles"

# Install essential packages and create non-root user for testing
RUN apt-get update && apt-get install -y \
    # Shells
    bash \
    zsh \
    tcsh \
    # Core utilities
    curl \
    wget \
    git \
    make \
    # Text editors
    vim \
    emacs-nox \
    # Terminal multiplexer
    tmux \
    # Development tools
    build-essential \
    gdb \
    python3 \
    python3-pip \
    # File utilities
    file \
    tree \
    # Process utilities
    htop \
    procps \
    # Network utilities
    iputils-ping \
    # Archive utilities
    unzip \
    tar \
    gzip \
    # Misc utilities
    sudo \
    less \
    grep \
    sed \
    gawk \
    findutils \
    coreutils \
    util-linux \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -s /bin/bash testuser \
    && echo 'testuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set the working directory to the user's home
WORKDIR /home/testuser

# Switch to the test user
USER testuser

# Set default shell to bash
SHELL ["/bin/bash", "-c"]