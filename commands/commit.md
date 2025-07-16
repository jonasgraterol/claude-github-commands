# Conventional Commits with Automation

You are creating commits that follow conventional commit standards with automated type detection, formatting, and pre-commit validation. This command ensures consistent, meaningful commit messages and integrates with development workflows.

## Command Usage

The commit command supports various formats:
- `/commit "Add user authentication"` - Auto-detect type and format
- `/commit "feat: add user authentication"` - Explicit conventional format
- `/commit --type feat "Add user authentication"` - Specify type explicitly
- `/commit --interactive` - Interactive commit creation
- `/commit --amend` - Amend previous commit

Arguments: $ARGUMENTS

## Phase 1: Commit Message Analysis and Processing

### Step 1.1: Parse Commit Arguments
```bash
# Initialize variables
COMMIT_MESSAGE="$ARGUMENTS"
COMMIT_TYPE=""
COMMIT_SCOPE=""
COMMIT_DESCRIPTION=""
COMMIT_BODY=""
COMMIT_FOOTER=""
INTERACTIVE_MODE=false
AMEND_MODE=false

# Parse command flags
while [[ $# -gt 0 ]]; do
    case $1 in
        --type)
            COMMIT_TYPE="$2"
            shift 2
            ;;
        --scope)
            COMMIT_SCOPE="$2"
            shift 2
            ;;
        --interactive|-i)
            INTERACTIVE_MODE=true
            shift
            ;;
        --amend)
            AMEND_MODE=true
            shift
            ;;
        *)
            # Remaining arguments form the commit message
            COMMIT_MESSAGE="$*"
            break
            ;;
    esac
done

echo "📝 Processing commit with message: '$COMMIT_MESSAGE'"
```

### Step 1.2: Analyze Existing Commit Format
```bash
# Check if message already follows conventional format
check_conventional_format() {
    local message="$1"
    
    # Conventional commit pattern: type(scope): description
    if [[ "$message" =~ ^([a-z]+)(\([^)]+\))?:[[:space:]]*(.+)$ ]]; then
        EXISTING_TYPE="${BASH_REMATCH[1]}"
        EXISTING_SCOPE="${BASH_REMATCH[2]//[()]/}"
        EXISTING_DESCRIPTION="${BASH_REMATCH[3]}"
        echo "✅ Conventional format detected:"
        echo "   Type: $EXISTING_TYPE"
        echo "   Scope: $EXISTING_SCOPE"
        echo "   Description: $EXISTING_DESCRIPTION"
        return 0
    else
        echo "📝 Natural language message detected, will format conventionally"
        return 1
    fi
}

if check_conventional_format "$COMMIT_MESSAGE"; then
    # Use existing format
    COMMIT_TYPE="${EXISTING_TYPE}"
    COMMIT_SCOPE="${EXISTING_SCOPE}"
    COMMIT_DESCRIPTION="${EXISTING_DESCRIPTION}"
    NEEDS_FORMATTING=false
else
    NEEDS_FORMATTING=true
fi
```

## Phase 2: Automated Type Detection

