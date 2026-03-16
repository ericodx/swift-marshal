import Testing

@testable import swift_marshal

@Suite("Visibility Detection Tests")
struct VisibilityDetectionTests {

    // MARK: - Property Visibility

    @Test("Given a property with public modifier, when analyzing the member, then visibility is public")
    func detectsPublicProperty() {
        let members = discoverMembers(in: "public var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .publicAccess)
    }

    @Test("Given a property with private modifier, when analyzing the member, then visibility is private")
    func detectsPrivateProperty() {
        let members = discoverMembers(in: "private var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .privateAccess)
    }

    @Test("Given a property with internal modifier, when analyzing the member, then visibility is internal")
    func detectsInternalProperty() {
        let members = discoverMembers(in: "internal var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .internalAccess)
    }

    @Test("Given a property with fileprivate modifier, when analyzing the member, then visibility is fileprivate")
    func detectsFileprivateProperty() {
        let members = discoverMembers(in: "fileprivate var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .filePrivateAccess)
    }

    @Test("Given a property with open modifier, when analyzing the member, then visibility is open")
    func detectsOpenProperty() {
        let members = discoverMembers(in: "open var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .openAccess)
    }

    @Test(
        "Given a property without a visibility modifier, when analyzing the member, then visibility defaults to internal"
    )
    func defaultsToInternal() {
        let members = discoverMembers(in: "var name: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .internalAccess)
    }

    // MARK: - Method Visibility

    @Test("Given a method with public modifier, when analyzing the member, then visibility is public")
    func detectsPublicMethod() {
        let members = discoverMembers(in: "public func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .publicAccess)
    }

    @Test("Given a method with private modifier, when analyzing the member, then visibility is private")
    func detectsPrivateMethod() {
        let members = discoverMembers(in: "private func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .privateAccess)
    }

    @Test("Given a method with internal modifier, when analyzing the member, then visibility is internal")
    func detectsInternalMethod() {
        let members = discoverMembers(in: "internal func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .internalAccess)
    }

    @Test(
        "Given a method without a visibility modifier, when analyzing the member, then visibility defaults to internal")
    func methodDefaultsToInternal() {
        let members = discoverMembers(in: "func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .internalAccess)
    }

    // MARK: - Initializer Visibility

    @Test("Given an initializer with public modifier, when analyzing the member, then visibility is public")
    func detectsPublicInitializer() {
        let members = discoverMembers(in: "public init() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .publicAccess)
    }

    @Test("Given an initializer with private modifier, when analyzing the member, then visibility is private")
    func detectsPrivateInitializer() {
        let members = discoverMembers(in: "private init() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .privateAccess)
    }

    @Test(
        "Given an initializer without a visibility modifier, when analyzing the member, then visibility defaults to internal"
    )
    func initializerDefaultsToInternal() {
        let members = discoverMembers(in: "init() {}")

        #expect(members.count == 1)
        #expect(members[0].visibility == .internalAccess)
    }

    // MARK: - Static Method Visibility

    @Test("Given a static method with public modifier, when analyzing the member, then visibility is public")
    func detectsPublicStaticMethod() {
        let members = discoverMembers(in: "public static func create() {}")

        #expect(members.count == 1)
        #expect(members[0].kind == .typeMethod)
        #expect(members[0].visibility == .publicAccess)
    }

    @Test("Given a static method with private modifier, when analyzing the member, then visibility is private")
    func detectsPrivateStaticMethod() {
        let members = discoverMembers(in: "private static func helper() {}")

        #expect(members.count == 1)
        #expect(members[0].kind == .typeMethod)
        #expect(members[0].visibility == .privateAccess)
    }

    // MARK: - Static Property Visibility

    @Test("Given a static property with public modifier, when analyzing the member, then visibility is public")
    func detectsPublicStaticProperty() {
        let members = discoverMembers(in: "public static var shared: Self")

        #expect(members.count == 1)
        #expect(members[0].kind == .typeProperty)
        #expect(members[0].visibility == .publicAccess)
    }

    @Test("Given a static property with private modifier, when analyzing the member, then visibility is private")
    func detectsPrivateStaticProperty() {
        let members = discoverMembers(in: "private static var instance: Self")

        #expect(members.count == 1)
        #expect(members[0].kind == .typeProperty)
        #expect(members[0].visibility == .privateAccess)
    }

    // MARK: - Multiple Members

    @Test(
        "Given source with members of different visibility levels, when analyzing all members, then each member has its specified visibility"
    )
    func detectsVisibilityForMultipleMembers() {
        let source = """
            public var publicProp: String
            private var privateProp: Int
            internal func internalMethod() {}
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 3)
        #expect(members[0].visibility == .publicAccess)
        #expect(members[1].visibility == .privateAccess)
        #expect(members[2].visibility == .internalAccess)
    }
}
