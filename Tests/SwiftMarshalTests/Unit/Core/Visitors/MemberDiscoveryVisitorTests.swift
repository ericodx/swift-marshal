import Testing

@testable import swift_marshal

@Suite("MemberDiscoveryVisitor Tests")
struct MemberDiscoveryVisitorTests {

    @Test("Given a stored property declaration, when analyzing the source, then identifies it as instanceProperty")
    func discoversInstanceProperty() {
        let members = discoverMembers(in: "var name: String")

        #expect(members.count == 1)
        #expect(members[0].name == "name")
        #expect(members[0].kind == .instanceProperty)
    }

    @Test("Given a computed property declaration, when analyzing the source, then identifies it as instanceProperty")
    func discoversComputedProperty() {
        let members = discoverMembers(in: "var computed: Int { return 42 }")

        #expect(members.count == 1)
        #expect(members[0].name == "computed")
        #expect(members[0].kind == .instanceProperty)
    }

    @Test("Given a static property declaration, when analyzing the source, then identifies it as typeProperty")
    func discoversTypeProperty() {
        let members = discoverMembers(in: "static var shared: Self")

        #expect(members.count == 1)
        #expect(members[0].name == "shared")
        #expect(members[0].kind == .typeProperty)
    }

    @Test("Given an init declaration, when analyzing the source, then identifies it as initializer")
    func discoversInitializer() {
        let members = discoverMembers(in: "init() {}")

        #expect(members.count == 1)
        #expect(members[0].name == "init")
        #expect(members[0].kind == .initializer)
    }

    @Test("Given a deinit declaration, when analyzing the source, then identifies it as deinitializer")
    func discoversDeinitializer() {
        let members = discoverMembers(in: "deinit {}")

        #expect(members.count == 1)
        #expect(members[0].name == "deinit")
        #expect(members[0].kind == .deinitializer)
    }

