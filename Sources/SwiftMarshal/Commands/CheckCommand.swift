import Foundation

struct CheckCommand {

    // MARK: - Properties

    var options = CommonCommandOptions()
    var warnOnly: Bool = false
    var xcode: Bool = false
    var output: String?

    // MARK: - Parsing

    static func parse(_ args: [String]) throws -> CheckCommand {
        var command = CheckCommand()

        try parseArguments(args, options: &command.options) { flag, index in
            switch flag {

            case "--warn-only":
                command.warnOnly = true
                return true

            case "--xcode":
                command.xcode = true
                return true

            case "--output":
                command.output = try nextValue(in: args, after: &index, flag: "--output")
                return true

            default:
                return false

            }
        }

        return command
    }

    // MARK: - Execution

    func run() async throws {
        let resolved = try await resolveCommand(options: options)
        let results = try await resolved.coordinator.checkFiles(resolved.files)

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
            } else if !options.quiet {
                print(result.reportText)
                print()
            }
        }

        if !xcode {
            printSummary(
                totalFiles: resolved.files.count,
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
            if options.quiet {
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
