# Optimized Dockerfile for Agentic Template Repository
# Designed for fast launches via pre-built images

FROM mcr.microsoft.com/devcontainers/base:debian-12

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set locale environment early
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Layer 1: System packages and locale setup (rarely changes)
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    # Build essentials
    build-essential \
    pkg-config \
    curl \
    wget \
    unzip \
    git \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
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

# Layer 2: Git configuration (security)
RUN git config --global --add safe.directory /workspaces/*

# Switch to vscode user for tool installations
USER vscode

# Layer 3: mise installation (modern runtime manager)
RUN curl -fsSL https://mise.run | sh && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && \
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && \
    echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc && \
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc

# Layer 4: uv installation (Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc && \
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc

# Add mise and uv to PATH for subsequent layers
ENV PATH="/home/vscode/.local/bin:/home/vscode/.cargo/bin:${PATH}"

# Layer 5: Core runtime installations via mise
RUN eval "$($HOME/.local/bin/mise activate bash)" && \
    $HOME/.local/bin/mise install python@3.12 && \
    $HOME/.local/bin/mise install node@lts && \
    $HOME/.local/bin/mise global python@3.12 node@lts

# Layer 6: Claude Code tool installation (requires Node.js)
RUN eval "$($HOME/.local/bin/mise activate bash)" && \
    npm install -g cc-sdd@latest

# Set working directory
WORKDIR /workspaces

# Reset to default frontend
ENV DEBIAN_FRONTEND=dialog

# Set environment variables for runtime
ENV PYTHONPATH="/workspaces" \
    TERM="xterm-256color"

# Expose common development ports
EXPOSE 3000 8000 8080 5000 8888