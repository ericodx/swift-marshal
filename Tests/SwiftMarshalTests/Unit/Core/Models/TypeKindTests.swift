import Testing

@testable import swift_marshal

@Suite("TypeKind Tests")
struct TypeKindTests {

    @Test("Given TypeKind raw values, when checking the enum, then raw values match new camelCase names")
    func rawValuesMatchKeywords() {
        #expect(TypeKind.classType.rawValue == "classType")
        #expect(TypeKind.structType.rawValue == "structType")
        #expect(TypeKind.enumType.rawValue == "enumType")
        #expect(TypeKind.actorType.rawValue == "actorType")
        #expect(TypeKind.protocolType.rawValue == "protocolType")
    }

    @Test("Given all TypeKind cases, when checking the enum, then all cases are defined")
    func allCasesDefined() {
        let allCases: [TypeKind] = [.classType, .structType, .enumType, .actorType, .protocolType]
        #expect(allCases.count == 5)
    }

    @Test("Given TypeKind, when stored as Sendable, then can be recovered with same value")
    func isSendable() {
        let original: TypeKind = .structType
        let sendable: any Sendable = original

        #expect((sendable as? TypeKind) == original)
    }
}
