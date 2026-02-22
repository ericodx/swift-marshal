# CI Integration

Guide for integrating Swift Marshal into continuous integration pipelines.

## Overview

Swift Marshal's `check` command returns exit code `1` when files need reordering, making it ideal for CI enforcement.

```bash
# Exit 0 = All files correctly ordered
# Exit 1 = Files need reordering
swift-marshal check --path Sources

# Exit 0 = Files were reordered
swift-marshal fix --path Sources
```

## GitHub Actions

### Basic Workflow

```yaml
# .github/workflows/swift-marshal.yml
name: Swift Marshal

on:
  pull_request:
    paths:
      - '**.swift'

jobs:
  check:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Build Swift Marshal
        run: |
          git clone https://github.com/ericodx/swift-marshal.git /tmp/swift-marshal
          cd /tmp/swift-marshal
          swift build -c release
          cp /tmp/swift-marshal/.build/release/swift-marshal /usr/local/bin/

      - name: Check Swift Marshal
        run: |
          swift-marshal check --path Sources
```

### With Caching

```yaml
name: Swift Marshal

on:
  pull_request:
    paths:
      - '**.swift'

jobs:
  check:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Cache Swift Marshal
        id: cache-swift-marshal
        uses: actions/cache@v4
        with:
          path: /usr/local/bin/swift-marshal
          key: swift-marshal-v1.0.0

      - name: Build Swift Marshal
        if: steps.cache-swift-marshal.outputs.cache-hit != 'true'
        run: |
          git clone https://github.com/ericodx/swift-marshal.git /tmp/swift-marshal
          cd /tmp/swift-marshal
          swift build -c release
          cp /tmp/swift-marshal/.build/release/swift-marshal /usr/local/bin/

      - name: Check Swift Marshal
        run: |
          swift-marshal check --path Sources
```

### Auto-Fix and Commit

```yaml
name: Swift Marshal Auto-Fix

on:
  pull_request:
    paths:
      - '**.swift'

jobs:
  fix:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Setup Swift Marshal
        run: |
          git clone https://github.com/ericodx/swift-marshal.git /tmp/swift-marshal
          cd /tmp/swift-marshal
          swift build -c release
          cp /tmp/swift-marshal/.build/release/swift-marshal /usr/local/bin/

      - name: Fix Swift Marshal
        run: |
          swift-marshal fix --path Sources

      - name: Commit Changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add -A
          git commit -m "fix: apply swift-marshal" || exit 0
          git push
```

## Best Practices

### Configuration

Always include your `.swift-marshal.yaml` in your repository:

```yaml
# .github/workflows/swift-marshal.yml
- name: Check Swift Marshal
  run: |
    swift-marshal check --config .swift-marshal.yaml --path Sources
```

### Performance

- Use caching to avoid rebuilding Swift Marshal
- Run only on Swift file changes
- Consider using `--quiet` flag for cleaner logs

### Integration with Other Tools

Swift Marshal works well alongside other code quality tools:

```yaml
- name: Run SwiftLint
  run: swiftlint

- name: Check Swift Marshal
  run: swift-marshal check --path Sources

- name: Run Tests
  run: swift test
```
