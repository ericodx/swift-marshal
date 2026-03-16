# Usage & Configuration Guide

This guide covers every way to run and configure `swift-marshal`, from a first run to full CI integration.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Configuration File](#configuration-file)
3. [CLI Reference](#cli-reference)
4. [Output Formats](#output-formats)
5. [CI/CD Integration](#cicd-integration)
6. [Xcode & SPM Plugin](#xcode--spm-plugin)
7. [Exit Codes](#exit-codes)

---

## Quick Start

### SPM project

```bash
# Generate a default config file (auto-detects source paths)
swift-marshal init

# Check for ordering violations
swift-marshal check

# Apply fixes automatically
swift-marshal fix
```

### Xcode project

```bash
# Auto-detects your target folder (e.g. MyApp/)
swift-marshal init

# Edit .swift-marshal.yaml if needed, then run
swift-marshal check Sources/MyApp/
```

### First-time output

```
Sources/MyApp/Services/UserService.swift:
  struct UserService (line 3)
    [needs reordering]
    original:
      - instance_method fetchUser
      - instance_property id
      - initializer init
    reordered:
      - initializer init
      - instance_property id
      - instance_method fetchUser

Summary: 1 types, 1 need reordering

✗ 1 type in 1 file needs reordering
  Run 'swift-marshal fix' to apply changes
```

---

## Configuration File

`swift-marshal` looks for `.swift-marshal.yaml` by walking up from the target directory. Generate a starter file with:

```bash
swift-marshal init
```

### Full reference

```yaml
version: 1

# Ordered list of member kinds. Members are placed in the order defined here.
# Each entry is either a simple kind name or a complex rule with constraints.
ordering:
  members:
    # Simple rules — match by kind only
    - typealias
    - associatedtype
    - initializer
    - type_property
    - instance_property
    - subtype
    - type_method
    - instance_method
    - subscript
    - deinitializer

    # Complex rules — match by kind plus optional visibility / annotation constraints
    # - property:
    #     visibility: public      # open | public | internal | fileprivate | private
    #     annotated: true         # true | false
    # - method:
    #     kind: static            # static | instance
    #     visibility: internal

# How extensions are handled (not yet enforced — reserved for future use)
extensions:
  strategy: separate            # separate | inline
  respect_boundaries: true      # honour MARK: comment boundaries

# Default directories to scan when no files or --path are provided
paths:
  - Sources/
```

### Rule evaluation order

Rules are evaluated from top to bottom. A member is assigned to the **first rule that matches** it. Complex rules that do not match a member fall through to the next rule.

```
CLI --path  >  positional file arguments  >  configuration paths:
```

---

## CLI Reference

### Commands

```bash
swift-marshal init              # generate .swift-marshal.yaml in the current directory
swift-marshal --version         # print version
swift-marshal --help            # print usage summary
```

### check

Reports ordering violations without modifying any file.

```bash
swift-marshal check [files…] [options]
```

| Option | Description |
|---|---|
| `--path <dir>` / `-p` | Directory to scan for Swift files |
| `--config <file>` / `-c` | Path to a `.swift-marshal.yaml` file |
| `--xcode` | Emit `file:line: warning:` diagnostics (for Xcode build phases) |
| `--warn-only` | Exit `0` even when violations are found |
| `--output <path>` | Write an empty marker file on completion |
| `--quiet` / `-q` | Suppress per-file output; print only violating file paths |

### fix

Rewrites source files to comply with the configured ordering.

```bash
swift-marshal fix [files…] [options]
```

| Option | Description |
|---|---|
| `--path <dir>` / `-p` | Directory to scan for Swift files |
| `--config <file>` / `-c` | Path to a `.swift-marshal.yaml` file |
| `--dry-run` | Report what would change without writing files (exits `1` if changes needed) |
| `--quiet` / `-q` | Suppress per-file output |

### init

Writes a starter `.swift-marshal.yaml` in the current directory.

```bash
swift-marshal init [--force]
```

| Option | Description |
|---|---|
| `--force` | Overwrite an existing configuration file |

Auto-detects the project type and sets `paths:` accordingly:

- `Package.swift` present → `paths: [Sources/]`
- `.xcodeproj` present → `paths: [<ProjectName>/]`
- Neither detected → no `paths:` entry written

### Common invocations

```bash
# Check a single directory
swift-marshal check --path Sources/

# Check specific files
swift-marshal check Sources/MyApp/Services/UserService.swift

# Fix with a custom config
swift-marshal fix --config config/strict.yaml --path Sources/

# Dry run before fixing
swift-marshal fix --dry-run --path Sources/

# Xcode diagnostic format (one warning per violation)
swift-marshal check --xcode --path Sources/

# Suppress all output, exit code only
swift-marshal check --quiet --path Sources/
```

---

## Output Formats

### Normal (default)

Human-readable per-file report with original and target member orders, followed by a summary.

```
Sources/App/Models/User.swift:
  struct User (line 1)
    [needs reordering]
    original:
      - instance_method fullName
      - instance_property firstName
      - instance_property lastName
      - initializer init
    reordered:
      - initializer init
      - instance_property firstName
      - instance_property lastName
      - instance_method fullName

Summary: 1 types, 1 need reordering

✗ 1 type in 1 file needs reordering
  Run 'swift-marshal fix' to apply changes
```

### Quiet (`-q`)

Suppresses per-file details. Prints only the list of violating file paths and the summary line.

```
Sources/App/Models/User.swift

✗ 1 type in 1 file needs reordering
  Run 'swift-marshal fix' to apply changes
```

### Xcode (`--xcode`)

One line per violating type, in the format Xcode recognises as a build warning. No summary is printed.

```
Sources/App/Models/User.swift:1: warning: 'User' members need reordering
```

### Fix output

```
Reordered: Sources/App/Models/User.swift
✓ 1 file reordered
```

### Dry run output

```
Would reorder: Sources/App/Models/User.swift
⚠ 1 file would be modified
```

---

## CI/CD Integration

### GitHub Actions — check on every push

```yaml
- name: Check member ordering
  run: swift-marshal check --path Sources/
```

### GitHub Actions — fail only on violations (not build errors)

```yaml
- name: Check member ordering
  run: swift-marshal check --warn-only --path Sources/
```

### GitHub Actions — apply fixes and commit

```yaml
- name: Fix member ordering
  run: |
    swift-marshal fix --path Sources/
    git diff --quiet || git commit -am "fix: apply member reordering"
```

### Require fix on pull requests

```yaml
- name: Verify ordering
  run: |
    swift-marshal fix --dry-run --path Sources/
    # Exits 1 if any file would be modified
```

### Using a custom config in CI

```yaml
- name: Check member ordering (strict)
  run: swift-marshal check --config ci/strict.yaml --path Sources/
```

---

## Xcode & SPM Plugin

Two SPM plugins are included. Neither requires a global CLI installation.

### SwiftMarshalPlugin (Build Tool Plugin)

Runs `check --xcode` automatically on every build. Violations appear as yellow warning triangles in the source editor.

**Limitations:** SPM build-tool plugins run in a sandbox with read-only access. The plugin can only report — it cannot write files.

#### Add to an SPM target

```swift
// Package.swift
.package(url: "https://github.com/ericodx/swift-marshal.git", from: "1.0.0")

// In your target:
.target(
    name: "MyTarget",
    plugins: [.plugin(name: "SwiftMarshalPlugin", package: "swift-marshal")]
)
```

#### Add to an Xcode target

1. Select your target → **Build Phases**
2. Click **+** → **Add Build Tool Plug-in**
3. Select **SwiftMarshalPlugin**

### SwiftMarshalCommandPlugin (Command Plugin)

Runs `fix` on demand with write access to the package directory. Invoked explicitly — never runs automatically.

Because the command plugin writes to source files, SPM prompts for permission on the first run. The plugin requires the `.writeToPackageDirectory` entitlement granted at invocation time.

#### Setup

Add `swift-marshal` as a package dependency. No target-level `plugins:` entry is needed — command plugins are available package-wide.

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/ericodx/swift-marshal.git", from: "1.0.0")
]
```

#### From the command line

The plugin is invoked via the `marshal` verb:

```bash
# Fix all source targets in the package
swift package marshal

# Fix a specific target
swift package marshal --target MyTarget

# Fix multiple specific targets
swift package marshal --target MyTarget --target MyOtherTarget
```

When no `--target` is given, the plugin iterates every source target in the package.

SPM will ask for write permission on the first run:

```
The plugin 'SwiftMarshalCommandPlugin' wants permission to write to the package directory.
Reason: Reorders member declarations in Swift source files.
Allow? (yes/no)
```

Enter `yes` to proceed. On subsequent runs in the same SPM session the prompt does not reappear.

To skip the prompt in scripts, pass `--allow-writing-to-package-directory`:

```bash
swift package --allow-writing-to-package-directory marshal
```

#### From Xcode

1. In the menu bar select **Product → SwiftMarshal**
2. Xcode displays a permission dialog — click **Allow**
3. The plugin runs `fix` on all source targets and the source editor refreshes

To target a specific SPM target, use the command line instead — Xcode does not expose the `--target` argument through the menu UI.

#### Output

The plugin prints the same output as `swift-marshal fix` to the Xcode console:

```
Reordered: Sources/MyTarget/Models/User.swift
Reordered: Sources/MyTarget/Services/UserService.swift
✓ 2 files reordered
```

If all files are already ordered:

```
✓ 12 files already correctly ordered
```

### Plugin configuration

Both plugins respect `.swift-marshal.yaml` at the package root. Place the file there before running the plugin.

---

## Exit Codes

| Code | Meaning |
|---|---|
| `0` | Success — no violations, or `--warn-only` set |
| `1` | Violations found (`check`) / changes needed (`fix --dry-run`) |
| `2` | Error — invalid arguments, file not found, or other runtime failure |

Use exit codes in shell scripts:

```bash
swift-marshal check --path Sources/
case $? in
  0) echo "All types correctly ordered" ;;
  1) echo "Ordering violations found — run 'swift-marshal fix'" ;;
  2) echo "Error — check arguments and file paths" ; exit 2 ;;
esac
```
