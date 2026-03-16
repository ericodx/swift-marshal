struct ReorderReportStage: Stage {

    // MARK: - Stage

    func process(_ input: ReorderOutput) throws -> ReportOutput {
        var lines: [String] = []
        lines.append("\(input.path):")

        if input.results.isEmpty {
            lines.append("  (no type declarations)")
        } else {
            for result in input.results {
                lines.append("  \(result.kind.rawValue) \(result.name) (line \(result.line))")

                if result.originalMembers.isEmpty {
                    lines.append("    (no members)")
                } else if result.needsReordering {
                    lines.append("    [needs reordering]")
                    lines.append("    original:")
                    for member in result.originalMembers {
                        lines.append("      - \(member.kind.rawValue) \(member.name)")
                    }
                    lines.append("    reordered:")
                    for member in result.reorderedMembers {
                        lines.append("      - \(member.kind.rawValue) \(member.name)")
                    }
                } else {
                    lines.append("    [order ok]")
                    for member in result.originalMembers {
                        lines.append("      - \(member.kind.rawValue) \(member.name)")
                    }
                }
            }
        }

        let needsReorderingCount = input.results.filter(\.needsReordering).count
        lines.append("")
        lines.append("Summary: \(input.results.count) types, \(needsReorderingCount) need reordering")

        return ReportOutput(
            path: input.path,
            text: lines.joined(separator: "\n"),
            declarationCount: input.results.count
        )
    }
}
