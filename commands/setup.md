# Development Environment Setup

You are setting up a complete development environment for this project. This command automatically detects the project type and configures all necessary tools, dependencies, and development workflows.

## Setup Overview

Comprehensive environment setup includes:
1. **Project Detection**: Identify technology stack and frameworks
2. **Dependencies Installation**: Install all required packages and tools
3. **Environment Configuration**: Set up configuration files and environments
4. **Development Tools**: Configure linting, testing, and build tools
5. **Git Hooks**: Install pre-commit and post-commit automation
6. **IDE Configuration**: Set up editor configurations and extensions
7. **Health Checks**: Verify everything is working correctly

## Phase 1: Project Analysis and Detection

### Step 1.1: Detect Project Type
Analyze project structure to identify technologies:

```bash
# Check for various project indicators
echo "🔍 Analyzing project structure..."

PROJECT_TYPES=()

# Node.js/JavaScript detection
if [[ -f "package.json" ]]; then
    PROJECT_TYPES+=("node")
    echo "✅ Node.js project detected"
    
    # Check for specific frameworks
    if grep -q "react" package.json; then
        PROJECT_TYPES+=("react")
        echo "✅ React framework detected"
    fi
    
    if grep -q "next" package.json; then
        PROJECT_TYPES+=("nextjs")
        echo "✅ Next.js framework detected"
    fi
    
    if grep -q "vue" package.json; then
        PROJECT_TYPES+=("vue")
        echo "✅ Vue.js framework detected"
    fi
    
    if grep -q "typescript" package.json; then
        PROJECT_TYPES+=("typescript")
        echo "✅ TypeScript detected"
    fi
fi

# Python detection
if [[ -f "pyproject.toml" ]] || [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]]; then
    PROJECT_TYPES+=("python")
    echo "✅ Python project detected"
    
    if [[ -f "pyproject.toml" ]] && grep -q "django" pyproject.toml; then
        PROJECT_TYPES+=("django")
        echo "✅ Django framework detected"
    fi
    
    if grep -q "fastapi" requirements.txt 2>/dev/null; then
        PROJECT_TYPES+=("fastapi")
        echo "✅ FastAPI framework detected"
    fi
    
    if grep -q "flask" requirements.txt 2>/dev/null; then
        PROJECT_TYPES+=("flask")
        echo "✅ Flask framework detected"
    fi
fi

# Other language detection
if [[ -f "Cargo.toml" ]]; then
    PROJECT_TYPES+=("rust")
    echo "✅ Rust project detected"
fi

if [[ -f "go.mod" ]]; then
    PROJECT_TYPES+=("go")
    echo "✅ Go project detected"
fi

if [[ -f "composer.json" ]]; then
    PROJECT_TYPES+=("php")
    echo "✅ PHP project detected"
fi

if [[ -f "Gemfile" ]]; then
    PROJECT_TYPES+=("ruby")
    echo "✅ Ruby project detected"
fi

echo "📊 Detected project types: ${PROJECT_TYPES[*]}"
```

### Step 1.2: Analyze Existing Configuration
Check for existing configurations:

```bash
# Check for existing development tools
echo "🔧 Checking existing development tools..."

EXISTING_TOOLS=()

# Linting tools
[[ -f ".eslintrc.json" ]] || [[ -f ".eslintrc.js" ]] && EXISTING_TOOLS+=("eslint")
[[ -f "pyproject.toml" ]] && grep -q "ruff" pyproject.toml && EXISTING_TOOLS+=("ruff")
[[ -f ".flake8" ]] && EXISTING_TOOLS+=("flake8")

# Testing tools
[[ -f "jest.config.js" ]] && EXISTING_TOOLS+=("jest")
[[ -f "pytest.ini" ]] && EXISTING_TOOLS+=("pytest")

# Build tools
[[ -f "webpack.config.js" ]] && EXISTING_TOOLS+=("webpack")
[[ -f "vite.config.js" ]] && EXISTING_TOOLS+=("vite")

# Git hooks
[[ -f ".pre-commit-config.yaml" ]] && EXISTING_TOOLS+=("pre-commit")

echo "🛠️  Existing tools: ${EXISTING_TOOLS[*]}"
```

