import Testing

@testable import swift_marshal

@Suite("Annotation Detection Tests")
struct AnnotationDetectionTests {

    // MARK: - Property Annotations

    @Test("Given a property with @State attribute, when analyzing the member, then isAnnotated is true")
    func detectsAnnotatedProperty() {
        let members = discoverMembers(in: "@State var name: String")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == true)
    }

    @Test("Given a property without any attribute, when analyzing the member, then isAnnotated is false")
    func detectsNonAnnotatedProperty() {
        let members = discoverMembers(in: "var name: String")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == false)
    }

    @Test("Given a property with multiple attributes, when analyzing the member, then isAnnotated is true")
    func detectsMultipleAnnotations() {
        let members = discoverMembers(in: "@State @Observable var name: String")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == true)
    }

    @Test("Given properties with common SwiftUI attributes, when analyzing each member, then isAnnotated is true")
    func detectsSwiftUIAnnotations() {
        let sources = [
            "@State var state: Int",
            "@Binding var binding: String",
            "@Published var published: Bool",
            "@ObservedObject var observed: Object",
            "@EnvironmentObject var environment: Object",
            "@Environment(\\.key) var env: Value",
        ]

        for source in sources {
            let members = discoverMembers(in: source)
            #expect(members.count == 1)
            #expect(members[0].isAnnotated == true)
        }
    }

    // MARK: - Method Annotations

    @Test("Given a method with @MainActor attribute, when analyzing the member, then isAnnotated is true")
    func detectsAnnotatedMethod() {
        let members = discoverMembers(in: "@MainActor func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == true)
    }

    @Test("Given a method without any attribute, when analyzing the member, then isAnnotated is false")
    func detectsNonAnnotatedMethod() {
        let members = discoverMembers(in: "func doSomething() {}")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == false)
    }

    @Test("Given a method with @discardableResult attribute, when analyzing the member, then isAnnotated is true")
    func detectsDiscardableResult() {
        let members = discoverMembers(in: "@discardableResult func compute() -> Int { 0 }")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == true)
    }

    // MARK: - Combined Visibility and Annotation

    @Test(
        "Given a property with both @State and private modifier, when analyzing the member, then both visibility and isAnnotated are captured"
    )
    func detectsBothVisibilityAndAnnotation() {
        let members = discoverMembers(in: "@State private var state: Int")

        #expect(members.count == 1)
        #expect(members[0].visibility == .privateAccess)
        #expect(members[0].isAnnotated == true)
    }

    @Test(
        "Given a property with both @Published and public modifier, when analyzing the member, then both visibility and isAnnotated are captured"
    )
    func detectsPublicAnnotatedProperty() {
        let members = discoverMembers(in: "@Published public var value: String")

        #expect(members.count == 1)
        #expect(members[0].visibility == .publicAccess)
        #expect(members[0].isAnnotated == true)
    }

    // MARK: - Initializer Annotations

    @Test("Given an initializer with @MainActor attribute, when analyzing the member, then isAnnotated is true")
    func detectsAnnotatedInitializer() {
        let members = discoverMembers(in: "@MainActor init() {}")

        #expect(members.count == 1)
        #expect(members[0].isAnnotated == true)
    }

    // MARK: - Mixed Members

    @Test(
        "Given source with annotated and non-annotated members, when analyzing all members, then isAnnotated reflects each member's attributes"
    )
    func identifiesAnnotationsAcrossMixedMembers() {
        let source = """
            @State var annotatedProp: String
            var normalProp: Int
            @MainActor func annotatedMethod() {}
            func normalMethod() {}
            """
        let members = discoverMembers(in: source)

        #expect(members.count == 4)
        #expect(members[0].isAnnotated == true)
        #expect(members[1].isAnnotated == false)
        #expect(members[2].isAnnotated == true)
        #expect(members[3].isAnnotated == false)
    }
}
