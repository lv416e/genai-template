# Gemini Review Command

Fetch and analyze Gemini Code Assistant's PR review comments, implement fixes if valid, and trigger re-review.

## Usage

```
/gemini-review
```

## Description

This command will:
1. Find or create a PR from the current branch
2. Retrieve Gemini Code Assistant's review comments
3. Analyze the validity of the review comments
4. Provide guidance for implementing fixes
5. Post "/gemini review" comment to trigger Gemini re-review

## Implementation

```bash
#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🤖 Gemini Review Analysis${NC}"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}❌ Not in a git repository${NC}"
    exit 1
fi

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI (gh) is not installed${NC}"
    echo -e "${YELLOW}💡 Install with: brew install gh${NC}"
    exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo -e "${BLUE}📍 Current branch: ${CURRENT_BRANCH}${NC}"

# Don't allow running on main branch
if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
    echo -e "${RED}❌ Cannot run on main/master branch${NC}"
    echo -e "${YELLOW}💡 Switch to a feature branch first${NC}"
    exit 1
fi

# Check if there's an open PR for current branch
echo -e "${BLUE}🔍 Searching for PR from ${CURRENT_BRANCH}...${NC}"

PR_NUMBER=$(gh pr list --head "$CURRENT_BRANCH" --json number --jq '.[0].number' 2>/dev/null || echo "")

if [ -z "$PR_NUMBER" ] || [ "$PR_NUMBER" = "null" ]; then
    echo -e "${YELLOW}⚠️  No open PR found for branch ${CURRENT_BRANCH}${NC}"
    echo -e "${BLUE}🔧 Would you like to create a PR now? (y/N)${NC}"
    read -r CREATE_PR

    if [ "$CREATE_PR" = "y" ] || [ "$CREATE_PR" = "Y" ]; then
        echo -e "${BLUE}📝 Creating PR...${NC}"

        # Generate PR title based on branch name and commits
        COMMITS_COUNT=$(git rev-list --count HEAD ^main 2>/dev/null || git rev-list --count HEAD ^master 2>/dev/null || echo "1")
        LATEST_COMMIT_MSG=$(git log -1 --pretty=format:'%s')

        # Try to create PR with template
        if gh pr create --web; then
            echo -e "${GREEN}✅ PR creation initiated${NC}"
            echo -e "${YELLOW}💡 Complete PR creation in browser, then run this command again${NC}"
        else
            echo -e "${RED}❌ Failed to create PR${NC}"
        fi
        exit 0
    else
        echo -e "${YELLOW}💡 Create a PR first with: gh pr create${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✅ Found PR #${PR_NUMBER}${NC}"

# Get PR details
PR_TITLE=$(gh pr view "$PR_NUMBER" --json title --jq '.title')
echo -e "${BLUE}📋 PR: ${PR_TITLE}${NC}"

# Fetch all reviews for the PR
echo -e "${BLUE}🔍 Fetching review comments...${NC}"

# Get reviews from Gemini Code Assistant bot
GEMINI_REVIEWS=$(gh api "repos/:owner/:repo/pulls/$PR_NUMBER/reviews" \
    --jq '.[] | select(.user.login == "gemini-code-assist[bot]") | {id: .id, body: .body, state: .state}' 2>/dev/null || echo "")

if [ -z "$GEMINI_REVIEWS" ]; then
    echo -e "${YELLOW}⚠️  No Gemini Code Assistant reviews found${NC}"
    echo -e "${BLUE}💡 Posting '/gemini review' to trigger initial review...${NC}"

    # Post the exact comment to trigger Gemini review
    gh pr comment "$PR_NUMBER" --body "/gemini review"
    echo -e "${GREEN}✅ Posted '/gemini review' comment${NC}"
    exit 0
fi

echo -e "${GREEN}✅ Found Gemini reviews${NC}"

# Parse and display Gemini reviews
echo -e "${BLUE}📝 Gemini Review Comments:${NC}"
echo "$GEMINI_REVIEWS" | jq -r '
    if type == "object" then [.] else . end |
    .[] |
    "---\n🤖 Review ID: \(.id)\n📝 Status: \(.state)\n💬 Comment:\n\(.body)\n"
'

# Get review comments (line-specific comments)
GEMINI_REVIEW_COMMENTS=$(gh api "repos/:owner/:repo/pulls/$PR_NUMBER/comments" \
    --jq '.[] | select(.user.login == "gemini-code-assist[bot]") | {id: .id, body: .body, path: .path, line: .line, diff_hunk: .diff_hunk}' 2>/dev/null || echo "")

if [ -n "$GEMINI_REVIEW_COMMENTS" ]; then
    echo -e "${BLUE}📍 Line-specific comments:${NC}"
    echo "$GEMINI_REVIEW_COMMENTS" | jq -r '
        if type == "object" then [.] else . end |
        .[] |
        "---\n📁 File: \(.path)\n📍 Line: \(.line // "N/A")\n💬 Comment:\n\(.body)\n🔍 Context:\n\(.diff_hunk // "N/A")\n"
    '
fi

# Analyze review validity
echo -e "${BLUE}🧠 Analyzing review validity...${NC}"

VALID_REVIEW=false
REVIEW_CATEGORIES=()

# Check for common valid review patterns in both general reviews and line comments
ALL_REVIEW_TEXT=""
if [ -n "$GEMINI_REVIEWS" ]; then
    ALL_REVIEW_TEXT="$ALL_REVIEW_TEXT $(echo "$GEMINI_REVIEWS" | jq -r 'if type == "object" then [.] else . end | .[] | .body' 2>/dev/null || echo "")"
fi
if [ -n "$GEMINI_REVIEW_COMMENTS" ]; then
    ALL_REVIEW_TEXT="$ALL_REVIEW_TEXT $(echo "$GEMINI_REVIEW_COMMENTS" | jq -r 'if type == "object" then [.] else . end | .[] | .body' 2>/dev/null || echo "")"
fi

# Enhanced pattern matching for Gemini's review style
if echo "$ALL_REVIEW_TEXT" | grep -qi -E "(bug|error|issue|problem|potential issue)"; then
    REVIEW_CATEGORIES+=("🐛 Bug/Error Detection")
    VALID_REVIEW=true
fi

if echo "$ALL_REVIEW_TEXT" | grep -qi -E "(performance|optimization|efficient|slow|memory|cpu)"; then
    REVIEW_CATEGORIES+=("⚡ Performance Suggestions")
    VALID_REVIEW=true
fi

if echo "$ALL_REVIEW_TEXT" | grep -qi -E "(security|vulnerability|sanitize|validate|injection|xss)"; then
    REVIEW_CATEGORIES+=("🔒 Security Concerns")
    VALID_REVIEW=true
fi

if echo "$ALL_REVIEW_TEXT" | grep -qi -E "(maintainability|readability|clean code|refactor|structure)"; then
    REVIEW_CATEGORIES+=("🧹 Code Quality")
    VALID_REVIEW=true
fi

if echo "$ALL_REVIEW_TEXT" | grep -qi -E "(test|testing|coverage|unit test|integration test)"; then
    REVIEW_CATEGORIES+=("🧪 Testing Recommendations")
    VALID_REVIEW=true
fi

if echo "$ALL_REVIEW_TEXT" | grep -qi -E "(documentation|comment|doc|explain|clarify)"; then
    REVIEW_CATEGORIES+=("📚 Documentation")
    VALID_REVIEW=true
fi

if echo "$ALL_REVIEW_TEXT" | grep -qi -E "(best practice|convention|standard|pattern|idiom)"; then
    REVIEW_CATEGORIES+=("✨ Best Practices")
    VALID_REVIEW=true
fi

# Display analysis results
if [ "$VALID_REVIEW" = true ]; then
    echo -e "${GREEN}✅ Review contains valuable feedback${NC}"
    echo -e "${BLUE}📊 Detected categories:${NC}"
    for category in "${REVIEW_CATEGORIES[@]}"; do
        echo "  $category"
    done

    echo -e "${BLUE}📋 Recommended Actions:${NC}"
    echo "1. 📖 Review the specific comments above carefully"
    echo "2. 🔧 Implement fixes for valid suggestions"
    echo "3. 🧪 Run tests to ensure changes work correctly"
    echo "4. 📝 Update documentation if needed"
    echo "5. 💾 Commit changes with descriptive messages"
    echo "6. 🔄 Re-run this command to trigger re-review"

    # Check for high-priority issues
    if echo "$ALL_REVIEW_TEXT" | grep -qi -E "(critical|urgent|security|vulnerability|bug)"; then
        echo -e "${RED}⚠️  HIGH PRIORITY: Review contains critical issues that should be addressed immediately${NC}"
    fi
else
    if [ -z "$ALL_REVIEW_TEXT" ]; then
        echo -e "${YELLOW}ℹ️  No detailed feedback found - likely a positive review${NC}"
    else
        echo -e "${YELLOW}ℹ️  Review appears to be general feedback without specific actionable items${NC}"
    fi
fi

# Ask if user wants to trigger re-review
echo -e "${BLUE}🤔 Do you want to trigger Gemini re-review now? (y/N)${NC}"
read -r TRIGGER_REVIEW

if [ "$TRIGGER_REVIEW" = "y" ] || [ "$TRIGGER_REVIEW" = "Y" ]; then
    echo -e "${BLUE}💬 Posting '/gemini review' to trigger re-review...${NC}"

    # Post the exact comment to trigger Gemini re-review
    gh pr comment "$PR_NUMBER" --body "/gemini review"
    echo -e "${GREEN}✅ Posted '/gemini review' comment - Gemini will re-review the PR${NC}"
else
    echo -e "${BLUE}💡 To trigger re-review later, run: gh pr comment ${PR_NUMBER} --body '/gemini review'${NC}"
fi

echo -e "${GREEN}✅ Gemini review analysis complete${NC}"
```

## Prerequisites

- GitHub CLI (`gh`) must be installed and authenticated
- Must be run from within a git repository
- Current branch must have an open PR

## Notes

- Posts exactly "/gemini review" (no additional characters) to trigger Gemini re-review
- Analyzes review comments for constructive feedback patterns
- Provides guidance for implementing fixes
- Safe to run multiple times
