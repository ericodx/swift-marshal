import Foundation
import Testing

@testable import swift_marshal

@Suite("CheckCommand Tests")
struct CheckCommandTests {

    // MARK: - Exit Code Behavior

    @Test(
        "Given files that need reordering, when executing check command, then throws ExitCode(1)"
    )
    func exitsWithOneWhenChangesNeeded() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    @Test(
        "Given already ordered files, when executing check command, then does not throw"
    )
    func doesNotThrowWhenNoChangesNeeded() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    @Test(
        "Given check command with quiet flag, when files need reordering, then outputs file paths"
    )
    func quietModeOutputsFilePaths() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    @Test("Given files needing changes without quiet flag, when executing check, then prints detailed output")
    func printsDetailedOutputWithoutQuietFlag() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse([tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    @Test(
        "Given files needing changes with detailed output enabled, when executing check, then generates report and prints details"
    )
    func generatesDetailedReportWhenQuietFalse() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse([tempFile])  // quiet=false by default

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    // MARK: - Multiple Files

    @Test("Given multiple files with some needing reordering, when executing check, then reports correct count")
    func handlesMultipleFiles() async throws {
        let tempFile1 = createTempFile(
            content: """
                struct Test1 {
                    func doSomething() {}
                    init() {}
                }
                """)
        let tempFile2 = createTempFile(
            content: """
                struct Test2 {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer {
            removeTempFile(tempFile1)
            removeTempFile(tempFile2)
        }

        let command = try CheckCommand.parse(["--quiet", tempFile1, tempFile2])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    @Test("Given multiple ordered files, when executing check, then does not throw")
    func multipleOrderedFilesDoNotThrow() async throws {
        let tempFile1 = createTempFile(
            content: """
                struct Test1 {
                    init() {}
                    func doSomething() {}
                }
                """)
        let tempFile2 = createTempFile(
            content: """
                struct Test2 {
                    init() {}
                    var name: String
                }
                """)
        defer {
            removeTempFile(tempFile1)
            removeTempFile(tempFile2)
        }

        let command = try CheckCommand.parse(["--quiet", tempFile1, tempFile2])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    // MARK: - Single Type Edge Cases

    @Test("Given a file with single type needing reorder, when executing check with quiet, then reports correctly")
    func singleTypeNeedingReorder() async throws {
        let tempFile = createTempFile(
            content: """
                struct Single {
                    func method() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    // MARK: - Multiple Types in Single File

    @Test("Given a file with multiple types needing reorder, when executing check, then counts all types")
    func multipleTypesNeedingReorder() async throws {
        let tempFile = createTempFile(
            content: """
                struct First {
                    func a() {}
                    init() {}
                }
                struct Second {
                    func b() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    // MARK: - Singular/Plural Coverage

    @Test("Given single file with single type ordered, when check, then uses singular 'file'")
    func singleFileSingleTypeOrdered() async throws {
        let tempFile = createTempFile(
            content: """
                struct Single {
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    @Test("Given single file with single type needing reorder, when check, then uses singular 'type' and 'file needs'")
    func singleFileSingleTypeNeedsReorder() async throws {
        let tempFile = createTempFile(
            content: """
                struct Single {
                    func method() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    // MARK: - Warn Only Flag

    @Test("Given files needing reorder with warn-only flag, when executing check, then does not throw")
    func warnOnlyDoesNotThrowWhenChangesNeeded() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--warn-only", "--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    @Test("Given ordered files with warn-only flag, when executing check, then does not throw")
    func warnOnlyDoesNotThrowWhenNoChangesNeeded() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--warn-only", "--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    // MARK: - Path Flag

    @Test("Given directory with Swift files, when using --path flag, then finds and checks all files")
    func pathFlagFindsSwiftFiles() async throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

        let file1 = tempDir.appendingPathComponent("File1.swift")
        let file2 = tempDir.appendingPathComponent("File2.swift")

        try """
        struct Test1 {
            init() {}
        }
        """.write(to: file1, atomically: true, encoding: .utf8)

        try """
        struct Test2 {
            init() {}
        }
        """.write(to: file2, atomically: true, encoding: .utf8)

        defer { try? FileManager.default.removeItem(at: tempDir) }

        let command = try CheckCommand.parse(["--path", tempDir.path, "--quiet"])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    @Test("Given no files and no path, when executing check, then throws validation error")
    func noFilesOrPathThrowsError() async throws {
        let command = try CheckCommand.parse([])

        await #expect(throws: ValidationError.self) {
            try await command.run()
        }
    }

    @Test("Given path to directory with nested Swift files, when using --path flag, then finds files recursively")
    func pathFlagFindsNestedFiles() async throws {
        let tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        let nestedDir = tempDir.appendingPathComponent("Nested")
        try FileManager.default.createDirectory(at: nestedDir, withIntermediateDirectories: true)

        let file1 = tempDir.appendingPathComponent("Root.swift")
        let file2 = nestedDir.appendingPathComponent("Nested.swift")

        try """
        struct Root {
            init() {}
        }
        """.write(to: file1, atomically: true, encoding: .utf8)

        try """
        struct Nested {
            init() {}
        }
        """.write(to: file2, atomically: true, encoding: .utf8)

        defer { try? FileManager.default.removeItem(at: tempDir) }

        let command = try CheckCommand.parse(["--path", tempDir.path, "--quiet"])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    // MARK: - Xcode Flag

    @Test("Given files needing reorder with xcode flag, when executing check, then does not throw")
    func xcodeFlagDoesNotThrow() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--xcode", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    @Test("Given ordered files with xcode flag, when executing check, then does not throw")
    func xcodeFlagWithOrderedFilesDoesNotThrow() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--xcode", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }
    }

    @Test("Given invalid directory path, when using --path flag, then throws validation error")
    func invalidPathThrowsError() async throws {
        let command = try CheckCommand.parse(["--path", "/nonexistent/directory/that/does/not/exist"])

        await #expect(throws: ValidationError.self) {
            try await command.run()
        }
    }

    // MARK: - Output Flag

    @Test("Given output flag, when executing check on ordered files, then creates marker file")
    func outputFlagCreatesMarkerFile() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        let outputPath = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent("marker.txt")
        defer {
            removeTempFile(tempFile)
            try? FileManager.default.removeItem(at: outputPath.deletingLastPathComponent())
        }

        let command = try CheckCommand.parse(["--output", outputPath.path, "--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }

        #expect(FileManager.default.fileExists(atPath: outputPath.path))
    }

    @Test("Given output flag, when executing check on unordered files, then creates marker file before throwing")
    func outputFlagCreatesMarkerFileEvenWhenFailing() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        let outputPath = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent("marker.txt")
        defer {
            removeTempFile(tempFile)
            try? FileManager.default.removeItem(at: outputPath.deletingLastPathComponent())
        }

        let command = try CheckCommand.parse(["--output", outputPath.path, "--quiet", tempFile])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }

        #expect(FileManager.default.fileExists(atPath: outputPath.path))
    }

    @Test("Given output flag with nested directory, when executing check, then creates intermediate directories")
    func outputFlagCreatesIntermediateDirectories() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                }
                """)
        let outputPath = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent("nested")
            .appendingPathComponent("deep")
            .appendingPathComponent("marker.txt")
        defer {
            removeTempFile(tempFile)
            try? FileManager.default.removeItem(
                at: outputPath.deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
            )
        }

        let command = try CheckCommand.parse(["--output", outputPath.path, "--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }

        #expect(FileManager.default.fileExists(atPath: outputPath.path))
    }

    @Test("Given output flag with xcode flag, when executing check, then creates marker file")
    func outputFlagWorksWithXcodeFlag() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        let outputPath = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent("marker.txt")
        defer {
            removeTempFile(tempFile)
            try? FileManager.default.removeItem(at: outputPath.deletingLastPathComponent())
        }

        let command = try CheckCommand.parse(["--output", outputPath.path, "--xcode", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }

        #expect(FileManager.default.fileExists(atPath: outputPath.path))
    }

    @Test("Given two files both needing reorder, when executing check, then reports plural files")
    func twoFilesNeedingReorderReportsPlural() async throws {
        let tempFile1 = createTempFile(
            content: """
                struct Test1 {
                    func method() {}
                    init() {}
                }
                """)
        let tempFile2 = createTempFile(
            content: """
                struct Test2 {
                    func method() {}
                    init() {}
                }
                """)
        defer {
            removeTempFile(tempFile1)
            removeTempFile(tempFile2)
        }

        let command = try CheckCommand.parse([tempFile1, tempFile2])

        await #expect(throws: ExitCode.self) {
            try await command.run()
        }
    }

    // MARK: - Argument Parsing

    @Test("Given config flag, when parsing arguments, then sets config path")
    func configFlagSetsConfigPath() throws {
        let command = try CheckCommand.parse(["--config", "/path/to/config.yaml"])
        #expect(command.config == "/path/to/config.yaml")
    }

    @Test("Given short config flag, when parsing arguments, then sets config path")
    func shortConfigFlagSetsConfigPath() throws {
        let command = try CheckCommand.parse(["-c", "/path/to/config.yaml"])
        #expect(command.config == "/path/to/config.yaml")
    }

    @Test("Given unknown flag, when parsing arguments, then throws ArgumentParsingError")
    func unknownFlagThrowsError() {
        #expect(throws: ArgumentParsingError.self) {
            try CheckCommand.parse(["--unknown-flag"])
        }
    }

    @Test("Given config flag with no value, when parsing arguments, then throws ArgumentParsingError")
    func configFlagMissingValueThrowsError() {
        #expect(throws: ArgumentParsingError.self) {
            try CheckCommand.parse(["--config"])
        }
    }

    @Test("Given output flag with no value, when parsing arguments, then throws ArgumentParsingError")
    func outputFlagMissingValueThrowsError() {
        #expect(throws: ArgumentParsingError.self) {
            try CheckCommand.parse(["--output"])
        }
    }

    @Test("Given no output flag, when executing check, then does not create marker file")
    func noOutputFlagDoesNotCreateMarkerFile() async throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                }
                """)
        let potentialOutputPath = FileManager.default.temporaryDirectory
            .appendingPathComponent("should-not-exist-\(UUID().uuidString).txt")
        defer { removeTempFile(tempFile) }

        let command = try CheckCommand.parse(["--quiet", tempFile])

        await #expect(throws: Never.self) {
            try await command.run()
        }

        #expect(!FileManager.default.fileExists(atPath: potentialOutputPath.path))
    }
}
