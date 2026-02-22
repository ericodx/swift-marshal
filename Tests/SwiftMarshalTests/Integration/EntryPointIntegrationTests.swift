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
}
