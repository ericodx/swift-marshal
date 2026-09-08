# Building Swift Marshal

This guide covers building, testing, and running `swift-marshal` **from source**.

If you only want to *use* the tool, install a released build instead — see the [Installation Guide](Docs/INSTALLATION.md).

---

## Prerequisites

| Requirement | Version | Notes |
|---|---|---|
| macOS | 15 or later | The package declares `.macOS(.v15)` as its minimum deployment target |
| Swift | 6.2 or later | `Package.swift` uses `swift-tools-version: 6.2` and builds in Swift 6 language mode |
| Xcode | 26 or later | Ships the Swift 6.2 toolchain, and provides `xcrun llvm-cov` for coverage. Any toolchain that provides Swift 6.2+ works |
| Git | any recent version | |

Verify your toolchain:

```bash
swift --version
xcodebuild -version
```

### Dependencies

`swift-marshal` has **a single dependency**: [swift-syntax](https://github.com/swiftlang/swift-syntax) (`from: "603.0.0"`).
Swift Package Manager resolves and builds it automatically on the first build — no manual setup required.

Everything else in the repository (SwiftLint, swift-format, Periphery, codespell, …) is **optional developer tooling**, covered in [Quality tooling](#quality-tooling).

---

## Clone and build

```bash
git clone https://github.com/ericodx/swift-marshal.git
cd swift-marshal

# Debug build
swift build

# Release build (optimized — use this for local installs and benchmarking)
swift build -c release
```

The first build also resolves and compiles `swift-syntax`, which takes several minutes. Later builds are incremental and take seconds.

### Build artifacts

| Configuration | Binary |
|---|---|
| Debug | `.build/debug/swift-marshal` |
| Release | `.build/release/swift-marshal` |

`.build/debug` and `.build/release` are symlinks into an architecture-specific directory. To resolve the real path:

```bash
swift build --show-bin-path
```

### Cleaning

```bash
swift package clean   # remove build products, keep resolved dependencies
swift package reset   # also drop the dependency cache and Package.resolved state
```

Run `swift package reset` after upgrading your Swift toolchain if you hit stale-module errors.

---

## Run the tests

```bash
swift test
```

The suite uses [Swift Testing](https://github.com/swiftlang/swift-testing) (not XCTest) and covers unit, integration, and snapshot tests under `Tests/SwiftMarshalTests/`.

```bash
# Run a single suite or test by name
swift test --filter "ReorderEngine"

# Quieter output
swift test --quiet
```

### Code coverage

`CONTRIBUTING.md` sets a target of **90%+** coverage. To measure it locally:

```bash
swift test --enable-code-coverage

BIN_PATH=$(swift build --show-bin-path)

TEST_BINARY=$(find "$BIN_PATH" -type f \
  -path "*Tests.xctest/Contents/MacOS/*" \
  ! -path "*.dSYM/*" | head -n 1)

xcrun llvm-cov report "$TEST_BINARY" \
  -instr-profile "$BIN_PATH/codecov/default.profdata" \
  --sources Sources
```

Swap `report` for `export --format=lcov` to produce the `lcov.info` that CI feeds to SonarCloud.

### Mutation testing

The project tracks a mutation score alongside coverage. Configuration lives in `.swift-mutation-testing.yml`; install the tool as shown under [Quality tooling](#quality-tooling).

```bash
swift-mutation-testing
```

The run is significantly slower than `swift test` — it re-runs the suite once per mutant.

---

## Run the tool locally

Run straight from the package without installing:

```bash
swift run swift-marshal --help
swift run swift-marshal --version
```

Or invoke the built binary directly, which avoids a rebuild check on every call:

```bash
.build/debug/swift-marshal --help
```

### Typical invocations

```bash
# Check a directory recursively
swift run swift-marshal check --path Sources

# Check specific files
swift run swift-marshal check Sources/SwiftMarshal/Version.swift

# Preview fixes without touching the files
swift run swift-marshal fix --path Sources --dry-run

# Apply fixes
swift run swift-marshal fix --path Sources

# Generate a starter configuration in the current directory
swift run swift-marshal init
```

Files are taken from positional arguments or `--path`. With neither, `swift-marshal` falls back to the `paths:` entry of `.swift-marshal.yaml`; if there is no configuration file either, it exits with `2` and *No Swift files found*.

Full flag reference: [Usage & Configuration Guide](Docs/USAGE.md).

### Exit codes

| Code | Meaning |
|---|---|
| `0` | Success — no violations, or fixes applied |
| `1` | Violations found (`check`) or changes needed (`fix --dry-run`) |
| `2` | Error — bad arguments, unreadable file, invalid configuration |

Use `--warn-only` to force `check` to exit `0` even when violations are found.

### Running the plugins

The package ships two SPM plugins. Both build the `swift-marshal` executable first, then invoke it.

```bash
# List the command plugins exposed by the package
swift package plugin --list

# Run the command plugin (writes to the package directory)
swift package --allow-writing-to-package-directory marshal

# Restrict it to a single target
swift package --allow-writing-to-package-directory marshal --target MyTarget
```

`SwiftMarshalPlugin` is a build tool plugin and runs automatically as part of `swift build` in any package that attaches it to a target; it runs `check --xcode` in read-only mode and reports violations as build warnings.

---

## Install the local build

```bash
swift build -c release
sudo cp .build/release/swift-marshal /usr/local/bin/

swift-marshal --version
# swift-marshal 0.0.0-dev [arm64-macos26]
```

Source builds report the version as `0.0.0-dev` — the real version number is injected by the release workflow at tag time. Homebrew builds report the released version, so `--version` tells you which one is on your `PATH`.

To remove it:

```bash
sudo rm /usr/local/bin/swift-marshal
```

If you also have the Homebrew build installed, either uninstall it (`brew uninstall swift-marshal`) or make sure `/usr/local/bin` precedes `/opt/homebrew/bin` in your `PATH`.

---

## Quality tooling

These checks are optional locally but gate the pull request in CI. Install what you need:

```bash
brew install swiftlint swift-format periphery pre-commit
brew install ericodx/homebrew-tools/swift-cpd ericodx/homebrew-tools/swift-mutation-testing
```

| Tool | Command | Configuration |
|---|---|---|
| SwiftLint | `swiftlint lint --strict --quiet` | `.swiftlint.yml` |
| swift-format (check) | `swift-format lint --recursive --parallel Sources Tests` | `.swift-format` |
| swift-format (apply) | `swift-format format --in-place --recursive --parallel Sources Tests` | `.swift-format` |
| Clone detection | `swift-cpd` | `.swift-cpd.yml` |
| Dead code | `periphery scan` | `.periphery.yml` |
| Mutation testing | `swift-mutation-testing` | `.swift-mutation-testing.yml` |

### pre-commit

The repository defines its own hooks in `.pre-commit-config.yaml` — SwiftLint, swift-format, codespell, Gitleaks, clone detection, and commit message rules.

```bash
pre-commit install          # installs both the pre-commit and commit-msg hooks
pre-commit run --all-files  # run every hook against the whole repository
```

Two commit message rules are enforced through the `commit-msg` hook and reject the commit locally:

- messages must follow [Conventional Commits](https://www.conventionalcommits.org) (`docs: add BUILDING.md`)
- messages must be **a single line** — no body, no `Co-Authored-By:` trailer

Direct commits to `main` are blocked; work on a branch and open a pull request.

---

## What CI runs

| Workflow | Trigger | Steps |
|---|---|---|
| `pull-request-analysis.yml` | PR to `main` (non-Markdown changes) | `swift test` on `macos-26` |
| `pull-request-docs-bypass.yml` | PR to `main` (Markdown only) | Skips analysis |
| `main-analysis.yml` | Push to `main` | `swift test --enable-code-coverage`, LCOV export, SonarCloud scan |
| `release.yml` | Tag `v*` or manual dispatch | Injects the version, `swift build -c release`, uploads the macOS tarball |

Running `swift test`, `swiftlint lint --strict`, and `swift-format lint` before pushing reproduces everything the pull request gate checks.

---

## Troubleshooting

**`error: package at '/…' is using Swift tools version 6.2.0 but the installed version is …`**
Your toolchain is older than the package requires. Install Swift 6.2+ or a matching Xcode, then run `xcode-select -s /Applications/Xcode.app` to point the command line tools at it.

**Stale or missing modules after a toolchain upgrade**
Run `swift package reset && swift build`.

**Dependency resolution fails behind a proxy or offline**
`swift-syntax` is fetched over HTTPS from GitHub on the first build and cached under `.build/checkouts`. Later builds reuse that checkout. To stop SwiftPM from re-resolving versions, pin them with `swift build --disable-automatic-resolution`, which requires an existing `Package.resolved`.

**`swift package marshal` fails with a sandbox or permission error**
The command plugin writes to the package directory and needs `--allow-writing-to-package-directory`, placed *before* the `marshal` verb.

**Tests pass locally but coverage output is empty**
`--enable-code-coverage` must be passed to `swift test` itself, and the profile data is written under the *architecture-specific* bin path — always resolve it with `swift build --show-bin-path`.

---

## Next steps

| Document | Contents |
|---|---|
| [Contributing](CONTRIBUTING.md) | Technical principles, testing requirements, pull request workflow |
| [Installation](Docs/INSTALLATION.md) | Homebrew, pre-built binaries, pre-commit hook, Xcode plugin |
| [Usage & Configuration](Docs/USAGE.md) | CLI options, YAML reference, output formats, CI integration |
| [Architecture](Docs/Architecture/README.md) | Module map, pipeline design, configuration model, AST rewriting |
| [Codebase Reference](Docs/CodeBase/README.md) | Every type, protocol, and stage documented |
