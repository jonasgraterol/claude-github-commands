# Claude GitHub Commands - Usage Guide

This comprehensive guide covers all aspects of using Claude GitHub Commands for streamlined development workflows.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Command Overview](#command-overview)
3. [Detailed Command Usage](#detailed-command-usage)
4. [Workflow Patterns](#workflow-patterns)
5. [Configuration](#configuration)
6. [Troubleshooting](#troubleshooting)
7. [Advanced Features](#advanced-features)

## Getting Started

### Prerequisites

Before using Claude GitHub Commands, ensure you have:

- **Git**: Installed and configured
- **GitHub CLI**: Installed and authenticated (`gh auth login`)
- **Claude Code**: Installed and configured
- **Project Setup**: Working in a Git repository with GitHub remote

### Quick Setup

1. **Install Commands**:
   ```bash
   # As submodule (recommended)
   git submodule add https://github.com/your-username/claude-github-commands .claude-commands
   cd .claude-commands && ./install.sh
   
   # Or direct installation
   git clone https://github.com/your-username/claude-github-commands
   cd claude-github-commands && ./install.sh
   ```

2. **Verify Installation**:
   ```bash
   # Check available commands
   ls .claude/commands/
   
   # Test GitHub CLI authentication
   gh auth status
   ```

3. **First Use**:
   ```bash
   # In Claude Code, try:
   /setup          # Configure development environment
   /issues         # List project issues
   /issue 123      # Start working on issue #123
   ```

## Command Overview

### Core Workflow Commands

| Command | Purpose | Example Usage |
|---------|---------|---------------|
| `/issue <number>` | Work on specific issue | `/issue 123` |
| `/workflow <number>` | Complete development cycle | `/workflow 456` |
| `/branch <name>` | Smart branch creation | `/branch feature/new-login` |
| `/commit <message>` | Conventional commits | `/commit "Add user authentication"` |

### Analysis and Review Commands

| Command | Purpose | Example Usage |
|---------|---------|---------------|
| `/issues [filters]` | List and filter issues | `/issues --priority high` |
| `/pr-review <number>` | Automated PR review | `/pr-review 789` |

### Setup and Maintenance Commands

| Command | Purpose | Example Usage |
|---------|---------|---------------|
| `/setup` | Development environment setup | `/setup` |

## Detailed Command Usage

### `/issue` - Issue Workflow

**Purpose**: Automates the process of starting work on a GitHub issue.

**Syntax**: `/issue <issue_number>`

**Process**:
1. Fetches issue details from GitHub
2. Analyzes issue type (bug, feature, etc.)
3. Creates appropriately named branch
4. Sets up development environment
5. Creates initial commit with issue reference

**Example**:
```bash
/issue 123
```

**Output**:
```
🔍 Fetching issue #123 details...
✅ Issue: "Add user authentication system"
📋 Type: feature
🌿 Creating branch: feature/issue-123-user-authentication
✅ Branch created and pushed
📝 Initial commit created with issue reference
💡 Ready for development!
```

**Advanced Usage**:
- The command automatically detects issue type from labels
- Branch naming follows conventional patterns
- Links commits to issues for tracking

### `/workflow` - Complete Development Workflow

**Purpose**: Guides through the entire development process from issue to PR.

**Syntax**: `/workflow <issue_number>`

**Phases**:
1. **Analysis**: Understand requirements and plan implementation
2. **Setup**: Create branch and prepare environment  
3. **Development**: Guided implementation with quality checks
4. **Review**: Create PR with conventional format

**Example**:
```bash
/workflow 456
```

**Process Flow**:
```
Phase 1: Issue Analysis ✅
├── Fetch issue details
├── Analyze requirements
├── Create development plan
└── 🔄 Confirmation point

Phase 2: Environment Setup ✅
├── Create feature branch
├── Set up dependencies
├── Configure development tools
└── 🔄 Confirmation point

Phase 3: Guided Development ✅
├── Code analysis and navigation
├── Implementation guidance
├── Progressive quality checks
└── 🔄 Confirmation point

Phase 4: Pull Request Creation ✅
├── Final quality assurance
├── Generate PR description
├── Create and configure PR
└── ✅ Workflow complete
```

### `/branch` - Smart Branch Management

**Purpose**: Creates Git branches with intelligent naming and validation.

**Syntax**: 
- `/branch <branch_name>` - Create specific branch
- `/branch` - Interactive branch creation

**Branch Types & Naming**:
- **Features**: `feature/issue-123-brief-description`
- **Bug Fixes**: `fix/issue-456-login-error`
- **Documentation**: `docs/api-documentation`
- **Hotfixes**: `hotfix/critical-security-patch`

**Example**:
```bash
/branch feature/user-dashboard
```

**Validation Checks**:
- Branch name format validation
- Duplicate branch detection
- Working directory status
- Base branch verification

**Interactive Mode**:
```bash
/branch

🤖 Let's create a branch together!

Branch types available:
  🆕 feature  - New features or enhancements
  🐛 fix      - Bug fixes
  📚 docs     - Documentation changes
  🔧 chore    - Maintenance tasks
  ♻️  refactor - Code refactoring
  🧪 test     - Testing improvements
  🚨 hotfix   - Critical production fixes

Select branch type: feature
Brief description: user-dashboard
📝 Generated branch name: feature/user-dashboard
✅ Branch created successfully!
```

### `/commit` - Conventional Commits

**Purpose**: Creates commits following conventional commit standards with automated type detection.

**Syntax**:
- `/commit "message"` - Auto-detect type and format
- `/commit "feat: add login"` - Explicit conventional format
- `/commit --type feat "add login"` - Specify type
- `/commit --interactive` - Interactive mode

**Commit Types**:
- `feat` - New features
- `fix` - Bug fixes  
- `docs` - Documentation
- `style` - Code style/formatting
- `refactor` - Code refactoring
- `test` - Tests
- `chore` - Maintenance
- `perf` - Performance improvements

**Auto-Detection Examples**:

```bash
# Input: "Add user authentication"
# Output: "feat: add user authentication"

# Input: "Fix login bug"  
# Output: "fix: login bug"

# Input: "Update README"
# Output: "docs: update README"
```

**Process**:
1. Analyze staged changes
2. Detect commit type from content and message
3. Format according to conventions
4. Run pre-commit validation
5. Create commit with proper linking

### `/issues` - Issue Management

**Purpose**: Lists, filters, and analyzes GitHub issues with actionable insights.

**Syntax**:
- `/issues` - List all open issues
- `/issues --priority high` - Filter by priority
- `/issues --type bug` - Filter by type
- `/issues --assignee @me` - Filter by assignee

**Filtering Options**:
```bash
/issues --state all              # Include closed issues
/issues --milestone v2.0         # Filter by milestone  
/issues --label "needs-review"   # Filter by label
/issues --assignee username      # Filter by assignee
```

**Output Categories**:
```markdown
## 🚨 Critical Issues (P0)
- #123 Production login broken (assigned: @alice)
- #124 Data loss in user profiles (assigned: @bob)

## 🔴 High Priority Issues (P1)  
- #125 Slow dashboard loading (unassigned)
- #126 Email notifications failing (assigned: @charlie)

## 🐛 Bug Fixes
- #127 Form validation errors
- #128 Mobile layout issues

## ✨ Feature Requests
- #129 Dark mode support
- #130 Advanced search filters

## 📊 Issue Statistics
Total Issues: 45
Open Issues: 32
By Priority: Critical: 2, High: 8, Medium: 15, Low: 7
By Type: Bugs: 12, Features: 15, Improvements: 5
```

**Smart Recommendations**:
```markdown
## 💡 Recommendations

### Immediate Actions Needed:
1. **Critical Issues**: 2 issues need immediate attention
2. **Stale Issues**: 5 issues without activity for >30 days

### Sprint Planning Suggestions:
1. **High-Impact Quick Wins**: #125, #127, #128
2. **Technical Debt**: #131, #132
3. **User-Facing Improvements**: #129, #130
```

### `/pr-review` - Pull Request Review

**Purpose**: Automates comprehensive PR review with code analysis and testing.

**Syntax**: `/pr-review <pr_number>`

**Review Process**:
1. **Information Gathering**: Fetch PR details and changes
2. **Environment Setup**: Checkout PR branch safely
3. **Code Analysis**: Quality, complexity, and standards review
4. **Automated Testing**: Run comprehensive test suites
5. **Security Review**: Check for vulnerabilities and patterns
6. **Documentation Review**: Verify docs and standards
7. **Generate Feedback**: Create structured review comments

**Example**:
```bash
/pr-review 789
```

**Review Output**:
```markdown
## Code Review Summary for PR #789

### Overview
This PR implements user authentication with OAuth integration.
Overall assessment: ✅ Approved with minor suggestions

### ✅ Strengths
- Well-structured code with clear separation of concerns
- Comprehensive test coverage (95%)
- Proper error handling implementation
- Good documentation and code comments

### ⚠️ Areas for Improvement
- Consider extracting OAuth config to environment variables
- Add input validation for edge cases
- Minor code style inconsistencies

### 🧪 Testing Results
- Unit Tests: ✅ PASS (47/47 tests)
- Integration Tests: ✅ PASS
- Security Scan: ✅ PASS
- Build: ✅ PASS

### 📝 Recommendations
1. Move OAuth secrets to environment configuration
2. Add rate limiting to authentication endpoints
3. Consider adding audit logging for auth events
```

### `/setup` - Development Environment

**Purpose**: Automatically detects project type and sets up complete development environment.

**Syntax**: `/setup`

**Detection & Setup**:
- **Node.js/React**: npm/yarn, ESLint, Prettier, Jest
- **Python**: virtualenv, pip, ruff, pytest, mypy
- **Go**: modules, golint, go test
- **Rust**: cargo, clippy, rustfmt

**Process**:
1. **Project Detection**: Analyze files to identify technologies
2. **Dependencies**: Install packages and development tools
3. **Configuration**: Create config files (linting, testing, etc.)
4. **Git Hooks**: Set up pre-commit hooks
5. **IDE Setup**: Configure VS Code settings and extensions
6. **Environment**: Create .env templates
7. **Health Checks**: Verify everything works

**Example Output**:
```bash
🔍 Analyzing project structure...
✅ Node.js project detected
✅ React framework detected
✅ TypeScript detected

📦 Setting up Node.js environment...
✅ npm dependencies installed
🔧 Installing ESLint...
🔧 Installing TypeScript tools...
🔧 Installing React development tools...

🔧 Setting up linting configuration...
✅ ESLint configuration created
✅ TypeScript ESLint configuration created

🧪 Setting up testing configuration...
✅ Jest configuration created

🪝 Setting up Git hooks...
✅ Pre-commit configuration created
✅ Pre-commit hooks installed

🔐 Setting up environment configuration...
✅ .env.example created
✅ .env created from example

🔧 Setting up IDE configuration...
✅ VS Code configuration created

🏥 Running health checks...
✅ Node.js dependencies installed correctly
✅ ESLint working correctly
✅ Pre-commit hooks working correctly

🎉 Development Environment Setup Complete!
```

## Workflow Patterns

### Pattern 1: Feature Development

**Complete feature development cycle**:

```bash
# 1. Start with issue
/issue 123

# 2. Develop feature (manual coding)
# ... write code, add tests ...

# 3. Commit changes progressively
/commit "implement user registration"
/commit "add validation tests"
/commit "update documentation"

# 4. Create pull request (when ready)
gh pr create --title "feat: user registration system" --body "Closes #123"
```

### Pattern 2: Bug Fix Workflow

**Quick bug fix process**:

```bash
# 1. Create fix branch
/branch fix/login-error

# 2. Implement fix
# ... fix the bug ...

# 3. Commit with conventional format
/commit "fix login validation error"

# 4. Push and create PR
git push
gh pr create --title "fix: resolve login validation error"
```

### Pattern 3: Code Review Process

**Comprehensive review workflow**:

```bash
# 1. Review incoming PR
/pr-review 456

# 2. Provide feedback (automated comments created)
# 3. Re-review after changes
/pr-review 456

# 4. Approve and merge (manual via GitHub)
```

### Pattern 4: Project Maintenance

**Regular maintenance tasks**:

```bash
# 1. Check project health
/setup                    # Verify environment
/issues --priority high   # Check critical issues

# 2. Security audit
npm audit                 # Check vulnerabilities
/commit "chore: update dependencies"

# 3. Documentation updates
/commit "docs: update API documentation"
```

## Configuration

### Settings File: `.claude/settings.toml`

The installation script creates a settings file that can be customized:

```toml
[tools]
bash = true
edit = true
read = true
write = true
ls = true
grep = true
glob = true

[github]
default_branch = "main"
conventional_commits = true
auto_link_issues = true

[project.node]
package_manager = "npm"
lint_command = "npm run lint"
test_command = "npm test"
build_command = "npm run build"
dev_command = "npm run dev"

[project.python]
lint_command = "ruff check ."
format_command = "ruff format ."
test_command = "pytest"

[workflow]
default_reviewers = ["team-lead", "senior-dev"]
auto_assign_pr = true
require_tests = true
quality_gates = ["lint", "test", "build"]
conventional_commits = true

[branch]
default_base = "main"
auto_push = true
create_initial_commit = true
require_issue_link = false
max_name_length = 50

[commit]
auto_detect_type = true
require_scope = false
max_header_length = 50
auto_push = false
update_changelog = true

[issues]
priority_labels = ["critical", "high", "medium", "low"]
type_labels = ["bug", "feature", "improvement", "docs", "maintenance"]
status_labels = ["ready", "blocked", "in-progress", "needs-info"]

[pr_review]
auto_checkout = true
run_tests = true
security_scan = true
require_documentation = true
max_file_size = 1000
complexity_threshold = 10
coverage_threshold = 80
```

### Environment Variables

```bash
# GitHub Authentication
GITHUB_TOKEN=your_token_here

# Project Settings  
PROJECT_TYPE=node
DEFAULT_BRANCH=main

# Quality Standards
REQUIRE_TESTS=true
MIN_COVERAGE=80
CONVENTIONAL_COMMITS=true

# Automation Settings
AUTO_ASSIGN_PR=true
AUTO_PUSH_BRANCHES=false
```

### Hooks Configuration

Enable automation hooks in `hooks/github-hooks.toml`:

```toml
[hooks.pre-commit]
enabled = true
# Auto-format and lint before commits

[hooks.post-push]  
enabled = true
# Suggest next actions after push

[hooks.pr-create]
enabled = true
# Auto-configure new PRs

[hooks.security-audit]
enabled = true
trigger = "weekly"
# Weekly security scans
```

## Troubleshooting

### Common Issues

#### 1. GitHub CLI Not Authenticated

**Problem**: Commands fail with authentication errors

**Solution**:
```bash
# Check auth status
gh auth status

# Login if needed
gh auth login

# Verify with test command
gh repo view
```

#### 2. Commands Not Found

**Problem**: Claude Code doesn't recognize commands

**Solution**:
```bash
# Check commands directory exists
ls .claude/commands/

# Re-run installation if missing
cd .claude-commands && ./install.sh

# Verify settings file
cat .claude/settings.toml
```

#### 3. Pre-commit Hooks Failing

**Problem**: Commits fail due to hook errors

**Solution**:
```bash
# Check hook configuration
cat .pre-commit-config.yaml

# Run hooks manually to debug
pre-commit run --all-files

# Skip hooks temporarily (not recommended)
git commit --no-verify -m "message"
```

#### 4. Branch Creation Fails

**Problem**: Cannot create branches

**Solution**:
```bash
# Check git status
git status

# Ensure clean working directory
git stash push -m "temporary stash"

# Check for existing branch
git branch -a | grep branch-name

# Verify remote access
git remote -v
```

#### 5. Quality Checks Failing

**Problem**: Tests or linting fail during workflows

**Solution**:
```bash
# Run checks manually
npm run lint
npm test
npm run build

# Fix issues individually
npm run lint:fix

# Check project setup
/setup
```

### Debug Mode

Enable verbose output for troubleshooting:

```bash
# Add to .claude/settings.toml
[debug]
enabled = true
verbose = true
log_file = ".claude/debug.log"
```

### Getting Help

1. **Check Documentation**:
   - Review this usage guide
   - Check [EXAMPLES.md](EXAMPLES.md) for patterns
   - Read command-specific help

2. **Verify Setup**:
   ```bash
   /setup                    # Re-run environment setup
   gh auth status           # Check GitHub authentication
   git status              # Check repository state
   ```

3. **Manual Alternatives**:
   - All commands have manual alternatives
   - Use GitHub CLI directly: `gh issue list`, `gh pr create`
   - Use standard Git commands: `git checkout -b`, `git commit`

4. **Community Support**:
   - Open issues in the repository
   - Check existing issues for solutions
   - Contribute improvements back to the project

## Advanced Features

### Custom Hooks

Create project-specific hooks:

```bash
# Add to .claude/hooks/custom.toml
[hooks.deploy-staging]
description = "Deploy to staging environment"
trigger = "after_pr_merge"
command = "./scripts/deploy-staging.sh"
```

### Integration with CI/CD

Configure commands to work with your CI/CD pipeline:

```yaml
# .github/workflows/claude-commands.yml
name: Claude Commands Integration
on: [push, pull_request]

jobs:
  quality-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Quality Checks
        run: |
          npm run lint
          npm test
          npm run build
```

### Metrics and Analytics

Track development metrics:

```bash
# Enable metrics collection
[metrics]
enabled = true
track_commit_times = true
track_pr_cycle_time = true
export_format = "csv"
```

### Team Collaboration

Configure for team use:

```toml
[team]
reviewers = ["alice", "bob", "charlie"]
default_assignee = "team-lead"
notification_channels = ["#dev-updates"]

[standards]
commit_message_template = true
pr_template = true
issue_templates = true
```

This usage guide provides comprehensive information for effectively using Claude GitHub Commands in your development workflow. For specific examples and patterns, see [EXAMPLES.md](EXAMPLES.md).