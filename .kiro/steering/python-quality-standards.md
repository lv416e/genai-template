<!-- Inclusion Mode: Always -->
# Python Development Quality Constitution

## Fundamental Principles

**Define practical quality standards based on operational realities for Python implementation and development using Claude Code.**

The critical requirement for each Todo is to ensure that ALL quality gates listed below pass completely, and it is **ABSOLUTELY PROHIBITED** to proceed to the next Todo until all gates pass.

## Article 1: Absolute Compliance with Quality Gates

### Required Inspection Items

All of the following commands must pass successfully before proceeding to the next task:

1. **MyPy Type Checking**
   ```bash
   mypy --config-file=pyproject.toml [target_paths]
   ```

2. **Pre-commit Hook Execution**
   ```bash
   pre-commit run --all-files
   ```

3. **Ruff Linter & Formatter**
   ```bash
   ruff check . --fix --unsafe-fixes
   ```

4. **Pytest Test Execution**
   ```bash
   pytest [test_paths]
   ```

### Execution Order and Error Handling

1. **Sequential Execution**: Run the above 4 commands in order
2. **Stop on Failure**: If any command fails, immediately stop all work
3. **Fix and Re-run**: After fixing errors, re-run ALL checks again
4. **Complete Pass Confirmation**: Only proceed to next Todo after ALL commands succeed

## Article 2: Detailed Quality Standards

### MyPy Configuration Requirements

- **Realistic Type Checking**: Ensure type safety at an operationally viable level
- **Gradual Introduction**: Avoid Strict Mode, adopt practical warning levels
- **External Dependency Flexibility**: Use `ignore_missing_imports = true` for operational continuity

**Practical Configuration (pyproject.toml)**:
```toml
[tool.mypy]
python_version = "3.12"
cache_dir = ".mypy_cache"
ignore_missing_imports = true
warn_unused_configs = true
warn_redundant_casts = true
warn_unused_ignores = true
disable_error_code = ["no-redef"]
# Adjust exclude patterns based on your project structure
exclude = [
    "tests/.*",
    "scripts/.*",
    "tools/.*",
]
# Adjust files pattern based on your source structure
files = ["src", "genai"]
```

### Pre-commit Configuration Requirements

**Maintain Current Configuration**: Keep existing `.pre-commit-config.yaml` and do not edit
- Provides basic hooks for formatter, linter, and type checker
- Continue using current settings that work operationally
- Make configuration changes only when necessary and with caution

### Ruff Configuration Requirements

**Practical Configuration (pyproject.toml)**:
```toml
[tool.ruff]
line-length = 120
target-version = "py312"
# Adjust include patterns based on your source structure
include = ["src/**/*.py", "genai/**/*.py"]

[tool.ruff.lint]
select = ["F", "E", "W", "I", "B", "C4", "C90", "N", "ANN", "UP"]
ignore = ["N803", "N806", "N815", "ANN101", "ANN102"]
# Adjust exclude patterns for your test structure
exclude = ["**/tests/**"]

[tool.ruff.lint.mccabe]
max-complexity = 30

[tool.ruff.lint.isort]
combine-as-imports = true
split-on-trailing-comma = true

[tool.ruff.format]
quote-style = "double"
line-ending = "lf"
```

### Pytest Configuration Requirements

**Practical Configuration**:
- **Test Execution Success is Top Priority**: Test passing is more important than coverage
- **Coverage is Supplementary Metric**: Measure separately when needed  
- **Adapt to Current Test Structure**: Target your specific test directories

**Recommended Configuration (pyproject.toml)**:
```toml
[tool.pytest.ini_options]
minversion = "8.0"
# Adjust testpaths to your actual test directory structure
testpaths = ["tests"]
python_files = "test_*.py"
python_classes = "Test*" 
python_functions = "test_*"
addopts = [
    "--strict-markers",
    "--tb=short",
    "--timeout=300",
    "-v"
]
markers = [
    "slow: marks tests as slow",
    "integration: marks tests as integration tests", 
    "unit: marks tests as unit tests",
]
```

