# Smart Branch Management

You are creating and managing Git branches with intelligent naming conventions and pre-creation checks. This command ensures consistent branch naming and validates the environment before branch creation.

## Command Usage

The branch command supports various arguments:
- `/branch feature/new-dashboard` - Create a feature branch
- `/branch fix/login-bug` - Create a bug fix branch
- `/branch docs/api-documentation` - Create a documentation branch
- `/branch hotfix/critical-security` - Create a hotfix branch
- `/branch` - Interactive branch creation with guidance

Arguments: $ARGUMENTS

## Phase 1: Branch Name Analysis and Validation

### Step 1.1: Parse Branch Arguments
```bash
# Extract branch name from arguments
BRANCH_NAME="$ARGUMENTS"

# If no arguments provided, enter interactive mode
if [[ -z "$BRANCH_NAME" ]]; then
    echo "🌿 Interactive Branch Creation Mode"
    echo "Please provide branch name or let me help you create one"
    INTERACTIVE_MODE=true
else
    INTERACTIVE_MODE=false
    echo "🌿 Creating branch: $BRANCH_NAME"
fi
```

### Step 1.2: Detect Branch Type
Analyze the branch name to determine type and validate naming:

```bash
# Detect branch type from name or content
detect_branch_type() {
    local branch_name="$1"
    
    case "$branch_name" in
        feature/*)
            echo "feature"
            ;;
        fix/*|bugfix/*)
            echo "fix"
            ;;
        hotfix/*)
            echo "hotfix"
            ;;
        docs/*|doc/*|documentation/*)
            echo "docs"
            ;;
        chore/*|maintenance/*)
            echo "chore"
            ;;
        refactor/*|refactoring/*)
            echo "refactor"
            ;;
        test/*|testing/*)
            echo "test"
            ;;
        *)
            # Auto-detect based on keywords
            if echo "$branch_name" | grep -qi "fix\|bug\|patch"; then
                echo "fix"
            elif echo "$branch_name" | grep -qi "feat\|feature\|add"; then
                echo "feature"
            elif echo "$branch_name" | grep -qi "doc\|readme\|guide"; then
                echo "docs"
            else
                echo "feature"  # Default to feature
            fi
            ;;
    esac
}

BRANCH_TYPE=$(detect_branch_type "$BRANCH_NAME")
echo "📋 Detected branch type: $BRANCH_TYPE"
```

### Step 1.3: Validate Branch Name Format
```bash
validate_branch_name() {
    local name="$1"
    local errors=()
    
    # Check for valid characters (alphanumeric, dash, underscore, slash)
    if [[ ! "$name" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
        errors+=("Branch name contains invalid characters")
    fi
    
    # Check length (max 50 characters for readability)
    if [[ ${#name} -gt 50 ]]; then
        errors+=("Branch name too long (max 50 characters)")
    fi
    
    # Check for proper format (type/description)
    if [[ ! "$name" =~ ^[a-z]+/[a-z0-9-]+$ ]] && [[ "$name" != */* ]]; then
        errors+=("Branch name should follow format: type/description")
    fi
    
    # Check for consecutive dashes or underscores
    if [[ "$name" =~ (--|__) ]]; then
        errors+=("Avoid consecutive dashes or underscores")
    fi
    
    # Return validation results
    if [[ ${#errors[@]} -eq 0 ]]; then
        echo "✅ Branch name validation passed"
        return 0
    else
        echo "❌ Branch name validation failed:"
        for error in "${errors[@]}"; do
            echo "  - $error"
        done
        return 1
    fi
}

# Validate the branch name
if ! validate_branch_name "$BRANCH_NAME"; then
    if [[ "$INTERACTIVE_MODE" == "true" ]]; then
        echo "💡 Let me help you create a proper branch name"
        # Interactive name creation will be handled later
    else
        echo "🔧 Suggested fixes:"
        echo "  - Use lowercase letters, numbers, dashes, and slashes only"
        echo "  - Format: type/brief-description"
        echo "  - Types: feature, fix, docs, chore, refactor, test, hotfix"
        echo "  - Example: feature/user-authentication"
        exit 1
    fi
fi
```

## Phase 2: Interactive Branch Creation (if needed)

