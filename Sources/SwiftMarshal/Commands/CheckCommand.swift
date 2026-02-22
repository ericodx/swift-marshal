import Foundation

struct CheckCommand {

    // MARK: - Properties

    var files: [String] = []
    var path: String?
    var config: String?
    var quiet: Bool = false
    var warnOnly: Bool = false
    var xcode: Bool = false
    var output: String?

    // MARK: - Parsing

    static func parse(_ args: [String]) throws -> CheckCommand {
        var command = CheckCommand()
        var index = 0

        while index < args.count {
            switch args[index] {

            case "--quiet", "-q":
                command.quiet = true

            case "--warn-only":
                command.warnOnly = true

            case "--xcode":
                command.xcode = true

            case "--path", "-p":
                command.path = try nextValue(in: args, after: &index, flag: "--path")

            case "--config", "-c":
                command.config = try nextValue(in: args, after: &index, flag: "--config")

            case "--output":
                command.output = try nextValue(in: args, after: &index, flag: "--output")

            default:
                if args[index].hasPrefix("-") {
                    throw ArgumentParsingError.unknownFlag(args[index])
                }
                command.files.append(args[index])

            }

            index += 1
        }

        return command
    }

    private static func nextValue(in args: [String], after index: inout Int, flag: String) throws -> String {
        index += 1
        guard index < args.count else {
            throw ArgumentParsingError.missingValue(flag)
        }
        return args[index]
    }

    // MARK: - Execution

    func run() async throws {
        let filesToCheck = SwiftFileResolver.resolve(files: files, path: path)

        guard !filesToCheck.isEmpty else {
            throw ValidationError("No Swift files found. Provide files as arguments or use --path.")
        }

        let coordinator = try await PipelineCoordinator.create(configPath: config)
        let results = try await coordinator.checkFiles(filesToCheck)

        var totalTypes = 0
        var typesNeedingReorder = 0
        var filesNeedingReorder: [String] = []

        for result in results {
            totalTypes += result.results.count

            if result.needsReorder {
                filesNeedingReorder.append(result.path)
                typesNeedingReorder += result.results.filter(\.needsReordering).count
            }

            if xcode {
                printXcodeWarnings(path: result.path, results: result.results)
            } else if !quiet {
                let reportStage = ReorderReportStage()
                let reorderOutput = ReorderOutput(path: result.path, results: result.results)
                let reportOutput = try reportStage.process(reorderOutput)
                print(reportOutput.text)
                print()
            }
        }

        if !xcode {
            printSummary(
                totalFiles: filesToCheck.count,
                totalTypes: totalTypes,
                filesNeedingReorder: filesNeedingReorder,
                typesNeedingReorder: typesNeedingReorder
            )
        }

        if let outputPath = output {
            try writeMarkerFile(to: outputPath)
        }

        let shouldFail = !filesNeedingReorder.isEmpty && !warnOnly && !xcode

        if shouldFail {
            throw ExitCode(1)
        }
    }

    // MARK: - Private Helpers

    private func writeMarkerFile(to path: String) throws {
        let url = URL(fileURLWithPath: path)
        let directory = url.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try Data().write(to: url)
    }

    private func printXcodeWarnings(path: String, results: [TypeReorderResult]) {
        for result in results where result.needsReordering {
            print("\(path):\(result.line): warning: '\(result.name)' members need reordering")
        }
    }

    private func printSummary(
        totalFiles: Int,
        totalTypes: Int,
        filesNeedingReorder: [String],
        typesNeedingReorder: Int
    ) {
        if filesNeedingReorder.isEmpty {
            print(
                "✓ All \(totalTypes) types in \(totalFiles) \(totalFiles == 1 ? "file" : "files") are correctly ordered"
            )
        } else {
            if quiet {
                for file in filesNeedingReorder {
                    print("\(file)")
                }
                print()
            }
            let typeWord = typesNeedingReorder == 1 ? "type" : "types"
            let fileWord = filesNeedingReorder.count == 1 ? "file needs" : "files need"
            print("✗ \(typesNeedingReorder) \(typeWord) in \(filesNeedingReorder.count) \(fileWord) reordering")
            print("  Run 'swift-marshal fix' to apply changes")
        }
    }
}
