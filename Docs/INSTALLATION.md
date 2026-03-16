# Installation

## Requirements

- macOS 15 or later
- Xcode 16 or later (for building from source or using the Xcode plugin)
- Swift 6.2 or later (for building from source)

---

## Homebrew (recommended)

The fastest way to install `swift-marshal` on macOS.

```bash
brew tap ericodx/homebrew-tools
brew install swift-marshal
```

Verify the installation:

```bash
swift-marshal --version
# swift-marshal 1.0.0
```

### Updating

```bash
brew upgrade swift-marshal
```

### Uninstalling

```bash
brew uninstall swift-marshal
brew untap ericodx/homebrew-tools  # optional
```

---

## Download a pre-built binary

Pre-built binaries are published with every release on the [GitHub Releases page](https://github.com/ericodx/swift-marshal/releases).

```bash
# Replace X.Y.Z with the desired version
VERSION="1.0.0"
curl -L "https://github.com/ericodx/swift-marshal/releases/download/v${VERSION}/swift-marshal-v${VERSION}-macos.tar.gz" \
  | tar -xz

# Move to a directory in your PATH
sudo mv swift-marshal /usr/local/bin/
```

Verify:

```bash
swift-marshal --version
```

---

## Build from source

Requires Swift 6.2 or later. Check your version with `swift --version`.

```bash
git clone https://github.com/ericodx/swift-marshal.git
cd swift-marshal
swift build -c release
```

The compiled binary is at `.build/release/swift-marshal`. Copy it to a directory in your `PATH`:

```bash
sudo cp .build/release/swift-marshal /usr/local/bin/
```

---

## Run without installing (SPM)

If your project already uses Swift Package Manager, you can run `swift-marshal` directly from the repository without a global install:

```bash
# From the swift-marshal repository root
swift run swift-marshal check Sources/

# Or point to the package from another directory
swift run --package-path /path/to/swift-marshal swift-marshal check Sources/
```

---

## pre-commit hook

`swift-marshal` can run automatically on every `git commit` via [pre-commit](https://pre-commit.com), blocking the commit if member ordering violations are introduced.

### Step 1 — Install pre-commit

```bash
brew install pre-commit
```

### Step 2 — Add the hook to your project

Create or edit `.pre-commit-config.yaml` in your repository root:

```yaml
repos:
  - repo: https://github.com/ericodx/swift-marshal
    rev: v1.0.0   # replace with the desired version tag
    hooks:
      - id: swift-marshal
```

### Step 3 — Install the hook

```bash
pre-commit install
```

From this point on, `swift-marshal check` runs automatically on every `git commit`. If violations are found the commit is blocked and the report is printed to the terminal.

### Running manually

```bash
pre-commit run swift-marshal            # run on staged files only
pre-commit run swift-marshal --all-files  # run on the entire repository
```

---

## Xcode & SPM plugin

The plugin integrates member-order checking directly into the Xcode build system — no CLI installation required.

### Add to an SPM target

In `Package.swift`, add the plugin to any target you want monitored:

```swift
.target(
    name: "MyTarget",
    plugins: [.plugin(name: "SwiftMarshalPlugin", package: "swift-marshal")]
)
```

And declare the package dependency:

```swift
.package(url: "https://github.com/ericodx/swift-marshal.git", from: "1.0.0")
```

### Add to an Xcode target

1. In Xcode, select your target → **Build Phases**
2. Click **+** → **Add Build Tool Plug-in**
3. Select **SwiftMarshalPlugin**

Violations appear as yellow warning triangles inline in the source editor on every build.

---

## Verify the installation

```bash
swift-marshal --version   # print version
swift-marshal --help      # print all available commands and flags
swift-marshal init        # generate a starter .swift-marshal.yaml in the current directory
```
