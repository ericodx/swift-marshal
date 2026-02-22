# Git Hooks Integration

Run Swift Marshal automatically before each commit.

## Pre-commit Hook (Check Only)

This hook checks staged Swift files and blocks the commit if reordering is needed.

```bash
# Create hooks directory if needed
mkdir -p .git/hooks

# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.swift$')

if [ -n "$STAGED_FILES" ]; then
    echo "Running Swift Marshal check..."

    swift-marshal check $STAGED_FILES

    if [ $? -ne 0 ]; then
        echo ""
        echo "Swift Marshal check failed."
        echo "Run 'swift-marshal fix <files>' to fix ordering."
        echo "Or use 'git commit --no-verify' to skip this check."
        exit 1
    fi

    echo "✓ Swift Marshal check passed."
fi

exit 0
EOF

# Make executable
chmod +x .git/hooks/pre-commit
```

## Pre-commit Hook (Auto-Fix)

This hook automatically fixes staged Swift files and re-stages them.

```bash
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.swift$')

if [ -n "$STAGED_FILES" ]; then
    echo "Running Swift Marshal fix..."

    swift-marshal fix $STAGED_FILES

    # Re-stage fixed files
    git add $STAGED_FILES

    echo "✓ Swift Marshal fix complete."
fi

exit 0
EOF

chmod +x .git/hooks/pre-commit
```

## Skipping the Hook

To commit without running the hook:

```bash
git commit --no-verify -m "your message"
```
