# Claude GitHub Commands - Practical Examples

This document provides real-world examples and patterns for using Claude GitHub Commands effectively in various development scenarios.

## Table of Contents

1. [Basic Workflows](#basic-workflows)
2. [Team Collaboration](#team-collaboration)
3. [Project Maintenance](#project-maintenance)
4. [Advanced Patterns](#advanced-patterns)
5. [Integration Examples](#integration-examples)
6. [Troubleshooting Scenarios](#troubleshooting-scenarios)

## Basic Workflows

### Example 1: New Feature Development

**Scenario**: Implementing a user authentication feature for a React application.

```bash
# Step 1: Check available issues
/issues --type feature

# Output:
# ✨ Feature Requests
# - #123 User authentication system (unassigned)
# - #124 Dark mode support (assigned: @alice)
# - #125 Advanced search filters (assigned: @bob)

# Step 2: Start working on authentication feature
/issue 123

# Output:
# 🔍 Fetching issue #123 details...
# ✅ Issue: "User authentication system"
# 📋 Type: feature
# 🌿 Creating branch: feature/issue-123-user-authentication
# ✅ Branch created and pushed
# 📝 Initial commit created with issue reference
# 💡 Ready for development!

# Step 3: Implement the feature (manual coding)
# ... write authentication components ...
# ... add form validation ...
# ... create API integration ...

# Step 4: Commit changes progressively
/commit "implement login form component"

# Output:
# 📝 Processing commit with message: 'implement login form component'
# 🔍 Analyzing staged changes for type detection...
# 📊 Found 3 staged file(s):
#   - src/components/LoginForm.jsx
#   - src/components/LoginForm.test.jsx
#   - src/styles/LoginForm.css
# 🎯 Detected commit type: feat
# 📝 Formatted header: feat: implement login form component
# ✅ Commit created successfully: a1b2c3d

/commit "add authentication API service"
/commit "implement password validation logic"
/commit "add comprehensive test coverage"

# Step 5: Complete development and create PR
/workflow 123

# This will guide through final quality checks and PR creation
```

### Example 2: Bug Fix Workflow

**Scenario**: Fixing a critical login validation bug.

```bash
# Step 1: Identify the bug from issue reports
/issues --priority high --type bug

# Output:
# 🚨 Critical Issues (P0)
# - #456 Login validation allows empty passwords (assigned: @me)
# 
# 🔴 High Priority Issues (P1)
# - #457 Dashboard loading slowly (unassigned)

# Step 2: Create hotfix branch directly
/branch hotfix/issue-456-login-validation

# Output:
# 🌿 Creating branch: hotfix/issue-456-login-validation
# 🔍 Performing pre-creation checks...
# ✅ Git repository validated
# ✅ Branch name is available
# 🔄 Updating main...
# ✅ main updated
# ✅ Branch created successfully
# 📝 Creating initial commit...
# ✅ Initial commit created
# 🚀 Pushing branch to remote...
# ✅ Branch pushed to remote successfully

# Step 3: Fix the validation logic
# ... modify validation functions ...
# ... add edge case handling ...

# Step 4: Commit the fix
/commit "fix empty password validation bug"

# Output:
# 📝 Processing commit with message: 'fix empty password validation bug'
# 🔍 Analyzing staged changes for type detection...
# 🎯 Detected commit type: fix
# 📝 Formatted header: fix: empty password validation bug
# ✅ Pre-commit checks passed
# ✅ Commit created successfully: d4e5f6g

# Step 5: Add regression test
/commit "add regression test for password validation"

# Step 6: Create urgent PR
gh pr create --title "hotfix: resolve login validation vulnerability" --body "Fixes #456

## Problem
Empty passwords were being accepted during login validation.

## Solution
- Added strict validation for empty/whitespace passwords
- Implemented proper error messaging
- Added comprehensive regression tests

## Testing
- All existing tests pass
- New regression tests added
- Manual testing completed

## Impact
- Resolves security vulnerability
- No breaking changes
- Ready for immediate deployment"
```

### Example 3: Documentation Update

**Scenario**: Updating API documentation after feature changes.

```bash
# Step 1: Create documentation branch
/branch docs/api-authentication-update

# Step 2: Update documentation files
# ... edit README.md ...
# ... update API.md ...
# ... create new examples ...

# Step 3: Commit documentation changes
/commit "update API documentation for authentication"

# Output:
# 📝 Processing commit with message: 'update API documentation for authentication'
# 🔍 Analyzing staged changes for type detection...
# 📊 Found 4 staged file(s):
#   - README.md
#   - docs/API.md
#   - docs/examples/auth-example.js
#   - CHANGELOG.md
# 🔍 Change patterns detected: documentation
# 🎯 Detected commit type: docs
# 📝 Formatted header: docs: update API documentation for authentication

/commit "add authentication flow diagrams"
/commit "include code examples for OAuth integration"

# Step 4: Create documentation PR
gh pr create --title "docs: update authentication API documentation" --body "Updates documentation for the new authentication system (#123)

## Changes
- Updated API endpoint documentation
- Added authentication flow diagrams  
- Included OAuth integration examples
- Updated README with new setup instructions

## Related
- Closes #125 (documentation update request)
- Related to #123 (authentication feature)"
```

## Team Collaboration

### Example 4: Code Review Process

**Scenario**: Reviewing a team member's pull request.

```bash
# Step 1: Check pending PRs for review
gh pr list --assignee @me

# Output:
# #789  feat: implement user dashboard  alice:feature/user-dashboard

# Step 2: Perform comprehensive review
/pr-review 789

# Output:
# 🔍 PR Review Complete for #789
# 
# 📊 Review Statistics:
# - Files Reviewed: 12
# - Tests Run: 45
# - Issues Found: 3
# - Recommendation: REQUEST_CHANGES
# 
# 🎯 Key Findings:
# - Missing error handling in API calls
# - Test coverage below threshold (72%)
# - Security concern: user input not sanitized
# 
# 📋 Action Items:
# - Add try-catch blocks for async operations
# - Increase test coverage to >80%
# - Implement input validation/sanitization
# 
# ✅ Review submitted successfully!

# Step 3: Follow up after changes
# (After Alice addresses feedback)
/pr-review 789

# Output:
# 🔍 PR Review Complete for #789
# 
# 📊 Review Statistics:
# - Files Reviewed: 12
# - Tests Run: 52
# - Issues Found: 0
# - Recommendation: APPROVE
# 
# 🎯 Key Findings:
# - All previous issues addressed
# - Test coverage increased to 85%
# - Security concerns resolved
# 
# ✅ Review submitted successfully!
```

### Example 5: Sprint Planning with Issue Analysis

**Scenario**: Planning next sprint by analyzing available issues.

```bash
# Step 1: Get comprehensive issue overview
/issues

# Output:
# 📊 Issue Statistics
# Total Issues: 28
# Open Issues: 23
# 
# By Priority:
# - Critical: 1 issues
# - High: 4 issues  
# - Medium: 12 issues
# - Low: 6 issues
# 
# By Type:
# - Bugs: 8 issues
# - Features: 10 issues
# - Improvements: 3 issues
# - Documentation: 2 issues
# 
# 💡 Recommendations
# 
# ### Immediate Actions Needed:
# 1. **Critical Issues**: 1 issue needs immediate attention
# 2. **Stale Issues**: 3 issues need triage or closure
# 
# ### Sprint Planning Suggestions:
# 1. **High-Impact Quick Wins**: #234, #235, #236
# 2. **Technical Debt**: #237, #238
# 3. **User-Facing Improvements**: #239, #240

# Step 2: Filter for specific sprint focus
/issues --priority high --assignee ""

# Output:
# 🔴 High Priority Issues (P1)
# - #234 Optimize database queries (unassigned) [quick-win]
# - #235 Add loading states to forms (unassigned) [ui/ux]
# - #236 Implement caching layer (unassigned) [performance]
# - #237 Refactor authentication module (unassigned) [technical-debt]

# Step 3: Start sprint work
/issue 234  # Begin with quick win
```

## Project Maintenance

### Example 6: Regular Maintenance Workflow

**Scenario**: Weekly project maintenance and cleanup.

```bash
# Step 1: Set up environment and check health
/setup

# Output:
# 🔍 Analyzing project structure...
# ✅ Node.js project detected
# ✅ Dependencies up to date
# ⚠️  Found 2 security vulnerabilities
# ✅ Pre-commit hooks working correctly
# 
# 🏥 Running health checks...
# ✅ All tests passing
# ✅ Build successful
# ⚠️  Code coverage: 78% (below 80% threshold)

# Step 2: Address security vulnerabilities
npm audit fix

/commit "chore: fix security vulnerabilities in dependencies"

# Step 3: Update dependencies
npm update

/commit "chore: update project dependencies"

# Step 4: Clean up stale branches
git branch -r --merged | grep -v main | grep -v HEAD | xargs -n 1 git push --delete origin

/commit "chore: clean up merged remote branches"

# Step 5: Update documentation
# ... update CHANGELOG.md ...
# ... refresh README if needed ...

/commit "docs: update changelog and project documentation"

# Step 6: Check for outdated issues
/issues --state all | grep "last updated > 30 days"

# Close stale issues or update them
```

### Example 7: Release Preparation

**Scenario**: Preparing for a new version release.

```bash
# Step 1: Create release branch
/branch release/v2.1.0

# Step 2: Update version numbers
# ... edit package.json version ...
# ... update version constants ...

/commit "chore: bump version to 2.1.0"

# Step 3: Update changelog
# ... compile changes since last release ...

/commit "docs: update changelog for v2.1.0 release"

# Step 4: Run comprehensive tests
npm run test:ci
npm run test:e2e
npm run build

# Step 5: Create release PR
gh pr create --title "release: prepare v2.1.0" --body "Release preparation for version 2.1.0

## Changes in this release
- New authentication system (#123)
- Performance improvements (#234, #236)
- Bug fixes (#456, #457)
- Documentation updates

## Testing
- All unit tests pass
- Integration tests pass
- E2E tests pass
- Manual testing completed

## Checklist
- [x] Version numbers updated
- [x] Changelog updated
- [x] All tests passing
- [x] Documentation current
- [ ] Security review completed
- [ ] Performance testing completed"

# Step 6: Final review before merge
/pr-review [release-pr-number]
```

## Advanced Patterns

### Example 8: Multi-Repository Workflow

**Scenario**: Working across frontend and backend repositories.

```bash
# In frontend repository
/issue 123  # "Add user profile API integration"

# Create frontend changes
/commit "feat: add user profile API client"
/commit "feat: implement profile editing UI"

# Switch to backend repository
cd ../backend-repo

/branch feature/user-profile-api

# Implement backend changes
/commit "feat: add user profile API endpoints"
/commit "feat: add profile validation middleware"
/commit "test: add comprehensive API tests"

# Create linked PRs
# Frontend PR
cd ../frontend-repo
gh pr create --title "feat: user profile management UI" --body "Frontend implementation for user profile management.

Depends on: backend-repo#456
Related: #123"

# Backend PR  
cd ../backend-repo
gh pr create --title "feat: user profile API" --body "Backend API for user profile management.

Required by: frontend-repo#789
Related: frontend-repo#123"
```

### Example 9: Feature Flag Development

**Scenario**: Implementing a feature behind a feature flag.

```bash
# Step 1: Create feature branch
/branch feature/new-dashboard-with-flag

# Step 2: Implement feature with flag
/commit "feat: add new dashboard component (behind feature flag)"

# Step 3: Add feature flag configuration
/commit "feat: add dashboard feature flag configuration"

# Step 4: Add gradual rollout logic
/commit "feat: implement gradual rollout for new dashboard"

# Step 5: Add monitoring and metrics
/commit "feat: add analytics for new dashboard feature"

# Step 6: Create comprehensive PR
gh pr create --title "feat: new dashboard with feature flag rollout" --body "Implements new dashboard behind feature flag for gradual rollout.

## Feature Flag
- Flag name: `new_dashboard_enabled`
- Default: disabled
- Rollout plan: 5% → 25% → 50% → 100%

## Implementation
- New dashboard components
- Feature flag integration
- Gradual rollout mechanism
- Analytics and monitoring

## Testing
- Feature works when flag enabled
- Graceful fallback when flag disabled
- A/B testing metrics implemented

## Rollout Plan
1. Deploy with flag disabled
2. Enable for 5% of users
3. Monitor metrics for 48 hours
4. Gradually increase rollout
5. Full rollout after validation"
```

### Example 10: Emergency Hotfix Process

**Scenario**: Critical production issue requiring immediate fix.

```bash
# Step 1: Create emergency hotfix
/branch hotfix/critical-data-leak

# Step 2: Implement urgent fix
# ... fix the security vulnerability ...

/commit "fix: resolve critical data exposure vulnerability"

# Step 3: Add immediate test
/commit "test: add regression test for data exposure fix"

# Step 4: Create emergency PR
gh pr create --title "🚨 URGENT: fix critical data exposure" --body "🚨 **CRITICAL SECURITY FIX** 🚨

## Issue
Critical data exposure vulnerability allowing unauthorized access to user data.

## Fix
- Implement proper authorization checks
- Add data sanitization
- Close security loophole

## Testing
- Manual security testing completed
- Regression test added
- No breaking changes

## Deployment
- Ready for immediate deployment
- Hotfix can be deployed independently
- Monitoring plan in place

CC: @security-team @team-lead"

# Step 5: Fast-track review
/pr-review [hotfix-pr-number]

# Step 6: Coordinate deployment
# ... work with DevOps for immediate deployment ...
```

## Integration Examples

### Example 11: CI/CD Integration

**Scenario**: Integrating commands with GitHub Actions.

```yaml
# .github/workflows/claude-commands.yml
name: Claude Commands Workflow
on:
  pull_request:
    branches: [main]

jobs:
  automated-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Claude Commands
        run: |
          git submodule update --init --recursive
          cd .claude-commands && ./install.sh
      
      - name: Run Automated Review
        run: |
          # This would be adapted to work in CI environment
          echo "Running quality checks..."
          npm run lint
          npm test
          npm run build
      
      - name: Comment on PR
        uses: actions/github-script@v6
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '✅ Claude Commands automated review completed successfully!'
            })
```

### Example 12: Slack Integration

**Scenario**: Notifications to Slack when using commands.

```bash
# Custom hook for Slack notifications
# In hooks/slack-notifications.toml

[hooks.slack-notify-pr]
description = "Notify Slack when PR is created"
trigger = "after_pr_create"
command = """
PR_NUMBER="$1"
PR_TITLE=$(gh pr view "$PR_NUMBER" --json title -q .title)
AUTHOR=$(gh pr view "$PR_NUMBER" --json author -q .author.login)

curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"🚀 New PR created by $AUTHOR: $PR_TITLE\\n<$(gh pr view "$PR_NUMBER" --json url -q .url)|View PR #$PR_NUMBER>\"}" \
  $SLACK_WEBHOOK_URL
"""
```

### Example 13: JIRA Integration

**Scenario**: Syncing with JIRA issues.

```bash
# Enhanced issue command with JIRA sync
# This would be a custom extension

/issue 123

# Output includes JIRA sync:
# 🔍 Fetching GitHub issue #123...
# 🔄 Syncing with JIRA ticket DEV-456...
# ✅ Issue: "User authentication system"
# 📋 JIRA Status: In Progress
# 🌿 Creating branch: feature/DEV-456-user-authentication
# 🔗 Branch linked to JIRA ticket
```

## Troubleshooting Scenarios

### Example 14: Handling Merge Conflicts

**Scenario**: Resolving conflicts during branch operations.

```bash
# Attempting to update branch
git pull origin main

# Output:
# Auto-merging src/auth.js
# CONFLICT (content): Merge conflict in src/auth.js
# Automatic merge failed; fix conflicts and then commit the result.

# Resolve conflicts manually
# ... edit conflicted files ...

# Commit resolution
/commit "resolve merge conflicts in authentication module"

# Output:
# 📝 Processing commit with message: 'resolve merge conflicts in authentication module'
# 🔍 Analyzing staged changes for type detection...
# 🎯 Detected commit type: fix
# 📝 Formatted header: fix: resolve merge conflicts in authentication module
# ✅ Commit created successfully
```

### Example 15: Failed Quality Checks

**Scenario**: Handling failed pre-commit hooks.

```bash
# Attempting to commit
/commit "add new feature implementation"

# Output:
# 🪝 Running pre-commit checks...
# ❌ ESLint failed: 3 errors found
# ❌ Tests failed: 2 test failures
# 
# 🔧 Issues to fix:
# - Linting errors in src/newFeature.js
# - Test failures in auth.test.js
# 
# 💡 Suggestions:
# 1. Fix linting: npm run lint:fix
# 2. Fix tests: npm test -- --verbose
# 3. Then retry commit

# Fix the issues
npm run lint:fix
# ... fix test failures ...

# Retry commit
/commit "add new feature implementation"

# Output:
# ✅ Pre-commit hooks passed
# ✅ Commit created successfully: a1b2c3d
```

### Example 16: Network Issues During Operations

**Scenario**: Handling connectivity problems.

```bash
# Attempting GitHub operation
/issue 123

# Output:
# ❌ Network error: Unable to connect to GitHub API
# 
# 🔄 Fallback options:
# 1. Work offline with manual issue details
# 2. Retry when connection restored
# 3. Use cached issue data if available
# 
# 💡 Manual workflow:
# 1. Create branch: git checkout -b feature/issue-123-description
# 2. Work on implementation
# 3. Commit locally: git commit -m "feat: description"
# 4. Push when connection restored: git push -u origin branch-name

# Working offline
git checkout -b feature/issue-123-user-auth
# ... implement feature ...
git add .
git commit -m "feat: implement user authentication system"

# When connection restored
git push -u origin feature/issue-123-user-auth
gh pr create --title "feat: user authentication system" --body "Implements authentication feature for issue #123"
```

These examples demonstrate real-world usage patterns and show how Claude GitHub Commands integrate into various development workflows. Each example includes expected outputs and shows how to handle both success and failure scenarios.