# GitHub Issues Management

You are helping the user manage and analyze GitHub issues. This command provides comprehensive issue filtering, categorization, and actionable recommendations.

## Command Usage

The issues command supports various filters and arguments:
- `/issues` - List all open issues
- `/issues --priority high` - Filter by priority
- `/issues --type bug` - Filter by issue type
- `/issues --assignee @me` - Filter by assignee
- `/issues --milestone v2.0` - Filter by milestone
- `/issues --label "needs-review"` - Filter by label
- `/issues --state all` - Include closed issues

Arguments: $ARGUMENTS

## Phase 1: Issue Data Collection

### Step 1.1: Parse Command Arguments
Parse the provided arguments to determine filters:

```bash
# Set default filters
STATE="open"
ASSIGNEE=""
LABELS=""
MILESTONE=""
PRIORITY=""
TYPE=""

# Parse arguments from $ARGUMENTS
# Example parsing for: --priority high --type bug --assignee @me
```

### Step 1.2: Fetch Issues with Filters
```bash
# Base GitHub CLI command
gh issue list --state $STATE --json number,title,body,labels,assignees,milestone,createdAt,updatedAt,author,state

# Apply additional filters based on parsed arguments
if [[ -n "$ASSIGNEE" ]]; then
    gh issue list --assignee "$ASSIGNEE" --state $STATE --json number,title,body,labels,assignees,milestone,createdAt,updatedAt,author,state
fi

if [[ -n "$LABELS" ]]; then
    gh issue list --label "$LABELS" --state $STATE --json number,title,body,labels,assignees,milestone,createdAt,updatedAt,author,state
fi

if [[ -n "$MILESTONE" ]]; then
    gh issue list --milestone "$MILESTONE" --state $STATE --json number,title,body,labels,assignees,milestone,createdAt,updatedAt,author,state
fi
```

## Phase 2: Issue Classification and Analysis

### Step 2.1: Categorize by Type
Analyze issue labels and content to classify:

**Bug Issues:**
- Labels: `bug`, `defect`, `error`, `crash`
- Keywords: "error", "crash", "broken", "doesn't work", "fails"

**Feature Requests:**
- Labels: `feature`, `enhancement`, `new feature`
- Keywords: "add", "implement", "create", "new"

**Improvements:**
- Labels: `improvement`, `optimization`, `refactor`
- Keywords: "improve", "optimize", "refactor", "better"

**Documentation:**
- Labels: `documentation`, `docs`
- Keywords: "document", "readme", "docs", "guide"

**Maintenance:**
- Labels: `maintenance`, `chore`, `dependencies`
- Keywords: "update", "upgrade", "maintain", "clean"

### Step 2.2: Determine Priority Levels
Analyze labels and content for priority:

**Critical Priority:**
- Labels: `critical`, `urgent`, `p0`, `blocker`
- Impact: Production down, security issues, data loss

**High Priority:**
- Labels: `high priority`, `p1`, `important`
- Impact: Major feature broken, significant user impact

**Medium Priority:**
- Labels: `medium priority`, `p2`
- Impact: Minor feature issues, moderate user impact

**Low Priority:**
- Labels: `low priority`, `p3`, `nice-to-have`
- Impact: Cosmetic issues, quality-of-life improvements

### Step 2.3: Assess Complexity and Effort
Estimate effort based on:
- **Simple**: Small fixes, documentation updates, single file changes
- **Medium**: Feature additions, multi-file changes, requires testing
- **Complex**: Major features, architectural changes, extensive testing

## Phase 3: Issue Organization and Presentation

### Step 3.1: Group Issues by Category
Create organized groups:

```markdown
## 🚨 Critical Issues (P0)
[List critical issues requiring immediate attention]

## 🔴 High Priority Issues (P1)
[List high priority issues for next sprint]

## 🟡 Medium Priority Issues (P2)
[List medium priority issues for backlog]

## 🟢 Low Priority Issues (P3)
[List low priority issues for future consideration]
```

### Step 3.2: Categorize by Type
```markdown
## 🐛 Bug Fixes
[List all bug-related issues]

## ✨ Feature Requests
[List new feature requests]

## 🔧 Improvements & Optimizations
[List enhancement issues]

## 📚 Documentation
[List documentation-related issues]

## 🧹 Maintenance & Chores
[List maintenance tasks]
```

### Step 3.3: Create Action-Oriented Views
```markdown
## 🎯 Ready for Development
Issues that are well-defined and ready to be worked on:
- Clear requirements
- Proper labeling
- No blocking dependencies

## 🔍 Needs Clarification
Issues requiring more information:
- Missing requirements
- Unclear scope
- Needs product input

## 👥 Needs Assignment
Issues ready for work but unassigned:
- Well-defined scope
- Proper priority
- No assignee

## 🔄 In Progress
Issues currently being worked on:
- Has assignee
- Recent activity
- Linked to branches/PRs
```

## Phase 4: Generate Actionable Insights

### Step 4.1: Issue Statistics
```markdown
## 📊 Issue Statistics

**Total Issues:** [X]
**Open Issues:** [Y]
**Closed Issues:** [Z]

**By Priority:**
- Critical: [A] issues
- High: [B] issues  
- Medium: [C] issues
- Low: [D] issues

**By Type:**
- Bugs: [E] issues
- Features: [F] issues
- Improvements: [G] issues
- Documentation: [H] issues
- Maintenance: [I] issues

**By Status:**
- Ready for Development: [J] issues
- Needs Clarification: [K] issues
- Needs Assignment: [L] issues
- In Progress: [M] issues
```

