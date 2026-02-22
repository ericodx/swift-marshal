import Foundation
import Testing

@testable import swift_marshal

@Suite("Snapshot Tests")
struct SnapshotTests {

    private let fixturesDirectory: URL
    private let expectedDirectory: URL

    init() throws {
        let testFile = URL(fileURLWithPath: #filePath)
        let snapshotsDir = testFile.deletingLastPathComponent()
        fixturesDirectory = snapshotsDir.appendingPathComponent("Fixtures")
        expectedDirectory = snapshotsDir.appendingPathComponent("Expected")
    }

    @Test("Given a simple struct declaration, when processing the snapshot, then generates SimpleStruct snapshot")
    func simpleStruct() throws {
        try assertSnapshot(for: "SimpleStruct.txt", fixturesDirectory: fixturesDirectory, expectedDirectory: expectedDirectory)
    }

    @Test("Given a class with properties, when processing the snapshot, then generates ClassWithProperties snapshot")
    func classWithProperties() throws {
        try assertSnapshot(for: "ClassWithProperties.txt", fixturesDirectory: fixturesDirectory, expectedDirectory: expectedDirectory)
    }

    @Test("Given a file with multiple types, when processing the snapshot, then generates MultipleTypes snapshot")
    func multipleTypes() throws {
        try assertSnapshot(for: "MultipleTypes.txt", fixturesDirectory: fixturesDirectory, expectedDirectory: expectedDirectory)
    }

    @Test("Given a file with nested types, when processing the snapshot, then generates NestedTypes snapshot")
    func nestedTypes() throws {
        try assertSnapshot(for: "NestedTypes.txt", fixturesDirectory: fixturesDirectory, expectedDirectory: expectedDirectory)
    }

    @Test("Given a file with comments, when processing the snapshot, then generates CommentsPreserved snapshot")
    func commentsPreserved() throws {
        try assertSnapshot(for: "CommentsPreserved.txt", fixturesDirectory: fixturesDirectory, expectedDirectory: expectedDirectory)
    }

    @Test("Given an already ordered file, when processing the snapshot, then generates AlreadyOrdered snapshot")
    func alreadyOrdered() throws {
        try assertSnapshot(for: "AlreadyOrdered.txt", fixturesDirectory: fixturesDirectory, expectedDirectory: expectedDirectory)
    }

    @Test("Given a file with annotated members, when processing the snapshot, then generates AnnotatedMembers snapshot")
    func annotatedMembers() throws {
        try assertSnapshot(for: "AnnotatedMembers.txt", fixturesDirectory: fixturesDirectory, expectedDirectory: expectedDirectory)
    }

    @Test(
        "Given a file with visibility ordering, when processing the snapshot, then generates VisibilityOrdering snapshot"
    )
    func visibilityOrdering() throws {
        try assertSnapshot(for: "VisibilityOrdering.txt", fixturesDirectory: fixturesDirectory, expectedDirectory: expectedDirectory)
    }

    @Test("Given a type with extension, when processing the snapshot, then generates TypeWithExtension snapshot")
    func typeWithExtension() throws {
        try assertSnapshot(for: "TypeWithExtension.txt", fixturesDirectory: fixturesDirectory, expectedDirectory: expectedDirectory)
    }

    @Test(
        "Given annotated members with visibility, when processing the snapshot, then generates AnnotatedWithVisibility snapshot"
    )
    func annotatedWithVisibility() throws {
        try assertSnapshot(for: "AnnotatedWithVisibility.txt", fixturesDirectory: fixturesDirectory, expectedDirectory: expectedDirectory)
    }

    @Test(
        "Given nested types with extensions, when processing the snapshot, then generates NestedTypesWithExtension snapshot"
    )
    func nestedTypesWithExtension() throws {
        try assertSnapshot(for: "NestedTypesWithExtension.txt", fixturesDirectory: fixturesDirectory, expectedDirectory: expectedDirectory)
    }
}
