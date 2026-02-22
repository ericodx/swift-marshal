import Testing

@testable import swift_marshal

@Suite("MemberDeclaration Tests")
struct MemberDeclarationTests {

    // MARK: - Tests

    @Test("Given a member declaration with a name, when creating the instance, then stores the name correctly")
    func storesName() {
        let member = MemberDeclaration(name: "myProperty", kind: .instanceProperty, line: 1)
        #expect(member.name == "myProperty")
    }

    @Test("Given a member declaration with a specific kind, when creating the instance, then stores the kind correctly")
    func storesKind() {
        let member = MemberDeclaration(name: "test", kind: .instanceMethod, line: 1)
        #expect(member.kind == .instanceMethod)
    }

    @Test("Given a member declaration with a line number, when creating the instance, then stores the line correctly")
    func storesLine() {
        let member = MemberDeclaration(name: "test", kind: .initializer, line: 42)
        #expect(member.line == 42)
    }

    @Test("Given MemberDeclaration, when stored as Sendable, then can be recovered with same name")
    func isSendable() {
        let original = MemberDeclaration(name: "test", kind: .typeProperty, line: 1)
        let sendable: any Sendable = original

        #expect((sendable as? MemberDeclaration)?.name == original.name)
    }
}
