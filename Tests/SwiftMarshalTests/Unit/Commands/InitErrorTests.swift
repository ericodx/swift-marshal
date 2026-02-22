import Testing

@testable import swift_marshal

@Suite("InitError Tests")
struct InitErrorTests {

    // MARK: - Tests

    @Test("Given configAlreadyExists error, when getting errorDescription, then contains path")
    func errorDescriptionContainsPath() {
        let error = InitError.configAlreadyExists("/path/to/config.yaml")

        #expect(error.errorDescription?.contains("/path/to/config.yaml") == true)
    }

    @Test("Given configAlreadyExists error, when getting errorDescription, then mentions --force")
    func errorDescriptionMentionsForceFlag() {
        let error = InitError.configAlreadyExists("/path/to/config.yaml")

        #expect(error.errorDescription?.contains("--force") == true)
    }

    @Test("Given configAlreadyExists error, when getting errorDescription, then is not nil")
    func errorDescriptionIsNotNil() {
        let error = InitError.configAlreadyExists("/any/path")

        #expect(error.errorDescription != nil)
    }

    @Test("Given configAlreadyExists error with different paths, when comparing descriptions, then are different")
    func differentPathsProduceDifferentDescriptions() {
        let error1 = InitError.configAlreadyExists("/path/one")
        let error2 = InitError.configAlreadyExists("/path/two")

        #expect(error1.errorDescription != error2.errorDescription)
    }

    @Test("Given configAlreadyExists error, when getting errorDescription, then indicates file already exists")
    func errorDescriptionIndicatesFileExists() {
        let error = InitError.configAlreadyExists("/config.yaml")

        #expect(error.errorDescription?.contains("already exists") == true)
    }
}
