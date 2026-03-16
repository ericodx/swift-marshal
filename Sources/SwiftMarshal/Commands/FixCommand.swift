import Foundation

struct FixCommand {

    // MARK: - Properties

    var options = CommonCommandOptions()
    var dryRun: Bool = false

    // MARK: - Parsing

    static func parse(_ args: [String]) throws -> FixCommand {
        var command = FixCommand()

        try parseArguments(args, options: &command.options) { flag, _ in
            if flag == "--dry-run" {
                command.dryRun = true
                return true
            }
            return false
        }

        return command
    }

    // MARK: - Execution

    func run() async throws {
        let resolved = try await resolveCommand(options: options)
        let results = try await resolved.coordinator.fixFiles(resolved.files, dryRun: dryRun)

        var modifiedFiles: [String] = []

        for result in results where result.modified {
            modifiedFiles.append(result.path)

            if !options.quiet {
                if dryRun {
                    print("Would reorder: \(result.path)")
                } else {
                    print("Reordered: \(result.path)")
                }
            }
        }

        printSummary(
            totalFiles: resolved.files.count,
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
