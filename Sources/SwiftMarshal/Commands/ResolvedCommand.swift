struct ResolvedCommand: Sendable {
    let coordinator: PipelineCoordinator
    let files: [String]
    let configuration: Configuration
}
