import Foundation

struct ConfigurationService {

    // MARK: - Initialization

    init(
        fileReader: FileReading = FileReader(),
        loader: ConfigurationLoader = ConfigurationLoader(),
        mapper: ConfigurationMapper = ConfigurationMapper(),
        currentDirectory: String = FileManager.default.currentDirectoryPath
    ) {
        self.fileReader = fileReader
        self.loader = loader
        self.mapper = mapper
        self.currentDirectory = currentDirectory
    }

    // MARK: - Properties

    private let fileReader: FileReading
    private let loader: ConfigurationLoader
    private let mapper: ConfigurationMapper
    private let currentDirectory: String
    private let configFileName = ".swift-marshal.yaml"

    // MARK: - Public Methods

    func load(from directory: String? = nil) async throws -> Configuration {
        let startDirectory = directory ?? currentDirectory

        guard !startDirectory.isEmpty, let configPath = findConfigFile(startingFrom: startDirectory) else {
            return .defaultValue
        }

        return try await loadFromFile(at: configPath)
    }

    func load(configFile: String) async throws -> Configuration {
        return try await loadFromFile(at: configFile)
    }

    func load(configPath: String?) async throws -> Configuration {
        if let path = configPath {
            return try await load(configFile: path)
        }
        return try await load()
    }

    // MARK: - Private Methods

    private func loadFromFile(at path: String) async throws -> Configuration {
        let content = try await fileReader.read(at: path)
        let raw = try loader.parse(content)
        return mapper.map(raw)
    }

    private func findConfigFile(startingFrom directory: String) -> String? {
        var currentPath = URL(fileURLWithPath: directory).standardized

        while true {
            let configPath = currentPath.appendingPathComponent(configFileName).path
            if FileManager.default.fileExists(atPath: configPath) {
                return configPath
            }

            let parent = currentPath.deletingLastPathComponent().standardizedFileURL
            guard parent.path.count < currentPath.path.count else { break }
            currentPath = parent
        }

        return nil
    }
}
