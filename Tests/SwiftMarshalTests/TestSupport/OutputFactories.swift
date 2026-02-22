import SwiftParser
import SwiftSyntax

@testable import swift_marshal

// MARK: - SyntaxClassifyOutput Factory

func makeSyntaxClassifyOutput(
    path: String = "Test.swift",
    source: String = "struct Test {}"
) -> SyntaxClassifyOutput {
    let syntax = Parser.parse(source: source)
    return SyntaxClassifyOutput(path: path, syntax: syntax, declarations: [])
}

// MARK: - RewritePlanOutput Factory

func makeRewritePlanOutputFactory(
    path: String = "Test.swift",
    source: String = "struct Test {}"
) -> RewritePlanOutput {
    let syntax = Parser.parse(source: source)
    return RewritePlanOutput(path: path, syntax: syntax, plans: [])
}

// MARK: - Default Config YAML

let defaultConfigYaml = """
    version: 1

    ordering:
      members:
        - typealias
        - associatedtype
        - initializer
        - type_property
        - instance_property
        - subtype
        - type_method
        - instance_method
        - subscript
        - deinitializer

    extensions:
      strategy: separate
      respect_boundaries: true
    """
