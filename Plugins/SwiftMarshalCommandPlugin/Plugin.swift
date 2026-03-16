import Foundation
import PackagePlugin

@main
struct SwiftMarshalCommandPlugin: CommandPlugin {

    func performCommand(context: PluginContext, arguments: [String]) async throws {
        let tool = try context.tool(named: "swift-marshal")
        var extractor = ArgumentExtractor(arguments)
        let targetNames = extractor.extractOption(named: "target")

        let targets: [Target]

        if targetNames.isEmpty {
            targets = context.package.targets
        } else {
            targets = try context.package.targets(named: targetNames)
        }

        for target in targets {
            guard let sourceTarget = target as? SourceModuleTarget else {
                continue
            }

            run(tool: tool.url, arguments: ["fix", "--path", sourceTarget.directoryURL.path()])
        }
    }

    private func run(tool: URL, arguments: [String]) {
        let process = Process()
        process.executableURL = tool
        process.arguments = arguments
        try? process.run()
        process.waitUntilExit()
    }
}

#if canImport(XcodeProjectPlugin)
    import XcodeProjectPlugin

    extension SwiftMarshalCommandPlugin: XcodeCommandPlugin {
        func performCommand(context: XcodePluginContext, arguments: [String]) throws {
            let tool = try context.tool(named: "swift-marshal")
            run(tool: tool.url, arguments: ["fix", "--path", context.xcodeProject.directoryURL.path()])
        }
    }
#endif
