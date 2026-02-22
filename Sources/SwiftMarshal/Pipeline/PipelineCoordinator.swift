actor PipelineCoordinator {

    init(fileIO: FileIOActor, configuration: Configuration) {
        self.fileIO = fileIO
        self.configuration = configuration
    }

    private let fileIO: FileIOActor
    private let configuration: Configuration

    nonisolated static func create(configPath: String?) async throws -> PipelineCoordinator {
        let fileIO = FileIOActor()
        let fileReader = FileReader()
        let configService = ConfigurationService(fileReader: fileReader)
        let configuration = try await configService.load(configPath: configPath)
        return PipelineCoordinator(fileIO: fileIO, configuration: configuration)
    }

    // MARK: - Check Operation

    func checkFiles(_ paths: [String]) async throws -> [CheckResult] {
        let pipeline = ParseStage()
            .then(ClassifyStage())
            .then(ReorderStage(configuration: configuration))

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
            return results
        }
    }

    // MARK: - Fix Operation

    func fixFiles(_ paths: [String], dryRun: Bool) async throws -> [FixResult] {
        let pipeline = ParseStage()
            .then(SyntaxClassifyStage())
            .then(RewritePlanStage(configuration: configuration))
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
            return results
        }
    }

    // MARK: - Private Helpers

    private func checkSingleFile(
        path: String, pipeline: any Stage<ParseInput, ReorderOutput>
    ) async throws -> CheckResult {
        let source = try await fileIO.read(at: path)
        let input = ParseInput(path: path, source: source)
        let output = try pipeline.process(input)
        let needsReorder = needsReordering(output.results)
        return CheckResult(path: path, results: output.results, needsReorder: needsReorder)
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
