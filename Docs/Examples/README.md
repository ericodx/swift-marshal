# Configuration Examples

Example configurations for different project types and use cases.

## Configuration Files

| File | Description |
|------|-------------|
| [minimal.yaml](minimal.yaml) | Simplest configuration with basic ordering |
| [swiftui.yaml](swiftui.yaml) | Optimized for SwiftUI with property wrappers |
| [uikit.yaml](uikit.yaml) | Optimized for UIKit with lifecycle awareness |
| [visibility-focused.yaml](visibility-focused.yaml) | Ordering primarily by access level |

## Integration Guides

| Guide | Description |
|-------|-------------|
| [Xcode Integration](xcode-integration.md) | Build phases and Xcode behaviors |
| [Git Hooks](git-hooks.md) | Pre-commit hooks for automatic checking |
| [CI Integration](ci-integration.md) | GitHub Actions, GitLab CI, Bitrise |

## Quick Start

1. Copy the example that matches your project type
2. Rename to `.swift-marshal.yaml`
3. Place in your project root
4. Run `swift-marshal check` to verify

```bash
# Copy example
cp Docs/Examples/swiftui.yaml .swift-marshal.yaml

# Check your files
swift-marshal check --path Sources
```

## Choosing an Example

```mermaid
flowchart TD
    Q1{Project Type?}
    Q1 -->|SwiftUI| swiftui[swiftui.yaml]
    Q1 -->|UIKit/AppKit| uikit[uikit.yaml]
    Q1 -->|Library/Framework| Q2{Priority?}
    Q1 -->|Simple/Learning| minimal[minimal.yaml]

    Q2 -->|API visibility| visibility[visibility-focused.yaml]
    Q2 -->|Code organization| minimal
```
