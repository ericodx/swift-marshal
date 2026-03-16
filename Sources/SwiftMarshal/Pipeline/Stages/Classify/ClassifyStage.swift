import SwiftSyntax

struct ClassifyStage: Stage {

    // MARK: - Stage

    func process(_ input: ParseOutput) throws -> ClassifyOutput {
        let declarations = discover(from: input)
        return ClassifyOutput(path: input.path, declarations: declarations)
    }

    private func discover(from input: ParseOutput) -> [TypeDeclaration] {
        let visitor = UnifiedTypeDiscoveryVisitor.forDeclarations(converter: input.locationConverter)
        visitor.walk(input.syntax)
        return visitor.declarations
    }
}
