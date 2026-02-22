import Testing

@testable import swift_marshal

@Suite("CLI Tests")
struct CLITests {

    // MARK: - HelpText

    @Test("Given the help text, when accessing usage, then contains command name")
    func helpTextContainsCommandName() {
        #expect(HelpText.usage.contains("swift-marshal"))
    }

    @Test("Given the help text, when accessing usage, then contains all subcommands")
    func helpTextContainsSubcommands() {
        #expect(HelpText.usage.contains("check"))
        #expect(HelpText.usage.contains("fix"))
        #expect(HelpText.usage.contains("init"))
    }

    // MARK: - ArgumentParsingError

    @Test("Given an unknown flag error, when getting description, then returns correct message")
    func unknownFlagDescription() {
        let error = ArgumentParsingError.unknownFlag("--bad")
        #expect(error.description == "unknown flag '--bad'")
    }

    @Test("Given a missing value error, when getting description, then returns correct message")
    func missingValueDescription() {
        let error = ArgumentParsingError.missingValue("--config")
        #expect(error.description == "missing value for '--config'")
    }

    // MARK: - ValidationError

    @Test("Given a validation error, when getting errorDescription, then returns the message")
    func validationErrorDescription() {
        let error = ValidationError("something went wrong")
        #expect(error.errorDescription == "something went wrong")
    }
}
