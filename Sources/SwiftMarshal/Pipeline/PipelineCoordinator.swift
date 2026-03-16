actor PipelineCoordinator {

    init(fileIO: FileIOActor, configuration: Configuration) {
        self.fileIO = fileIO
        self.configuration = configuration
    }

    private let fileIO: FileIOActor
    private let configuration: Configuration

    // MARK: - Check Operation

    func checkFiles(_ paths: [String]) async throws -> [CheckResult] {
        let pipeline = ParseStage()
            .then(SyntaxClassifyStage())
            .then(RewritePlanStage(engine: ReorderEngine(configuration: configuration)))

        return try await withThrowingTaskGroup(of: CheckResult.self) { group in
            for path in paths {
                group.addTask {
                    try await self.checkSingleFile(path: path, pipeline: pipeline)
                }
            }

            var results: [CheckResult] = []
            for try await result in group {
                results.append(result)
            }
            return results.sorted { $0.path < $1.path }
        }
    }

    // MARK: - Fix Operation

    func fixFiles(_ paths: [String], dryRun: Bool) async throws -> [FixResult] {
        let pipeline = ParseStage()
            .then(SyntaxClassifyStage())
            .then(RewritePlanStage(engine: ReorderEngine(configuration: configuration)))
            .then(ApplyRewriteStage())

        return try await withThrowingTaskGroup(of: FixResult.self) { group in
            for path in paths {
                group.addTask {
                    try await self.fixSingleFile(path: path, pipeline: pipeline, dryRun: dryRun)
                }
            }

            var results: [FixResult] = []
            for try await result in group {
                results.append(result)
            }
            return results.sorted { $0.path < $1.path }
        }
    }

    // MARK: - Private Helpers

    private func checkSingleFile(
        path: String, pipeline: any Stage<ParseInput, RewritePlanOutput>
    ) async throws -> CheckResult {
        let source = try await fileIO.read(at: path)
        let input = ParseInput(path: path, source: source)
        let output = try pipeline.process(input)
        let results = output.plans.map(TypeReorderResult.init(from:))
        let reorderOutput = ReorderOutput(path: path, results: results)
        let needsReorder = needsReordering(results)
        let reportText = try ReorderReportStage().process(reorderOutput).text
        return CheckResult(path: path, results: results, needsReorder: needsReorder, reportText: reportText)
    }

    private func needsReordering(_ results: [TypeReorderResult]) -> Bool {
        return results.contains { $0.needsReordering }
    }

    private func fixSingleFile(
        path: String, pipeline: any Stage<ParseInput, RewriteOutput>, dryRun: Bool
    ) async throws -> FixResult {
        let source = try await fileIO.read(at: path)
        let input = ParseInput(path: path, source: source)
        let output = try pipeline.process(input)

        if output.modified && !dryRun {
            try await fileIO.write(output.source, to: path)
        }

        return FixResult(path: path, source: output.source, modified: output.modified)
    }
}
