# Complete GitHub Workflow

You are executing a complete development workflow from issue to pull request. This command automates the entire process with confirmation points for user control.

## Workflow Overview

Complete workflow for GitHub issue #$ARGUMENTS:
1. **Analysis Phase**: Fetch issue and analyze requirements
2. **Setup Phase**: Create branch and prepare environment
3. **Development Phase**: Guide implementation with quality checks
4. **Review Phase**: Create pull request with conventional standards

## Phase 1: Issue Analysis and Planning

### Step 1.1: Fetch Issue Details
```bash
gh issue view $ARGUMENTS --json title,body,labels,assignees,milestone,state,author
```

### Step 1.2: Analyze Issue Requirements
Extract and analyze:
- **Type**: Bug fix, feature, enhancement, documentation
- **Scope**: Files/components likely to be affected
- **Priority**: Based on labels and milestone
- **Acceptance Criteria**: From issue description
- **Dependencies**: Related issues or requirements

### Step 1.3: Create Development Plan
Based on issue analysis, create a structured plan:
1. Identify affected components
2. Break down implementation tasks
3. Define testing strategy
4. Estimate effort and complexity

**🔄 CONFIRMATION POINT**: Present analysis and plan to user for approval before proceeding.

## Phase 2: Environment Setup

### Step 2.1: Git Preparation
```bash
# Ensure clean working directory
git status

# Switch to main branch and update
git checkout main
git pull origin main

# Check for conflicts or issues
git log --oneline -5
```

### Step 2.2: Branch Creation
Generate branch name based on issue type:

**Branch naming patterns:**
- `feature/issue-$ARGUMENTS-brief-description` (for features)
- `fix/issue-$ARGUMENTS-brief-description` (for bugs)
- `enhancement/issue-$ARGUMENTS-brief-description` (for improvements)
- `docs/issue-$ARGUMENTS-brief-description` (for documentation)

```bash
# Create and switch to feature branch
git checkout -b [GENERATED_BRANCH_NAME]

# Create initial commit linking to issue
git commit --allow-empty -m "feat: start work on issue #$ARGUMENTS

- Initialize development for [ISSUE_TITLE]
- Set up branch structure

Refs: #$ARGUMENTS"

# Push branch and set upstream
git push -u origin [GENERATED_BRANCH_NAME]
```

### Step 2.3: Development Environment Setup
Detect project type and configure environment:

**For Node.js/React projects:**
```bash
# Install dependencies
npm install

# Check package.json for available scripts
npm run | grep -E "(dev|start|build|test|lint)"

# Setup development server if needed
npm run dev &
DEV_PID=$!
```

**For Python projects:**
```bash
# Setup virtual environment
python -m venv venv 2>/dev/null || true
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt 2>/dev/null || pip install -r requirements-dev.txt 2>/dev/null || true

# Install pre-commit hooks
pre-commit install 2>/dev/null || true
```

**🔄 CONFIRMATION POINT**: Confirm environment setup is complete and ready for development.

## Phase 3: Guided Development

### Step 3.1: Code Analysis and Navigation
Use available tools to understand the codebase:

```bash
# Find relevant files based on issue description
# Use grep/find commands to locate related code
```

Analyze:
- Existing code patterns and conventions
- Similar implementations
- Test file structures
- Documentation patterns

### Step 3.2: Implementation Guidance
Provide step-by-step implementation guidance:

1. **File Identification**: Locate files that need modification
2. **Code Patterns**: Identify existing patterns to follow
3. **Implementation Steps**: Break down the work into manageable tasks
4. **Testing Requirements**: Define what tests need to be added/updated

### Step 3.3: Quality Checks During Development
Implement continuous quality checks:

```bash
# Run linting after each significant change
npm run lint 2>/dev/null || python -m ruff check . 2>/dev/null || echo "Configure linting"

# Run relevant tests
npm test 2>/dev/null || python -m pytest 2>/dev/null || echo "Configure testing"

# Type checking (if applicable)
npm run type-check 2>/dev/null || python -m mypy . 2>/dev/null || echo "No type checking"
```

### Step 3.4: Progressive Commits
Guide the user to make conventional commits throughout development:

