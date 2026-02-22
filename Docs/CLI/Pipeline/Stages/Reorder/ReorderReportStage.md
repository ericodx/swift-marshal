# ReorderReportStage

**Source**: `Sources/SwiftMarshal/Pipeline/Stages/Reorder/ReorderReportStage.swift`

Stage that generates human-readable reorder reports.

## Structure

| Component | Description |
|-----------|-------------|
| **Type** | `struct ReorderReportStage` |
| **Protocols** | `Stage` |

## Stage Protocol

| Type | Value |
|------|-------|
| `Input` | `ReorderOutput` |
| `Output` | `ReportOutput` |

## Methods

| Method | Parameters | Returns | Description |
|--------|------------|---------|-------------|
| `process(_:)` | `ReorderOutput` | `ReportOutput` | Generate report |

## Report Format

```text
path/to/file.swift:
  struct Foo (line 1)
    [needs reordering]
    original:
      - method doSomething
      - initializer init
    reordered:
      - initializer init
      - method doSomething

Summary: 1 types, 1 need reordering
```

## Report Sections

| Section | Content |
|---------|---------|
| File header | File path |
| Type entry | Kind, name, line number |
| Status | `[needs reordering]` or `[order ok]` |
| Members | Original and reordered lists |
| Summary | Type count and reorder count |

## Design Decisions

- **Human-readable**: Plain text format for CLI output
- **Detailed diff**: Shows both original and reordered for comparison
- **Summary line**: Quick overview of reorder needs

## Related

- [ReorderOutput](ReorderOutput.md) - Input type
- [ReportOutput](../Report/ReportOutput.md) - Output type
