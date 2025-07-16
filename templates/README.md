# Project Template README

This directory contains templates for different project types that can be used with Claude GitHub Commands. These templates provide standardized project structures and configurations optimized for use with the command suite.

## Available Templates

### JavaScript/Node.js Templates

- **`javascript/`** - Basic JavaScript/Node.js project template
- **`react/`** - React application template with modern tooling
- **`node/`** - Node.js backend service template

### Python Templates

- **`python/`** - Basic Python project template with modern tooling

## Template Structure

Each template includes:

- **Project Structure**: Recommended directory layout
- **Configuration Files**: Pre-configured linting, testing, and build tools
- **Documentation**: README template, contribution guidelines
- **GitHub Integration**: Issue templates, PR templates, workflows
- **Claude Commands**: Pre-configured settings for optimal command usage

## Using Templates

### Option 1: Manual Template Usage

1. **Copy Template**:
   ```bash
   cp -r templates/react/* your-new-project/
   cd your-new-project
   ```

2. **Customize Project**:
   ```bash
   # Update package.json with your project details
   # Modify README.md with your project information
   # Update configuration files as needed
   ```

3. **Install Commands**:
   ```bash
   git submodule add https://github.com/your-username/claude-github-commands .claude-commands
   cd .claude-commands && ./install.sh
   ```

### Option 2: Automated Setup (Future Enhancement)

```bash
# Future command for creating projects from templates
/create-project --template react --name my-awesome-app
```

## Template Features

### Common Features (All Templates)

- **Git Configuration**: Pre-configured `.gitignore` and Git hooks
- **Code Quality**: ESLint/Ruff, Prettier/Black, pre-commit hooks
- **Testing**: Test framework setup with coverage reporting
- **Documentation**: README template, API docs structure
- **CI/CD**: GitHub Actions workflows
- **Claude Commands**: Optimized settings and configurations

### JavaScript/React Features

- Modern build tools (Vite/Webpack)
- TypeScript support
- Component testing setup
- Storybook integration (React)
- Bundle analysis tools

### Python Features

- Virtual environment setup
- Modern packaging (pyproject.toml)
- Type checking with mypy
- Documentation with Sphinx
- Poetry/pip-tools for dependency management

## Template Customization

### Project-Specific Settings

Each template includes a `.claude/settings.toml` file that can be customized:

```toml
[project]
name = "Your Project Name"
type = "react"  # or "node", "python", etc.
description = "Project description"

[github]
default_branch = "main"
issue_labels = ["bug", "feature", "enhancement"]
pr_template = true

[quality]
lint_command = "npm run lint"
test_command = "npm test"
build_command = "npm run build"
coverage_threshold = 80

[workflow]
auto_assign_pr = true
require_tests = true
conventional_commits = true
```

### GitHub Templates

Templates include GitHub-specific files:

```
.github/
├── ISSUE_TEMPLATE/
│   ├── bug_report.md
│   ├── feature_request.md
│   └── enhancement.md
├── PULL_REQUEST_TEMPLATE.md
└── workflows/
    ├── ci.yml
    ├── release.yml
    └── deploy.yml
```

### Development Scripts

Common development scripts in `package.json` or `Makefile`:

```json
{
  "scripts": {
    "dev": "Start development server",
    "build": "Build for production",
    "test": "Run test suite",
    "test:watch": "Run tests in watch mode",
    "test:coverage": "Run tests with coverage",
    "lint": "Run linting",
    "lint:fix": "Fix linting issues",
    "format": "Format code",
    "type-check": "Run type checking"
  }
}
```

## Contributing New Templates

### Template Requirements

1. **Complete Setup**: Template should work out-of-the-box
2. **Best Practices**: Follow current industry standards
3. **Documentation**: Include comprehensive README
4. **Testing**: Include test setup and examples
5. **Claude Integration**: Optimized for Claude Commands

### Template Structure

