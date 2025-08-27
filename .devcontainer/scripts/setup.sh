#!/bin/bash

set -e

echo "🚀 Setting up modern GenAI development environment..."

# Update system packages
echo "📦 Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install essential build tools and dependencies
echo "🔧 Installing build essentials..."
sudo apt-get install -y \
    build-essential \
    curl \
    wget \
    unzip \
    git \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    libssl-dev \
    libffi-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    liblzma-dev

# Install mise (modern runtime manager)
echo "⚡ Installing mise..."
curl https://mise.run | sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
export PATH="$HOME/.local/bin:$PATH"

# Install uv (fast Python package manager)
echo "🐍 Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
export PATH="$HOME/.cargo/bin:$PATH"

# Install Claude Code Spec-Driven Development tool
echo "🤖 Setting up Claude Code integration..."
npm install -g cc-sdd@latest

# Set up locale support
sudo apt-get install -y locales
sudo locale-gen en_US.UTF-8

# Install additional useful tools
echo "🛠️ Installing additional development tools..."
sudo apt-get install -y \
    ripgrep \
    fd-find \
    bat \
    exa \
    jq \
    tree \
    htop

# Configure git with safe directory
echo "🔒 Configuring git..."
git config --global --add safe.directory /workspaces/*


# Make sure mise and uv are available in current session
eval "$(~/.local/bin/mise activate bash)"
source ~/.cargo/env

# Install tools from mise.toml
echo "🔧 Installing tools via mise..."
~/.local/bin/mise install

# Install Python dependencies
echo "📦 Installing Python dependencies..."
cd /workspaces/$(basename $PWD)
~/.cargo/bin/uv sync --dev

# Verify installations
echo "✅ Verifying installations..."
echo "mise version: $(~/.local/bin/mise --version)"
echo "uv version: $(~/.cargo/bin/uv --version)"
echo "Python version: $(python3 --version)"
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

# Initialize Claude Code project template
echo "🚀 Initializing Claude Code project template..."
cd /workspaces/$(basename $PWD)
if [ ! -f ".claude-code-spec.json" ]; then
    npx cc-sdd@latest --lang ja --dry-run || echo "Note: Claude Code setup will be available after first run"
fi

# Clean up
echo "🧹 Cleaning up..."
sudo apt-get autoremove -y
sudo apt-get autoclean

echo "✅ Setup completed!"