# Architecture Documentation

`swift-marshal` is an AST-based CLI that enforces a consistent member ordering within Swift type declarations. It reports violations with `check` and applies fixes with `fix` — both driven by SwiftSyntax and a declarative configuration file.

## Documents

| Document | Contents |
|---|---|
| [01 — Overview](01-overview.md) | Purpose, module map, entry point, exit codes |
| [02 — Pipeline](02-pipeline.md) | Pipeline stages, data flow, concurrency model |
| [03 — Configuration](03-configuration.md) | Configuration model, YAML format, ordering rules |
| [04 — Classification & Rewriting](04-classification-rewriting.md) | Type discovery, member classification, AST rewriting |

## Quick Reference

```
swift-marshal check [--path <dir>] [--config <file>] [--xcode] [--warn-only]
swift-marshal fix   [--path <dir>] [--config <file>] [--dry-run]
swift-marshal init
```

**Exit codes:** `0` success · `1` violations found (check) or changes needed (fix --dry-run) · `2` error
