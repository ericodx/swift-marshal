import Testing

@testable import swift_marshal

@Suite("ReorderEngine Integration Tests")
struct ReorderEngineIntegrationTests {

    // MARK: - Simple Ordering

    @Test(
        "Given members with different kinds and ordering rules, when reordering the members, then orders by simple member kinds"
    )
    func ordersSimpleMemberKinds() {
        let rules: [MemberOrderingRule] = [
            .simple(.initializer),
            .simple(.instanceProperty),
            .simple(.instanceMethod),
        ]
        let engine = ReorderEngine(
            configuration: Configuration(
                version: 1,
                memberOrderingRules: rules,
                extensionsStrategy: .separate,
                respectBoundaries: true
            ))

        let members = [
            MemberDeclaration(name: "doSomething", kind: .instanceMethod, line: 1),
            MemberDeclaration(name: "name", kind: .instanceProperty, line: 2),
            MemberDeclaration(name: "init", kind: .initializer, line: 3),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "init")
        #expect(result[1].name == "name")
        #expect(result[2].name == "doSomething")
    }

    @Test("Given multiple members of the same kind, when reordering the members, then preserves order for same kind")
    func preservesOrderForSameKind() {
        let rules: [MemberOrderingRule] = [.simple(.instanceMethod)]
        let engine = ReorderEngine(
            configuration: Configuration(
                version: 1,
                memberOrderingRules: rules,
                extensionsStrategy: .separate,
                respectBoundaries: true
            ))

        let members = [
            MemberDeclaration(name: "methodA", kind: .instanceMethod, line: 1),
            MemberDeclaration(name: "methodB", kind: .instanceMethod, line: 2),
            MemberDeclaration(name: "methodC", kind: .instanceMethod, line: 3),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "methodA")
        #expect(result[1].name == "methodB")
        #expect(result[2].name == "methodC")
    }

    // MARK: - Property Ordering by Annotation

    @Test(
        "Given annotated and non-annotated properties with ordering rules, when reordering members, then orders annotated properties first"
    )
    func ordersAnnotatedPropertiesFirst() {
        let rules: [MemberOrderingRule] = [
            .property(annotated: true, visibility: nil),
            .property(annotated: false, visibility: nil),
        ]
        let engine = ReorderEngine(
            configuration: Configuration(
                version: 1,
                memberOrderingRules: rules,
                extensionsStrategy: .separate,
                respectBoundaries: true
            ))

        let members = [
            MemberDeclaration(
                name: "normalProp",
                kind: .instanceProperty,
                line: 1,
                visibility: .internalAccess,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "stateProp",
                kind: .instanceProperty,
                line: 2,
                visibility: .internalAccess,
                isAnnotated: true
            ),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "stateProp")
        #expect(result[1].name == "normalProp")
    }

    // MARK: - Property Ordering by Visibility

    @Test(
        "Given properties with different visibility levels and ordering rules, when reordering members, then orders properties by visibility"
    )
    func ordersPropertiesByVisibility() {
        let rules: [MemberOrderingRule] = [
            .property(annotated: nil, visibility: .publicAccess),
            .property(annotated: nil, visibility: .internalAccess),
            .property(annotated: nil, visibility: .privateAccess),
        ]
        let engine = ReorderEngine(
            configuration: Configuration(
                version: 1,
                memberOrderingRules: rules,
                extensionsStrategy: .separate,
                respectBoundaries: true
            ))

        let members = [
            MemberDeclaration(
                name: "privateProp",
                kind: .instanceProperty,
                line: 1,
                visibility: .privateAccess,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "publicProp",
                kind: .instanceProperty,
                line: 2,
                visibility: .publicAccess,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "internalProp",
                kind: .instanceProperty,
                line: 3,
                visibility: .internalAccess,
                isAnnotated: false
            ),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "publicProp")
        #expect(result[1].name == "internalProp")
        #expect(result[2].name == "privateProp")
    }

    // MARK: - Method Ordering by Kind

