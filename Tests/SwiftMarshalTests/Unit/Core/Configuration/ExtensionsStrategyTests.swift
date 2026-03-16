import Testing

@testable import swift_marshal

@Suite("ExtensionsStrategy Tests")
struct ExtensionsStrategyTests {

    // MARK: - Cases

    @Test("Given ExtensionsStrategy, when checking separate case, then exists")
    func separateCaseExists() {
        let strategy = ExtensionsStrategy.separate

        #expect(strategy == .separate)
    }

    @Test("Given ExtensionsStrategy, when checking merge case, then exists")
    func mergeCaseExists() {
        let strategy = ExtensionsStrategy.merge

        #expect(strategy == .merge)
    }

    // MARK: - Raw Values

    @Test("Given separate strategy, when getting raw value, then is 'separate'")
    func separateRawValue() {
        #expect(ExtensionsStrategy.separate.rawValue == "separate")
    }

    @Test("Given merge strategy, when getting raw value, then is 'merge'")
    func mergeRawValue() {
        #expect(ExtensionsStrategy.merge.rawValue == "merge")
    }

    // MARK: - Init from Raw Value

    @Test("Given 'separate' string, when creating strategy, then returns separate")
    func initFromSeparateString() {
        let strategy = ExtensionsStrategy(rawValue: "separate")

        #expect(strategy == .separate)
    }

    @Test("Given 'merge' string, when creating strategy, then returns merge")
    func initFromMergeString() {
        let strategy = ExtensionsStrategy(rawValue: "merge")

        #expect(strategy == .merge)
    }

    @Test("Given invalid string, when creating strategy, then returns nil")
    func initFromInvalidString() {
        let strategy = ExtensionsStrategy(rawValue: "invalid")

        #expect(strategy == nil)
    }

    // MARK: - Equatable

    @Test("Given two same strategies, when comparing, then are equal")
    func equatable() {
        #expect(ExtensionsStrategy.separate == ExtensionsStrategy.separate)
        #expect(ExtensionsStrategy.merge == ExtensionsStrategy.merge)
    }

    @Test("Given two different strategies, when comparing, then are not equal")
    func notEqual() {
        #expect(ExtensionsStrategy.separate != ExtensionsStrategy.merge)
    }

    // MARK: - Sendable

    @Test("Given ExtensionsStrategy, when stored as Sendable, then can be recovered with same value")
    func isSendable() {
        let original = ExtensionsStrategy.separate
        let sendable: any Sendable = original

        #expect((sendable as? ExtensionsStrategy) == original)
    }
}
