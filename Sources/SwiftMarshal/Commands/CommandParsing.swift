import Foundation

func nextValue(in args: [String], after index: inout Int, flag: String) throws -> String {
    index += 1

    guard index < args.count else {
        throw ArgumentParsingError.missingValue(flag)
    }

    return args[index]
}

func resolvedPaths(options: CommonCommandOptions, configuration: Configuration) -> [String] {
    if let path = options.path {
        return [path]
    }

    if !options.files.isEmpty {
        return []
    }

    return configuration.paths
}

func resolveCommand(options: CommonCommandOptions) async throws -> ResolvedCommand {
    let configuration = try await ConfigurationService().load(configPath: options.config)
    let effectivePaths = resolvedPaths(options: options, configuration: configuration)
    let files = SwiftFileResolver.resolve(files: options.files, paths: effectivePaths)

    guard !files.isEmpty else {
        throw ValidationError("No Swift files found. Provide files as arguments or use --path.")
    }

    return ResolvedCommand(
        coordinator: PipelineCoordinator(fileIO: FileIOActor(), configuration: configuration),
        files: files,
        configuration: configuration
    )
}

func parseArguments(
    _ args: [String],
    options: inout CommonCommandOptions,
    handle: (String, inout Int) throws -> Bool
) throws {
    var index = 0

    while index < args.count {
        let flag = args[index]
        var handled = false

        switch flag {

        case "--quiet", "-q":
            options.quiet = true
            handled = true

        case "--path", "-p":
            options.path = try nextValue(in: args, after: &index, flag: "--path")
            handled = true

        case "--config", "-c":
            options.config = try nextValue(in: args, after: &index, flag: "--config")
            handled = true

        default:
            handled = try handle(flag, &index)

        }

        if !handled {
            if flag.hasPrefix("-") {
                throw ArgumentParsingError.unknownFlag(flag)
            }
            options.files.append(flag)
        }

        index += 1
    }
}
