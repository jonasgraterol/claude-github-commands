#!/bin/bash

# Claude GitHub Commands Installation Script
# Installs custom Claude Code commands for GitHub workflows

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_info() {
    print_color "$BLUE" "ℹ️  $1"
}

print_success() {
    print_color "$GREEN" "✅ $1"
}

print_warning() {
    print_color "$YELLOW" "⚠️  $1"
}

print_error() {
    print_color "$RED" "❌ $1"
}

print_header() {
    print_color "$CYAN" "🚀 $1"
}

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Determine target directory (where to install)
# Check current directory first, then parent directory (for submodule usage)
if [[ -f "package.json" ]] || [[ -f "pyproject.toml" ]] || [[ -f "Cargo.toml" ]] || [[ -f "go.mod" ]] || [[ -d ".git" ]]; then
    TARGET_DIR="$(pwd)"
elif [[ -f "../package.json" ]] || [[ -f "../pyproject.toml" ]] || [[ -f "../Cargo.toml" ]] || [[ -f "../go.mod" ]] || [[ -d "../.git" ]]; then
    TARGET_DIR="$(cd .. && pwd)"
    print_info "Detected project in parent directory: $TARGET_DIR"
else
    print_error "No project detected in current directory or parent directory."
    print_info "Please run from a project root, or from within the .claude-commands submodule."
    print_info "Expected files: package.json, pyproject.toml, Cargo.toml, go.mod, or .git directory"
    exit 1
fi

CLAUDE_DIR="$TARGET_DIR/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
SETTINGS_FILE="$CLAUDE_DIR/settings.toml"

print_header "Claude GitHub Commands Installation"
print_info "Installing to: $TARGET_DIR"

# Check dependencies
check_dependencies() {
    print_info "Checking dependencies..."
    
    local missing_deps=()
    
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    if ! command -v gh &> /dev/null; then
        missing_deps+=("github-cli")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Please install:"
        for dep in "${missing_deps[@]}"; do
            case $dep in
                "git")
                    echo "  - Git: https://git-scm.com/"
                    ;;
                "github-cli")
                    echo "  - GitHub CLI: https://cli.github.com/"
                    ;;
            esac
        done
        exit 1
    fi
    
    print_success "All dependencies found"
}