### Step 2.1: Analyze Git Changes
```bash
echo "🔍 Analyzing staged changes for type detection..."

# Get staged files and changes
STAGED_FILES=$(git diff --cached --name-only)
NUM_STAGED=$(echo "$STAGED_FILES" | wc -l)

if [[ -z "$STAGED_FILES" ]]; then
    echo "❌ No staged changes found"
    echo "💡 Stage changes with: git add <files>"
    exit 1
fi

echo "📊 Found $NUM_STAGED staged file(s):"
echo "$STAGED_FILES" | sed 's/^/  - /'

# Analyze change patterns
analyze_changes() {
    local change_patterns=()
    
    # Check for new files
    NEW_FILES=$(git diff --cached --diff-filter=A --name-only)
    if [[ -n "$NEW_FILES" ]]; then
        change_patterns+=("new_files")
    fi
    
    # Check for deleted files
    DELETED_FILES=$(git diff --cached --diff-filter=D --name-only)
    if [[ -n "$DELETED_FILES" ]]; then
        change_patterns+=("deleted_files")
    fi
    
    # Check for test files
    TEST_FILES=$(echo "$STAGED_FILES" | grep -E "\.(test|spec)\.(js|ts|py)$|test_.*\.py$|.*_test\.(go|rs)$")
    if [[ -n "$TEST_FILES" ]]; then
        change_patterns+=("tests")
    fi
    
    # Check for documentation files
    DOC_FILES=$(echo "$STAGED_FILES" | grep -E "\.(md|rst|txt)$|README|CHANGELOG|LICENSE")
    if [[ -n "$DOC_FILES" ]]; then
        change_patterns+=("documentation")
    fi
    
    # Check for configuration files
    CONFIG_FILES=$(echo "$STAGED_FILES" | grep -E "\.(json|yaml|yml|toml|ini|conf)$|Dockerfile|Makefile|package\.json")
    if [[ -n "$CONFIG_FILES" ]]; then
        change_patterns+=("config")
    fi
    
    # Check for style/formatting files
    STYLE_FILES=$(echo "$STAGED_FILES" | grep -E "\.(css|scss|sass|less)$|.*\.styles\.*")
    if [[ -n "$STYLE_FILES" ]]; then
        change_patterns+=("styles")
    fi
    
    echo "${change_patterns[@]}"
}

CHANGE_PATTERNS=($(analyze_changes))
echo "🔍 Change patterns detected: ${CHANGE_PATTERNS[*]}"
```

### Step 2.2: Content Analysis for Type Detection
```bash
if [[ "$NEEDS_FORMATTING" == "true" && -z "$COMMIT_TYPE" ]]; then
    echo "🤖 Auto-detecting commit type..."
    
    detect_commit_type() {
        local message="$1"
        local patterns=("${@:2}")
        
        # Keyword-based detection
        case "$message" in
            *"fix"*|*"bug"*|*"patch"*|*"resolve"*|*"correct"*)
                echo "fix"
                return 0
                ;;
            *"feat"*|*"feature"*|*"add"*|*"implement"*|*"create"*|*"new"*)
                echo "feat"
                return 0
                ;;
            *"doc"*|*"readme"*|*"guide"*|*"manual"*)
                echo "docs"
                return 0
                ;;
            *"test"*|*"spec"*|*"coverage"*)
                echo "test"
                return 0
                ;;
            *"style"*|*"format"*|*"lint"*|*"prettier"*)
                echo "style"
                return 0
                ;;
            *"refactor"*|*"restructure"*|*"reorganize"*)
                echo "refactor"
                return 0
                ;;
            *"performance"*|*"perf"*|*"optimize"*|*"speed"*)
                echo "perf"
                return 0
                ;;
            *"chore"*|*"maintenance"*|*"update"*|*"upgrade"*|*"deps"*)
                echo "chore"
                return 0
                ;;
        esac
        
        # Pattern-based detection
        for pattern in "${patterns[@]}"; do
            case "$pattern" in
                "tests")
                    echo "test"
                    return 0
                    ;;
                "documentation")
                    echo "docs"
                    return 0
                    ;;
                "config")
                    echo "chore"
                    return 0
                    ;;
                "styles")
                    echo "style"
                    return 0
                    ;;
                "new_files")
                    if [[ "$message" =~ (add|create|new) ]]; then
                        echo "feat"
                    else
                        echo "chore"
                    fi
                    return 0
                    ;;
                "deleted_files")
                    echo "chore"
                    return 0
                    ;;
            esac
        done
        
        # Default to feat for new functionality or fix for modifications
        if [[ " ${patterns[*]} " =~ " new_files " ]]; then
            echo "feat"
        else
            echo "fix"
        fi
    }
    
    DETECTED_TYPE=$(detect_commit_type "$COMMIT_MESSAGE" "${CHANGE_PATTERNS[@]}")
    
    if [[ -z "$COMMIT_TYPE" ]]; then
        COMMIT_TYPE="$DETECTED_TYPE"
    fi
    
    echo "🎯 Detected commit type: $COMMIT_TYPE"
fi
```

