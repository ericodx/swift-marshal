import Foundation
import Testing

@testable import swift_marshal

@Suite("SwiftMarshal.run Tests", .serialized)
struct SwiftMarshalRunTests {

    // MARK: - Help

    @Test("Given no arguments, when running, then returns success and prints help")
    func emptyArgsReturnsSuccess() async {
        let code = await SwiftMarshal.run(args: [])
        #expect(code.rawValue == ExitCode.success.rawValue)
    }

    @Test("Given --help flag, when running, then returns success")
    func helpFlagReturnsSuccess() async {
        let code = await SwiftMarshal.run(args: ["--help"])
        #expect(code.rawValue == ExitCode.success.rawValue)
    }

    @Test("Given -h flag, when running, then returns success")
    func shortHelpFlagReturnsSuccess() async {
        let code = await SwiftMarshal.run(args: ["-h"])
        #expect(code.rawValue == ExitCode.success.rawValue)
    }

    // MARK: - Version

    @Test("Given --version flag, when running, then returns success")
    func versionFlagReturnsSuccess() async {
        let code = await SwiftMarshal.run(args: ["--version"])
        #expect(code.rawValue == ExitCode.success.rawValue)
    }

    // MARK: - Unknown Command

    @Test("Given an unknown subcommand, when running, then returns error")
    func unknownCommandReturnsError() async {
        let code = await SwiftMarshal.run(args: ["unknown-command"])
        #expect(code.rawValue == ExitCode.error.rawValue)
    }

    // MARK: - Parse Error (generic catch)

    @Test("Given check subcommand with unknown flag, when running, then returns error")
    func checkParseErrorReturnsError() async {
        let code = await SwiftMarshal.run(args: ["check", "--nonexistent-flag"])
        #expect(code.rawValue == ExitCode.error.rawValue)
    }

    @Test("Given fix subcommand with unknown flag, when running, then returns error")
    func fixParseErrorReturnsError() async {
        let code = await SwiftMarshal.run(args: ["fix", "--nonexistent-flag"])
        #expect(code.rawValue == ExitCode.error.rawValue)
    }

    @Test("Given init subcommand with unknown flag, when running, then returns error")
    func initParseErrorReturnsError() async {
        let code = await SwiftMarshal.run(args: ["init", "--nonexistent-flag"])
        #expect(code.rawValue == ExitCode.error.rawValue)
    }

    // MARK: - ExitCode catch

    @Test("Given check subcommand with unordered file, when running, then returns exit code 1")
    func checkUnorderedFileReturnsExitCode1() async {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let code = await SwiftMarshal.run(args: ["check", "--quiet", tempFile])
        #expect(code.rawValue == 1)
    }

    // MARK: - Successful subcommands

    @Test("Given check subcommand with ordered file, when running, then returns success")
    func checkOrderedFileReturnsSuccess() async {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let code = await SwiftMarshal.run(args: ["check", "--quiet", tempFile])
        #expect(code.rawValue == ExitCode.success.rawValue)
    }

    @Test("Given fix subcommand with ordered file, when running, then returns success")
    func fixOrderedFileReturnsSuccess() async {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let code = await SwiftMarshal.run(args: ["fix", "--quiet", tempFile])
        #expect(code.rawValue == ExitCode.success.rawValue)
    }

    @Test("Given init subcommand in empty directory, when running, then returns success")
    func initSubcommandReturnsSuccess() async {
        let tempDir = createTempDirectory()
        defer { removeTempDirectory(tempDir) }

        let originalDir = FileManager.default.currentDirectoryPath
        FileManager.default.changeCurrentDirectoryPath(tempDir)
        defer { FileManager.default.changeCurrentDirectoryPath(originalDir) }

        let code = await SwiftMarshal.run(args: ["init"])
        #expect(code.rawValue == ExitCode.success.rawValue)
    }
}
