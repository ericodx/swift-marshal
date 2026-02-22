import Foundation

struct InitCommand {

    // MARK: - Properties

    var force: Bool = false

    // MARK: - Private

    private static let configFileName = ".swift-marshal.yaml"

    private var defaultConfigContent: String {
        """
        version: 1

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
        let configPath = FileManager.default.currentDirectoryPath + "/" + Self.configFileName

        if FileManager.default.fileExists(atPath: configPath) && !force {
            throw InitError.configAlreadyExists(configPath)
        }

        try defaultConfigContent.write(toFile: configPath, atomically: true, encoding: .utf8)
        print("Created \(Self.configFileName)")
    }
}
