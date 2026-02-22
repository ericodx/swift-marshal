import Foundation
import Testing

@testable import swift_marshal

@Suite("InitCommand Tests", .serialized)
struct InitCommandTests {

    // MARK: - Run Method Tests

    @Test(
        "Given no existing config file, when executing init command, then creates config file"
    )
    func createsConfigFileWhenNotExists() throws {
        let tempDir = createTempDirectory()
        defer { removeTempDirectory(tempDir) }

        let originalDir = FileManager.default.currentDirectoryPath
        FileManager.default.changeCurrentDirectoryPath(tempDir)
        defer { FileManager.default.changeCurrentDirectoryPath(originalDir) }

        let command = try InitCommand.parse([])
        try command.run()

        let configPath = tempDir + "/.swift-marshal.yaml"
        #expect(FileManager.default.fileExists(atPath: configPath))
    }

    @Test(
        "Given existing config file without force flag, when executing init command, then throws error"
    )
    func throwsErrorWhenConfigExists() throws {
        let tempDir = createTempDirectory()
        defer { removeTempDirectory(tempDir) }

        let configPath = tempDir + "/.swift-marshal.yaml"
        FileManager.default.createFile(atPath: configPath, contents: Data("existing".utf8))

        let originalDir = FileManager.default.currentDirectoryPath
        FileManager.default.changeCurrentDirectoryPath(tempDir)
        defer { FileManager.default.changeCurrentDirectoryPath(originalDir) }

        let command = try InitCommand.parse([])

        #expect(throws: InitError.self) {
            try command.run()
        }
    }

    @Test(
        "Given existing config file with force flag, when executing init command, then overwrites file"
    )
    func overwritesWithForceFlag() throws {
        let tempDir = createTempDirectory()
        defer { removeTempDirectory(tempDir) }

        let configPath = tempDir + "/.swift-marshal.yaml"
        FileManager.default.createFile(atPath: configPath, contents: Data("old content".utf8))

        let originalDir = FileManager.default.currentDirectoryPath
        FileManager.default.changeCurrentDirectoryPath(tempDir)
        defer { FileManager.default.changeCurrentDirectoryPath(originalDir) }

        let command = try InitCommand.parse(["--force"])
        try command.run()

        let newContent = try String(contentsOfFile: configPath, encoding: .utf8)
        #expect(newContent.contains("version: 1"))
        #expect(!newContent.contains("old content"))
    }

    @Test(
        "Given init command creates file, when reading the file, then contains valid YAML configuration"
    )
    func createdFileContainsValidConfiguration() throws {
        let tempDir = createTempDirectory()
        defer { removeTempDirectory(tempDir) }

        let originalDir = FileManager.default.currentDirectoryPath
        FileManager.default.changeCurrentDirectoryPath(tempDir)
        defer { FileManager.default.changeCurrentDirectoryPath(originalDir) }

        let command = try InitCommand.parse([])
        try command.run()

        let configPath = tempDir + "/.swift-marshal.yaml"
        let content = try String(contentsOfFile: configPath, encoding: .utf8)

        let loader = ConfigurationLoader()
        let mapper = ConfigurationMapper()

        let raw = try loader.parse(content)
        let config = mapper.map(raw)

        #expect(config.version == 1)
        #expect(config.memberOrderingRules.count == 10)
    }

    // MARK: - Argument Parsing

    @Test("Given unknown flag, when parsing arguments, then throws ArgumentParsingError")
    func unknownFlagThrowsError() {
        #expect(throws: ArgumentParsingError.self) {
            try InitCommand.parse(["--unknown-flag"])
        }
    }

    // MARK: - Error Cases

    @Test(
        "Given an InitError for existing config file, when getting the error description, then the InitError provides correct error description for existing file"
    )
    func initErrorDescription() {
        let error = InitError.configAlreadyExists("/path/to/config.yaml")

        #expect(
            error.errorDescription
                == "Configuration file already exists at /path/to/config.yaml. Use --force to overwrite.")
    }

    // MARK: - Default Config Content

    @Test(
        "Given the default configuration template, when checking the content, then the default config contains all member kinds in correct order"
    )
    func defaultConfigContainsAllMemberKinds() {
        let expectedMembers = [
            "typealias",
            "associatedtype",
            "initializer",
            "type_property",
            "instance_property",
            "subtype",
            "type_method",
            "instance_method",
            "subscript",
            "deinitializer",
        ]

        for member in expectedMembers {
            #expect(defaultConfigYaml.contains("- \(member)"))
        }
    }

    @Test("Given the default configuration template, when checking the version, then the default config has version 1")
    func defaultConfigHasVersion1() {
        #expect(defaultConfigYaml.contains("version: 1"))
    }

    @Test(
        "Given the default configuration template, when checking the extensions strategy, then the default config has separate extensions strategy"
    )
    func defaultConfigHasSeparateStrategy() {
        #expect(defaultConfigYaml.contains("strategy: separate"))
    }

    @Test(
        "Given the default configuration template, when checking the boundaries setting, then the default config has respect_boundaries true"
    )
    func defaultConfigHasRespectBoundariesTrue() {
        #expect(defaultConfigYaml.contains("respect_boundaries: true"))
    }

    @Test(
        "Given the default configuration template, when parsing the YAML, then the default config is valid YAML that can be parsed"
    )
    func defaultConfigIsValidYaml() throws {
        let loader = ConfigurationLoader()
        let mapper = ConfigurationMapper()

        let raw = try loader.parse(defaultConfigYaml)
        let config = mapper.map(raw)

        #expect(config.version == 1)
        #expect(config.memberOrderingRules.count == 10)
        #expect(config.extensionsStrategy == .separate)
        #expect(config.respectBoundaries == true)
    }
}