### Step 2.1: Gather Branch Information
```bash
if [[ "$INTERACTIVE_MODE" == "true" ]] || [[ -z "$BRANCH_NAME" ]]; then
    echo "🤖 Let's create a branch together!"
    echo ""
    echo "Branch types available:"
    echo "  🆕 feature  - New features or enhancements"
    echo "  🐛 fix      - Bug fixes"
    echo "  📚 docs     - Documentation changes"
    echo "  🔧 chore    - Maintenance tasks"
    echo "  ♻️  refactor - Code refactoring"
    echo "  🧪 test     - Testing improvements"
    echo "  🚨 hotfix   - Critical production fixes"
    echo ""
    
    # In a real implementation, this would prompt the user
    # For this template, we'll show the process
    
    read -p "Select branch type (feature/fix/docs/chore/refactor/test/hotfix): " SELECTED_TYPE
    read -p "Brief description (kebab-case): " DESCRIPTION
    
    # Clean up description
    CLEAN_DESCRIPTION=$(echo "$DESCRIPTION" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    
    BRANCH_NAME="$SELECTED_TYPE/$CLEAN_DESCRIPTION"
    echo "📝 Generated branch name: $BRANCH_NAME"
fi
```

### Step 2.2: Link to GitHub Issue (Optional)
```bash
# Check if branch is related to a GitHub issue
echo "🔗 Checking for related GitHub issues..."

# Extract issue number from branch name if present
ISSUE_NUMBER=$(echo "$BRANCH_NAME" | grep -o 'issue-[0-9]\+' | grep -o '[0-9]\+')

if [[ -n "$ISSUE_NUMBER" ]]; then
    echo "📋 Found issue reference: #$ISSUE_NUMBER"
    
    # Verify issue exists
    if gh issue view "$ISSUE_NUMBER" &> /dev/null; then
        echo "✅ Issue #$ISSUE_NUMBER exists"
        LINKED_ISSUE="$ISSUE_NUMBER"
    else
        echo "❌ Issue #$ISSUE_NUMBER not found"
        LINKED_ISSUE=""
    fi
else
    # Ask if branch should be linked to an issue
    echo "💡 Consider linking this branch to a GitHub issue for better tracking"
    echo "   Example: feature/issue-123-user-dashboard"
    LINKED_ISSUE=""
fi
```

## Phase 3: Pre-Creation Environment Checks

### Step 3.1: Git Repository Validation
```bash
echo "🔍 Performing pre-creation checks..."

# Check if we're in a git repository
if ! git rev-parse --git-dir &> /dev/null; then
    echo "❌ Not in a Git repository"
    echo "💡 Initialize with: git init"
    exit 1
fi

# Check if repository has remotes
if ! git remote | grep -q "origin"; then
    echo "⚠️  No 'origin' remote found"
    echo "💡 Add remote with: git remote add origin <repository-url>"
fi

echo "✅ Git repository validated"
```

### Step 3.2: Working Directory Status
```bash
# Check for uncommitted changes
if ! git diff --quiet; then
    echo "⚠️  Uncommitted changes detected:"
    git status --porcelain
    echo ""
    echo "Options:"
    echo "  1. Commit changes: git add . && git commit -m 'commit message'"
    echo "  2. Stash changes: git stash push -m 'temporary stash'"
    echo "  3. Continue anyway (not recommended)"
    echo ""
    read -p "How would you like to proceed? (commit/stash/continue): " CHOICE
    
    case "$CHOICE" in
        "commit")
            echo "📝 Please commit your changes first, then re-run the branch command"
            exit 1
            ;;
        "stash")
            git stash push -m "Temporary stash before creating branch $BRANCH_NAME"
            echo "✅ Changes stashed"
            ;;
        "continue")
            echo "⚠️  Continuing with uncommitted changes"
            ;;
        *)
            echo "❌ Invalid choice. Exiting."
            exit 1
            ;;
    esac
fi
```

### Step 3.3: Branch Existence Check
```bash
# Check if branch already exists locally
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    echo "❌ Branch '$BRANCH_NAME' already exists locally"
    echo "💡 Use: git checkout $BRANCH_NAME (to switch to existing branch)"
    echo "💡 Or choose a different branch name"
    exit 1
fi

# Check if branch exists on remote
if git ls-remote --heads origin "$BRANCH_NAME" | grep -q "$BRANCH_NAME"; then
    echo "❌ Branch '$BRANCH_NAME' already exists on remote"
    echo "💡 Use: git checkout -b $BRANCH_NAME origin/$BRANCH_NAME"
    exit 1
fi

echo "✅ Branch name is available"
```

