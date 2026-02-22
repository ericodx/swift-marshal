import SwiftSyntax

struct ClassifyOutput: Sendable {
    let path: String
    let declarations: [TypeDeclaration]
}
