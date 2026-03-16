# Entry Point

[Index](README.md) | Next: [Commands →](02-commands.md)

---

## SwiftMarshal

`SwiftMarshal.swift` — `@main` entry point.

```swift
@main
struct SwiftMarshal {
    static func main() async
    static func run(args: [String]) async -> ExitCode
}
```

`main()` strips the process name from `CommandLine.arguments` and passes the remainder to `run(args:)`, then calls `exit(_:)` with the returned code.

`run(args:)` handles three special cases before routing to a subcommand:

```mermaid
flowchart TD
    A[args] --> B{Empty or --help?}
    B -- yes --> C[Print HelpText.usage\nreturn .success]
    B -- no --> D{--version?}
    D -- yes --> E[Print Version.current\nreturn .success]
    D -- no --> F{Subcommand}
    F -- check --> G[CheckCommand.parse + run]
    F -- fix --> H[FixCommand.parse + run]
    F -- init --> I[InitCommand.parse + run]
    F -- unknown --> J[Print error to stderr\nreturn .error]
    G & H & I --> K{Throws ExitCode?}
    K -- yes --> L[Return thrown code]
    K -- no, other error --> M[Print to stderr\nreturn .error]
    K -- no --> N[Return .success]
```

Errors that conform to `ExitCode` propagate the specific exit code. All other thrown errors print to `stderr` and return `.error`.

---

## ExitCode

`CLI/ExitCode.swift`

```swift
struct ExitCode: Error, Sendable {
    let rawValue: Int32
    init(_ rawValue: Int32)

    static let success = ExitCode(0)
    static let error   = ExitCode(2)
}
```

Commands throw `ExitCode(1)` directly to signal violations without printing an error message.

| Value | Meaning |
|---|---|
| `0` | Success |
| `1` | Violations found (`check`) / changes needed (`fix --dry-run`) |
| `2` | Unrecoverable error |

---

## HelpText

`CLI/HelpText.swift`

```swift
enum HelpText {
    static let usage: String
}
```

A static string rendered verbatim to stdout when the user passes `--help`, `-h`, or no arguments.

---

## Version

`Version.swift`

```swift
enum Version {
    static let current: String
}
```

Single static string containing the current tool version, printed for `--version`.

---

## ArgumentParsingError

`CLI/ArgumentParsingError.swift`

```swift
enum ArgumentParsingError: Error, LocalizedError {
    case unknownFlag(String)
    case missingValue(String)
}
```

Thrown by `parseArguments(_:options:handle:)` when argument parsing fails.

| Case | Trigger |
|---|---|
| `.unknownFlag(flag)` | An unrecognised `-` prefixed token |
| `.missingValue(flag)` | A value-taking flag with nothing following it |

---

## ValidationError

`CLI/ValidationError.swift`

```swift
struct ValidationError: Error, LocalizedError, Sendable {
    init(_ message: String)
    var errorDescription: String? { get }
}
```

Wraps a plain message string. Thrown when a command cannot proceed (e.g. no Swift files found).

---

[Index](README.md) | Next: [Commands →](02-commands.md)