## Phase 2: Dependencies Installation

### Step 2.1: Node.js/JavaScript Setup
```bash
if [[ " ${PROJECT_TYPES[*]} " =~ " node " ]]; then
    echo "📦 Setting up Node.js environment..."
    
    # Check Node.js version
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        echo "✅ Node.js $NODE_VERSION installed"
    else
        echo "❌ Node.js not found. Please install Node.js first."
        exit 1
    fi
    
    # Determine package manager
    if [[ -f "pnpm-lock.yaml" ]]; then
        PKG_MANAGER="pnpm"
    elif [[ -f "yarn.lock" ]]; then
        PKG_MANAGER="yarn"
    else
        PKG_MANAGER="npm"
    fi
    
    echo "📦 Using package manager: $PKG_MANAGER"
    
    # Install dependencies
    case $PKG_MANAGER in
        "pnpm")
            pnpm install
            ;;
        "yarn")
            yarn install
            ;;
        "npm")
            npm install
            ;;
    esac
    
    # Install development tools if not present
    if [[ ! " ${EXISTING_TOOLS[*]} " =~ " eslint " ]]; then
        echo "🔧 Installing ESLint..."
        $PKG_MANAGER add -D eslint @eslint/js
    fi
    
    if [[ " ${PROJECT_TYPES[*]} " =~ " typescript " ]] && [[ ! " ${EXISTING_TOOLS[*]} " =~ " typescript " ]]; then
        echo "🔧 Installing TypeScript tools..."
        $PKG_MANAGER add -D typescript @types/node
    fi
    
    if [[ " ${PROJECT_TYPES[*]} " =~ " react " ]]; then
        echo "🔧 Installing React development tools..."
        $PKG_MANAGER add -D @types/react @types/react-dom
    fi
fi
```

### Step 2.2: Python Setup
```bash
if [[ " ${PROJECT_TYPES[*]} " =~ " python " ]]; then
    echo "🐍 Setting up Python environment..."
    
    # Check Python version
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version)
        echo "✅ $PYTHON_VERSION installed"
    else
        echo "❌ Python 3 not found. Please install Python 3 first."
        exit 1
    fi
    
    # Create virtual environment if it doesn't exist
    if [[ ! -d "venv" ]] && [[ ! -d ".venv" ]]; then
        echo "🔧 Creating virtual environment..."
        python3 -m venv venv
    fi
    
    # Activate virtual environment
    if [[ -d "venv" ]]; then
        source venv/bin/activate
        echo "✅ Virtual environment activated (venv)"
    elif [[ -d ".venv" ]]; then
        source .venv/bin/activate
        echo "✅ Virtual environment activated (.venv)"
    fi
    
    # Upgrade pip
    pip install --upgrade pip
    
    # Install dependencies
    if [[ -f "requirements.txt" ]]; then
        echo "📦 Installing requirements.txt..."
        pip install -r requirements.txt
    fi
    
    if [[ -f "requirements-dev.txt" ]]; then
        echo "📦 Installing development requirements..."
        pip install -r requirements-dev.txt
    fi
    
    if [[ -f "pyproject.toml" ]]; then
        echo "📦 Installing from pyproject.toml..."
        pip install -e .
    fi
    
    # Install development tools
    echo "🔧 Installing Python development tools..."
    pip install ruff pytest black mypy pre-commit
fi
```

### Step 2.3: Other Languages Setup
```bash
# Rust setup
if [[ " ${PROJECT_TYPES[*]} " =~ " rust " ]]; then
    echo "🦀 Setting up Rust environment..."
    
    if command -v cargo &> /dev/null; then
        echo "✅ Rust/Cargo installed"
        cargo build
    else
        echo "❌ Rust not found. Please install Rust first."
    fi
fi

# Go setup
if [[ " ${PROJECT_TYPES[*]} " =~ " go " ]]; then
    echo "🐹 Setting up Go environment..."
    
    if command -v go &> /dev/null; then
        echo "✅ Go installed"
        go mod download
    else
        echo "❌ Go not found. Please install Go first."
    fi
fi
```

## Phase 3: Configuration Files Setup