### Step 2.3: Scope Detection
```bash
if [[ -z "$COMMIT_SCOPE" ]]; then
    echo "🔍 Detecting commit scope..."
    
    detect_scope() {
        local files="$1"
        
        # Analyze file paths for scope hints
        local scopes=()
        
        # Check for component/module directories
        while IFS= read -r file; do
            if [[ "$file" =~ ^src/([^/]+)/ ]]; then
                scopes+=("${BASH_REMATCH[1]}")
            elif [[ "$file" =~ ^components/([^/]+)/ ]]; then
                scopes+=("${BASH_REMATCH[1]}")
            elif [[ "$file" =~ ^lib/([^/]+)/ ]]; then
                scopes+=("${BASH_REMATCH[1]}")
            elif [[ "$file" =~ ^modules/([^/]+)/ ]]; then
                scopes+=("${BASH_REMATCH[1]}")
            elif [[ "$file" =~ ^([^/]+)/.*\.(js|ts|py|go|rs)$ ]]; then
                scopes+=("${BASH_REMATCH[1]}")
            fi
        done <<< "$files"
        
        # Find most common scope
        if [[ ${#scopes[@]} -gt 0 ]]; then
            echo "${scopes[0]}"  # Use first detected scope
        fi
    }
    
    DETECTED_SCOPE=$(detect_scope "$STAGED_FILES")
    
    if [[ -n "$DETECTED_SCOPE" ]]; then
        COMMIT_SCOPE="$DETECTED_SCOPE"
        echo "🎯 Detected scope: $COMMIT_SCOPE"
    else
        echo "📝 No specific scope detected"
    fi
fi
```

## Phase 3: Interactive Mode (if enabled)

### Step 3.1: Interactive Commit Builder
```bash
if [[ "$INTERACTIVE_MODE" == "true" ]]; then
    echo "🤖 Interactive Commit Builder"
    echo "=============================="
    
    # Present detected information
    echo "📊 Analysis Results:"
    echo "  Type: ${COMMIT_TYPE:-'not detected'}"
    echo "  Scope: ${COMMIT_SCOPE:-'not detected'}"
    echo "  Files: $NUM_STAGED staged"
    echo ""
    
    # Allow user to confirm or modify
    echo "📝 Commit Types:"
    echo "  feat     - New feature"
    echo "  fix      - Bug fix"
    echo "  docs     - Documentation"
    echo "  style    - Code style/formatting"
    echo "  refactor - Code refactoring"
    echo "  test     - Tests"
    echo "  chore    - Maintenance"
    echo "  perf     - Performance improvement"
    echo "  ci       - CI/CD changes"
    echo "  build    - Build system changes"
    echo "  revert   - Revert previous commit"
    echo ""
    
    # Interactive prompts (in real implementation)
    # read -p "Commit type [$COMMIT_TYPE]: " USER_TYPE
    # read -p "Scope [$COMMIT_SCOPE]: " USER_SCOPE
    # read -p "Description: " USER_DESCRIPTION
    
    # For this template, we'll use detected values
    echo "✅ Using interactive mode values"
fi
```

## Phase 4: Commit Message Formatting

### Step 4.1: Format Conventional Commit
```bash
echo "📝 Formatting conventional commit message..."

# Use original description or create one
if [[ -z "$COMMIT_DESCRIPTION" ]]; then
    COMMIT_DESCRIPTION="$COMMIT_MESSAGE"
fi

# Clean up description
clean_description() {
    local desc="$1"
    
    # Remove conventional format if present
    desc=$(echo "$desc" | sed 's/^[a-z]\+(\([^)]*\))*: *//')
    
    # Ensure it starts with lowercase
    desc=$(echo "$desc" | sed 's/^./\L&/')
    
    # Remove trailing periods
    desc=$(echo "$desc" | sed 's/\.*$//')
    
    echo "$desc"
}

COMMIT_DESCRIPTION=$(clean_description "$COMMIT_DESCRIPTION")

# Build the commit message
build_commit_message() {
    local type="$1"
    local scope="$2"
    local description="$3"
    
    local header="$type"
    
    if [[ -n "$scope" ]]; then
        header="$header($scope)"
    fi
    
    header="$header: $description"
    
    echo "$header"
}

FORMATTED_HEADER=$(build_commit_message "$COMMIT_TYPE" "$COMMIT_SCOPE" "$COMMIT_DESCRIPTION")
echo "📋 Formatted header: $FORMATTED_HEADER"
```