```
templates/new-template/
├── README.md                     # Template-specific documentation
├── package.json                  # Dependencies and scripts
├── .gitignore                   # Git ignore patterns
├── .claude/
│   └── settings.toml            # Claude Commands configuration
├── .github/
│   ├── ISSUE_TEMPLATE/          # GitHub issue templates
│   ├── PULL_REQUEST_TEMPLATE.md # PR template
│   └── workflows/               # GitHub Actions
├── src/                         # Source code structure
├── tests/                       # Test structure
├── docs/                        # Documentation structure
└── scripts/                     # Utility scripts
```

### Adding a New Template

1. **Create Template Directory**:
   ```bash
   mkdir templates/my-new-template
   cd templates/my-new-template
   ```

2. **Add Required Files**:
   - Project configuration files
   - Source code structure
   - Test setup
   - Documentation templates
   - GitHub integration files

3. **Configure Claude Settings**:
   ```toml
   # .claude/settings.toml
   [project.my-new-template]
   type = "my-new-template"
   lint_command = "your-lint-command"
   test_command = "your-test-command"
   build_command = "your-build-command"
   ```

4. **Test Template**:
   ```bash
   # Create test project from template
   cp -r templates/my-new-template /tmp/test-project
   cd /tmp/test-project
   
   # Verify setup works
   ./install.sh
   npm install  # or equivalent
   npm test     # or equivalent
   ```

5. **Document Template**:
   - Update this README with template information
   - Create template-specific documentation
   - Add usage examples

## Template Maintenance

### Regular Updates

Templates should be regularly updated to:
- Use latest tool versions
- Follow current best practices  
- Include new Claude Commands features
- Address security vulnerabilities

### Version Compatibility

Templates include version information:

```json
{
  "template": {
    "name": "react",
    "version": "1.2.0",
    "claude-commands": ">=1.0.0",
    "node": ">=18.0.0"
  }
}
```

## Examples

### Creating a React Project

```bash
# 1. Copy React template
cp -r claude-github-commands/templates/react my-react-app
cd my-react-app

# 2. Customize project
sed -i 's/PROJECT_NAME/my-react-app/g' package.json
sed -i 's/PROJECT_DESCRIPTION/My awesome React app/g' package.json

# 3. Initialize Git
git init
git add .
git commit -m "initial: bootstrap React project from template"

# 4. Install dependencies
npm install

# 5. Set up Claude Commands
git submodule add https://github.com/your-username/claude-github-commands .claude-commands
cd .claude-commands && ./install.sh

# 6. Start development
npm run dev
```

### Creating a Python Project

```bash
# 1. Copy Python template
cp -r claude-github-commands/templates/python my-python-app
cd my-python-app

# 2. Customize project
sed -i 's/PROJECT_NAME/my-python-app/g' pyproject.toml
sed -i 's/PROJECT_DESCRIPTION/My awesome Python app/g' pyproject.toml

# 3. Set up virtual environment
python -m venv venv
source venv/bin/activate

# 4. Install dependencies
pip install -e .

# 5. Initialize Git and Claude Commands
git init
git add .
git commit -m "initial: bootstrap Python project from template"

git submodule add https://github.com/your-username/claude-github-commands .claude-commands
cd .claude-commands && ./install.sh

# 6. Start development
python -m pytest
```

## Future Enhancements

### Planned Features

1. **Interactive Template Generator**: Command to create projects interactively
2. **Template Registry**: Central registry of community templates  
3. **Template Versioning**: Better version management and updates
4. **Custom Templates**: Easy way to create organization-specific templates
5. **Template Testing**: Automated testing of template integrity

### Community Templates

We welcome community-contributed templates for:
- Different frameworks (Vue, Svelte, Angular)
- Backend technologies (FastAPI, Django, Express)
- Mobile development (React Native, Flutter)
- DevOps tools (Docker, Kubernetes)
- Specialized domains (ML, blockchain, gaming)

## Support

For template-related issues:

1. **Check Documentation**: Review template-specific README
2. **Common Issues**: Check troubleshooting section
3. **Create Issue**: Report problems or request new templates
4. **Contribute**: Submit improvements or new templates

## License

Templates are provided under the same license as Claude GitHub Commands (MIT). Feel free to use, modify, and distribute according to the license terms.