### Step 3.1: Linting Configuration
```bash
echo "🔧 Setting up linting configuration..."

# ESLint configuration for JavaScript/TypeScript
if [[ " ${PROJECT_TYPES[*]} " =~ " node " ]] && [[ ! -f ".eslintrc.json" ]]; then
    cat > .eslintrc.json << 'EOF'
{
  "extends": ["eslint:recommended"],
  "env": {
    "node": true,
    "es2022": true
  },
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "rules": {
    "no-console": "warn",
    "no-unused-vars": "error",
    "prefer-const": "error"
  }
}
EOF
    echo "✅ ESLint configuration created"
fi

# TypeScript ESLint configuration
if [[ " ${PROJECT_TYPES[*]} " =~ " typescript " ]] && [[ ! -f ".eslintrc.json" ]]; then
    cat > .eslintrc.json << 'EOF'
{
  "extends": [
    "eslint:recommended",
    "@typescript-eslint/recommended"
  ],
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint"],
  "env": {
    "node": true,
    "es2022": true
  },
  "rules": {
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/explicit-function-return-type": "warn"
  }
}
EOF
    echo "✅ TypeScript ESLint configuration created"
fi

# Python linting configuration
if [[ " ${PROJECT_TYPES[*]} " =~ " python " ]] && [[ ! -f "pyproject.toml" ]]; then
    cat >> pyproject.toml << 'EOF'

[tool.ruff]
line-length = 88
target-version = "py38"

[tool.ruff.lint]
select = ["E", "F", "W", "C90", "I", "N", "UP", "YTT", "S", "BLE", "FBT", "B", "A", "COM", "C4", "DTZ", "T10", "EM", "EXE", "FA", "ISC", "ICN", "G", "INP", "PIE", "T20", "PYI", "PT", "Q", "RSE", "RET", "SLF", "SLOT", "SIM", "TID", "TCH", "ARG", "PTH", "ERA", "PD", "PGH", "PL", "TRY", "FLY", "NPY", "AIR", "PERF", "FURB", "LOG", "RUF"]

[tool.black]
line-length = 88
target-version = ['py38']

[tool.mypy]
python_version = "3.8"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
EOF
    echo "✅ Python tool configuration added to pyproject.toml"
fi
```

### Step 3.2: Testing Configuration
```bash
echo "🧪 Setting up testing configuration..."

# Jest configuration for JavaScript/TypeScript
if [[ " ${PROJECT_TYPES[*]} " =~ " node " ]] && [[ ! -f "jest.config.js" ]]; then
    cat > jest.config.js << 'EOF'
module.exports = {
  testEnvironment: 'node',
  collectCoverage: true,
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  testMatch: [
    '**/__tests__/**/*.(js|ts)',
    '**/*.(test|spec).(js|ts)'
  ],
  transform: {
    '^.+\\.ts$': 'ts-jest'
  },
  collectCoverageFrom: [
    'src/**/*.(js|ts)',
    '!src/**/*.d.ts'
  ]
};
EOF
    echo "✅ Jest configuration created"
fi

# Pytest configuration for Python (already included in pyproject.toml above)
if [[ " ${PROJECT_TYPES[*]} " =~ " python " ]]; then
    echo "✅ Pytest configuration included in pyproject.toml"
fi
```

### Step 3.3: Git Hooks Setup
```bash
echo "🪝 Setting up Git hooks..."

# Pre-commit configuration
if [[ ! -f ".pre-commit-config.yaml" ]]; then
    cat > .pre-commit-config.yaml << 'EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict

  - repo: https://github.com/commitizen-tools/commitizen
    rev: v3.13.0
    hooks:
      - id: commitizen
EOF

    # Add language-specific hooks
    if [[ " ${PROJECT_TYPES[*]} " =~ " node " ]]; then
        cat >> .pre-commit-config.yaml << 'EOF'

  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v8.56.0
    hooks:
      - id: eslint
        files: \.(js|ts|jsx|tsx)$
        additional_dependencies:
          - eslint@8.56.0
EOF
    fi

    if [[ " ${PROJECT_TYPES[*]} " =~ " python " ]]; then
        cat >> .pre-commit-config.yaml << 'EOF'

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.9
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
EOF
    fi

    echo "✅ Pre-commit configuration created"
fi

# Install pre-commit hooks
if command -v pre-commit &> /dev/null; then
    pre-commit install
    echo "✅ Pre-commit hooks installed"
else
    echo "⚠️  Pre-commit not available, skipping hook installation"
fi
```

