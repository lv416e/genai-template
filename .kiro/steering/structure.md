# Project Structure

## Root Directory Organization

The GenAI Development Environment follows a clean, organized structure optimized for template usage and rapid project bootstrapping. Each directory serves a specific purpose in the development workflow.

```
genai/
├── .kiro/                    # Spec-driven development workspace
├── .claude/                  # Claude Code configuration and commands
├── .devcontainer/           # Docker development environment
├── .serena/                 # Serena MCP server workspace
├── configuration files      # Project setup and tooling config
└── documentation           # Project documentation
```

### Configuration Files (Root Level)
```
├── pyproject.toml          # Python project configuration (primary)
├── mise.toml               # Runtime and task management
├── .pre-commit-config.yaml # Git hook configuration
├── .gitignore              # Version control exclusions
├── .tool-versions          # mise version specifications
├── .env.example            # Environment variable template
├── README.md               # Project overview and quick start
└── CLAUDE.md               # Claude Code project instructions
```

## Subdirectory Structures

### `.kiro/` - Spec-Driven Development
```
.kiro/
├── steering/               # Project guidance documents
│   ├── product.md         # Product overview and context
│   ├── tech.md           # Technology stack documentation
│   └── structure.md      # Project organization (this file)
└── specs/                # Feature specifications (created as needed)
    └── [feature-name]/   # Individual feature directories
        ├── requirements.md
        ├── design.md
        └── tasks.md
```

