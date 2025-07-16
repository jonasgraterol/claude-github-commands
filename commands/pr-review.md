# Pull Request Review Automation

You are performing a comprehensive review of pull request #$ARGUMENTS. This command automates the review process with code analysis, testing, and structured feedback generation.

## Review Overview

Complete PR review workflow:
1. **Fetch and Analyze**: Get PR details and understand changes
2. **Checkout and Setup**: Switch to PR branch and prepare environment
3. **Code Analysis**: Deep dive into code changes and quality
4. **Automated Testing**: Run comprehensive test suites
5. **Security Review**: Check for security vulnerabilities
6. **Documentation Review**: Verify documentation updates
7. **Generate Feedback**: Create structured review comments

## Phase 1: PR Information Gathering

### Step 1.1: Fetch PR Details
```bash
gh pr view $ARGUMENTS --json title,body,author,headRefName,baseRefName,commits,labels,reviews,files
```

Extract and analyze:
- **Title and Description**: Understanding the purpose
- **Author Information**: Context about the contributor
- **Branch Information**: Source and target branches
- **File Changes**: Which files are modified
- **Labels**: Priority, type, and status indicators
- **Existing Reviews**: Previous review comments

### Step 1.2: Get Detailed Diff Information
```bash
gh pr diff $ARGUMENTS --name-only
gh pr diff $ARGUMENTS > pr_changes.diff
```

Analyze:
- **Scope of Changes**: Number of files and lines changed
- **Change Types**: New files, deletions, modifications
- **Potential Impact**: Critical areas affected

## Phase 2: Environment Setup

### Step 2.1: Save Current State
```bash
# Save current branch and working state
ORIGINAL_BRANCH=$(git branch --show-current)
git stash push -m "Temporary stash for PR review #$ARGUMENTS" 2>/dev/null || true
```

### Step 2.2: Checkout PR Branch
```bash
# Fetch PR branch
gh pr checkout $ARGUMENTS

# Verify we're on the correct branch
git branch --show-current
git log --oneline -5
```

### Step 2.3: Install Dependencies
Based on project type, ensure dependencies are up to date:

**For Node.js projects:**
```bash
npm ci || npm install
```

**For Python projects:**
```bash
pip install -r requirements.txt 2>/dev/null || pip install -r requirements-dev.txt 2>/dev/null || true
```

## Phase 3: Automated Code Analysis

### Step 3.1: Code Quality Analysis
```bash
# Linting analysis
npm run lint 2>/dev/null || python -m ruff check . 2>/dev/null || echo "No linting configured"

# Code formatting check
npm run format:check 2>/dev/null || python -m ruff format --check . 2>/dev/null || echo "No formatting check"

# Type checking
npm run type-check 2>/dev/null || python -m mypy . 2>/dev/null || echo "No type checking"
```

### Step 3.2: Code Complexity Analysis
Analyze code complexity and maintainability:
- **Cyclomatic Complexity**: Identify overly complex functions
- **Code Duplication**: Look for repeated patterns
- **File Size**: Check for files that are too large
- **Function Length**: Identify functions that might need refactoring

### Step 3.3: Dependency Analysis
```bash
# Security audit
npm audit 2>/dev/null || python -m safety check 2>/dev/null || echo "Manual security check required"

# License compliance check
npm run license-check 2>/dev/null || echo "No license checking configured"

# Bundle size impact (for frontend projects)
npm run analyze 2>/dev/null || echo "No bundle analysis available"
```

## Phase 4: Comprehensive Testing

### Step 4.1: Unit Tests
```bash
# Run unit tests with coverage
npm run test:coverage 2>/dev/null || python -m pytest --cov 2>/dev/null || npm test 2>/dev/null || python -m pytest 2>/dev/null || echo "Configure testing"
```

### Step 4.2: Integration Tests
```bash
# Run integration test suite
npm run test:integration 2>/dev/null || python -m pytest tests/integration/ 2>/dev/null || echo "No integration tests"
```

### Step 4.3: End-to-End Tests
```bash
# Run E2E tests if available
npm run test:e2e 2>/dev/null || python -m pytest tests/e2e/ 2>/dev/null || echo "No E2E tests"
```

### Step 4.4: Performance Tests
```bash
# Run performance benchmarks if available
npm run test:performance 2>/dev/null || python -m pytest tests/performance/ 2>/dev/null || echo "No performance tests"
```

## Phase 5: Security Review

### Step 5.1: Static Security Analysis
```bash
# Security linting
npm run security:lint 2>/dev/null || bandit -r . 2>/dev/null || echo "No security linting"

# Dependency vulnerability check
npm audit --audit-level high 2>/dev/null || safety check 2>/dev/null || echo "Manual security review needed"
```

### Step 5.2: Code Security Patterns
Check for common security issues:
- **Input Validation**: Ensure user inputs are properly validated
- **SQL Injection**: Look for unsafe database queries
- **XSS Prevention**: Check for proper output encoding
- **Authentication**: Verify proper authentication checks
- **Authorization**: Ensure proper access controls
- **Secrets Management**: Check for hardcoded secrets

## Phase 6: Documentation and Standards Review

