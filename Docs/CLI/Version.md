# Version

**Source**: `Sources/SwiftMarshal/Version.swift`

Centralized version management for the CLI.

## Structure

```swift
enum Version {
    static let current = "0.0.0-dev"
}
```

| Component | Description |
|-----------|-------------|
| **Type** | `enum Version` (namespace) |
| **Property** | `current` - Current version string |

## Usage

```swift
// In SwiftMarshal.swift
static let configuration = CommandConfiguration(
    version: Version.current,
    // ...
)
```

## Version Strategy

| Context | Value | Source |
|---------|-------|--------|
| Development | `0.0.0-dev` | Hardcoded placeholder |
| Release | `1.2.3` | Injected from git tag |

## Release Workflow Integration

During the release workflow, the version is injected before build:

```yaml
- name: Inject version
  run: |
    VERSION="${{ steps.version.outputs.version }}"
    VERSION="${VERSION#v}"  # Remove 'v' prefix
    echo "enum Version { static let current = \"$VERSION\" }" > Sources/SwiftMarshal/Version.swift
```

This ensures the compiled binary contains the correct version from the git tag.

## Verification

```bash
# Development build
swift build
.build/debug/swift-marshal --version
# Output: 0.0.0-dev

# Release binary (from GitHub Releases)
swift-marshal --version
# Output: 1.2.3
```

## Related Documentation

- [SwiftMarshal](SwiftMarshal.md) - Entry point that uses Version
- [Release Workflow](../CI/release.md) - Version injection process