### Step 4.2: Add Body and Footer
```bash
# Generate commit body based on changes
generate_commit_body() {
    local body_lines=()
    
    # Add file change summary
    if [[ $NUM_STAGED -gt 5 ]]; then
        body_lines+=("- Update $NUM_STAGED files")
    else
        while IFS= read -r file; do
            if [[ -n "$file" ]]; then
                local change_type="modify"
                if git diff --cached --diff-filter=A --name-only | grep -q "^$file$"; then
                    change_type="add"
                elif git diff --cached --diff-filter=D --name-only | grep -q "^$file$"; then
                    change_type="remove"
                fi
                
                body_lines+=("- $(echo $change_type | sed 's/.*/\u&/') $file")
            fi
        done <<< "$STAGED_FILES"
    fi
    
    # Add pattern-based details
    for pattern in "${CHANGE_PATTERNS[@]}"; do
        case "$pattern" in
            "tests")
                body_lines+=("- Add/update test coverage")
                ;;
            "documentation")
                body_lines+=("- Update documentation")
                ;;
            "config")
                body_lines+=("- Update configuration")
                ;;
        esac
    done
    
    # Join body lines
    if [[ ${#body_lines[@]} -gt 0 ]]; then
        printf '%s\n' "${body_lines[@]}"
    fi
}

# Generate body if commit is significant
if [[ $NUM_STAGED -gt 3 ]] || [[ " ${CHANGE_PATTERNS[*]} " =~ " new_files " ]]; then
    COMMIT_BODY=$(generate_commit_body)
fi

# Add breaking change footer if detected
detect_breaking_changes() {
    # Check for breaking change indicators in diff
    local breaking_patterns=("BREAKING" "breaking" "remove" "delete" "deprecate")
    
    for pattern in "${breaking_patterns[@]}"; do
        if git diff --cached | grep -qi "$pattern"; then
            echo "BREAKING CHANGE: $COMMIT_DESCRIPTION"
            return 0
        fi
    done
    
    return 1
}

BREAKING_CHANGE=$(detect_breaking_changes)
if [[ -n "$BREAKING_CHANGE" ]]; then
    COMMIT_FOOTER="$BREAKING_CHANGE"
fi
```

## Phase 5: Pre-Commit Validation

### Step 5.1: Commit Message Validation
```bash
echo "✅ Validating commit message..."

validate_commit_message() {
    local header="$1"
    local errors=()
    
    # Check header length (max 50 characters)
    if [[ ${#header} -gt 50 ]]; then
        errors+=("Header too long (${#header}/50 characters)")
    fi
    
    # Check conventional format
    if [[ ! "$header" =~ ^[a-z]+(\([^)]+\))?:[[:space:]].+ ]]; then
        errors+=("Not in conventional format: type(scope): description")
    fi
    
    # Check type validity
    local valid_types=("feat" "fix" "docs" "style" "refactor" "test" "chore" "perf" "ci" "build" "revert")
    local header_type=$(echo "$header" | sed 's/\([a-z]*\).*/\1/')
    
    if [[ ! " ${valid_types[*]} " =~ " $header_type " ]]; then
        errors+=("Invalid commit type: $header_type")
    fi
    
    # Return validation results
    if [[ ${#errors[@]} -eq 0 ]]; then
        echo "✅ Commit message validation passed"
        return 0
    else
        echo "❌ Commit message validation failed:"
        for error in "${errors[@]}"; do
            echo "  - $error"
        done
        return 1
    fi
}

if ! validate_commit_message "$FORMATTED_HEADER"; then
    echo "🔧 Auto-fixing validation issues..."
    
    # Auto-fix header length
    if [[ ${#FORMATTED_HEADER} -gt 50 ]]; then
        FORMATTED_HEADER=$(echo "$FORMATTED_HEADER" | cut -c1-47)"..."
        echo "📏 Truncated header to: $FORMATTED_HEADER"
    fi
fi
```

