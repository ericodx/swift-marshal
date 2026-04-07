import Testing

@testable import swift_marshal

@Suite("CommandParsing Tests")
struct CommandParsingTests {

    // MARK: - resolvedPaths

    @Test("Given options with explicit files, when resolving paths, then returns empty array")
    func explicitFilesReturnsEmptyPaths() {
        var options = CommonCommandOptions()
        options.files = ["file1.swift", "file2.swift"]

        let paths = resolvedPaths(options: options, configuration: .defaultValue)

        #expect(paths.isEmpty)
    }

    @Test("Given options with path set, when resolving paths, then returns that path")
    func pathOptionReturnsSinglePath() {
        var options = CommonCommandOptions()
        options.path = "/some/path"

        let paths = resolvedPaths(options: options, configuration: .defaultValue)

        #expect(paths == ["/some/path"])
    }

    @Test("Given options with no files and no path, when resolving paths, then returns configuration paths")
    func noFilesNoPathReturnsConfigPaths() {
        let options = CommonCommandOptions()
        let config = Configuration(
            version: 1,
            memberOrderingRules: [],
            extensionsStrategy: .separate,
            respectBoundaries: true,
            paths: ["Sources/", "Tests/"]
        )

        let paths = resolvedPaths(options: options, configuration: config)

        #expect(paths == ["Sources/", "Tests/"])
    }

    // MARK: - parseArguments

    @Test("Given a positional argument, when parsing arguments, then adds it to files")
    func positionalArgumentAddedToFiles() throws {
        var options = CommonCommandOptions()
        try parseArguments(["file.swift"], options: &options) { _, _ in false }

        #expect(options.files == ["file.swift"])
    }

    @Test("Given --quiet flag, when parsing arguments, then sets quiet to true")
    func quietFlagSetsQuiet() throws {
        var options = CommonCommandOptions()
        try parseArguments(["--quiet"], options: &options) { _, _ in false }

        #expect(options.quiet == true)
    }

    @Test("Given -q flag, when parsing arguments, then sets quiet to true")
    func shortQuietFlagSetsQuiet() throws {
        var options = CommonCommandOptions()
        try parseArguments(["-q"], options: &options) { _, _ in false }

        #expect(options.quiet == true)
    }

    @Test("Given an unknown flag starting with dash, when parsing arguments, then throws unknownFlag error")
    func unknownFlagThrows() {
        var options = CommonCommandOptions()

        #expect(throws: ArgumentParsingError.self) {
            try parseArguments(["--unknown"], options: &options) { _, _ in false }
        }
    }

    @Test("Given a flag handled by the handler, when parsing arguments, then does not add to files")
    func handledFlagNotAddedToFiles() throws {
        var options = CommonCommandOptions()
        try parseArguments(["--custom"], options: &options) { flag, _ in
            flag == "--custom"
        }

        #expect(options.files.isEmpty)
    }
}
