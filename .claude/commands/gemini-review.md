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
- Open PRs for current branch: !`gh pr list --head "$(git rev-parse --abbrev-ref HEAD)" --json number,title`

## Your task

1. **Find the current PR** for this branch using GitHub CLI
2. **Retrieve Gemini reviews** from the PR using GitHub API
3. **Analyze review comments** for:
   - Bug/Error Detection 🐛
   - Performance Suggestions ⚡
   - Security Concerns 🔒
   - Code Quality 🧹
   - Testing Recommendations 🧪
   - Documentation 📚
   - Best Practices ✨
4. **Implement valid suggestions** by editing the relevant files
5. **Run tests** to ensure changes work correctly
6. **Commit changes** with descriptive messages
7. **Trigger Gemini re-review** by posting "/gemini review" comment

Focus on implementing fixes for HIGH and MEDIUM priority issues first. Use appropriate tools to make precise code changes.