### Step 5.2: Run Pre-Commit Hooks
```bash
echo "🪝 Running pre-commit checks..."

# Check if pre-commit is installed and configured
if command -v pre-commit &> /dev/null && [[ -f ".pre-commit-config.yaml" ]]; then
    echo "🔍 Running pre-commit hooks..."
    
    if pre-commit run --files $STAGED_FILES; then
        echo "✅ Pre-commit hooks passed"
    else
        echo "❌ Pre-commit hooks failed"
        echo "🔧 Some files may have been auto-fixed"
        echo "💡 Review changes and re-stage if needed"
        
        # Check if files were modified by hooks
        MODIFIED_FILES=$(git diff --name-only $STAGED_FILES)
        if [[ -n "$MODIFIED_FILES" ]]; then
            echo "📝 Files modified by pre-commit hooks:"
            echo "$MODIFIED_FILES" | sed 's/^/  - /'
            echo "🔄 Consider adding these changes: git add $MODIFIED_FILES"
        fi
    fi
else
    echo "⚠️  Pre-commit not configured, skipping hooks"
fi
```

### Step 5.3: Quality Checks
```bash
echo "🔍 Running additional quality checks..."

# Check for TODO/FIXME comments in staged changes
check_todos() {
    local todo_count=0
    
    while IFS= read -r file; do
        if [[ -f "$file" ]]; then
            local file_todos=$(git diff --cached "$file" | grep -E "^\+.*\b(TODO|FIXME|XXX|HACK)\b" | wc -l)
            todo_count=$((todo_count + file_todos))
        fi
    done <<< "$STAGED_FILES"
    
    if [[ $todo_count -gt 0 ]]; then
        echo "⚠️  Found $todo_count TODO/FIXME comments in staged changes"
        echo "💡 Consider addressing these before committing"
    else
        echo "✅ No TODO/FIXME comments in staged changes"
    fi
}

check_todos

# Check for debug statements
check_debug_statements() {
    local debug_patterns=("console.log" "print(" "debugger" "pdb.set_trace" "binding.pry")
    local debug_found=false
    
    for pattern in "${debug_patterns[@]}"; do
        if git diff --cached | grep -E "^\+.*$pattern" &> /dev/null; then
            echo "⚠️  Found debug statement: $pattern"
            debug_found=true
        fi
    done
    
    if [[ "$debug_found" == "false" ]]; then
        echo "✅ No debug statements found"
    else
        echo "💡 Consider removing debug statements before committing"
    fi
}

check_debug_statements
```

## Phase 6: Commit Creation

### Step 6.1: Build Final Commit Message
```bash
echo "📝 Building final commit message..."

# Construct the complete commit message
build_final_message() {
    local header="$1"
    local body="$2"
    local footer="$3"
    
    local message="$header"
    
    if [[ -n "$body" ]]; then
        message="$message\n\n$body"
    fi
    
    if [[ -n "$footer" ]]; then
        message="$message\n\n$footer"
    fi
    
    echo -e "$message"
}

FINAL_MESSAGE=$(build_final_message "$FORMATTED_HEADER" "$COMMIT_BODY" "$COMMIT_FOOTER")

echo "📋 Final commit message:"
echo "========================"
echo -e "$FINAL_MESSAGE"
echo "========================"
```

### Step 6.2: Create Commit
```bash
echo "💾 Creating commit..."

if [[ "$AMEND_MODE" == "true" ]]; then
    echo "🔄 Amending previous commit..."
    COMMIT_CMD=("git" "commit" "--amend" "-m" "$FINAL_MESSAGE")
else
    COMMIT_CMD=("git" "commit" "-m" "$FINAL_MESSAGE")
fi

# Execute commit
if "${COMMIT_CMD[@]}"; then
    COMMIT_HASH=$(git rev-parse HEAD)
    echo "✅ Commit created successfully: ${COMMIT_HASH:0:7}"
else
    echo "❌ Failed to create commit"
    exit 1
fi
```

### Step 6.3: Post-Commit Actions
```bash
echo "🎉 Post-commit actions..."

# Show commit summary
echo "📊 Commit Summary:"
echo "================="
echo "Hash: $(git rev-parse --short HEAD)"
echo "Type: $COMMIT_TYPE"
echo "Scope: ${COMMIT_SCOPE:-'none'}"
echo "Files: $NUM_STAGED"
echo "Message: $FORMATTED_HEADER"

# Check if we should push
echo ""
echo "🚀 Next Steps:"
echo "- Review commit: git show"
echo "- Push changes: git push"
echo "- Create PR: gh pr create"
echo "- Continue development: make additional changes"

# Optional: Auto-push if configured
if git config --get claude.auto-push &> /dev/null; then
    echo "🚀 Auto-pushing enabled, pushing to remote..."
    git push
fi
```