**Purpose**: Central workspace for spec-driven development workflow
- **steering/**: Always-included project knowledge for AI assistance
- **specs/**: Feature-specific development specifications

### `.claude/` - Claude Code Integration
```
.claude/
├── settings.local.json     # Claude Code local settings
└── commands/              # Custom slash commands
    └── kiro/              # Kiro workflow commands
        ├── steering.md
        ├── steering-custom.md
        ├── spec-init.md
        ├── spec-requirements.md
        ├── spec-design.md
        ├── spec-tasks.md
        ├── spec-impl.md
        └── spec-status.md
```

**Purpose**: Claude Code configuration and custom commands
- **settings.local.json**: Local development settings (not committed)
- **commands/kiro/**: Spec-driven development workflow commands

### `.devcontainer/` - Development Environment
```
.devcontainer/
├── devcontainer.json       # Container configuration
├── Dockerfile             # Container image definition
└── scripts/               # Setup and initialization scripts
    └── setup.sh          # Post-create setup commands
```

**Purpose**: Docker-based development environment for Codespaces
- Ensures consistent development environment across all machines
- Pre-installs all necessary tools and configurations

### `.serena/` - MCP Server Workspace
```
.serena/                    # Created by Serena MCP server
└── [memory-files]         # Project memory and context files
```

**Purpose**: Workspace for the Serena MCP server
- Stores project memory and context information
- Managed automatically by the MCP server

## Code Organization Patterns

### Python Package Structure (When Adding Source Code)
```
src/                       # Source code (create when needed)
├── genai/                # Main package
│   ├── __init__.py       # Package initialization
│   ├── core/             # Core functionality
│   ├── models/           # AI/ML models
│   ├── utils/            # Utility functions
│   └── config/           # Configuration management
├── tests/                # Test suite
│   ├── __init__.py       # Test package initialization
│   ├── unit/             # Unit tests
│   ├── integration/      # Integration tests
│   └── fixtures/         # Test data and fixtures
└── docs/                 # Documentation source
    ├── api/              # API documentation
    ├── guides/           # User guides
    └── examples/         # Code examples
```

**Note**: This structure is created only when actual source code is added to the template.

### AI/ML Specific Organization
```
notebooks/                # Jupyter notebooks (create when needed)
├── exploration/          # Data exploration notebooks
├── experiments/          # ML experiments and prototyping
└── analysis/             # Results analysis

data/                     # Data storage (create when needed)
├── raw/                  # Original, immutable data
├── processed/            # Cleaned and processed data
└── external/             # External data sources

models/                   # Trained model storage (create when needed)
├── checkpoints/          # Training checkpoints
├── artifacts/            # Model artifacts
└── configs/              # Model configurations
```

**Note**: These directories are created as needed for specific AI/ML projects.

## File Naming Conventions

### Python Files
- **Snake case**: `model_trainer.py`, `data_processor.py`
- **Test files**: `test_model_trainer.py` or `model_trainer_test.py`
- **Private modules**: `_internal_utils.py` (underscore prefix)

### Configuration Files
- **Lowercase with hyphens**: `.pre-commit-config.yaml`, `docker-compose.yml`
- **Dotfiles**: Standard names like `.gitignore`, `.env`
- **TOML files**: `pyproject.toml`, `mise.toml`

### Documentation Files
- **Uppercase**: `README.md`, `CLAUDE.md`, `LICENSE`
- **Lowercase for content**: `installation.md`, `contributing.md`

### Directory Names
- **Lowercase with underscores**: `test_data/`, `config_files/`
- **Descriptive**: `notebooks/`, `scripts/`, `docs/`

## Import Organization

### Import Order (Python)
Following ruff/isort configuration:
```python
# Standard library imports
import os
from pathlib import Path

# Third-party imports
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split

# First-party imports (your package)
from genai.core import ModelTrainer
from genai.utils import load_config
```

### Import Aliases
Standard aliases for common libraries:
```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import tensorflow as tf
import torch
```

## Key Architectural Principles

### 1. Template-First Design
- **Clean Starting Point**: Minimal but complete setup for new projects
- **Extensible**: Easy to add features without restructuring
- **Opinionated**: Pre-configured with best practices

### 2. Configuration as Code
- **Version Controlled**: All configuration in git repository
- **Reproducible**: Identical environments across machines
- **Documented**: Clear purpose for each configuration file

### 3. Tool Integration
- **Single Source of Truth**: pyproject.toml as primary configuration
- **Consistent Commands**: mise for unified task management
- **Quality Gates**: Pre-commit hooks enforce standards

### 4. Development Experience
- **Fast Setup**: 2-minute from zero to productive development
- **IDE Integration**: Full VS Code support with extensions
- **Hot Reloading**: Automatic updates during development

### 5. AI/ML Ready
- **Framework Agnostic**: Supports TensorFlow, PyTorch, scikit-learn
- **Notebook Integration**: Jupyter support for exploration
- **Data Pipeline**: Clear separation of raw, processed, and model data

### 6. Spec-Driven Development
- **Documentation First**: Specifications before implementation
- **AI Assisted**: Claude Code integration for workflow automation
- **Iterative**: Requirements → Design → Tasks → Implementation

## Security and Privacy Patterns

### Sensitive Data Handling
```
# Never commit these patterns:
.env                      # Environment variables
*.key                     # Private keys
*.pem                     # Certificates
config/local.py          # Local configurations
data/private/            # Private datasets
.secrets/                # Secrets directory
```

### Cache and Temporary Files
```
# Excluded from version control:
__pycache__/             # Python cache
.pytest_cache/           # Test cache
.mypy_cache/             # Type checking cache
.ruff_cache/             # Linter cache
.uv-cache/               # Package manager cache
htmlcov/                 # Coverage reports
.coverage                # Coverage data
```

## Performance Considerations

### File System Organization
- **Cache Isolation**: All cache directories clearly separated
- **Fast Access**: Frequently used files in root or shallow directories
- **Clean Workspace**: Generated files excluded from repository

### Build Optimization
- **Minimal Containers**: Only necessary tools in development environment
- **Layer Caching**: Docker layer optimization for faster builds
- **Dependency Caching**: Aggressive caching of packages and tools

## Maintenance Principles

### Growing the Template
- **Add, Don't Replace**: Extend existing patterns rather than restructuring
- **Document Changes**: Update steering documents when structure changes
- **Preserve Customizations**: User modifications should survive updates

### Keeping Clean
- **Regular Cleanup**: Remove unused files and directories
- **Dependency Hygiene**: Regular review of dependencies and their necessity
- **Configuration Pruning**: Remove unused configuration options

### Backward Compatibility
- **Migration Guides**: Document breaking changes clearly
- **Gradual Transitions**: Deprecate before removing
- **Version Awareness**: Tag significant structural changes

The project structure is designed to grow with your project while maintaining clarity and organization throughout the development lifecycle.