# Detect project type
detect_project_type() {
    print_info "Detecting project type..."
    
    local project_types=()
    
    if [[ -f "package.json" ]]; then
        project_types+=("node")
        if grep -q "react" package.json; then
            project_types+=("react")
        fi
    fi
    
    if [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
        project_types+=("python")
    fi
    
    if [[ -f "Cargo.toml" ]]; then
        project_types+=("rust")
    fi
    
    if [[ -f "go.mod" ]]; then
        project_types+=("go")
    fi
    
    if [[ -f "composer.json" ]]; then
        project_types+=("php")
    fi
    
    if [[ ${#project_types[@]} -eq 0 ]]; then
        project_types+=("generic")
    fi
    
    print_success "Detected project types: ${project_types[*]}"
    echo "${project_types[@]}"
}

# Create directory structure
create_directories() {
    print_info "Creating directory structure..."
    
    mkdir -p "$COMMANDS_DIR"
    mkdir -p "$CLAUDE_DIR/hooks"
    
    print_success "Directories created"
}

# Copy command files
copy_commands() {
    print_info "Copying command files..."
    
    local source_commands="$SCRIPT_DIR/commands"
    
    if [[ ! -d "$source_commands" ]]; then
        print_error "Commands directory not found: $source_commands"
        exit 1
    fi
    
    cp -r "$source_commands"/* "$COMMANDS_DIR/"
    
    print_success "Commands copied successfully"
}

# Create or update settings.toml
create_settings() {
    print_info "Creating Claude settings..."
    
    local project_types
    project_types=($(detect_project_type))
    
    # Create settings.toml if it doesn't exist
    if [[ ! -f "$SETTINGS_FILE" ]]; then
        cat > "$SETTINGS_FILE" << 'EOF'
[tools]
# Enable all tools by default
bash = true
edit = true
read = true
write = true
ls = true
grep = true
glob = true

[github]
# GitHub-specific settings
default_branch = "main"
conventional_commits = true
auto_link_issues = true

EOF
    fi
    
    # Add project-specific settings
    if [[ " ${project_types[*]} " =~ " node " ]]; then
        cat >> "$SETTINGS_FILE" << 'EOF'

[project.node]
# Node.js project settings
package_manager = "npm"
lint_command = "npm run lint"
test_command = "npm test"
build_command = "npm run build"
dev_command = "npm run dev"

EOF
    fi
    
    if [[ " ${project_types[*]} " =~ " python " ]]; then
        cat >> "$SETTINGS_FILE" << 'EOF'

[project.python]
# Python project settings
lint_command = "ruff check ."
format_command = "ruff format ."
test_command = "pytest"

EOF
    fi
    
    print_success "Settings configured"
}

# Copy hooks
copy_hooks() {
    print_info "Installing automation hooks..."
    
    local source_hooks="$SCRIPT_DIR/hooks"
    
    if [[ -d "$source_hooks" ]]; then
        cp -r "$source_hooks"/* "$CLAUDE_DIR/hooks/"
        print_success "Hooks installed"
    else
        print_warning "No hooks directory found, skipping"
    fi
}

# Verify GitHub authentication
verify_github_auth() {
    print_info "Verifying GitHub authentication..."
    
    if gh auth status &> /dev/null; then
        print_success "GitHub CLI authenticated"
    else
        print_warning "GitHub CLI not authenticated"
        print_info "Run 'gh auth login' to authenticate"
    fi
}

# Create update script
create_update_script() {
    print_info "Creating update script..."
    
    cat > "$TARGET_DIR/update-claude-commands.sh" << EOF
#!/bin/bash
# Auto-generated update script for Claude GitHub Commands

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "\${BLUE}ℹ️  \$1\${NC}"
}

print_success() {
    echo -e "\${GREEN}✅ \$1\${NC}"
}

print_info "Updating Claude GitHub Commands..."

# Determine if this is a submodule installation
if [[ -f ".gitmodules" ]] && grep -q "claude-github-commands" .gitmodules; then
    print_info "Updating submodule..."
    git submodule update --remote .claude-commands
    cd .claude-commands
else
    # Direct installation - pull latest changes
    COMMANDS_SOURCE="\$(dirname "\$0")/.claude-commands"
    if [[ -d "\$COMMANDS_SOURCE" ]]; then
        cd "\$COMMANDS_SOURCE"
        git pull origin main
    else
        print_info "Commands source not found, skipping update"
        exit 1
    fi
fi

# Re-run installation
./install.sh

print_success "Update completed!"
EOF
    
    chmod +x "$TARGET_DIR/update-claude-commands.sh"
    
    print_success "Update script created: update-claude-commands.sh"
}

# Verify installation
verify_installation() {
    print_info "Verifying installation..."
    
    local errors=()
    
    if [[ ! -d "$COMMANDS_DIR" ]]; then
        errors+=("Commands directory not found")
    fi
    
    if [[ ! -f "$SETTINGS_FILE" ]]; then
        errors+=("Settings file not found")
    fi
    
    # Check if at least some commands exist
    local command_count
    command_count=$(find "$COMMANDS_DIR" -name "*.md" | wc -l)
    if [[ $command_count -eq 0 ]]; then
        errors+=("No command files found")
    fi
    
    if [[ ${#errors[@]} -gt 0 ]]; then
        print_error "Installation verification failed:"
        for error in "${errors[@]}"; do
            echo "  - $error"
        done
        exit 1
    fi
    
    print_success "Installation verified successfully"
    print_success "Found $command_count command(s)"
}

# Print completion message
print_completion() {
    print_header "Installation Complete!"
    print_info "Available commands:"
    
    # List available commands
    for cmd_file in "$COMMANDS_DIR"/*.md; do
        if [[ -f "$cmd_file" ]]; then
            local cmd_name
            cmd_name=$(basename "$cmd_file" .md)
            echo "  /$cmd_name"
        fi
    done
    
    echo ""
    print_info "Next steps:"
    echo "  1. Authenticate with GitHub: gh auth login"
    echo "  2. Start using commands in Claude Code: /issue 123"
    echo "  3. Run ./update-claude-commands.sh to update"
    
    echo ""
    print_info "Documentation:"
    echo "  - Usage guide: docs/USAGE.md"
    echo "  - Examples: docs/EXAMPLES.md"
}

# Main installation process
main() {
    check_dependencies
    create_directories
    copy_commands
    create_settings
    copy_hooks
    verify_github_auth
    create_update_script
    verify_installation
    print_completion
}

# Run main function
main "$@"