    @Test(
        "Given static and instance methods with ordering rules, when reordering members, then orders static methods before instance methods"
    )
    func ordersStaticMethodsFirst() {
        let rules: [MemberOrderingRule] = [
            .method(kind: .staticMethod, visibility: nil, annotated: nil),
            .method(kind: .instance, visibility: nil, annotated: nil),
        ]
        let engine = ReorderEngine(
            configuration: Configuration(
                version: 1,
                memberOrderingRules: rules,
                extensionsStrategy: .separate,
                respectBoundaries: true
            ))

        let members = [
            MemberDeclaration(name: "instanceMethod", kind: .instanceMethod, line: 1),
            MemberDeclaration(name: "staticMethod", kind: .typeMethod, line: 2),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "staticMethod")
        #expect(result[1].name == "instanceMethod")
    }

    // MARK: - Method Ordering by Visibility

    @Test(
        "Given methods with different visibility levels and ordering rules, when reordering members, then orders methods by visibility"
    )
    func ordersMethodsByVisibility() {
        let rules: [MemberOrderingRule] = [
            .method(kind: nil, visibility: .publicAccess, annotated: nil),
            .method(kind: nil, visibility: .internalAccess, annotated: nil),
            .method(kind: nil, visibility: .privateAccess, annotated: nil),
        ]
        let engine = ReorderEngine(
            configuration: Configuration(
                version: 1,
                memberOrderingRules: rules,
                extensionsStrategy: .separate,
                respectBoundaries: true
            ))

        let members = [
            MemberDeclaration(
                name: "privateMethod",
                kind: .instanceMethod,
                line: 1,
                visibility: .privateAccess,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "publicMethod",
                kind: .instanceMethod,
                line: 2,
                visibility: .publicAccess,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "internalMethod",
                kind: .instanceMethod,
                line: 3,
                visibility: .internalAccess,
                isAnnotated: false
            ),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "publicMethod")
        #expect(result[1].name == "internalMethod")
        #expect(result[2].name == "privateMethod")
    }

    // MARK: - Combined Method Ordering

    @Test(
        "Given methods with different kinds and visibility levels with ordering rules, when reordering members, then orders methods by kind and visibility"
    )
    func ordersMethodsByKindAndVisibility() {
        let rules: [MemberOrderingRule] = [
            .method(kind: .staticMethod, visibility: .publicAccess, annotated: nil),
            .method(kind: .staticMethod, visibility: .privateAccess, annotated: nil),
            .method(kind: .instance, visibility: .publicAccess, annotated: nil),
            .method(kind: .instance, visibility: .privateAccess, annotated: nil),
        ]
        let engine = ReorderEngine(
            configuration: Configuration(
                version: 1,
                memberOrderingRules: rules,
                extensionsStrategy: .separate,
                respectBoundaries: true
            ))

        let members = [
            MemberDeclaration(
                name: "instancePrivate",
                kind: .instanceMethod,
                line: 1,
                visibility: .privateAccess,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "staticPublic",
                kind: .typeMethod,
                line: 2,
                visibility: .publicAccess,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "instancePublic",
                kind: .instanceMethod,
                line: 3,
                visibility: .publicAccess,
                isAnnotated: false
            ),
            MemberDeclaration(
                name: "staticPrivate",
                kind: .typeMethod,
                line: 4,
                visibility: .privateAccess,
                isAnnotated: false
            ),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "staticPublic")
        #expect(result[1].name == "staticPrivate")
        #expect(result[2].name == "instancePublic")
        #expect(result[3].name == "instancePrivate")
    }

    // MARK: - Complex Configuration