**Commit message format:**
```
<type>(<scope>): <description>

<body>

Refs: #$ARGUMENTS
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**🔄 CONFIRMATION POINT**: Confirm implementation is complete and ready for final quality checks.

## Phase 4: Pre-PR Quality Assurance

### Step 4.1: Comprehensive Testing
```bash
# Full test suite
npm test 2>/dev/null || python -m pytest -v 2>/dev/null || echo "Manual testing required"

# Integration tests if available
npm run test:integration 2>/dev/null || echo "No integration tests"

# End-to-end tests if available
npm run test:e2e 2>/dev/null || echo "No E2E tests"
```

### Step 4.2: Code Quality Verification
```bash
# Linting with auto-fix
npm run lint:fix 2>/dev/null || python -m ruff check --fix . 2>/dev/null || echo "Manual linting required"

# Format code
npm run format 2>/dev/null || python -m ruff format . 2>/dev/null || echo "Manual formatting required"

# Security audit
npm audit 2>/dev/null || python -m safety check 2>/dev/null || echo "Manual security check required"
```

### Step 4.3: Build Verification
```bash
# Production build
npm run build 2>/dev/null || python -m build 2>/dev/null || echo "No build step configured"

# Build size analysis (if applicable)
npm run analyze 2>/dev/null || echo "No bundle analysis"
```

### Step 4.4: Documentation Updates
Check and update documentation:
- README.md updates if needed
- API documentation
- CHANGELOG.md entry
- Code comments

**🔄 CONFIRMATION POINT**: Confirm all quality checks pass and code is ready for PR.

## Phase 5: Pull Request Creation

### Step 5.1: Final Commit Preparation
```bash
# Stage all changes
git add .

# Create final commit if there are pending changes
git commit -m "feat: complete implementation of issue #$ARGUMENTS

- Implement [SPECIFIC_FEATURES]
- Add comprehensive tests
- Update documentation
- Ensure code quality standards

Closes: #$ARGUMENTS"

# Push final changes
git push origin [BRANCH_NAME]
```

### Step 5.2: Generate PR Description
Create comprehensive PR description:

```markdown
## Summary
Brief description of changes made to resolve issue #$ARGUMENTS.

## Changes Made
- [ ] Feature implementation
- [ ] Test coverage added
- [ ] Documentation updated
- [ ] Code quality verified

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed
- [ ] No breaking changes

## Screenshots/Videos
(If applicable)

## Related Issues
Closes #$ARGUMENTS

## Checklist
- [ ] Code follows project conventions
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes
- [ ] Ready for review
```

### Step 5.3: Create Pull Request
```bash
gh pr create \
  --title "feat: implement solution for issue #$ARGUMENTS" \
  --body-file pr_description.md \
  --assignee @me \
  --label "ready-for-review"
```

### Step 5.4: Post-PR Actions
```bash
# Link PR to issue
gh issue comment $ARGUMENTS --body "Pull request created: $(gh pr view --json url -q .url)"

# Request reviewers if configured
gh pr edit --add-reviewer "team-lead,senior-dev" 2>/dev/null || echo "Manual reviewer assignment needed"
```

## Workflow Completion

### Success Summary
✅ **Issue Analysis**: Requirements understood and plan created
✅ **Environment Setup**: Branch created and development environment configured
✅ **Implementation**: Code developed following best practices
✅ **Quality Assurance**: All tests pass, code quality verified
✅ **Pull Request**: PR created with comprehensive description

### Next Steps for User
1. **Review PR**: Check the created pull request
2. **Address Feedback**: Respond to reviewer comments
3. **Monitor CI/CD**: Ensure automated checks pass
4. **Merge**: Complete the workflow when approved

## Error Recovery

If any phase fails:
1. **Capture Error Context**: Save current state and error details
2. **Provide Recovery Options**: Suggest manual steps or alternatives
3. **Resume Point**: Allow workflow to resume from last successful phase
4. **Fallback Mode**: Switch to manual guidance if automation fails

## Configuration Options

The workflow can be customized through `.claude/settings.toml`:

```toml
[workflow]
default_reviewers = ["team-lead", "senior-dev"]
auto_assign_pr = true
require_tests = true
quality_gates = ["lint", "test", "build"]
conventional_commits = true
```

## Notes

- Each confirmation point allows user to abort or modify the workflow
- All git operations include safety checks
- Quality gates are enforced before PR creation
- PR follows conventional format with proper linking
- Workflow state is preserved for error recovery