### Step 3.4: Base Branch Validation
```bash
# Ensure we're on the correct base branch (usually main/master)
CURRENT_BRANCH=$(git branch --show-current)
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")

echo "📍 Current branch: $CURRENT_BRANCH"
echo "📍 Default branch: $DEFAULT_BRANCH"

if [[ "$CURRENT_BRANCH" != "$DEFAULT_BRANCH" ]]; then
    echo "⚠️  Not on default branch ($DEFAULT_BRANCH)"
    echo "💡 Recommended: Switch to $DEFAULT_BRANCH before creating feature branch"
    echo ""
    read -p "Switch to $DEFAULT_BRANCH first? (y/n): " SWITCH_BRANCH
    
    if [[ "$SWITCH_BRANCH" =~ ^[Yy] ]]; then
        git checkout "$DEFAULT_BRANCH"
        git pull origin "$DEFAULT_BRANCH"
        echo "✅ Switched to $DEFAULT_BRANCH and updated"
    else
        echo "⚠️  Creating branch from $CURRENT_BRANCH"
    fi
else
    # Update default branch
    echo "🔄 Updating $DEFAULT_BRANCH..."
    git pull origin "$DEFAULT_BRANCH"
    echo "✅ $DEFAULT_BRANCH updated"
fi
```

## Phase 4: Branch Creation and Setup

### Step 4.1: Create Branch
```bash
echo "🌿 Creating branch: $BRANCH_NAME"

# Create and switch to the new branch
if git checkout -b "$BRANCH_NAME"; then
    echo "✅ Branch created successfully"
else
    echo "❌ Failed to create branch"
    exit 1
fi

# Verify we're on the new branch
NEW_CURRENT_BRANCH=$(git branch --show-current)
if [[ "$NEW_CURRENT_BRANCH" == "$BRANCH_NAME" ]]; then
    echo "✅ Successfully switched to $BRANCH_NAME"
else
    echo "❌ Branch creation verification failed"
    exit 1
fi
```

### Step 4.2: Initial Commit (Optional)
```bash
# Create initial commit to establish branch
echo "📝 Creating initial commit..."

# Create a simple initial commit
COMMIT_MESSAGE=""
case "$BRANCH_TYPE" in
    "feature")
        COMMIT_MESSAGE="feat: initialize $BRANCH_NAME

- Set up branch for new feature development
- Ready for implementation"
        ;;
    "fix")
        COMMIT_MESSAGE="fix: initialize $BRANCH_NAME

- Set up branch for bug fix
- Issue investigation ready"
        ;;
    "docs")
        COMMIT_MESSAGE="docs: initialize $BRANCH_NAME

- Set up branch for documentation updates
- Ready for content creation"
        ;;
    *)
        COMMIT_MESSAGE="$BRANCH_TYPE: initialize $BRANCH_NAME

- Set up branch for development
- Ready for implementation"
        ;;
esac

# Add issue reference if available
if [[ -n "$LINKED_ISSUE" ]]; then
    COMMIT_MESSAGE="$COMMIT_MESSAGE

Refs: #$LINKED_ISSUE"
fi

# Create empty commit to establish branch
git commit --allow-empty -m "$COMMIT_MESSAGE"
echo "✅ Initial commit created"
```

### Step 4.3: Push Branch to Remote
```bash
echo "🚀 Pushing branch to remote..."

# Push branch and set upstream
if git push -u origin "$BRANCH_NAME"; then
    echo "✅ Branch pushed to remote successfully"
    
    # Get the repository URL for reference
    REPO_URL=$(git remote get-url origin | sed 's/\.git$//')
    echo "🔗 Branch URL: $REPO_URL/tree/$BRANCH_NAME"
else
    echo "❌ Failed to push branch to remote"
    echo "💡 You can push later with: git push -u origin $BRANCH_NAME"
fi
```

## Phase 5: Branch Information and Next Steps

### Step 5.1: Branch Summary
```bash
echo ""
echo "🎉 Branch Creation Complete!"
echo "==============================="
echo "📝 Branch name: $BRANCH_NAME"
echo "📋 Branch type: $BRANCH_TYPE"
echo "🌿 Base branch: $(git log --oneline -1 --format='%h %s' HEAD~1 2>/dev/null || echo 'N/A')"
if [[ -n "$LINKED_ISSUE" ]]; then
    echo "🔗 Linked issue: #$LINKED_ISSUE"
fi
echo "📍 Current location: $(git branch --show-current)"
echo "🚀 Remote tracking: origin/$BRANCH_NAME"
echo ""
```