## Phase 4: Environment Configuration

### Step 4.1: Environment Variables Setup
```bash
echo "🔐 Setting up environment configuration..."

# Create .env.example if it doesn't exist
if [[ ! -f ".env.example" ]]; then
    cat > .env.example << 'EOF'
# Development Environment Variables
NODE_ENV=development
DEBUG=true

# Database Configuration
DATABASE_URL=postgresql://localhost:5432/myapp_dev

# API Keys (Replace with actual values)
API_KEY=your_api_key_here
SECRET_KEY=your_secret_key_here

# GitHub Integration
GITHUB_TOKEN=your_github_token_here

# Application Settings
PORT=3000
HOST=localhost
EOF
    echo "✅ .env.example created"
fi

# Create .env if it doesn't exist (copy from example)
if [[ ! -f ".env" ]] && [[ -f ".env.example" ]]; then
    cp .env.example .env
    echo "✅ .env created from example (remember to update with real values)"
fi

# Ensure .env is in .gitignore
if [[ ! -f ".gitignore" ]] || ! grep -q "\.env$" .gitignore; then
    echo ".env" >> .gitignore
    echo "✅ .env added to .gitignore"
fi
```

### Step 4.2: IDE Configuration
```bash
echo "🔧 Setting up IDE configuration..."

# VS Code configuration
if [[ ! -d ".vscode" ]]; then
    mkdir -p .vscode
    
    # Settings
    cat > .vscode/settings.json << 'EOF'
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "python.defaultInterpreterPath": "./venv/bin/python",
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": false,
  "python.linting.flake8Enabled": false,
  "python.formatting.provider": "black",
  "typescript.preferences.importModuleSpecifier": "relative"
}
EOF

    # Extensions recommendations
    cat > .vscode/extensions.json << 'EOF'
{
  "recommendations": [
    "ms-python.python",
    "ms-python.black-formatter",
    "charliermarsh.ruff",
    "bradlc.vscode-tailwindcss",
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "ms-vscode.vscode-typescript-next",
    "github.copilot",
    "ms-vscode.git-base"
  ]
}
EOF

    echo "✅ VS Code configuration created"
fi

# EditorConfig
if [[ ! -f ".editorconfig" ]]; then
    cat > .editorconfig << 'EOF'
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

[*.{py,pyi}]
indent_size = 4

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
EOF
    echo "✅ EditorConfig created"
fi
```

## Phase 5: Development Scripts Setup

### Step 5.1: Package.json Scripts (Node.js)
```bash
if [[ " ${PROJECT_TYPES[*]} " =~ " node " ]] && [[ -f "package.json" ]]; then
    echo "📜 Adding development scripts to package.json..."
    
    # Use jq to add scripts if not present
    if command -v jq &> /dev/null; then
        # Backup original package.json
        cp package.json package.json.backup
        
        # Add common scripts
        jq '.scripts.lint = "eslint src/**/*.{js,ts}" |
            .scripts."lint:fix" = "eslint src/**/*.{js,ts} --fix" |
            .scripts.test = "jest" |
            .scripts."test:watch" = "jest --watch" |
            .scripts."test:coverage" = "jest --coverage" |
            .scripts.build = (.scripts.build // "tsc") |
            .scripts.dev = (.scripts.dev // (.scripts.start // "node index.js")) |
            .scripts."type-check" = "tsc --noEmit"' package.json > package.json.tmp
        
        mv package.json.tmp package.json
        echo "✅ Development scripts added to package.json"
    else
        echo "⚠️  jq not available, manual script addition recommended"
    fi
fi
```

