import SwiftParser
import SwiftSyntax

struct ParseOutput: Sendable {
    let path: String
    let syntax: SourceFileSyntax
    let locationConverter: SourceLocationConverter
}
