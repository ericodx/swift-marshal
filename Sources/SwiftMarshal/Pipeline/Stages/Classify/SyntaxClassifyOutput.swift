import SwiftSyntax

struct SyntaxClassifyOutput: Sendable {
    let path: String
    let syntax: SourceFileSyntax
    let declarations: [SyntaxTypeDeclaration]
}
