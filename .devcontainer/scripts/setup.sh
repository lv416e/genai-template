#!/bin/bash

set -e

echo "🚀 Setting up project environment (lightweight)..."

# Ensure mise and uv are available in current session
eval "$(~/.local/bin/mise activate bash)"
source ~/.cargo/env 2>/dev/null || true

# Navigate to workspace
cd /workspaces/$(basename $PWD)

# Install Python dependencies if pyproject.toml exists
if [ -f "pyproject.toml" ]; then
    echo "📦 Installing Python dependencies..."
    ~/.cargo/bin/uv sync --dev
else
    echo "📦 No pyproject.toml found, skipping Python dependencies..."
fi

# Install Node.js dependencies if package.json exists
if [ -f "package.json" ]; then
    echo "📦 Installing Node.js dependencies..."
    npm install
else
    echo "📦 No package.json found, skipping Node.js dependencies..."
fi

# Install tools from mise.toml if it exists
if [ -f "mise.toml" ] || [ -f ".tool-versions" ]; then
    echo "🔧 Installing additional tools via mise..."
    ~/.local/bin/mise install
else
    echo "🔧 No mise.toml or .tool-versions found, skipping tool installation..."
fi

# Initialize Claude Code project template if needed
echo "🚀 Checking Claude Code project setup..."
if [ ! -f ".claude-code-spec.json" ]; then
    echo "🤖 Initializing Claude Code project template..."
    npx cc-sdd@latest --lang ja --dry-run || echo "Note: Claude Code setup will be available after first run"
fi

# Verify installations
echo "✅ Verifying installations..."
echo "mise version: $(~/.local/bin/mise --version 2>/dev/null || echo 'Not available')"
echo "uv version: $(~/.cargo/bin/uv --version 2>/dev/null || echo 'Not available')"
echo "Python version: $(python3 --version 2>/dev/null || echo 'Not available')"
echo "Node.js version: $(node --version 2>/dev/null || echo 'Not available')"
echo "npm version: $(npm --version 2>/dev/null || echo 'Not available')"

echo "✅ Lightweight setup completed in $(date)!"