    @Test(
        "Given a complex structural configuration with all member types, when reordering members, then produces full structural order matching config file"
    )
    func fullStructuralOrder() {
        let rules: [MemberOrderingRule] = [
            .simple(.typeAlias),
            .simple(.associatedType),
            .property(annotated: true, visibility: nil),
            .simple(.initializer),
            .property(annotated: nil, visibility: .publicAccess),
            .property(annotated: nil, visibility: .internalAccess),
            .property(annotated: nil, visibility: .privateAccess),
            .simple(.subtype),
            .method(kind: .staticMethod, visibility: .publicAccess, annotated: nil),
            .method(kind: .staticMethod, visibility: .privateAccess, annotated: nil),
            .method(kind: .instance, visibility: .publicAccess, annotated: nil),
            .method(kind: .instance, visibility: .privateAccess, annotated: nil),
            .simple(.subscriptMember),
            .simple(.deinitializer),
        ]
        let engine = ReorderEngine(
            configuration: Configuration(
                version: 1,
                memberOrderingRules: rules,
                extensionsStrategy: .separate,
                respectBoundaries: true
            ))

        let members = [
            MemberDeclaration(
                name: "privateMethod",
                kind: .instanceMethod,
                line: 1,
                visibility: .privateAccess,
                isAnnotated: false
            ),
            MemberDeclaration(name: "deinit", kind: .deinitializer, line: 2),
            MemberDeclaration(
                name: "privateProp",
                kind: .instanceProperty,
                line: 3,
                visibility: .privateAccess,
                isAnnotated: false
            ),
            MemberDeclaration(name: "init", kind: .initializer, line: 4),
            MemberDeclaration(
                name: "annotatedProp",
                kind: .instanceProperty,
                line: 5,
                visibility: .internalAccess,
                isAnnotated: true
            ),
            MemberDeclaration(name: "ID", kind: .typeAlias, line: 6),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "ID")
        #expect(result[1].name == "annotatedProp")
        #expect(result[2].name == "init")
        #expect(result[3].name == "privateProp")
        #expect(result[4].name == "privateMethod")
        #expect(result[5].name == "deinit")
    }

    // MARK: - Unmatched Members

    @Test(
        "Given members that do not match any ordering rules, when reordering members, then places unmatched members at the end"
    )
    func unmatchedMembersGoToEnd() {
        let rules: [MemberOrderingRule] = [
            .simple(.initializer)
        ]
        let engine = ReorderEngine(
            configuration: Configuration(
                version: 1,
                memberOrderingRules: rules,
                extensionsStrategy: .separate,
                respectBoundaries: true
            ))

        let members = [
            MemberDeclaration(name: "method", kind: .instanceMethod, line: 1),
            MemberDeclaration(name: "init", kind: .initializer, line: 2),
            MemberDeclaration(name: "prop", kind: .instanceProperty, line: 3),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "init")
        #expect(result[1].name == "method")
        #expect(result[2].name == "prop")
    }

    // MARK: - Configuration Integration

    @Test(
        "Given a Configuration struct with custom ordering rules, when creating a ReorderEngine, then uses configuration from Configuration struct"
    )
    func usesConfigurationStruct() {
        let config = Configuration(
            version: 1,
            memberOrderingRules: [
                .simple(.instanceMethod),
                .simple(.instanceProperty),
            ],
            extensionsStrategy: .separate,
            respectBoundaries: true
        )
        let engine = ReorderEngine(configuration: config)

        let members = [
            MemberDeclaration(name: "prop", kind: .instanceProperty, line: 1),
            MemberDeclaration(name: "method", kind: .instanceMethod, line: 2),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "method")
        #expect(result[1].name == "prop")
    }

    @Test(
        "Given the default configuration, when creating a ReorderEngine, then default configuration maintains original MemberKind order"
    )
    func defaultConfigurationOrder() {
        let engine = ReorderEngine(configuration: .defaultValue)

        let members = [
            MemberDeclaration(name: "method", kind: .instanceMethod, line: 1),
            MemberDeclaration(name: "init", kind: .initializer, line: 2),
            MemberDeclaration(name: "alias", kind: .typeAlias, line: 3),
        ]

        let result = engine.reorder(members)

        #expect(result[0].name == "alias")
        #expect(result[1].name == "init")
        #expect(result[2].name == "method")
    }
}
