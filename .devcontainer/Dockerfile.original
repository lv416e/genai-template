# Optional custom Dockerfile for the devcontainer
# This is not required if using the base image with features,
# but provided as an alternative for more control

FROM mcr.microsoft.com/devcontainers/base:debian-12

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install additional system dependencies
RUN apt-get update && apt-get install -y \
    # Build essentials
    build-essential \
    pkg-config \
    # SSL and crypto libraries
    libssl-dev \
    libffi-dev \
    # Python build dependencies
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    liblzma-dev \
    # Modern CLI tools
    ripgrep \
    fd-find \
    bat \
    exa \
    jq \
    tree \
    htop \
    # Locale support
    locales \
    && locale-gen en_US.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set locale environment
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Switch to vscode user
USER vscode

# Install mise (modern runtime manager)
RUN curl https://mise.run | sh

# Install uv (Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Add mise and uv to PATH
ENV PATH="/home/vscode/.local/bin:/home/vscode/.cargo/bin:${PATH}"

# Install default tool versions
RUN eval "$(~/.local/bin/mise activate bash)" && \
    ~/.local/bin/mise install python@3.12 && \
    ~/.local/bin/mise install node@lts && \
    ~/.local/bin/mise global python@3.12 node@lts

# Setup shell configuration
RUN echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc && \
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc && \
    echo 'export PATH="/home/vscode/.cargo/bin:$PATH"' >> ~/.bashrc && \
    echo 'export PATH="/home/vscode/.cargo/bin:$PATH"' >> ~/.zshrc

# Set working directory
WORKDIR /workspaces

# Reset to default frontend
ENV DEBIAN_FRONTEND=dialog