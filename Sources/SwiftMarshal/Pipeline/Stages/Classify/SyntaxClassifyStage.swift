import SwiftSyntax

struct SyntaxClassifyStage: Stage {

    // MARK: - Stage

    func process(_ input: ParseOutput) throws -> SyntaxClassifyOutput {
        let visitor = UnifiedTypeDiscoveryVisitor.forSyntaxDeclarations(converter: input.locationConverter)
        visitor.walk(input.syntax)
        return SyntaxClassifyOutput(path: input.path, syntax: input.syntax, declarations: visitor.declarations)
    }
}
