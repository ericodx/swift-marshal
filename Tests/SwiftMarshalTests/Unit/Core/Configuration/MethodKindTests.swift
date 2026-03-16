import Testing

@testable import swift_marshal

@Suite("MethodKind Tests")
struct MethodKindTests {

    // MARK: - Cases

    @Test("Given MethodKind, when checking static case, then exists")
    func staticCaseExists() {
        let kind = MethodKind.staticMethod

        #expect(kind == .staticMethod)
    }

    @Test("Given MethodKind, when checking instance case, then exists")
    func instanceCaseExists() {
        let kind = MethodKind.instance

        #expect(kind == .instance)
    }

    // MARK: - Raw Values

    @Test("Given static kind, when getting raw value, then is 'static'")
    func staticRawValue() {
        #expect(MethodKind.staticMethod.rawValue == "static")
    }

    @Test("Given instance kind, when getting raw value, then is 'instance'")
    func instanceRawValue() {
        #expect(MethodKind.instance.rawValue == "instance")
    }

    // MARK: - Init from Raw Value

    @Test("Given 'static' string, when creating kind, then returns static")
    func initFromStaticString() {
        let kind = MethodKind(rawValue: "static")

        #expect(kind == .staticMethod)
    }

    @Test("Given 'instance' string, when creating kind, then returns instance")
    func initFromInstanceString() {
        let kind = MethodKind(rawValue: "instance")

        #expect(kind == .instance)
    }

    @Test("Given invalid string, when creating kind, then returns nil")
    func initFromInvalidString() {
        let kind = MethodKind(rawValue: "invalid")

        #expect(kind == nil)
    }

    // MARK: - Sendable

    @Test("Given MethodKind, when stored as Sendable, then can be recovered with same value")
    func isSendable() {
        let original = MethodKind.staticMethod
        let sendable: any Sendable = original

        #expect((sendable as? MethodKind) == original)
    }
}
