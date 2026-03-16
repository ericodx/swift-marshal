import Foundation
import Testing

@testable import swift_marshal

@Suite("SwiftFileResolver Tests")
struct SwiftFileResolverTests {

    // MARK: - resolve(files:path:)

    @Test("Given files without path, when resolving, then returns files unchanged")
    func resolveWithFilesOnly() {
        let files = ["/path/to/File1.swift", "/path/to/File2.swift"]

        let result = SwiftFileResolver.resolve(files: files, path: nil)

        #expect(result == files)
    }

    @Test("Given empty files without path, when resolving, then returns empty array")
    func resolveWithEmptyFilesAndNoPath() {
        let result = SwiftFileResolver.resolve(files: [], path: nil)

        #expect(result.isEmpty)
    }

    @Test("Given path to directory with Swift files, when resolving, then returns found files")
    func resolveWithPath() throws {
        let (tempDir, cleanup) = try createTempDirectoryWithCleanup()
        defer { cleanup() }

        let file1 = tempDir.appendingPathComponent("File1.swift")
        let file2 = tempDir.appendingPathComponent("File2.swift")

        try "".write(to: file1, atomically: true, encoding: .utf8)
        try "".write(to: file2, atomically: true, encoding: .utf8)

        let result = SwiftFileResolver.resolve(files: [], path: realPath(tempDir))

        #expect(result.count == 2)
        #expect(result.contains { $0.hasSuffix("File1.swift") })
        #expect(result.contains { $0.hasSuffix("File2.swift") })
    }

    @Test("Given files and path, when resolving, then combines both")
    func resolveWithFilesAndPath() throws {
        let (tempDir, cleanup) = try createTempDirectoryWithCleanup()
        defer { cleanup() }

        let pathFile = tempDir.appendingPathComponent("PathFile.swift")
        try "".write(to: pathFile, atomically: true, encoding: .utf8)

        let existingFiles = ["/existing/File.swift"]
        let result = SwiftFileResolver.resolve(files: existingFiles, path: realPath(tempDir))

        #expect(result.count == 2)
        #expect(result.contains("/existing/File.swift"))
        #expect(result.contains { $0.hasSuffix("PathFile.swift") })
    }

    @Test("Given path to directory with nested Swift files, when resolving, then finds files recursively")
    func resolveWithNestedPath() throws {
        let (tempDir, cleanup) = try createTempDirectoryWithCleanup()
        defer { cleanup() }

        let nestedDir = tempDir.appendingPathComponent("Nested")
        try FileManager.default.createDirectory(at: nestedDir, withIntermediateDirectories: true)

        let rootFile = tempDir.appendingPathComponent("Root.swift")
        let nestedFile = nestedDir.appendingPathComponent("Nested.swift")

        try "".write(to: rootFile, atomically: true, encoding: .utf8)
        try "".write(to: nestedFile, atomically: true, encoding: .utf8)

        let result = SwiftFileResolver.resolve(files: [], path: realPath(tempDir))

        #expect(result.count == 2)
        #expect(result.contains { $0.hasSuffix("Root.swift") })
        #expect(result.contains { $0.hasSuffix("Nested/Nested.swift") })
    }

    @Test("Given path to directory with non-Swift files, when resolving, then ignores them")
    func resolveIgnoresNonSwiftFiles() throws {
        let (tempDir, cleanup) = try createTempDirectoryWithCleanup()
        defer { cleanup() }

        let swiftFile = tempDir.appendingPathComponent("File.swift")
        let txtFile = tempDir.appendingPathComponent("File.txt")
        let mdFile = tempDir.appendingPathComponent("README.md")

        try "".write(to: swiftFile, atomically: true, encoding: .utf8)
        try "".write(to: txtFile, atomically: true, encoding: .utf8)
        try "".write(to: mdFile, atomically: true, encoding: .utf8)

        let result = SwiftFileResolver.resolve(files: [], path: realPath(tempDir))

        #expect(result.count == 1)
        #expect(result.contains { $0.hasSuffix("File.swift") })
    }

    @Test("Given path to empty directory, when resolving, then returns empty array")
    func resolveWithEmptyDirectory() throws {
        let (tempDir, cleanup) = try createTempDirectoryWithCleanup()
        defer { cleanup() }

        let result = SwiftFileResolver.resolve(files: [], path: realPath(tempDir))

        #expect(result.isEmpty)
    }

    @Test("Given path to nonexistent directory, when resolving, then returns empty array")
    func resolveWithNonexistentPath() {
        let result = SwiftFileResolver.resolve(files: [], path: "/nonexistent/path")

        #expect(result.isEmpty)
    }

    @Test("Given path to directory, when resolving, then returns sorted files")
    func resolveReturnsSortedFiles() throws {
        let (tempDir, cleanup) = try createTempDirectoryWithCleanup()
        defer { cleanup() }

        let fileC = tempDir.appendingPathComponent("C.swift")
        let fileA = tempDir.appendingPathComponent("A.swift")
        let fileB = tempDir.appendingPathComponent("B.swift")

        try "".write(to: fileC, atomically: true, encoding: .utf8)
        try "".write(to: fileA, atomically: true, encoding: .utf8)
        try "".write(to: fileB, atomically: true, encoding: .utf8)

        let result = SwiftFileResolver.resolve(files: [], path: realPath(tempDir))

        #expect(result.count == 3)

        let fileNames = result.map { URL(fileURLWithPath: $0).lastPathComponent }
        #expect(fileNames == ["A.swift", "B.swift", "C.swift"])
    }
}
