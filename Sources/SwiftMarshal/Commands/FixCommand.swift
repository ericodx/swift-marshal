import Foundation

struct FixCommand {

    // MARK: - Properties

    var files: [String] = []
    var path: String?
    var config: String?
    var dryRun: Bool = false
    var quiet: Bool = false

    // MARK: - Parsing

    static func parse(_ args: [String]) throws -> FixCommand {
        var command = FixCommand()
        var index = 0

        while index < args.count {
            switch args[index] {

            case "--dry-run":
                command.dryRun = true

            case "--quiet", "-q":
                command.quiet = true

            case "--path", "-p":
                index += 1
                guard index < args.count else {
                    throw ArgumentParsingError.missingValue("--path")
                }
                command.path = args[index]

            case "--config", "-c":
                index += 1
                guard index < args.count else {
                    throw ArgumentParsingError.missingValue("--config")
                }
                command.config = args[index]

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

    // MARK: - Execution

    func run() async throws {
        let filesToFix = SwiftFileResolver.resolve(files: files, path: path)

        guard !filesToFix.isEmpty else {
            throw ValidationError("No Swift files found. Provide files as arguments or use --path.")
        }

        let coordinator = try await PipelineCoordinator.create(configPath: config)
        let results = try await coordinator.fixFiles(filesToFix, dryRun: dryRun)

        var modifiedFiles: [String] = []

        for result in results where result.modified {
            modifiedFiles.append(result.path)

            if !quiet {
                if dryRun {
                    print("Would reorder: \(result.path)")
                } else {
                    print("Reordered: \(result.path)")
                }
            }
        }

        printSummary(
            totalFiles: filesToFix.count,
            modifiedFiles: modifiedFiles,
            dryRun: dryRun
        )

        if dryRun && !modifiedFiles.isEmpty {
            throw ExitCode(1)
        }
    }

    // MARK: - Private Helpers

    private func printSummary(totalFiles: Int, modifiedFiles: [String], dryRun: Bool) {
        let count = modifiedFiles.count

        if count == 0 {
            print("✓ All \(totalFiles) \(totalFiles == 1 ? "file" : "files") already correctly ordered")
        } else if dryRun {
            print("⚠ \(count) \(count == 1 ? "file" : "files") would be modified")
        } else {
            print("✓ \(count) \(count == 1 ? "file" : "files") reordered")
        }
    }
}