### Step 4.2: Trends and Patterns
Identify patterns in issues:
- **Recent Activity**: Issues with recent updates
- **Stale Issues**: Issues without activity for >30 days
- **Popular Issues**: Issues with most comments/reactions
- **Quick Wins**: Low-effort, high-impact issues

### Step 4.3: Resource Allocation Suggestions
```markdown
## 💡 Recommendations

### Immediate Actions Needed:
1. **Critical Issues**: [X] issues need immediate attention
2. **Blocked Issues**: [Y] issues are waiting for dependencies
3. **Stale Issues**: [Z] issues need triage or closure

### Sprint Planning Suggestions:
1. **High-Impact Quick Wins**: [List 3-5 easy but valuable issues]
2. **Technical Debt**: [List maintenance issues to address]
3. **User-Facing Improvements**: [List issues that improve UX]

### Resource Allocation:
- **Bug Fixing**: [X]% of effort recommended
- **New Features**: [Y]% of effort recommended  
- **Technical Debt**: [Z]% of effort recommended
```

## Phase 5: Advanced Filtering and Search

### Step 5.1: Smart Search Capabilities
Enable natural language search:
- "Show me all high priority bugs"
- "Find issues related to authentication"
- "List unassigned feature requests"
- "Show me stale issues older than 2 months"

### Step 5.2: Custom Filters
Support advanced filtering:
```bash
# Age-based filtering
gh issue list --created ">2023-01-01"
gh issue list --updated "<2023-12-01"

# Content-based filtering
gh issue list | grep -i "authentication"
gh issue list | grep -i "performance"

# Reaction-based filtering (popular issues)
gh issue list --json reactions | jq '.[] | select(.reactions.total_count > 5)'
```

### Step 5.3: Related Issue Detection
Find related issues by:
- **Similar Titles**: Use text similarity to group related issues
- **Common Labels**: Issues sharing specific labels
- **Linked Issues**: Issues that reference each other
- **Author Patterns**: Issues from the same contributor

## Phase 6: Issue Management Actions

### Step 6.1: Bulk Operations
Provide options for bulk actions:
```markdown
## 🔧 Bulk Actions Available

Based on the current issue list, you can:

1. **Label Management:**
   - Add priority labels to unlabeled issues
   - Add type labels based on content analysis
   - Update milestone assignments

2. **Assignment Management:**
   - Auto-assign based on expertise areas
   - Balance workload across team members
   - Assign quick wins to new contributors

3. **Cleanup Actions:**
   - Close duplicate issues
   - Archive stale issues (with confirmation)
   - Update outdated issue templates
```

### Step 6.2: Issue Creation Helpers
```markdown
## ➕ Create New Issues

Quick issue creation for common patterns:

1. **Bug Report Template**: `/create-bug-issue`
2. **Feature Request Template**: `/create-feature-issue`
3. **Documentation Issue**: `/create-docs-issue`
4. **Performance Issue**: `/create-performance-issue`
```

## Phase 7: Reporting and Export

### Step 7.1: Generate Reports
Create formatted reports:

```markdown
# GitHub Issues Report
Generated on: [DATE]
Repository: [REPO_NAME]

## Executive Summary
[High-level overview of issue status]

## Detailed Analysis
[Comprehensive breakdown by categories]

## Action Items
[Specific recommendations for team]

## Appendix
[Raw data and additional metrics]
```

### Step 7.2: Export Options
Provide data in different formats:
- **Markdown Report**: For documentation
- **CSV Export**: For spreadsheet analysis
- **JSON Export**: For external tool integration
- **GitHub Project**: Create/update project boards

## Configuration and Customization

### Step 8.1: Custom Labels and Classifications
Configure through `.claude/settings.toml`:

```toml
[issues]
priority_labels = ["critical", "high", "medium", "low"]
type_labels = ["bug", "feature", "improvement", "docs", "maintenance"]
status_labels = ["ready", "blocked", "in-progress", "needs-info"]

[issues.filters]
default_state = "open"
default_sort = "updated"
max_results = 100

[issues.classification]
auto_label = true
sentiment_analysis = false
complexity_estimation = true
```

### Step 8.2: Team-Specific Views
Create role-based views:
- **Developer View**: Focus on technical issues
- **Product Manager View**: Focus on features and priorities
- **QA View**: Focus on bugs and testing issues
- **Documentation View**: Focus on docs and user guides

## Error Handling and Edge Cases

### Common Scenarios:
1. **No Issues Found**: Provide helpful guidance on issue creation
2. **Rate Limiting**: Handle GitHub API limits gracefully
3. **Permission Issues**: Guide user on repository access
4. **Large Issue Lists**: Implement pagination and summarization

### Recovery Options:
- **Offline Mode**: Use cached data when API is unavailable
- **Manual Filtering**: Provide CLI commands for manual operations
- **Simplified Views**: Fall back to basic listing when complex analysis fails

## Output Format

The command will output a structured, readable format with:
- Clear section headers
- Color-coded priority indicators (when terminal supports)
- Clickable issue links
- Action recommendations
- Summary statistics

All output is optimized for both terminal viewing and copy-paste into documentation or reports.