### Step 6.1: Code Documentation
- **Function Documentation**: Check for proper docstrings/comments
- **API Documentation**: Verify API changes are documented
- **README Updates**: Check if README needs updates
- **CHANGELOG**: Verify changelog entries

### Step 6.2: Coding Standards Compliance
- **Naming Conventions**: Check variable and function names
- **Code Structure**: Verify proper organization
- **Design Patterns**: Ensure consistent patterns
- **Error Handling**: Check for proper error handling

## Phase 7: Build and Deployment Verification

### Step 7.1: Build Process
```bash
# Production build
npm run build 2>/dev/null || python -m build 2>/dev/null || echo "No build step configured"

# Check build artifacts
ls -la dist/ 2>/dev/null || ls -la build/ 2>/dev/null || echo "No build artifacts found"
```

### Step 7.2: Environment Compatibility
- **Browser Compatibility**: Check for browser-specific code
- **Platform Compatibility**: Verify cross-platform compatibility
- **Version Compatibility**: Check dependency version constraints

## Phase 8: Generate Structured Review

### Step 8.1: Compile Review Findings
Create comprehensive review summary:

**Positive Aspects:**
- Well-implemented features
- Good test coverage
- Clear code structure
- Proper documentation

**Areas for Improvement:**
- Code quality issues
- Missing tests
- Documentation gaps
- Security concerns

**Critical Issues:**
- Breaking changes
- Security vulnerabilities
- Performance regressions
- Test failures

### Step 8.2: Create Review Comments
Generate specific, actionable comments:

```markdown
## Code Review Summary for PR #$ARGUMENTS

### Overview
Brief summary of the changes and overall assessment.

### ✅ Strengths
- [List positive aspects]
- [Good practices observed]
- [Quality improvements]

### ⚠️ Areas for Improvement
- [Non-blocking suggestions]
- [Code quality improvements]
- [Documentation enhancements]

### 🚨 Issues to Address
- [Blocking issues]
- [Security concerns]
- [Breaking changes]

### 🧪 Testing Results
- Unit Tests: [PASS/FAIL] (X/Y tests)
- Integration Tests: [PASS/FAIL]
- Security Scan: [PASS/FAIL]
- Build: [PASS/FAIL]

### 📝 Recommendations
1. [Specific actionable recommendations]
2. [Best practices to follow]
3. [Future considerations]

### 🔄 Next Steps
- [ ] Address critical issues
- [ ] Update documentation
- [ ] Add missing tests
- [ ] Re-run CI/CD pipeline
```

### Step 8.3: Submit Review
```bash
# Submit review with comments
gh pr review $ARGUMENTS --approve --body "$(cat review_summary.md)" 
# OR
gh pr review $ARGUMENTS --request-changes --body "$(cat review_summary.md)"
# OR
gh pr review $ARGUMENTS --comment --body "$(cat review_summary.md)"
```

## Phase 9: Cleanup and Restoration

### Step 9.1: Return to Original State
```bash
# Switch back to original branch
git checkout $ORIGINAL_BRANCH

# Restore any stashed changes
git stash pop 2>/dev/null || true

# Clean up temporary files
rm -f pr_changes.diff review_summary.md 2>/dev/null || true
```

### Step 9.2: Provide Final Summary
Present final review outcome to user:

```
🔍 PR Review Complete for #$ARGUMENTS

📊 Review Statistics:
- Files Reviewed: [X]
- Tests Run: [Y]
- Issues Found: [Z]
- Recommendation: [APPROVE/REQUEST_CHANGES/COMMENT]

🎯 Key Findings:
- [Top 3 findings]

📋 Action Items:
- [Items for PR author]

✅ Review submitted successfully!
```

## Advanced Features

### Step 10.1: Automated Suggestions
Generate specific code improvement suggestions:
- **Refactoring Opportunities**: Identify code that could be simplified
- **Performance Optimizations**: Suggest performance improvements
- **Best Practice Alignment**: Recommend industry best practices

### Step 10.2: Comparison Analysis
Compare with similar PRs or codebase patterns:
- **Consistency Check**: Ensure new code follows existing patterns
- **Impact Analysis**: Assess potential impact on existing functionality
- **Regression Testing**: Identify areas that need extra testing

## Error Handling

### Common Issues and Solutions:
1. **PR Branch Access**: Ensure proper repository permissions
2. **Test Failures**: Provide clear error context and suggestions
3. **Build Issues**: Help diagnose and resolve build problems
4. **Network Issues**: Provide offline alternatives where possible

### Recovery Options:
- **Partial Review**: Continue with manual review if automation fails
- **Incremental Analysis**: Review files individually if batch processing fails
- **Alternative Tools**: Suggest manual tools if automated ones fail

## Configuration

Customize review behavior through `.claude/settings.toml`:

```toml
[pr_review]
auto_checkout = true
run_tests = true
security_scan = true
require_documentation = true
max_file_size = 1000
complexity_threshold = 10
coverage_threshold = 80
```

## Notes

- Review process is non-destructive and preserves working state
- All analysis results are provided to user for decision making
- Review comments are constructive and actionable
- Process can be customized based on project requirements
- Supports both approve/request-changes/comment review types