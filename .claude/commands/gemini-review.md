---
allowed-tools: Bash(gh api:*), Bash(gh pr list:*), Bash(gh pr view:*), Bash(gh pr comment:*), Bash(git rev-parse:*), Bash(git status:*), Bash(git diff:*), Bash(git commit:*), Bash(git push:*)
argument-hint:
description: Analyze Gemini Code Assistant's PR review comments and implement fixes
model: claude-opus-4-20250805
---

# Gemini Review Analysis and Implementation

Find or create a PR from the current branch, retrieve Gemini Code Assistant's review comments, analyze their validity, provide guidance for implementing fixes, and trigger re-review.

- think harder!
- use web search
- use context7
- use ultrathink
- use sequential-thinking
- use serena
- use @modelcontextprotocol/server-memory

## Context Information

- Current branch: !`git rev-parse --abbrev-ref HEAD`
- Current git status: !`git status --porcelain`
- Open PRs for current branch: Use GitHub CLI to find PRs for the current branch

## Your task

1. **Find the current PR** for this branch using GitHub CLI
2. **Retrieve Gemini reviews** from the PR using GitHub API and filter out resolved comments
   - Filter comments with `**[RESOLVED]**` in the body text
   - Only process unresolved review comments from gemini-code-assist[bot]
3. **Analyze review comments** and categorize by priority:
   - **CRITICAL** 🔴: Security vulnerabilities, runtime errors, data corruption
   - **HIGH** 🟠: Performance issues, significant bugs, architectural problems
   - **MEDIUM** 🟡: Code quality, testing gaps, maintainability issues
   - **LOW** 🟢: Style preferences, minor optimizations, documentation

   Categories:
   - Bug/Error Detection 🐛
   - Performance Suggestions ⚡
   - Security Concerns 🔒
   - Code Quality 🧹
   - Testing Recommendations 🧪
   - Documentation 📚
   - Best Practices ✨
4. **Implement suggestions in priority order** (CRITICAL → HIGH → MEDIUM → LOW)
5. **Run tests** to ensure changes work correctly
6. **Commit and push changes** with descriptive messages
7. **Mark comments as resolved** by updating comment body to include `**[RESOLVED]**` marker
8. **Trigger Gemini re-review** by posting **only** "/gemini review" comment

## Priority Implementation Strategy
1. **CRITICAL** 🔴: Fix immediately, block all other work if necessary
2. **HIGH** 🟠: Address before proceeding to lower priorities
3. **MEDIUM** 🟡: Implement systematically after high-priority items
4. **LOW** 🟢: Address if time permits, or create follow-up issues

Use appropriate tools to make precise code changes. Group commits by priority level when possible.
