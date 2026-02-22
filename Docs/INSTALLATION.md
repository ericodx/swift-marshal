# Installation

This document describes various ways to install Swift Marshal.

---

## Homebrew (Recommended)

The easiest way to install Swift Marshal is via Homebrew:

```bash
brew tap ericodx/homebrew-tools
brew install swift-marshal
```

### Update

```bash
brew upgrade swift-marshal
```

### Uninstall

```bash
brew uninstall swift-marshal
```

---

## Manual Installation

### Build from Source

```bash
git clone https://github.com/ericodx/swift-marshal.git
cd swift-marshal
swift build -c release

# Install to user local bin
mkdir -p ~/.local/bin
cp .build/release/swift-marshal ~/.local/bin/

# Add to PATH (add this to your ~/.zshrc)
export PATH="$HOME/.local/bin:$PATH"
```

### Verify Installation

```bash
swift-marshal --version
swift-marshal --help
```

---

## Direct Download

You can download pre-compiled binaries from [GitHub Releases](https://github.com/ericodx/swift-marshal/releases).

1. Download the latest `swift-marshal-v*.macos.tar.gz`
2. Extract the binary:
   ```bash
   tar -xzf swift-marshal-v*.macos.tar.gz
   ```
3. Move to your PATH:
   ```bash
   mv swift-marshal ~/.local/bin/
   ```

---

## Swift Package Manager (Plugin)

For Xcode integration via the Build Tool Plugin, add the package as a dependency:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/ericodx/swift-marshal", from: "1.0.0"),
]

targets: [
    .target(
        name: "MyApp",
        plugins: [
            .plugin(name: "SwiftMarshalPlugin", package: "swift-marshal")
        ]
    ),
]
```

For Xcode projects, add the package via **File** → **Add Package Dependencies** and enable the plugin in your target's Build Phases.

See [Xcode Integration](Examples/xcode-integration.md) for detailed setup instructions.

---

## Requirements

### CLI (Homebrew / Manual)

- **macOS** 12.0 (Monterey) or later
- **Swift** 6.0+ (for building from source)

### Build Tool Plugin

- **macOS** 12.0+ / **iOS** 15.0+ / **tvOS** 15.0+ / **watchOS** 8.0+ / **visionOS** 1.0+
- **Xcode** 14.0+ or **Swift Package Manager** 5.9+

---

##  Verification

After installation, verify that Swift Marshal is working:

```bash
# Check version
swift-marshal --version

# Check help
swift-marshal --help

# Test on a sample file
echo 'struct Test { func b() {} func a() {} }' > test.swift
swift-marshal check test.swift
```

---

## 🐛 Troubleshooting

### Command not found

```bash
# Check if binary is in PATH
which swift-marshal

# If not found, add to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Permission denied

```bash
# Make binary executable
chmod +x ~/.local/bin/swift-marshal
```

### Build from source fails

```bash
# Clean build cache
rm -rf .build
swift build -c release

# Ensure Xcode command line tools are installed
xcode-select --install
```

---

## Updates

### Homebrew

```bash
brew upgrade swift-marshal
```

### Manual

```bash
cd swift-marshal
git pull origin main
swift build -c release
cp .build/release/swift-marshal ~/.local/bin/
```

---

## Next Steps

- [Usage Guide](../README.md#usage)
- [Configuration](./CONFIGURATION.md)
- [Examples](./EXAMPLES.md)
