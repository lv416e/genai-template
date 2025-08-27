# Technology Stack

## Architecture

**GenAI Development Environment** follows a cloud-first, container-based architecture optimized for GitHub Codespaces. The system is designed as a development template rather than a deployed application, focusing on providing a complete local development experience in the cloud.

### Core Architecture Principles

- **Container-First**: All development happens within a Docker container for consistency
- **Tool Integration**: Seamless integration between modern Python tooling and AI development workflow
- **Configuration as Code**: All environment setup captured in version-controlled configuration files
- **Multi-Language Support**: Runtime management supporting Python, Node.js, Go, and Rust simultaneously

## Development Environment

### Runtime Management
- **mise (v2024+)**: Unified runtime and tool manager
  - Manages Python 3.12, Node.js LTS, Go 1.22, Rust 1.80
  - Environment variable management and task automation
  - Replaces pyenv, nvm, and other version managers

### Container Environment
- **Docker**: Development container based on official Microsoft devcontainer images
- **GitHub Codespaces**: Optimized for cloud development with 2-minute startup time
- **VS Code Integration**: Full IDE support with extensions and settings pre-configured

## Python Development Stack

### Package Management
- **uv (v0.8+)**: Ultra-fast Python package installer and resolver
  - 10-100x faster than pip for most operations
  - Drop-in replacement for pip with advanced dependency resolution
  - Integrated virtual environment management
  - Cache-optimized for Codespaces environment

### Core Dependencies
- **Python 3.12+**: Latest stable Python with modern language features
- **Core Runtime**: Currently no production dependencies (template only)
- **Development Dependencies**: Comprehensive tooling for professional development

### Development Dependencies
```toml
# Code Quality & Formatting
ruff>=0.8.0          # Ultra-fast linter and formatter
mypy>=1.15.0         # Static type checking

# Testing Framework
pytest>=8.0.0        # Modern testing framework
pytest-cov>=6.0.0    # Coverage reporting
pytest-xdist>=3.5.0  # Parallel test execution
pytest-mock>=3.12.0  # Mocking utilities

# Development Tools
pre-commit>=4.0.0    # Git hook management
ipython>=8.18.0      # Enhanced Python REPL
jupyter>=1.1.0       # Notebook support
notebook>=7.2.0      # Jupyter notebook interface

# Documentation
mkdocs>=1.6.0        # Documentation generator
mkdocs-material>=9.5.0  # Material theme
mkdocstrings>=0.27.0  # Python API documentation
```

## Code Quality Pipeline

### Linting and Formatting
- **ruff**: Single tool replacing flake8, isort, pyupgrade, and black
  - Line length: 120 characters
  - Target: Python 3.12+
  - Comprehensive rule set (E, W, F, UP, B, SIM, I, C4, ISC, PL, RUF, ANN)
  - Auto-fixing capabilities for most issues

### Type Checking
- **mypy**: Static type analysis with moderate strictness
  - Python 3.12 target
  - Configured for good developer experience (not overly strict)
  - Missing imports ignored for faster iteration

### Pre-commit Hooks
- **Automated Quality Checks**: Runs on every commit
  - Ruff linting and formatting
  - MyPy type checking
  - File format validation (YAML, TOML, JSON)
  - Security checks (private keys, large files)
  - Conventional commit format enforcement

## Multi-Language Support

### Node.js/JavaScript
- **Node.js LTS**: Latest long-term support version
- **npm/yarn**: Package management (as needed for frontend tools)
- **Purpose**: Frontend development, build tools, and JavaScript-based AI tools

### Go
- **Go 1.22**: Modern Go version for backend services and CLI tools
- **Purpose**: High-performance microservices and system tools

### Rust
- **Rust 1.80**: Latest stable Rust for system programming
- **Purpose**: Required for some Python tools (ruff, uv), potential native extensions

## Claude Code Integration

### Spec-Driven Development
- **Kiro Commands**: Custom slash commands for workflow automation
  - `/kiro:spec-init`: Initialize feature specifications
  - `/kiro:spec-requirements`: Generate requirements documents
  - `/kiro:spec-design`: Interactive design process
  - `/kiro:spec-tasks`: Task breakdown and tracking
  - `/kiro:steering`: Update steering documents

### Language Support
- **Japanese Language Integration**: Native support for Japanese responses
- **Bilingual Development**: Think in English, respond in Japanese capability

## Common Commands

### Development Workflow
```bash
# Environment setup
mise install              # Install all runtimes
uv sync --dev            # Install dependencies

# Code quality
mise run lint            # Run linter
mise run format          # Format code
mise run type-check      # Type checking
mise run fix             # Auto-fix issues

# Testing
mise run test            # Run tests
mise run test-cov        # Run with coverage
mise run test-watch      # Watch mode

# Project management
mise run clean           # Clean cache files
mise run deps            # Show dependency tree
mise run outdated        # Check outdated packages
```

### Aliases (Short Commands)
```bash
mise run i               # Install package
mise run id              # Install dev package
mise run r               # Run Python
mise run l               # Lint
mise run f               # Format
mise run t               # Test
mise run c               # Clean
```

## Environment Variables

### Python Environment
```bash
PYTHONPATH="./src:./lib"      # Module search paths
PYTHONDONTWRITEBYTECODE="1"   # No .pyc files
PYTHONUNBUFFERED="1"          # Immediate output
```

### Development Settings
```bash
ENVIRONMENT="development"      # Environment mode
DEBUG="1"                     # Debug mode enabled
LANG="en_US.UTF-8"            # Locale settings
EDITOR="code"                 # Default editor
```

### Tool Configuration
```bash
UV_CACHE_DIR="./.uv-cache"           # UV cache location
UV_PYTHON_PREFERENCE="managed"       # Managed Python preference
RUFF_CACHE_DIR="./.ruff_cache"      # Ruff cache location
NODE_ENV="development"               # Node environment
```

## Performance Considerations

### Speed Optimizations
- **uv Package Manager**: 10-100x faster than pip for installations
- **ruff Linting**: Rust-based, extremely fast linting and formatting
- **Cache Strategy**: Aggressive caching for Codespaces environment
- **Parallel Testing**: pytest-xdist for concurrent test execution

### Resource Management
- **Container Optimization**: Minimal container size with essential tools only
- **Cache Directories**: Strategic placement of cache directories for persistence
- **Lazy Loading**: Tools loaded only when needed

## Security Considerations

### Code Security
- **Pre-commit Security Hooks**: 
  - Private key detection
  - Large file prevention
  - Debug statement detection
- **Dependency Security**: Regular security scanning through pre-commit.ci
- **Conventional Commits**: Enforced commit message standards

### Environment Security
- **No Secrets in Config**: Environment variables for sensitive data only
- **Gitignore Best Practices**: Comprehensive exclusion of sensitive files
- **Container Security**: Regular base image updates through Dependabot

## Monitoring and Maintenance

### Automated Updates
- **pre-commit.ci**: Weekly automatic updates of hooks and dependencies
- **Dependabot**: GitHub dependency security updates
- **Version Pinning**: Strategic pinning vs flexible versioning

### Health Checks
- **CI Integration**: All quality checks run in continuous integration
- **Coverage Reporting**: Automatic test coverage tracking
- **Performance Monitoring**: Tool execution time tracking in development