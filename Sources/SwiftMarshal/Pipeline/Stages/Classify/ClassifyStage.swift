import SwiftSyntax

struct ClassifyStage: Stage {

    // MARK: - Stage

    func process(_ input: ParseOutput) throws -> ClassifyOutput {
        let visitor = UnifiedTypeDiscoveryVisitor.forDeclarations(converter: input.locationConverter)
        visitor.walk(input.syntax)
        return ClassifyOutput(path: input.path, declarations: visitor.declarations)
    }
}
