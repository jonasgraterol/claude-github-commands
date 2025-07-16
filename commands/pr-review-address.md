# PR Review Comments Resolution

You are automatically addressing code review comments for pull request #$ARGUMENTS. This command fetches review comments, filters out already addressed ones, creates a task list, and implements the necessary changes.

## Overview

This command performs the following workflow:
1. **Fetch PR Review Comments**: Get all review comments and the main review message
2. **Filter Active Comments**: Discard comments that have already been addressed
3. **Create Task List**: Generate actionable tasks from remaining comments
4. **Implement Changes**: Work through tasks systematically
5. **Commit and Push**: Create commits for the changes and push to the PR branch

## Phase 1: Fetch PR Review Data

### Step 1.1: Get PR Review Comments
```bash
# Get all review comments for the PR
gh pr view $ARGUMENTS --json reviews > pr_reviews.json

# Get individual review comments with line-specific details
gh api repos/:owner/:repo/pulls/$ARGUMENTS/comments > pr_comments.json

# Get the PR details for context
gh pr view $ARGUMENTS --json title,body,headRefName,baseRefName,files > pr_details.json
```

### Step 1.2: Parse Review Structure
Extract and organize:
- **Main Review Messages**: Overall feedback from reviewers
- **Inline Comments**: Line-specific comments with file context
- **Comment Status**: Whether comments are resolved or pending
- **Comment Authors**: Who left each comment
- **Comment Timestamps**: When comments were made

## Phase 2: Filter Active Comments

### Step 2.1: Identify Addressed Comments
```bash
# Check if comments have been resolved or have replies
# Look for resolved conversations in the PR
gh api repos/:owner/:repo/pulls/$ARGUMENTS/comments --jq '.[] | select(.in_reply_to_id == null) | {id: .id, body: .body, path: .path, line: .line, resolved: .resolved}'
```

### Step 2.2: Filter Criteria
Remove comments that are:
- **Already Resolved**: Marked as resolved in GitHub
- **Have Author Replies**: Comments where the PR author has responded
- **Outdated**: Comments on lines that have been significantly changed
- **Acknowledgment Only**: Comments that are just acknowledgments or "thanks"

## Phase 3: Create Task List from Comments

### Step 3.1: Categorize Comments
Group comments by:
- **Critical Issues**: Security, bugs, breaking changes
- **Code Quality**: Style, best practices, refactoring
- **Documentation**: Missing or incorrect documentation
- **Testing**: Missing or inadequate tests
- **Performance**: Performance-related suggestions

### Step 3.2: Generate Actionable Tasks
For each remaining comment, create specific tasks:

```markdown
## Tasks from PR Review Comments

### Critical Issues
- [ ] [File:Line] Fix security vulnerability in authentication
- [ ] [File:Line] Correct null pointer exception handling

### Code Quality
- [ ] [File:Line] Refactor duplicate code in utility functions
- [ ] [File:Line] Improve variable naming for clarity

### Documentation
- [ ] [File:Line] Add JSDoc comments for public API
- [ ] [File:Line] Update README with new functionality

### Testing
- [ ] [File:Line] Add unit tests for edge cases
- [ ] [File:Line] Increase test coverage for error handling
```

## Phase 4: Implement Changes

### Step 4.1: Checkout PR Branch
```bash
# Save current state
ORIGINAL_BRANCH=$(git branch --show-current)
git stash push -m "Temp stash for PR review addressing" 2>/dev/null || true

# Checkout the PR branch
gh pr checkout $ARGUMENTS

# Pull latest changes
git pull origin $(git branch --show-current)
```

### Step 4.2: Work Through Tasks Systematically
For each task in priority order:

1. **Read the specific file and line mentioned**
2. **Understand the context of the comment**
3. **Implement the requested change**
4. **Verify the change doesn't break existing functionality**
5. **Run relevant tests if available**

### Step 4.3: Quality Assurance
Before committing each change:
```bash
# Run linting
npm run lint 2>/dev/null || python -m ruff check . 2>/dev/null || echo "No linting configured"

# Run tests
npm test 2>/dev/null || python -m pytest 2>/dev/null || echo "No tests configured"

# Check build
npm run build 2>/dev/null || python -m build 2>/dev/null || echo "No build configured"
```

## Phase 5: Commit and Push Changes

### Step 5.1: Create Focused Commits
Group related changes into logical commits:
```bash
# Stage changes for a specific type of fix
git add [files-related-to-specific-comment]

# Create descriptive commit message
git commit -m "fix: address review comment - [brief description]

- Specific change made
- Impact of the change
- Resolves review comment by @reviewer

Co-authored-by: Claude <noreply@anthropic.com>"
```

### Step 5.2: Push Changes
```bash
# Push changes to the PR branch
git push origin $(git branch --show-current)
```

