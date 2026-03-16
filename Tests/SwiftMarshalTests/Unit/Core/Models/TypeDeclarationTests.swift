import Testing

@testable import swift_marshal

@Suite("TypeDeclaration Tests")
struct TypeDeclarationTests {

    // MARK: - Tests

    @Test("Given a TypeDeclaration with a name, when creating the instance, then stores name correctly")
    func storesName() {
        let decl = TypeDeclaration(name: "MyType", kind: .structType, line: 1)
        #expect(decl.name == "MyType")
    }

    @Test("Given a TypeDeclaration with a specific kind, when creating the instance, then stores kind correctly")
    func storesKind() {
        let decl = TypeDeclaration(name: "Test", kind: .classType, line: 1)
        #expect(decl.kind == .classType)
    }

    @Test("Given a TypeDeclaration with a line number, when creating the instance, then stores line correctly")
    func storesLine() {
        let decl = TypeDeclaration(name: "Test", kind: .enumType, line: 42)
        #expect(decl.line == 42)
    }

    @Test("Given TypeDeclaration, when stored as Sendable, then can be recovered with same name")
    func isSendable() {
        let original = TypeDeclaration(name: "Test", kind: .actorType, line: 1)
        let sendable: any Sendable = original

        #expect((sendable as? TypeDeclaration)?.name == original.name)
    }

    @Test("Given all TypeKind values, when creating TypeDeclaration instances, then each kind is stored correctly")
    func supportsAllKinds() {
        let kinds: [TypeKind] = [.classType, .structType, .enumType, .actorType, .protocolType]

        for kind in kinds {
            let decl = TypeDeclaration(name: "Test", kind: kind, line: 1)
            #expect(decl.kind == kind)
        }
    }
}
