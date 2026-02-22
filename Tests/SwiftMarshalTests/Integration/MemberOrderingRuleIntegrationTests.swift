import Testing

@testable import swift_marshal

@Suite("MemberOrderingRule Integration Tests")
struct MemberOrderingRuleIntegrationTests {

    // MARK: - Simple Rules

    @Test(
        "Given a simple rule and a member with matching kind, when checking if the rule matches, then the simple rule matches exact kind"
    )
    func simpleRuleMatchesExactKind() {
        let rule = MemberOrderingRule.simple(.initializer)
        let member = MemberDeclaration(
            name: "init",
            kind: .initializer,
            line: 1
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a simple rule and a member with different kind, when checking if the rule matches, then the simple rule does not match different kind"
    )
    func simpleRuleDoesNotMatchDifferentKind() {
        let rule = MemberOrderingRule.simple(.initializer)
        let member = MemberDeclaration(
            name: "foo",
            kind: .instanceMethod,
            line: 1
        )

        #expect(rule.matches(member) == false)
    }

    @Test(
        "Given simple rules for all member kinds, when checking each rule, then the simple rule matches all member kinds"
    )
    func simpleRuleMatchesAllKinds() {
        for kind in MemberKind.allCases {
            let rule = MemberOrderingRule.simple(kind)
            let member = MemberDeclaration(name: "test", kind: kind, line: 1)
            #expect(rule.matches(member) == true)
        }
    }

    // MARK: - Property Rules - Annotated

    @Test(
        "Given a property rule requiring annotation and an annotated property, when checking if the rule matches, then the property rule matches annotated property"
    )
    func propertyRuleMatchesAnnotated() {
        let rule = MemberOrderingRule.property(annotated: true, visibility: nil)
        let member = MemberDeclaration(
            name: "state",
            kind: .instanceProperty,
            line: 1,
            visibility: .internalAccess,
            isAnnotated: true
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a property rule requiring annotation and a non-annotated property, when checking if the rule matches, then the property rule does not match non-annotated when annotated required"
    )
    func propertyRuleDoesNotMatchNonAnnotated() {
        let rule = MemberOrderingRule.property(annotated: true, visibility: nil)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1,
            visibility: .internalAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    @Test(
        "Given a property rule requiring no annotation and a non-annotated property, when checking if the rule matches, then the property rule matches non-annotated when annotated is false"
    )
    func propertyRuleMatchesNonAnnotatedExplicit() {
        let rule = MemberOrderingRule.property(annotated: false, visibility: nil)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1,
            visibility: .internalAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a property rule with no filters and a type property, when checking if the rule matches, then the property rule matches type property"
    )
    func propertyRuleMatchesTypeProperty() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: nil)
        let member = MemberDeclaration(
            name: "shared",
            kind: .typeProperty,
            line: 1
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a property rule with no filters and an instance property, when checking if the rule matches, then the property rule matches instance property"
    )
    func propertyRuleMatchesInstanceProperty() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: nil)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a property rule and a method declaration, when checking if the rule matches, then the property rule does not match method"
    )
    func propertyRuleDoesNotMatchMethod() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: nil)
        let member = MemberDeclaration(
            name: "foo",
            kind: .instanceMethod,
            line: 1
        )

        #expect(rule.matches(member) == false)
    }

    // MARK: - Property Rules - Visibility

    @Test(
        "Given a property rule requiring public visibility and a public property, when checking if the rule matches, then the property rule matches public visibility"
    )
    func propertyRuleMatchesPublicVisibility() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: .publicAccess)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1,
            visibility: .publicAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a property rule requiring private visibility and a private property, when checking if the rule matches, then the property rule matches private visibility"
    )
    func propertyRuleMatchesPrivateVisibility() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: .privateAccess)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1,
            visibility: .privateAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a property rule requiring public visibility and a private property, when checking if the rule matches, then the property rule does not match"
    )
    func propertyRuleDoesNotMatchWrongVisibility() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: .publicAccess)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1,
            visibility: .privateAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    @Test(
        "Given property rules for all visibility levels and matching properties, when checking each rule, then the property rule matches all visibility levels"
    )
    func propertyRuleMatchesAllVisibilities() {
        for visibility in Visibility.allCases {
            let rule = MemberOrderingRule.property(annotated: nil, visibility: visibility)
            let member = MemberDeclaration(
                name: "name",
                kind: .instanceProperty,
                line: 1,
                visibility: visibility,
                isAnnotated: false
            )
            #expect(rule.matches(member) == true)
        }
    }

    // MARK: - Property Rules - Combined

    @Test(
        "Given a property rule requiring annotation and private visibility, when checking a matching property, then the rule matches"
    )
    func propertyRuleMatchesCombined() {
        let rule = MemberOrderingRule.property(annotated: true, visibility: .privateAccess)
        let member = MemberDeclaration(
            name: "state",
            kind: .instanceProperty,
            line: 1,
            visibility: .privateAccess,
            isAnnotated: true
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a property rule requiring annotation and public visibility, when checking a private annotated property, then the rule does not match"
    )
    func propertyRuleCombinedAnnotatedMatchVisibilityFails() {
        let rule = MemberOrderingRule.property(annotated: true, visibility: .publicAccess)
        let member = MemberDeclaration(
            name: "state",
            kind: .instanceProperty,
            line: 1,
            visibility: .privateAccess,
            isAnnotated: true
        )

        #expect(rule.matches(member) == false)
    }

    @Test(
        "Given a property rule requiring annotation and public visibility, when checking a public non-annotated property, then the rule does not match"
    )
    func propertyRuleCombinedVisibilityMatchAnnotatedFails() {
        let rule = MemberOrderingRule.property(annotated: true, visibility: .publicAccess)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1,
            visibility: .publicAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    // MARK: - Method Rules - Kind

    @Test(
        "Given a method rule with static kind filter and a static method, when checking if the rule matches, then the method rule matches"
    )
    func methodRuleMatchesStaticMethod() {
        let rule = MemberOrderingRule.method(kind: .staticMethod, visibility: nil, annotated: nil)
        let member = MemberDeclaration(
            name: "create",
            kind: .typeMethod,
            line: 1
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a method rule with instance kind filter and an instance method, when checking if the rule matches, then the method rule matches"
    )
    func methodRuleMatchesInstanceMethod() {
        let rule = MemberOrderingRule.method(kind: .instance, visibility: nil, annotated: nil)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a method rule with static kind filter and an instance method, when checking if the rule matches, then the method rule does not match"
    )
    func methodRuleStaticDoesNotMatchInstance() {
        let rule = MemberOrderingRule.method(kind: .staticMethod, visibility: nil, annotated: nil)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1
        )

        #expect(rule.matches(member) == false)
    }

    @Test(
        "Given a method rule with instance kind filter and a static method, when checking if the rule matches, then the method rule does not match"
    )
    func methodRuleInstanceDoesNotMatchStatic() {
        let rule = MemberOrderingRule.method(kind: .instance, visibility: nil, annotated: nil)
        let member = MemberDeclaration(
            name: "create",
            kind: .typeMethod,
            line: 1
        )

        #expect(rule.matches(member) == false)
    }

    @Test(
        "Given a method rule with no kind filter and both static and instance methods, when checking if the rule matches, then the method rule matches both"
    )
    func methodRuleNilKindMatchesBoth() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: nil, annotated: nil)

        let staticMethod = MemberDeclaration(name: "create", kind: .typeMethod, line: 1)
        let instanceMethod = MemberDeclaration(name: "doSomething", kind: .instanceMethod, line: 1)

        #expect(rule.matches(staticMethod) == true)
        #expect(rule.matches(instanceMethod) == true)
    }

    @Test(
        "Given a method rule and a property declaration, when checking if the rule matches, then the method rule does not match"
    )
    func methodRuleDoesNotMatchProperty() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: nil, annotated: nil)
        let member = MemberDeclaration(
            name: "name",
            kind: .instanceProperty,
            line: 1
        )

        #expect(rule.matches(member) == false)
    }

    // MARK: - Method Rules - Visibility

    @Test(
        "Given a method rule requiring public visibility and a public method, when checking if the rule matches, then the method rule matches"
    )
    func methodRuleMatchesPublicVisibility() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: .publicAccess, annotated: nil)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1,
            visibility: .publicAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a method rule requiring public visibility and a private method, when checking if the rule matches, then the method rule does not match"
    )
    func methodRuleDoesNotMatchWrongVisibility() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: .publicAccess, annotated: nil)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1,
            visibility: .privateAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    // MARK: - Method Rules - Combined

    @Test(
        "Given a method rule requiring static kind and public visibility, when checking a matching method, then the method rule matches"
    )
    func methodRuleMatchesStaticPublic() {
        let rule = MemberOrderingRule.method(kind: .staticMethod, visibility: .publicAccess, annotated: nil)
        let member = MemberDeclaration(
            name: "create",
            kind: .typeMethod,
            line: 1,
            visibility: .publicAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a method rule requiring instance kind and private visibility, when checking a matching method, then the method rule matches"
    )
    func methodRuleMatchesInstancePrivate() {
        let rule = MemberOrderingRule.method(kind: .instance, visibility: .privateAccess, annotated: nil)
        let member = MemberDeclaration(
            name: "helper",
            kind: .instanceMethod,
            line: 1,
            visibility: .privateAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a method rule requiring static kind and public visibility, when checking a static private method, then the method rule does not match"
    )
    func methodRuleCombinedKindMatchVisibilityFails() {
        let rule = MemberOrderingRule.method(kind: .staticMethod, visibility: .publicAccess, annotated: nil)
        let member = MemberDeclaration(
            name: "create",
            kind: .typeMethod,
            line: 1,
            visibility: .privateAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    @Test(
        "Given a method rule requiring static kind and public visibility, when checking an instance public method, then the method rule does not match"
    )
    func methodRuleCombinedVisibilityMatchKindFails() {
        let rule = MemberOrderingRule.method(kind: .staticMethod, visibility: .publicAccess, annotated: nil)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1,
            visibility: .publicAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    // MARK: - Method Rules - Annotated

    @Test(
        "Given a method rule requiring annotation and an annotated method, when checking if the rule matches, then the method rule matches"
    )
    func methodRuleMatchesAnnotated() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: nil, annotated: true)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1,
            visibility: .internalAccess,
            isAnnotated: true
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a method rule requiring annotation and a non-annotated method, when checking if the rule matches, then the method rule does not match"
    )
    func methodRuleDoesNotMatchNonAnnotated() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: nil, annotated: true)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1,
            visibility: .internalAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == false)
    }

    @Test(
        "Given a method rule requiring no annotation and a non-annotated method, when checking if the rule matches, then the method rule matches"
    )
    func methodRuleMatchesNonAnnotatedExplicit() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: nil, annotated: false)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1,
            visibility: .internalAccess,
            isAnnotated: false
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a method rule requiring instance kind, private visibility, and annotation, when checking a matching method, then the rule matches"
    )
    func methodRuleMatchesCombinedWithAnnotated() {
        let rule = MemberOrderingRule.method(kind: .instance, visibility: .privateAccess, annotated: true)
        let member = MemberDeclaration(
            name: "helper",
            kind: .instanceMethod,
            line: 1,
            visibility: .privateAccess,
            isAnnotated: true
        )

        #expect(rule.matches(member) == true)
    }

    @Test(
        "Given a method rule requiring static kind and annotation, when checking an annotated instance method, then the rule does not match"
    )
    func methodRuleCombinedAnnotatedMatchKindFails() {
        let rule = MemberOrderingRule.method(kind: .staticMethod, visibility: nil, annotated: true)
        let member = MemberDeclaration(
            name: "doSomething",
            kind: .instanceMethod,
            line: 1,
            visibility: .internalAccess,
            isAnnotated: true
        )

        #expect(rule.matches(member) == false)
    }

    // MARK: - Edge Cases

    @Test(
        "Given a property rule and an initializer declaration, when checking if the rule matches, then the property rule does not match"
    )
    func propertyRuleDoesNotMatchInitializer() {
        let rule = MemberOrderingRule.property(annotated: nil, visibility: nil)
        let member = MemberDeclaration(name: "init", kind: .initializer, line: 1)

        #expect(rule.matches(member) == false)
    }

    @Test(
        "Given a method rule and an initializer declaration, when checking if the rule matches, then the method rule does not match"
    )
    func methodRuleDoesNotMatchInitializer() {
        let rule = MemberOrderingRule.method(kind: nil, visibility: nil, annotated: nil)
        let member = MemberDeclaration(name: "init", kind: .initializer, line: 1)

        #expect(rule.matches(member) == false)
    }

    @Test(
        "Given a simple initializer rule and a method declaration, when checking if the rule matches, then the initializer rule does not match"
    )
    func simpleInitializerRuleDoesNotMatchMethod() {
        let rule = MemberOrderingRule.simple(.initializer)
        let member = MemberDeclaration(name: "foo", kind: .instanceMethod, line: 1)

        #expect(rule.matches(member) == false)
    }
}