### Step 5.3: Update PR with Resolution Summary
```bash
# Add a comment to the PR summarizing what was addressed
gh pr comment $ARGUMENTS --body "## Review Comments Addressed

I've processed the review comments and implemented the following changes:

### ✅ Resolved Issues
$(cat addressed_comments.md)

### 🔄 Changes Made
$(git log --oneline -5)

### 🧪 Testing
- All existing tests pass
- New tests added where requested
- Build successful

The PR is now ready for re-review. Please let me know if any additional changes are needed."
```

## Phase 6: Follow-up Actions

### Step 6.1: Mark Comments as Resolved
```bash
# For each addressed comment, mark it as resolved (if using GitHub API)
# This would require comment IDs from the original fetch
```

### Step 6.2: Request Re-review
```bash
# Request re-review from the original reviewers
gh pr review $ARGUMENTS --request-changes --body "Changes have been made to address review comments. Please re-review when convenient."
```

### Step 6.3: Cleanup
```bash
# Switch back to original branch
git checkout $ORIGINAL_BRANCH

# Restore stashed changes
git stash pop 2>/dev/null || true

# Clean up temporary files
rm -f pr_reviews.json pr_comments.json pr_details.json addressed_comments.md 2>/dev/null || true
```

## Advanced Features

### Context-Aware Changes
- **Understand Code Patterns**: Analyze existing code style and patterns
- **Maintain Consistency**: Ensure changes follow project conventions
- **Cross-Reference**: Check how similar issues are handled elsewhere

### Intelligent Filtering
- **Semantic Analysis**: Understand the intent behind comments
- **Duplicate Detection**: Identify similar comments across files
- **Priority Scoring**: Rank comments by impact and urgency

### Automated Testing
- **Test Generation**: Create tests for new functionality when requested
- **Regression Testing**: Ensure changes don't break existing functionality
- **Coverage Analysis**: Verify test coverage meets requirements

## Error Handling

### Common Scenarios
1. **Merge Conflicts**: Handle conflicts when pulling latest changes
2. **Test Failures**: Address test failures caused by changes
3. **Build Issues**: Fix build problems introduced by modifications
4. **Permission Issues**: Handle cases where files cannot be modified

### Recovery Strategies
- **Incremental Changes**: Make smaller, focused changes to reduce risk
- **Rollback Support**: Ability to revert problematic changes
- **Manual Intervention**: Flag complex issues that need human review

## Configuration

Customize behavior through `.claude/settings.toml`:

```toml
[pr_review_address]
# Automatically commit changes
auto_commit = true

# Push changes automatically
auto_push = true

# Request re-review automatically
auto_request_review = true

# Minimum comment age to process (hours)
min_comment_age = 1

# Maximum files to modify in one run
max_files_per_run = 10

# Skip comments from specific users
skip_users = ["bot-user", "automated-reviewer"]

# Priority order for comment types
priority_order = ["security", "bug", "performance", "style", "docs"]
```

## Usage Examples

### Basic Usage
```bash
# Address comments for PR #123
/pr-review-address 123
```

### With Filtering
```bash
# Address only critical comments
/pr-review-address 123 --filter critical

# Address comments from specific reviewer
/pr-review-address 123 --reviewer username
```

## Output Format

The command provides structured output:

```
🔄 Processing PR Review Comments for #123

📥 Fetched Data:
- Main Reviews: 2
- Inline Comments: 15
- Total Comments: 17

🔍 Filtering Comments:
- Already Resolved: 5
- Outdated: 3
- Remaining: 9

📋 Generated Tasks:
- Critical Issues: 2
- Code Quality: 4
- Documentation: 2
- Testing: 1

⚡ Implementing Changes:
✅ Fix security vulnerability in auth.js:45
✅ Refactor duplicate code in utils.js:123
✅ Add JSDoc for public API
... (progress updates)

💾 Committing Changes:
✅ Created 4 commits
✅ Pushed to PR branch
✅ Updated PR with summary

🎯 Summary:
- Comments Addressed: 9/9
- Files Modified: 6
- Tests Added: 2
- Build Status: ✅ Passing

💬 Next Steps:
- Re-review requested from @original-reviewer
- PR updated with resolution summary
- All checks passing
```

## Best Practices

1. **Review Context**: Always read the full comment and surrounding code
2. **Test Changes**: Run tests after each modification
3. **Document Changes**: Update documentation when code behavior changes
4. **Follow Conventions**: Maintain consistency with existing codebase
5. **Communicate**: Provide clear commit messages and PR updates

## Notes

- This command is designed to handle routine review comments automatically
- Complex architectural changes may require manual intervention
- Always verify that automated changes meet the reviewer's intent
- The command preserves the original working state and can be safely interrupted