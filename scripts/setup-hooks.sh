#!/bin/sh
# Setup git hooks for this repository

HOOKS_DIR=".git/hooks"
PRE_COMMIT="$HOOKS_DIR/pre-commit"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository root"
    exit 1
fi

# Check if gitleaks is installed
if ! command -v gitleaks &> /dev/null; then
    echo "Warning: gitleaks is not installed."
    echo "Install it with: brew install gitleaks"
fi

# Create pre-commit hook if it doesn't exist
if [ ! -f "$PRE_COMMIT" ]; then
    cat > "$PRE_COMMIT" << 'EOF'
#!/bin/sh
# Pre-commit hook to check for secrets using gitleaks

# Check if gitleaks is installed
if ! command -v gitleaks &> /dev/null; then
    echo "gitleaks is not installed. Please install it: brew install gitleaks"
    exit 1
fi

# Run gitleaks on staged changes
gitleaks protect --staged -v

exit_code=$?

if [ $exit_code -ne 0 ]; then
    echo ""
    echo "gitleaks detected secrets in your staged changes."
    echo "Please remove the secrets before committing."
    echo ""
    echo "To ignore a false positive, add it to .gitleaksignore"
    exit 1
fi

exit 0
EOF
    chmod +x "$PRE_COMMIT"
    echo "Created pre-commit hook at $PRE_COMMIT"
else
    echo "Pre-commit hook already exists at $PRE_COMMIT"
fi

echo "Git hooks setup complete!"
