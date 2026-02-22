import SwiftParser
import SwiftSyntax

struct ParseStage: Stage {

    // MARK: - Stage

    func process(_ input: ParseInput) throws -> ParseOutput {
        let syntax = Parser.parse(source: input.source)
        let converter = SourceLocationConverter(fileName: input.path, tree: syntax)
        return ParseOutput(path: input.path, syntax: syntax, locationConverter: converter)
    }
}