## Phase 7: Integration Features

### Step 7.1: GitHub Integration
```bash
# Link commit to issues if mentioned
link_to_issues() {
    local message="$1"
    
    # Extract issue numbers from commit message
    local issue_numbers=$(echo "$message" | grep -oE "#[0-9]+" | tr -d '#')
    
    if [[ -n "$issue_numbers" ]]; then
        echo "🔗 Linked to issues: $issue_numbers"
        
        # Add comment to issues (if GitHub CLI is available)
        while IFS= read -r issue_num; do
            if [[ -n "$issue_num" ]] && command -v gh &> /dev/null; then
                local commit_url="$(git remote get-url origin)/commit/$(git rev-parse HEAD)"
                gh issue comment "$issue_num" --body "Addressed in commit: $commit_url" 2>/dev/null || true
            fi
        done <<< "$issue_numbers"
    fi
}

link_to_issues "$FINAL_MESSAGE"
```

### Step 7.2: Changelog Integration
```bash
# Update CHANGELOG if present
update_changelog() {
    if [[ -f "CHANGELOG.md" ]] && [[ "$COMMIT_TYPE" == "feat" || "$COMMIT_TYPE" == "fix" ]]; then
        echo "📝 Updating CHANGELOG.md..."
        
        # Add entry to changelog (simplified)
        local date=$(date +"%Y-%m-%d")
        local entry="- $COMMIT_TYPE: $COMMIT_DESCRIPTION"
        
        # Insert after ## [Unreleased] section
        if grep -q "## \[Unreleased\]" CHANGELOG.md; then
            sed -i "/## \[Unreleased\]/a\\$entry" CHANGELOG.md
            echo "✅ Added entry to CHANGELOG.md"
        fi
    fi
}

update_changelog
```

## Advanced Features

### Commit Templates
```bash
# Generate commit templates for complex commits
generate_commit_template() {
    local type="$1"
    
    case "$type" in
        "feat")
            cat << 'EOF'
feat(scope): brief description

# What:
- Implement new functionality
- Add feature X with capabilities Y and Z

# Why:
- Addresses user need for X
- Improves workflow by Y

# How:
- Use approach A
- Integrate with system B

Closes: #123
EOF
            ;;
        "fix")
            cat << 'EOF'
fix(scope): brief description

# Problem:
- Bug description
- Steps to reproduce

# Solution:
- Fix approach
- Root cause addressed

# Testing:
- Verification steps
- Regression tests added

Fixes: #123
EOF
            ;;
    esac
}
```

### Commit Metrics
```bash
# Track commit metrics
track_commit_metrics() {
    local type="$1"
    local files_changed="$2"
    
    # Log metrics for analysis
    echo "$(date +%Y-%m-%d),$(git rev-parse --short HEAD),$type,$files_changed" >> .git/commit-metrics.csv
}

track_commit_metrics "$COMMIT_TYPE" "$NUM_STAGED"
```

## Error Handling

```bash
# Handle common commit errors
handle_commit_error() {
    local error_type="$1"
    
    case "$error_type" in
        "no_staged_files")
            echo "💡 Stage files with: git add <files>"
            echo "💡 Stage all changes: git add ."
            ;;
        "merge_conflict")
            echo "💡 Resolve conflicts first: git status"
            echo "💡 Then continue with: git commit"
            ;;
        "hook_failure")
            echo "💡 Fix hook issues and retry"
            echo "💡 Skip hooks (not recommended): git commit --no-verify"
            ;;
        "empty_message")
            echo "💡 Provide commit message: /commit 'your message'"
            ;;
    esac
}
```

## Configuration

```toml
[commit]
auto_detect_type = true
require_scope = false
max_header_length = 50
auto_push = false
update_changelog = true

[commit.validation]
require_conventional = true
allow_empty = false
check_todos = true
check_debug_statements = true

[commit.types]
default = "feat"
allowed = ["feat", "fix", "docs", "style", "refactor", "test", "chore", "perf"]
```

This commit command provides comprehensive conventional commit support with intelligent type detection, validation, and integration with development workflows.