    @Test("Given a method declaration, when analyzing the source, then identifies it as instanceMethod")
    func discoversInstanceMethod() {
        let members = discoverMembers(in: "func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].name == "doSomething")
        #expect(members[0].kind == .instanceMethod)
    }

    @Test("Given a static func declaration, when analyzing the source, then identifies it as typeMethod")
    func discoversTypeMethod() {
        let members = discoverMembers(in: "static func create() -> Self { fatalError() }")

        #expect(members.count == 1)
        #expect(members[0].name == "create")
        #expect(members[0].kind == .typeMethod)
    }

    @Test("Given a subscript declaration, when analyzing the source, then identifies it as subscript")
    func discoversSubscript() {
        let members = discoverMembers(in: "subscript(index: Int) -> Int { return index }")

        #expect(members.count == 1)
        #expect(members[0].name == "subscript")
        #expect(members[0].kind == .subscriptMember)
    }

    @Test("Given a typealias declaration, when analyzing the source, then identifies it as typealias")
    func discoversTypealias() {
        let members = discoverMembers(in: "typealias ID = String")

        #expect(members.count == 1)
        #expect(members[0].name == "ID")
        #expect(members[0].kind == .typeAlias)
    }

    @Test(
        "Given an associatedtype declaration in a protocol, when analyzing the source, then identifies it as associatedtype"
    )
    func discoversAssociatedtype() {
        let members = discoverMembersInProtocol(in: "associatedtype Element")

        #expect(members.count == 1)
        #expect(members[0].name == "Element")
        #expect(members[0].kind == .associatedType)
    }

    @Test("Given a nested struct declaration, when analyzing the source, then identifies it as subtype")
    func discoversSubtype() {
        let members = discoverMembers(in: "struct Inner {}")

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
        #expect(members[0].kind == .subtype)
    }

    @Test(
        "Given source with property, initializer, and method, when analyzing the source, then identifies all three members"
    )
    func discoversMultipleMembers() {
        let source = """
            var name: String
            init() {}
            func greet() {}
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 3)
        #expect(members[0].kind == .instanceProperty)
        #expect(members[1].kind == .initializer)
        #expect(members[2].kind == .instanceMethod)
    }

    @Test(
        "Given a nested type containing members, when analyzing the source, then only the nested type itself is discovered"
    )
    func ignoresNestedTypeMembers() {
        let source = """
            struct Inner {
                var nestedProperty: Int
                func nestedMethod() {}
            }
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
        #expect(members[0].kind == .subtype)
    }

    @Test(
        "Given source with members on different lines, when analyzing the source, then each member has its start line recorded"
    )
    func recordsLineNumbers() {
        let source = """
            var first: Int
            var second: Int
            var third: Int
            """
        let members = discoverMembers(in: source)

        #expect(members[0].line == 2)
        #expect(members[1].line == 3)
        #expect(members[2].line == 4)
    }

    // MARK: - Nested Type Subtypes

    @Test("Given a nested class declaration, when analyzing the source, then identifies it as subtype")
    func discoversNestedClass() {
        let members = discoverMembers(in: "class InnerClass {}")

        #expect(members.count == 1)
        #expect(members[0].name == "InnerClass")
        #expect(members[0].kind == .subtype)
    }

    @Test("Given a nested enum declaration, when analyzing the source, then identifies it as subtype")
    func discoversNestedEnum() {
        let members = discoverMembers(in: "enum InnerEnum { case a }")

        #expect(members.count == 1)
        #expect(members[0].name == "InnerEnum")
        #expect(members[0].kind == .subtype)
    }

    @Test("Given a nested actor declaration, when analyzing the source, then identifies it as subtype")
    func discoversNestedActor() {
        let members = discoverMembers(in: "actor InnerActor {}")

        #expect(members.count == 1)
        #expect(members[0].name == "InnerActor")
        #expect(members[0].kind == .subtype)
    }

    @Test("Given a nested protocol declaration, when analyzing the source, then identifies it as subtype")
    func discoversNestedProtocol() {
        let members = discoverMembers(in: "protocol InnerProtocol {}")

        #expect(members.count == 1)
        #expect(members[0].name == "InnerProtocol")
        #expect(members[0].kind == .subtype)
    }

    // MARK: - Class Modifiers

    @Test("Given a class method declaration, when analyzing the source, then identifies it as typeMethod")
    func discoversClassMethod() {
        let members = discoverMembers(in: "class func create() -> Self { fatalError() }")

        #expect(members.count == 1)
        #expect(members[0].name == "create")
        #expect(members[0].kind == .typeMethod)
    }

    @Test("Given a class property declaration, when analyzing the source, then identifies it as typeProperty")
    func discoversClassProperty() {
        let members = discoverMembers(in: "class var shared: Self { fatalError() }")

        #expect(members.count == 1)
        #expect(members[0].name == "shared")
        #expect(members[0].kind == .typeProperty)
    }

    // MARK: - Visibility Modifiers

    @Test("Given a public property, when analyzing the source, then extracts public visibility")
    func discoversPublicVisibility() {
        let members = discoverMembers(in: "public var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .publicAccess)
    }

    @Test("Given an open property, when analyzing the source, then extracts open visibility")
    func discoversOpenVisibility() {
        let members = discoverMembers(in: "open var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .openAccess)
    }

    @Test("Given an internal property, when analyzing the source, then extracts internal visibility")
    func discoversInternalVisibility() {
        let members = discoverMembers(in: "internal var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .internalAccess)
    }

    @Test("Given a fileprivate property, when analyzing the source, then extracts fileprivate visibility")
    func discoversFileprivateVisibility() {
        let members = discoverMembers(in: "fileprivate var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .filePrivateAccess)
    }

    @Test("Given a private property, when analyzing the source, then extracts private visibility")
    func discoversPrivateVisibility() {
        let members = discoverMembers(in: "private var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .privateAccess)
    }

    @Test("Given a property without visibility, when analyzing the source, then defaults to internal")
    func defaultsToInternalVisibility() {
        let members = discoverMembers(in: "var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .internalAccess)
    }

    // MARK: - Multiple Bindings

    @Test(
        "Given a var declaration with multiple bindings, when analyzing, then discovers each binding as separate member"
    )
    func discoversMultipleBindings() {
        let members = discoverMembers(in: "var first: Int, second: String")

        #expect(members.count == 2)
        #expect(members[0].name == "first")
        #expect(members[1].name == "second")
    }

    @Test("Given a let declaration with multiple bindings, when analyzing, then discovers all bindings")
    func discoversMultipleLetBindings() {
        let members = discoverMembers(in: "let a: Int, b: Int, c: Int")

        #expect(members.count == 3)
        #expect(members[0].name == "a")
        #expect(members[1].name == "b")
        #expect(members[2].name == "c")
    }

    // MARK: - Deeply Nested Types

    @Test("Given deeply nested types, when analyzing, then only discovers top-level nested type")
    func discoversOnlyTopLevelNestedType() {
        let source = """
            struct Level1 {
                struct Level2 {
                    struct Level3 {}
                }
            }
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 1)
        #expect(members[0].name == "Level1")
        #expect(members[0].kind == .subtype)
    }

    @Test("Given a nested class with internal members, when analyzing, then ignores nested class members")
    func ignoresNestedClassMembers() {
        let source = """
            class Inner {
                var property: Int
                init() {}
                func method() {}
            }
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
    }

    @Test("Given a nested enum with internal members, when analyzing, then ignores nested enum members")
    func ignoresNestedEnumMembers() {
        let source = """
            enum Inner {
                case value
                var description: String { "" }
            }
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
    }

    @Test("Given a nested actor with internal members, when analyzing, then ignores nested actor members")
    func ignoresNestedActorMembers() {
        let source = """
            actor Inner {
                var state: Int
                func process() {}
            }
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
    }

    @Test("Given a nested protocol with internal members, when analyzing, then ignores nested protocol members")
    func ignoresNestedProtocolMembers() {
        let source = """
            protocol Inner {
                func doSomething()
            }
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
    }

    // MARK: - Visibility on Other Members

    @Test("Given a public method, when analyzing, then extracts public visibility")
    func discoversPublicMethodVisibility() {
        let members = discoverMembers(in: "public func doWork() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .publicAccess)
    }

    @Test("Given a private init, when analyzing, then extracts private visibility")
    func discoversPrivateInitVisibility() {
        let members = discoverMembers(in: "private init() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .privateAccess)
    }

    @Test("Given a fileprivate subscript, when analyzing, then extracts fileprivate visibility")
    func discoversFileprivateSubscriptVisibility() {
        let members = discoverMembers(in: "fileprivate subscript(index: Int) -> Int { index }")

        #expect(members.count == 1)
        #expect(members[0].visibility == .filePrivateAccess)
    }

    @Test("Given a public typealias, when analyzing, then extracts public visibility")
    func discoversPublicTypealiasVisibility() {
        let members = discoverMembers(in: "public typealias ID = String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .publicAccess)
    }

    @Test("Given a private nested type, when analyzing, then extracts private visibility")
    func discoversPrivateNestedTypeVisibility() {
        let members = discoverMembers(in: "private struct Inner {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .privateAccess)
    }

    // MARK: - Nested Types with Specific Members (Coverage for depth > 0 guards)

    @Test("Given a nested class with deinit, when analyzing, then ignores nested deinit")
    func ignoresNestedDeinit() {
        let source = """
            class Inner {
                deinit {}
            }
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
    }

    @Test("Given a nested class with subscript, when analyzing, then ignores nested subscript")
    func ignoresNestedSubscript() {
        let source = """
            class Inner {
                subscript(index: Int) -> Int { index }
            }
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
    }

    @Test("Given a nested struct with typealias, when analyzing, then ignores nested typealias")
    func ignoresNestedTypealias() {
        let source = """
            struct Inner {
                typealias ID = String
            }
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
    }

    @Test("Given a nested protocol with associatedtype, when analyzing, then ignores nested associatedtype")
    func ignoresNestedAssociatedtype() {
        let source = """
            protocol Inner {
                associatedtype Element
            }
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 1)
        #expect(members[0].name == "Inner")
    }
}
