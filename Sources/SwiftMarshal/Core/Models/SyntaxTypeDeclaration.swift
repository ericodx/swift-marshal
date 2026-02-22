import SwiftSyntax

struct SyntaxTypeDeclaration: Sendable {
    let name: String
    let kind: TypeKind
    let line: Int
    let members: [SyntaxMemberDeclaration]
    let memberBlock: MemberBlockSyntax
}