### Step 5.2: Makefile Creation
```bash
echo "📝 Creating Makefile for common tasks..."

cat > Makefile << 'EOF'
.PHONY: help install test lint format clean setup dev build

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	@echo "Installing dependencies..."
EOF

# Add project-specific commands
if [[ " ${PROJECT_TYPES[*]} " =~ " node " ]]; then
    cat >> Makefile << 'EOF'
	npm install

dev: ## Start development server
	npm run dev

build: ## Build for production
	npm run build

test: ## Run tests
	npm test

lint: ## Run linting
	npm run lint

format: ## Format code
	npm run lint:fix
EOF
fi

if [[ " ${PROJECT_TYPES[*]} " =~ " python " ]]; then
    cat >> Makefile << 'EOF'
	pip install -r requirements.txt

dev: ## Start development server
	python manage.py runserver

test: ## Run tests
	pytest

lint: ## Run linting
	ruff check .

format: ## Format code
	ruff format .
	ruff check --fix .
EOF
fi

cat >> Makefile << 'EOF'

clean: ## Clean build artifacts
	rm -rf dist/
	rm -rf build/
	rm -rf *.egg-info/
	rm -rf .pytest_cache/
	rm -rf .coverage
	rm -rf coverage/

setup: ## Setup development environment
	@echo "Setting up development environment..."
	make install
	pre-commit install
EOF

echo "✅ Makefile created with common development tasks"
```

## Phase 6: Health Checks and Verification

### Step 6.1: Dependency Verification
```bash
echo "🏥 Running health checks..."

HEALTH_ISSUES=()

# Check Node.js setup
if [[ " ${PROJECT_TYPES[*]} " =~ " node " ]]; then
    if npm list --depth=0 &> /dev/null; then
        echo "✅ Node.js dependencies installed correctly"
    else
        HEALTH_ISSUES+=("Node.js dependencies have issues")
    fi
fi

# Check Python setup
if [[ " ${PROJECT_TYPES[*]} " =~ " python " ]]; then
    if pip check &> /dev/null; then
        echo "✅ Python dependencies installed correctly"
    else
        HEALTH_ISSUES+=("Python dependencies have conflicts")
    fi
fi

# Check git setup
if git status &> /dev/null; then
    echo "✅ Git repository is healthy"
else
    HEALTH_ISSUES+=("Git repository has issues")
fi
```

### Step 6.2: Tool Verification
```bash
# Test linting
echo "🔍 Testing linting setup..."

if [[ " ${PROJECT_TYPES[*]} " =~ " node " ]]; then
    if npm run lint &> /dev/null; then
        echo "✅ ESLint working correctly"
    else
        echo "⚠️  ESLint has configuration issues"
    fi
fi

if [[ " ${PROJECT_TYPES[*]} " =~ " python " ]]; then
    if ruff check . &> /dev/null; then
        echo "✅ Ruff working correctly"
    else
        echo "⚠️  Ruff has configuration issues"
    fi
fi

# Test pre-commit
if pre-commit run --all-files &> /dev/null; then
    echo "✅ Pre-commit hooks working correctly"
else
    echo "⚠️  Pre-commit hooks need attention"
fi
```

### Step 6.3: Security Check
```bash
echo "🔒 Running security checks..."

# Node.js security audit
if [[ " ${PROJECT_TYPES[*]} " =~ " node " ]]; then
    if npm audit --audit-level high; then
        echo "✅ No high-severity security vulnerabilities found"
    else
        echo "⚠️  Security vulnerabilities detected - run 'npm audit fix'"
    fi
fi

# Python security check
if [[ " ${PROJECT_TYPES[*]} " =~ " python " ]] && command -v safety &> /dev/null; then
    if safety check; then
        echo "✅ No known security vulnerabilities in Python packages"
    else
        echo "⚠️  Security vulnerabilities detected in Python packages"
    fi
fi

# Check for secrets in code
if command -v git &> /dev/null; then
    if git log --all --full-history -- "*" | grep -E "(password|secret|key|token)" -i; then
        echo "⚠️  Potential secrets found in git history"
    else
        echo "✅ No obvious secrets found in git history"
    fi
fi
```

## Phase 7: Documentation and Final Setup

