# Claude GitHub Commands

A comprehensive collection of custom Claude Code commands for streamlined GitHub workflows. This repository provides pre-built slash commands that automate common development tasks including issue management, branch operations, pull request workflows, and development environment setup.

## Features

- **Complete GitHub Integration**: Seamless integration with GitHub CLI and Git
- **Automated Workflows**: End-to-end automation from issue creation to PR merge
- **Smart Project Detection**: Automatically detects project type and configures appropriate tooling
- **Conventional Standards**: Follows conventional commits, branch naming, and PR conventions
- **Quality Assurance**: Built-in linting, testing, and build verification
- **Internationalization Ready**: All commands and documentation in English for global teams

## Installation

### As Git Submodule (Recommended)

Add this repository as a submodule to your project:

```bash
# Add submodule
git submodule add https://github.com/your-username/claude-github-commands .claude-commands

# Initialize and update
git submodule update --init --recursive

# Run installation
./.claude-commands/install.sh
```

### Direct Installation

```bash
# Clone repository
git clone https://github.com/your-username/claude-github-commands
cd claude-github-commands

# Run installation script
./install.sh
```

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/issue` | Work on a specific GitHub issue | `/issue 123` |
| `/workflow` | Complete issue � branch � development � PR workflow | `/workflow 456` |
| `/pr-review` | Review and analyze a pull request | `/pr-review 789` |
| `/issues` | List and filter GitHub issues | `/issues --priority high` |
| `/setup` | Setup development environment | `/setup` |
| `/branch` | Smart branch creation and management | `/branch feature/new-feature` |
| `/commit` | Create conventional commits | `/commit "Add new feature"` |

## Prerequisites

- [Git](https://git-scm.com/) installed and configured
- [GitHub CLI](https://cli.github.com/) installed and authenticated (`gh auth login`)
- [Claude Code](https://claude.ai/code) installed and configured
- Project must be a Git repository with GitHub remote

## Quick Start

1. **Install the commands** using the installation method above
2. **Authenticate with GitHub**: `gh auth login`
3. **Start using commands** in Claude Code: `/issue 123`

## Command Details

### `/issue <number>`
Automatically fetches issue details, creates a feature branch, and sets up the development environment for working on a specific GitHub issue.

### `/workflow <number>`
Executes a complete development workflow:
1. Fetches issue information
2. Creates appropriately named branch
3. Guides through development process
4. Runs quality checks (lint, test, build)
5. Creates pull request with conventional format

### `/pr-review <number>`
Reviews a pull request by:
1. Checking out the PR branch
2. Analyzing code changes
3. Running automated tests
4. Providing structured feedback

### `/issues [filters]`
Lists and filters GitHub issues with:
- Priority categorization
- Type classification (bug, feature, enhancement)
- Action recommendations
- Search capabilities

### `/setup`
Automatically detects project type and sets up:
- Development dependencies
- Environment configuration
- Git hooks
- Quality tools

### `/branch <name>`
Creates branches with:
- Automatic type detection (feature/fix/docs)
- Standard naming conventions
- Pre-creation validation

### `/commit <message>`
Creates commits following:
- Conventional commit format
- Automatic type detection
- Pre-commit hook execution

## Project Structure

```
claude-github-commands/
├── README.md                 # This file
├── install.sh               # Installation script
├── commands/                 # Slash commands
│   ├── issue.md
│   ├── workflow.md
│   ├── pr-review.md
│   ├── issues.md
│   ├── setup.md
│   ├── branch.md
│   └── commit.md
├── hooks/                    # Automation hooks
│   └── github-hooks.toml
├── docs/                     # Documentation
│   ├── USAGE.md
│   └── EXAMPLES.md
└── templates/                # Project templates
    └── README.md
```
## Updating

To update to the latest version:

```bash
# If installed as submodule
git submodule update --remote .claude-commands
cd .claude-commands && ./install.sh

# If installed directly
cd claude-github-commands
git pull origin main
./install.sh
```

## Configuration

Commands can be customized by editing `.claude/settings.toml` in your project. The installation script creates sensible defaults, but you can modify:

- Default branch naming patterns
- Commit message templates
- Quality check commands
- GitHub issue labels

## Troubleshooting

### Common Issues

1. **GitHub CLI not authenticated**: Run `gh auth login`
2. **Commands not found**: Ensure `.claude/commands/` directory exists and contains command files
3. **Permission denied**: Make sure `install.sh` is executable (`chmod +x install.sh`)

### Getting Help

- Check [Usage Documentation](docs/USAGE.md) for detailed command explanations
- Review [Examples](docs/EXAMPLES.md) for common workflow patterns
- Open an issue in this repository for bugs or feature requests

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Related Projects

- [Claude Code](https://claude.ai/code) - The official CLI for Claude
- [GitHub CLI](https://cli.github.com/) - GitHub's official command line tool
- [Conventional Commits](https://www.conventionalcommits.org/) - Commit message specification