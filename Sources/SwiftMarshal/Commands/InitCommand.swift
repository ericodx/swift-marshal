import Foundation

struct InitCommand {

    // MARK: - Properties

    var force: Bool = false

    // MARK: - Private

    private static let configFileName = ".swift-marshal.yaml"

    // MARK: - Parsing

    static func parse(_ args: [String]) throws -> InitCommand {
        var command = InitCommand()
        var index = 0

        while index < args.count {
            if args[index] == "--force" {
                command.force = true
            } else if args[index].hasPrefix("-") {
                throw ArgumentParsingError.unknownFlag(args[index])
            }

            index += 1
        }

        return command
    }

    // MARK: - Execution

    func run() throws {
        let currentDir = FileManager.default.currentDirectoryPath
        let configPath = currentDir + "/" + Self.configFileName

        if FileManager.default.fileExists(atPath: configPath) && !force {
            throw InitError.configAlreadyExists(configPath)
        }

        let projectKind = ProjectDetector.detect(in: currentDir)
        try configContent(for: projectKind).write(toFile: configPath, atomically: true, encoding: .utf8)
        print("Created \(Self.configFileName)")

        switch projectKind {

        case .spm(let path):
            print("Detected SPM project — source path set to '\(path)'")

        case .xcode(let path):
            print("Detected Xcode project — source path set to '\(path)'")

        case .unknown:
            break

        }
    }

    // MARK: - Private

    func configContent(for projectKind: ProjectKind) -> String {
        let pathsSection: String

        switch projectKind {

        case .spm(let path), .xcode(let path):
            pathsSection = "\npaths:\n  - \(path)\n"

        case .unknown:
            pathsSection = "\n"

        }

        return """
            version: 1\(pathsSection)
            ordering:
              members:
                - typealias
                - associatedtype
                - initializer
                - type_property
                - instance_property
                - subtype
                - type_method
                - instance_method
                - subscript
                - deinitializer

            extensions:
              strategy: separate
              respect_boundaries: true
            """
    }
}