### Step 7.1: Update Documentation
```bash
echo "📚 Updating project documentation..."

# Create or update DEVELOPMENT.md
cat > DEVELOPMENT.md << 'EOF'
# Development Guide

This document contains information for developers working on this project.

## Prerequisites

EOF

# Add project-specific prerequisites
if [[ " ${PROJECT_TYPES[*]} " =~ " node " ]]; then
    cat >> DEVELOPMENT.md << 'EOF'
- Node.js 18+ and npm
EOF
fi

if [[ " ${PROJECT_TYPES[*]} " =~ " python " ]]; then
    cat >> DEVELOPMENT.md << 'EOF'
- Python 3.8+
- pip and virtualenv
EOF
fi

cat >> DEVELOPMENT.md << 'EOF'
- Git
- GitHub CLI (for GitHub integration)

## Setup

1. Clone the repository
2. Run `make setup` to install dependencies and configure the environment
3. Copy `.env.example` to `.env` and configure your environment variables
4. Run `make dev` to start the development server

## Available Commands

- `make dev` - Start development server
- `make test` - Run tests
- `make lint` - Run linting
- `make format` - Format code
- `make build` - Build for production
- `make clean` - Clean build artifacts

## Git Workflow

This project uses conventional commits and pre-commit hooks to maintain code quality.

### Commit Format

```
type(scope): description

body

footer
```

### Available Types

- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes
- `refactor` - Code refactoring
- `test` - Test changes
- `chore` - Build process or auxiliary tool changes

## Code Quality

- All code must pass linting checks
- All tests must pass
- Code coverage should be maintained above 80%
- Pre-commit hooks will enforce code quality standards

## Testing

EOF

if [[ " ${PROJECT_TYPES[*]} " =~ " node " ]]; then
    cat >> DEVELOPMENT.md << 'EOF'
- Unit tests: `npm test`
- Test coverage: `npm run test:coverage`
- Watch mode: `npm run test:watch`
EOF
fi

if [[ " ${PROJECT_TYPES[*]} " =~ " python " ]]; then
    cat >> DEVELOPMENT.md << 'EOF'
- Unit tests: `pytest`
- Test coverage: `pytest --cov`
- Specific test: `pytest tests/test_specific.py`
EOF
fi

echo "✅ Development documentation created"
```

### Step 7.2: Setup Summary
```bash
echo ""
echo "🎉 Development Environment Setup Complete!"
echo ""
echo "📊 Setup Summary:"
echo "=================="
echo "Project Types: ${PROJECT_TYPES[*]}"
echo "Package Manager: ${PKG_MANAGER:-"N/A"}"
echo "Existing Tools: ${EXISTING_TOOLS[*]}"
echo ""

if [[ ${#HEALTH_ISSUES[@]} -gt 0 ]]; then
    echo "⚠️  Health Issues Found:"
    for issue in "${HEALTH_ISSUES[@]}"; do
        echo "  - $issue"
    done
    echo ""
fi

echo "🚀 Next Steps:"
echo "1. Review and update .env file with your specific values"
echo "2. Run 'make dev' to start the development server"
echo "3. Run 'make test' to verify everything is working"
echo "4. Check DEVELOPMENT.md for detailed development guidelines"
echo ""
echo "💡 Useful Commands:"
echo "- make help    - Show all available commands"
echo "- make dev     - Start development server"
echo "- make test    - Run tests"
echo "- make lint    - Check code quality"
echo "- make format  - Format code"
echo ""
echo "✅ Your development environment is ready!"
```

## Error Handling and Recovery

```bash
# Error recovery function
handle_setup_error() {
    local error_msg="$1"
    local recovery_action="$2"
    
    echo "❌ Setup Error: $error_msg"
    echo "🔧 Recovery Action: $recovery_action"
    
    # Log error for debugging
    echo "[$(date)] Setup Error: $error_msg" >> setup.log
    
    # Provide manual alternatives
    echo ""
    echo "Manual Setup Options:"
    echo "1. Check setup.log for detailed error information"
    echo "2. Run individual setup commands manually"
    echo "3. Consult DEVELOPMENT.md for manual setup instructions"
}

# Cleanup function for failed setups
cleanup_failed_setup() {
    echo "🧹 Cleaning up failed setup..."
    
    # Remove partially created files
    [[ -f ".eslintrc.json.tmp" ]] && rm -f .eslintrc.json.tmp
    [[ -f "package.json.backup" ]] && mv package.json.backup package.json
    
    echo "✅ Cleanup completed"
}
```

This setup command provides comprehensive environment configuration for any project type while maintaining flexibility and error recovery options.