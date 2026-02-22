# Dependabot Configuration

**Source**: `.github/dependabot.yml`

## Overview

Dependabot automatically creates pull requests to keep dependencies up to date. This configuration manages Swift Package Manager dependencies and GitHub Actions versions.

## Configuration

### Swift Dependencies

```yaml
package-ecosystem: "swift"
directory: "/"
schedule:
  interval: "weekly"
  day: "sunday"
  time: "03:00"
  timezone: "America/Sao_Paulo"
commit-message:
  prefix: "deps(swift)"
```

| Setting | Value | Description |
|---------|-------|-------------|
| Interval | Weekly (Sunday 03:00) | When to check for updates |
| PR Limit | 3 | Maximum open PRs at once |
| Major Updates | Ignored | Only minor/patch updates |
| Commit Prefix | `deps(swift)` | Conventional commit prefix |

**Labels applied**:
- `dependencies`
- `swift`
- `spm`
- `auto-update`

### GitHub Actions

```yaml
package-ecosystem: "github-actions"
directory: "/"
schedule:
  interval: "weekly"
  day: "sunday"
  time: "03:00"
  timezone: "America/Sao_Paulo"
commit-message:
  prefix: "deps(actions)"
groups:
  github-actions:
    patterns:
      - "*"
```

| Setting | Value | Description |
|---------|-------|-------------|
| Interval | Weekly (Sunday 03:00) | When to check for updates |
| Grouping | `github-actions` | Single PR for all action updates |
| Commit Prefix | `deps(actions)` | Conventional commit prefix |

**Labels applied**:
- `dependencies`
- `github-actions`
- `auto-update`

## Commit Message Format

Dependabot uses conventional commit prefixes for clarity:

| Ecosystem | Prefix | Example |
|-----------|--------|---------|
| Swift | `deps(swift)` | `deps(swift): bump Yams from 5.0.0 to 5.1.0` |
| GitHub Actions | `deps(actions)` | `deps(actions): bump actions/checkout from 3 to 4` |

## Update Strategy

### Swift Packages

- **Minor updates**: Automatically created
- **Patch updates**: Automatically created
- **Major updates**: Ignored (manual review required)

This conservative approach prevents breaking changes from being automatically introduced.

### GitHub Actions

- All updates grouped into a single PR
- Reduces noise from multiple action update PRs
- Easier to review and merge

## Assignees and Reviewers

All Dependabot PRs are automatically:
- Assigned to: `ericodx`
- Review requested from: `ericodx`

## Workflow Integration

Dependabot PRs are excluded from the main `pull-request-analysis` workflow to avoid unnecessary CI runs. Dependabot has its own security checks.

```yaml
# In pull-request-analysis.yml
if: github.actor != 'dependabot[bot]'
```

## Schedule

| Day | Time | Timezone | Ecosystems |
|-----|------|----------|------------|
| Sunday | 03:00 | America/Sao_Paulo | Swift, GitHub Actions |

Updates are scheduled during low-activity periods to minimize disruption.

## Related Documentation

- [Pull Request Analysis](pull-request-analysis.md) - PR quality checks
- [Main Analysis](main-analysis.md) - Production branch analysis
