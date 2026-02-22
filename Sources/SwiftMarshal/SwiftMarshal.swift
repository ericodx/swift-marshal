import Foundation

@main
struct SwiftMarshal {

    static func main() async {
        exit(await run(args: Array(CommandLine.arguments.dropFirst())).rawValue)
    }

    static func run(args: [String]) async -> ExitCode {
        if args.isEmpty || args.first == "--help" || args.first == "-h" {
            print(HelpText.usage)
            return .success
        }

        if args.first == "--version" {
            print(Version.current)
            return .success
        }

        let subcommand = args[0]
        let subArgs = Array(args.dropFirst())

        do {
            switch subcommand {

            case "check":
                try await CheckCommand.parse(subArgs).run()

            case "fix":
                try await FixCommand.parse(subArgs).run()

            case "init":
                try InitCommand.parse(subArgs).run()

            default:
                fputs("error: unknown command '\(subcommand)'\n", stderr)
                fputs(HelpText.usage + "\n", stderr)
                return .error

            }
        } catch let code as ExitCode {
            return code
        } catch {
            fputs("error: \(error.localizedDescription)\n", stderr)
            return .error
        }

        return .success
    }
}
