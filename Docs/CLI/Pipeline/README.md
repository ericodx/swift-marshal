# Pipeline Module

Core pipeline architecture for composable data processing stages.

## Source Structure

```text
Sources/SwiftMarshal/Pipeline/
├── Pipeline.swift
├── PipelineCoordinator.swift
└── Stages/
    ├── Protocols/
    │   └── Stage.swift
    ├── Parse/
    │   ├── ParseInput.swift
    │   ├── ParseOutput.swift
    │   └── ParseStage.swift
    ├── Classify/
    │   ├── ClassifyOutput.swift
    │   ├── ClassifyStage.swift
    │   ├── SyntaxClassifyOutput.swift
    │   └── SyntaxClassifyStage.swift
    ├── Reorder/
    │   ├── ReorderOutput.swift
    │   ├── ReorderReportStage.swift
    │   ├── ReorderStage.swift
    │   └── TypeReorderResult.swift
    ├── Report/
    │   └── ReportOutput.swift
    └── Rewrite/
        ├── ApplyRewriteStage.swift
        ├── IndexedSyntaxMember.swift
        ├── MemberReorderingRewriter.swift
        ├── RewriteOutput.swift
        ├── RewritePlanOutput.swift
        ├── RewritePlanStage.swift
        ├── TypeLocation.swift
        └── TypeRewritePlan.swift
```

## Documents

| Document | Description |
|----------|-------------|
| [Pipeline](Pipeline.md) | Generic stage compositor |
| [PipelineCoordinator](PipelineCoordinator.md) | Async file processing coordinator |

## Stages

| Module | Description |
|--------|-------------|
| [Protocols](Stages/Protocols/README.md) | Stage protocol definition |
| [Parse](Stages/Parse/README.md) | Source code parsing |
| [Classify](Stages/Classify/README.md) | Type and member classification |
| [Reorder](Stages/Reorder/README.md) | Member reordering logic |
| [Report](Stages/Report/README.md) | Report generation |
| [Rewrite](Stages/Rewrite/README.md) | Syntax tree rewriting |

## Pipeline Architecture

```mermaid
flowchart LR
    subgraph Check Pipeline
        P1[ParseStage] --> C1[ClassifyStage] --> R1[ReorderStage]
    end

    subgraph Fix Pipeline
        P2[ParseStage] --> SC[SyntaxClassifyStage] --> RP[RewritePlanStage] --> AR[ApplyRewriteStage]
    end
```

## Stage Composition

Stages are composed using the `.then()` method:

```mermaid
flowchart LR
    S1[Stage A] -->|".then()"| S2[Stage B] -->|".then()"| S3[Stage C]
```

## Data Flow

```mermaid
flowchart TD
    PI[ParseInput] --> PS[ParseStage]
    PS --> PO[ParseOutput]
    PO --> CS[ClassifyStage]
    CS --> CO[ClassifyOutput]
    CO --> RS[ReorderStage]
    RS --> RO[ReorderOutput]
```

## Purpose

The Pipeline module:
- Defines the `Stage` protocol for composable processing
- Provides `Pipeline` type for stage composition
- Coordinates async file processing via `PipelineCoordinator`
- Implements concrete stages for each processing phase