**Coverage Measurement (Optional)**:
```bash
pytest --cov=src --cov-report=term-missing
```

## Article 3: Quality Evaluation Standards

### Minimum Required Quality Level

1. **Type Safety**: Pass basic type checking with MyPy
2. **Code Quality**: Pass all Ruff checks
3. **Test Execution**: All tests succeed (test passing is top priority)
4. **Coverage**: Supplementary metric, use as reference only

### Performance Requirements

- **MyPy Execution Time**: Within reasonable range (longer times acceptable for major error resolution)
- **Test Execution Time**: 300-second timeout setting (per individual test)
- **Pre-commit Execution Time**: Within practical operational range

## Article 4: Exception Handling and Practical Responses

### Permitted Exceptions and Flexibility

1. **External Dependency Errors**: Network failures, external API failures
2. **Environment-Specific Errors**: Issues occurring only in specific environments
3. **Gradual Improvement**: Prioritize continuous improvement over perfection
4. **Operational Continuity**: Prioritize operational viability over zero errors

### Practical Response Procedures

1. **Primary Response**: Fix automatically correctable errors
2. **Secondary Response**: Priority fixing of critical errors affecting operations
3. **Tertiary Response**: Plan gradual quality improvements
4. **Continuous Improvement**: Focus on continuous improvement cycles rather than perfection

## Article 5: Continuous Improvement

### Practical Quality Monitoring

- **Type Error Count**: Regular reduction efforts (don't demand perfection)
- **Test Success Rate**: Maintain test passing status
- **Code Quality**: Gradual improvement of Ruff violations

### Tool Update Policy

1. **Cautious Updates**: Prioritize stable operation, update only when necessary
2. **Gradual Introduction**: Carefully verify breaking changes
3. **Security Priority**: Apply security patches promptly

## Article 6: Implementation Support

### Claude Code Implementation Support

Provide the following support for practical quality improvement:

1. **Precise Information Gathering**: Obtain latest information using Context7 and other tools
2. **Staged Implementation**: Progress management using TodoWrite
3. **Practical Verification**: Quality confirmation within operational ranges
4. **Continuous Learning**: Deep thinking using UltraThink, Sequential-thinking, etc.

### Implementation Mindset

- **Think Harder**: Think more deeply
- **Use Precise Information**: Implementation based on accurate information
- **Practical Approach**: Prioritize practicality over perfection
- **Continuous Improvement**: Aim for gradual continuous improvement

## Implementation Commands

### Standard Quality Check Sequence
Run these commands in order for every Todo completion:

```bash
# 1. Type checking
mise run type-check
# or: mypy --config-file=pyproject.toml src/

# 2. Pre-commit hooks  
mise run pre-commit run --all-files
# or: pre-commit run --all-files

# 3. Linting and formatting
mise run lint && mise run format
# or: ruff check . --fix --unsafe-fixes

# 4. Test execution
mise run test
# or: pytest
```

### Emergency Quality Recovery
If quality gates fail:

```bash
# Auto-fix what's possible
ruff check . --fix --unsafe-fixes
ruff format .

# Re-run all checks
mise run type-check && pre-commit run --all-files && mise run test
```

## Quality Gate Integration with TodoWrite

### Mandatory Todo Pattern

For every implementation Todo, include quality verification:

```markdown
1. Implement [feature/fix]
2. Run all quality gates (MyPy, pre-commit, Ruff, Pytest)  
3. Fix any quality gate failures
4. Confirm all quality gates pass
5. Mark Todo as complete
```

### Quality Gate Status Tracking

- **In Progress**: Quality gates not yet run
- **Quality Check**: Currently running quality gates
- **Failed Quality**: Quality gates failed, fixing required
- **Completed**: All quality gates passed successfully

---

**This constitution provides operational and sustainable quality standards for Python development with Claude Code, enabling practical software development.**