### Step 5.2: Development Guidance
```bash
echo "💡 Next Steps:"
echo "==============="

case "$BRANCH_TYPE" in
    "feature")
        echo "1. Implement the new feature"
        echo "2. Add comprehensive tests"
        echo "3. Update documentation"
        echo "4. Use conventional commits (feat: description)"
        ;;
    "fix")
        echo "1. Reproduce and investigate the bug"
        echo "2. Implement the fix"
        echo "3. Add regression tests"
        echo "4. Use conventional commits (fix: description)"
        ;;
    "docs")
        echo "1. Update or create documentation"
        echo "2. Review for accuracy and clarity"
        echo "3. Test documentation examples"
        echo "4. Use conventional commits (docs: description)"
        ;;
    "hotfix")
        echo "1. Implement critical fix quickly"
        echo "2. Test thoroughly"
        echo "3. Coordinate with team for immediate deployment"
        echo "4. Use conventional commits (fix: critical description)"
        ;;
    *)
        echo "1. Implement your changes"
        echo "2. Add appropriate tests"
        echo "3. Update documentation if needed"
        echo "4. Use conventional commits ($BRANCH_TYPE: description)"
        ;;
esac

echo ""
echo "🔧 Useful Commands:"
echo "- Commit: git add . && git commit -m 'type: description'"
echo "- Push: git push"
echo "- Status: git status"
echo "- Switch back: git checkout $DEFAULT_BRANCH"
echo ""

if [[ -n "$LINKED_ISSUE" ]]; then
    echo "📋 Issue Commands:"
    echo "- View issue: gh issue view $LINKED_ISSUE"
    echo "- Comment: gh issue comment $LINKED_ISSUE --body 'message'"
    echo ""
fi

echo "🔄 When ready:"
echo "- Create PR: gh pr create --title 'Title' --body 'Description'"
echo "- Or use: /workflow (for guided development process)"
```

### Step 5.3: IDE Integration
```bash
# Check if VS Code is available and offer to open
if command -v code &> /dev/null; then
    echo "💻 IDE Integration:"
    echo "- Open in VS Code: code ."
fi

echo ""
echo "✅ Branch '$BRANCH_NAME' is ready for development!"
```

## Advanced Features

### Branch Templates
For common branch types, provide templates:

```bash
create_feature_template() {
    cat > FEATURE_CHECKLIST.md << 'EOF'
# Feature Development Checklist

## Implementation
- [ ] Core functionality implemented
- [ ] Edge cases handled
- [ ] Error handling added
- [ ] Performance optimized

## Testing
- [ ] Unit tests added
- [ ] Integration tests added
- [ ] Manual testing completed
- [ ] Test coverage > 80%

## Documentation
- [ ] Code comments added
- [ ] API documentation updated
- [ ] README updated if needed
- [ ] CHANGELOG entry added

## Quality
- [ ] Code linted and formatted
- [ ] No console.log/print statements
- [ ] No TODO comments
- [ ] Ready for review
EOF
}
```

### Branch Protection
Check for branch protection rules:

```bash
check_branch_protection() {
    if gh api "repos/:owner/:repo/branches/$DEFAULT_BRANCH/protection" &> /dev/null; then
        echo "🛡️  Branch protection is enabled on $DEFAULT_BRANCH"
        echo "💡 Make sure to follow the required checks before merging"
    fi
}
```

## Error Handling

```bash
# Cleanup function for failed branch creation
cleanup_failed_branch() {
    local branch_name="$1"
    
    echo "🧹 Cleaning up failed branch creation..."
    
    # Switch back to default branch
    git checkout "$DEFAULT_BRANCH" 2>/dev/null
    
    # Delete local branch if it was created
    git branch -D "$branch_name" 2>/dev/null
    
    # Delete remote branch if it was pushed
    git push origin --delete "$branch_name" 2>/dev/null
    
    echo "✅ Cleanup completed"
}

# Error recovery for common issues
handle_branch_error() {
    local error_type="$1"
    
    case "$error_type" in
        "remote_exists")
            echo "💡 Try: git checkout -b $BRANCH_NAME origin/$BRANCH_NAME"
            ;;
        "local_exists")
            echo "💡 Try: git checkout $BRANCH_NAME"
            ;;
        "dirty_working_tree")
            echo "💡 Try: git stash && /branch $BRANCH_NAME"
            ;;
        "network_error")
            echo "💡 Branch created locally. Push later with: git push -u origin $BRANCH_NAME"
            ;;
    esac
}
```

## Configuration

Allow customization through `.claude/settings.toml`:

```toml
[branch]
default_base = "main"
auto_push = true
create_initial_commit = true
require_issue_link = false
max_name_length = 50

[branch.naming]
feature_prefix = "feature"
fix_prefix = "fix"
docs_prefix = "docs"
hotfix_prefix = "hotfix"

[branch.templates]
feature_checklist = true
commit_template = true
```