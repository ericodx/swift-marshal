import Foundation
import Testing

@Suite("Entry Point Integration Tests")
struct EntryPointIntegrationTests {

    // MARK: - Help

    @Test("Given no arguments, when running binary, then exits 0 and prints help")
    func noArgsExitsZeroAndPrintsHelp() throws {
        let result = try run(args: [])
        #expect(result.exitCode == 0)
        #expect(result.stdout.contains("swift-marshal"))
        #expect(result.stdout.contains("check"))
        #expect(result.stdout.contains("fix"))
    }

    @Test("Given --help flag, when running binary, then exits 0")
    func helpFlagExitsZero() throws {
        let result = try run(args: ["--help"])
        #expect(result.exitCode == 0)
        #expect(result.stdout.contains("swift-marshal"))
    }

    @Test("Given -h flag, when running binary, then exits 0")
    func shortHelpFlagExitsZero() throws {
        let result = try run(args: ["-h"])
        #expect(result.exitCode == 0)
    }

    // MARK: - Version

    @Test("Given --version flag, when running binary, then exits 0 and prints version")
    func versionFlagExitsZeroAndPrintsVersion() throws {
        let result = try run(args: ["--version"])
        #expect(result.exitCode == 0)
        #expect(result.stdout.contains("swift-marshal"))
    }

    // MARK: - Unknown Command

    @Test("Given unknown subcommand, when running binary, then exits non-zero")
    func unknownCommandExitsNonZero() throws {
        let result = try run(args: ["unknown-subcommand"])
        #expect(result.exitCode != 0)
        #expect(result.stderr.contains("unknown command"))
    }

    // MARK: - Parse Error

    @Test("Given check subcommand with unknown flag, when running binary, then exits non-zero")
    func checkWithUnknownFlagExitsNonZero() throws {
        let result = try run(args: ["check", "--nonexistent-flag"])
        #expect(result.exitCode != 0)
    }

    // MARK: - Successful Subcommands

    @Test("Given check subcommand with ordered file, when running binary, then exits 0")
    func checkOrderedFileExitsZero() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["check", "--quiet", tempFile])
        #expect(result.exitCode == 0)
    }

    @Test("Given check subcommand with unordered file, when running binary, then exits 1")
    func checkUnorderedFileExitsOne() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["check", "--quiet", tempFile])
        #expect(result.exitCode == 1)
    }

    // MARK: - Unavailable Current Directory

    @Test("Given a deleted current directory, when running check, then finishes with the default configuration")
    func checkFromDeletedDirectoryFinishes() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try runFromDeletedDirectory(args: ["check", "--quiet", tempFile])
        #expect(result.finished)
        #expect(result.exitCode == 1)
    }

    @Test("Given a deleted current directory, when running init, then fails with an error")
    func initFromDeletedDirectoryFails() throws {
        let result = try runFromDeletedDirectory(args: ["init"])
        #expect(result.finished)
        #expect(result.exitCode == 2)
    }

    private func runFromDeletedDirectory(args: [String]) throws -> (finished: Bool, exitCode: Int32) {
        let binaryPath = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(".build/debug/swift-marshal")
            .path
        let parent = createTempDirectory()
        defer { removeTempDirectory(parent) }
        let directory = parent + "/cwd"
        try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: false)

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        let script = "cd \"$1\" && rmdir \"$1\" && shift && exec \"$@\""
        process.arguments = ["-c", script, "sh", directory, binaryPath] + args
        process.standardOutput = FileHandle.nullDevice
        process.standardError = FileHandle.nullDevice
        try process.run()

        let deadline = Date().addingTimeInterval(10)
        while process.isRunning && Date() < deadline {
            Thread.sleep(forTimeInterval: 0.05)
        }
        guard !process.isRunning else {
            process.terminate()
            return (false, -1)
        }
        return (true, process.terminationStatus)
    }
}
