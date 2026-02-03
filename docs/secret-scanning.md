# Secret Scanning with Gitleaks and Trufflehog

This guide covers how to detect secrets in your codebase using two complementary tools:

- **Gitleaks** - Fast pattern-based detection
- **Trufflehog** - Verification-based detection (tests if secrets are actually valid)

## Installation

### macOS (Homebrew)

```bash
brew install gitleaks trufflehog
```

### Other platforms

**Gitleaks:**
```bash
# Download from releases
https://github.com/gitleaks/gitleaks/releases

# Or use Go
go install github.com/gitleaks/gitleaks/v8@latest
```

**Trufflehog:**
```bash
# Download from releases
https://github.com/trufflesecurity/trufflehog/releases

# Or use Go
go install github.com/trufflesecurity/trufflehog/v3@latest
```

## Running Manual Scans

### Gitleaks

**Scan current directory (all git history):**
```bash
gitleaks detect -v
```

**Scan all branches:**
```bash
gitleaks detect -v --log-opts="--all"
```

**Scan entire history across all branches:**
```bash
gitleaks detect -v --log-opts="--all --full-history"
```

**Scan only staged changes (useful before committing):**
```bash
gitleaks protect --staged -v
```

**Scan a specific commit range:**
```bash
gitleaks detect --log-opts="commit1..commit2"
```

**Output results to JSON:**
```bash
gitleaks detect -v -f json -r results.json
```

### Trufflehog

**Scan git repository:**
```bash
trufflehog git file://.
```

**Scan only for verified (active) secrets:**
```bash
trufflehog git file://. --only-verified
```

**Scan a remote repository:**
```bash
trufflehog git https://github.com/user/repo.git
```

**Scan filesystem (non-git):**
```bash
trufflehog filesystem /path/to/directory
```

**Scan with JSON output:**
```bash
trufflehog git file://. --json
```

## Handling False Positives

### Gitleaks

Create a `.gitleaksignore` file in your repository root:

```
# Format: commit:file:rule:line
abc123def456:path/to/file.yaml:generic-api-key:42

# You can also use just the fingerprint from gitleaks output
abc123def456:config/example.json:generic-api-key:15
```

To find the fingerprint, run gitleaks and look for the `Fingerprint:` line in the output.

You can also add inline comments to ignore specific lines:

```yaml
api_key: "example-key-for-documentation"  # gitleaks:allow
```

### Trufflehog

Create a `.trufflehog-ignore` file:

```
# Ignore specific files
path/to/example/config.yaml

# Ignore patterns
**/test/fixtures/**
```

## Pre-commit Hook Setup

### Option 1: Manual Script

Create `.git/hooks/pre-commit`:

```bash
#!/bin/sh
# Pre-commit hook to check for secrets

exit_code=0

# Run gitleaks
if command -v gitleaks &> /dev/null; then
    echo "Running gitleaks..."
    gitleaks protect --staged -v
    if [ $? -ne 0 ]; then
        echo "gitleaks detected secrets in staged changes."
        exit_code=1
    fi
fi

# Run trufflehog
if command -v trufflehog &> /dev/null; then
    echo "Running trufflehog..."
    STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)
    if [ -n "$STAGED_FILES" ]; then
        trufflehog filesystem . --include-paths=<(echo "$STAGED_FILES") --fail 2>&1
        if [ $? -ne 0 ]; then
            echo "trufflehog detected secrets in staged changes."
            exit_code=1
        fi
    fi
fi

exit $exit_code
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

### Option 2: Using pre-commit Framework

Install the [pre-commit](https://pre-commit.com/) framework:

```bash
pip install pre-commit
# or
brew install pre-commit
```

Create `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0  # Use latest version
    hooks:
      - id: gitleaks

  - repo: https://github.com/trufflesecurity/trufflehog
    rev: v3.63.0  # Use latest version
    hooks:
      - id: trufflehog
        entry: trufflehog filesystem --fail .
        stages: [commit]
```

Install the hooks:
```bash
pre-commit install
```

## CI/CD Integration

### GitHub Actions

Create `.github/workflows/secret-scan.yml`:

```yaml
name: Secret Scanning

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  gitleaks:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Gitleaks
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  trufflehog:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Trufflehog
        uses: trufflesecurity/trufflehog@main
        with:
          extra_args: --only-verified
```

### GitLab CI

Add to `.gitlab-ci.yml`:

```yaml
secret-scan:
  stage: test
  image: alpine:latest
  before_script:
    - apk add --no-cache git curl
    - curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.18.0/gitleaks_8.18.0_linux_x64.tar.gz | tar -xz
  script:
    - ./gitleaks detect --source . -v
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
```

### Azure DevOps

Add to `azure-pipelines.yml`:

```yaml
trigger:
  - main

pool:
  vmImage: ubuntu-latest

steps:
  - checkout: self
    fetchDepth: 0

  - script: |
      curl -sSfL https://github.com/gitleaks/gitleaks/releases/download/v8.18.0/gitleaks_8.18.0_linux_x64.tar.gz | tar -xz
      ./gitleaks detect --source . -v
    displayName: 'Run Gitleaks'
```

## Best Practices

1. **Run both tools** - Gitleaks catches patterns; Trufflehog verifies if secrets are active
2. **Scan entire history** - Secrets in old commits are still exposed
3. **Use pre-commit hooks** - Prevent secrets from being committed in the first place
4. **Add CI checks** - Catch anything that slips through
5. **Rotate exposed secrets immediately** - Even if removed from code, they exist in git history
6. **Use `.gitignore`** - Prevent secret files (`.env`, credentials) from being tracked
7. **Use environment variables** - Never hardcode secrets in source code

## What To Do If Secrets Are Found

1. **Rotate the secret immediately** - Generate a new key/password
2. **Revoke the old secret** - Disable it in the service provider
3. **Remove from git history** (optional but recommended):
   ```bash
   # Using git-filter-repo (recommended)
   pip install git-filter-repo
   git filter-repo --invert-paths --path path/to/secret/file

   # Or using BFG Repo-Cleaner
   bfg --delete-files secret-file.txt
   ```
4. **Force push** (if history was rewritten):
   ```bash
   git push --force-with-lease
   ```
5. **Notify affected parties** if the secret was used in production

## Resources

- [Gitleaks Documentation](https://github.com/gitleaks/gitleaks)
- [Trufflehog Documentation](https://github.com/trufflesecurity/trufflehog)
- [pre-commit Framework](https://pre-commit.com/)
- [GitHub Secret Scanning](https://docs.github.com/en/code-security/secret-scanning)
- [git-filter-repo](https://github.com/newren/git-filter-repo)
