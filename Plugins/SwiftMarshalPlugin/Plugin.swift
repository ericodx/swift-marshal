import PackagePlugin

@main
struct SwiftMarshalPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PluginContext,
        target: Target
    ) async throws -> [Command] {
        guard let sourceTarget = target as? SourceModuleTarget else {
            return []
        }

        let tool = try context.tool(named: "swift-marshal")
        let outputPath = context.pluginWorkDirectoryURL.appending(path: "swift-marshal.marker")

        return [
            .buildCommand(
                displayName: "Swift Marshal Check",
                executable: tool.url,
                arguments: [
                    "check",
                    "--xcode",
                    "--path", sourceTarget.directoryURL.path(),
                    "--output", outputPath.path(),
                ],
                outputFiles: [outputPath]
            )
        ]
    }
}

#if canImport(XcodeProjectPlugin)
    import XcodeProjectPlugin

    extension SwiftMarshalPlugin: XcodeBuildToolPlugin {
        func createBuildCommands(
            context: XcodePluginContext,
            target: XcodeTarget
        ) throws -> [Command] {
            let tool = try context.tool(named: "swift-marshal")
            let outputPath = context.pluginWorkDirectoryURL.appending(path: "swift-marshal.marker")

            return [
                .buildCommand(
                    displayName: "Swift Marshal Check",
                    executable: tool.url,
                    arguments: [
                        "check",
                        "--xcode",
                        "--path", context.xcodeProject.directoryURL.path(),
                        "--output", outputPath.path(),
                    ],
                    outputFiles: [outputPath]
                )
            ]
        }
    }
#endif
