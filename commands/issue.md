# GitHub Issue Workflow

You are helping the user work on a specific GitHub issue. Follow this comprehensive workflow to automate the entire development process from issue analysis to branch creation.

## Task Overview

Work on GitHub issue #$ARGUMENTS by:
1. Fetching and analyzing issue details
2. Creating an appropriately named branch
3. Setting up development environment
4. Providing structured guidance for implementation

## Step 1: Fetch Issue Information

First, get the issue details using GitHub CLI:

```bash
gh issue view $ARGUMENTS --json title,body,labels,assignees,milestone,state
```

Parse the response to understand:
- Issue title and description
- Labels (bug, feature, enhancement, etc.)
- Priority level
- Current assignees
- Associated milestone

## Step 2: Determine Branch Type and Name

Based on the issue analysis:

**For Bug Issues:**
- Branch pattern: `fix/issue-$ARGUMENTS-brief-description`
- Example: `fix/issue-123-login-error`

**For Feature Issues:**
- Branch pattern: `feature/issue-$ARGUMENTS-brief-description`
- Example: `feature/issue-456-user-dashboard`

**For Enhancement Issues:**
- Branch pattern: `enhancement/issue-$ARGUMENTS-brief-description`
- Example: `enhancement/issue-789-improve-performance`

**For Documentation Issues:**
- Branch pattern: `docs/issue-$ARGUMENTS-brief-description`
- Example: `docs/issue-101-api-documentation`

Create a clean, kebab-case branch name from the issue title (max 50 characters).

## Step 3: Pre-Branch Checks

Before creating the branch, verify:

```bash
# Check current git status
git status

# Ensure we're on main/master branch
git branch --show-current

# Pull latest changes
git pull origin main

# Check for any uncommitted changes
git diff --staged
```

If there are uncommitted changes, prompt the user to commit or stash them.

## Step 4: Create and Switch to Branch

```bash
# Create and switch to the new branch
git checkout -b [BRANCH_NAME]

# Push branch to remote and set upstream
git push -u origin [BRANCH_NAME]
```

## Step 5: Environment Setup

Detect project type and run appropriate setup:

**For Node.js projects:**
```bash
# Install dependencies if needed
npm install

# Run any setup scripts
npm run setup 2>/dev/null || true
```

**For Python projects:**
```bash
# Create virtual environment if it doesn't exist
python -m venv venv 2>/dev/null || true

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt 2>/dev/null || true
```

**For any project:**
```bash
# Check for pre-commit hooks
pre-commit install 2>/dev/null || true
```

## Step 6: Create Issue-Linked Commit

Create an initial commit that links to the issue:

```bash
git commit --allow-empty -m "Start work on issue #$ARGUMENTS

Refs: #$ARGUMENTS"
```

## Step 7: Provide Implementation Guidance

Based on the issue type and project structure, provide specific guidance:

1. **Code Analysis**: Identify relevant files and components
2. **Implementation Strategy**: Break down the work into manageable tasks
3. **Testing Approach**: Suggest test cases and validation methods
4. **Quality Checks**: List required linting, testing, and build steps

## Step 8: Development Workflow Preparation

Prepare the development environment:

1. **File Exploration**: Use search tools to understand existing codebase structure
2. **Dependency Check**: Verify all required tools and dependencies are available
3. **Test Setup**: Ensure testing framework is configured and runnable
4. **Documentation**: Check if any documentation updates will be needed

## Step 9: Create Development Tasks

Create a structured todo list for the user:

1. [ ] Implement core functionality for issue #$ARGUMENTS
2. [ ] Add appropriate tests
3. [ ] Update documentation if needed
4. [ ] Run quality checks (lint, test, build)
5. [ ] Create pull request

## Step 10: Quality Verification

Before proceeding with development, ensure:

```bash
# Run linting (adjust command based on project type)
npm run lint 2>/dev/null || python -m ruff check . 2>/dev/null || echo "No linting configured"

# Run tests to ensure baseline is working
npm test 2>/dev/null || python -m pytest 2>/dev/null || echo "No tests configured"

# Run build if applicable
npm run build 2>/dev/null || echo "No build step configured"
```

## Success Confirmation

Confirm the workflow completion:

✅ Issue #$ARGUMENTS details fetched and analyzed
✅ Branch `[BRANCH_NAME]` created and pushed
✅ Development environment prepared
✅ Initial commit created with issue reference
✅ Implementation guidance provided

## Next Steps

The user can now:
1. Follow the provided implementation guidance
2. Use `/commit` command for conventional commits
3. Use `/pr-review` command when ready for code review
4. Use `/workflow` command for complete automation

## Error Handling

If any step fails:
1. Provide clear error message with suggested resolution
2. Check for common issues (authentication, network, permissions)
3. Offer manual alternatives for automated steps
4. Ensure user can continue with manual workflow if needed

## Notes

- Always verify GitHub CLI authentication before starting
- Respect existing git workflow and branch protection rules
- Preserve any existing work-in-progress
- Follow project-specific conventions and standards