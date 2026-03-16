import SwiftSyntax

class UnifiedVisitorBase<Builder: Sendable>: SyntaxVisitor {

    init(sourceLocationConverter: SourceLocationConverter, builder: Builder) {
        self.sourceLocationConverter = sourceLocationConverter
        self.builder = builder
        super.init(viewMode: .sourceAccurate)
    }

    let sourceLocationConverter: SourceLocationConverter
    let builder: Builder
}
