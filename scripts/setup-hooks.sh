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

# Check if trufflehog is installed
if ! command -v trufflehog &> /dev/null; then
    echo "Warning: trufflehog is not installed."
    echo "Install it with: brew install trufflehog"
fi

# Create pre-commit hook if it doesn't exist
if [ ! -f "$PRE_COMMIT" ]; then
    cat > "$PRE_COMMIT" << 'EOF'
#!/bin/sh
# Pre-commit hook to check for secrets using gitleaks and trufflehog

exit_code=0

# Run gitleaks on staged changes
if command -v gitleaks &> /dev/null; then
    echo "Running gitleaks..."
    gitleaks protect --staged -v
    if [ $? -ne 0 ]; then
        echo ""
        echo "gitleaks detected secrets in your staged changes."
        echo "Please remove the secrets before committing."
        echo "To ignore a false positive, add it to .gitleaksignore"
        exit_code=1
    fi
else
    echo "Warning: gitleaks is not installed. Skipping gitleaks check."
    echo "Install it with: brew install gitleaks"
fi

# Run trufflehog on staged changes
if command -v trufflehog &> /dev/null; then
    echo "Running trufflehog..."
    # Get staged files and scan them
    STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)
    if [ -n "$STAGED_FILES" ]; then
        trufflehog filesystem --no-update . --include-paths=<(echo "$STAGED_FILES") --fail 2>&1
        if [ $? -ne 0 ]; then
            echo ""
            echo "trufflehog detected secrets in your staged changes."
            echo "Please remove the secrets before committing."
            exit_code=1
        fi
    fi
else
    echo "Warning: trufflehog is not installed. Skipping trufflehog check."
    echo "Install it with: brew install trufflehog"
fi

if [ $exit_code -eq 0 ]; then
    echo "No secrets detected."
fi

exit $exit_code
EOF
    chmod +x "$PRE_COMMIT"
    echo "Created pre-commit hook at $PRE_COMMIT"
else
    echo "Pre-commit hook already exists at $PRE_COMMIT"
    echo "To update it, delete $PRE_COMMIT and run this script again."
fi

echo "Git hooks setup complete!"
