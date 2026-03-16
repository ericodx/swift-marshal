# Codebase Reference

`swift-marshal` is an AST-based CLI that enforces consistent member ordering within Swift type declarations. This reference documents every module, type, and function in the production codebase.

## Documents

| Document | Contents |
|---|---|
| [01 — Entry Point](01-entry-point.md) | `SwiftMarshal` `@main`, argument routing, `Version`, `HelpText`, `ExitCode` |
| [02 — Commands](02-commands.md) | `CheckCommand`, `FixCommand`, `InitCommand`, `CommonCommandOptions`, shared parsing helpers |
| [03 — Pipeline](03-pipeline.md) | `Stage` protocol, `Pipeline` composition, `PipelineCoordinator`, `CheckResult`, `FixResult` |
| [04 — Stages](04-stages.md) | `ParseStage`, `SyntaxClassifyStage`, `RewritePlanStage`, `ApplyRewriteStage`, `ReorderReportStage` and their I/O types |
| [05 — Core Models](05-core-models.md) | `MemberDeclaration`, `MemberKind`, `Visibility`, `TypeKind`, `SyntaxTypeDeclaration`, `SyntaxMemberDeclaration` |
| [06 — Configuration](06-configuration.md) | `Configuration`, `ConfigurationService`, `ConfigurationLoader`, `ConfigurationMapper`, `MemberOrderingRule` |
| [07 — Reordering & Rewriting](07-reordering-rewriting.md) | `ReorderEngine`, `TypeRewritePlan`, `TypeReorderResult`, `MemberReorderingRewriter` |
| [08 — Infrastructure](08-infrastructure.md) | `FileIOActor`, `SwiftFileResolver`, `ProjectDetector`, AST visitors and builders |

## Quick Reference

```
swift-marshal check [files…] [--path <dir>] [--config <file>] [--xcode] [--warn-only] [--output <file>] [-q]
swift-marshal fix   [files…] [--path <dir>] [--config <file>] [--dry-run] [-q]
swift-marshal init  [--force]
```

**Exit codes:** `0` success · `1` violations found (`check`) or changes needed (`fix --dry-run`) · `2` error
