import Foundation
import Testing

@testable import swift_marshal

@Suite("FileIOActor Tests")
struct FileIOActorTests {

    let actor = FileIOActor()

    // MARK: - Read Tests

    @Test("Given an existing file, when reading, then returns file content")
    func readsExistingFile() async throws {
        let content = "Hello, World!"
        let tempFile = createTempFile(content: content)
        defer { removeTempFile(tempFile) }

        let result = try await actor.read(at: tempFile)

        #expect(result == content)
    }

    @Test("Given a non-existent file, when reading, then throws fileNotFound error")
    func throwsFileNotFoundForNonExistentFile() async {
        let nonExistentPath = "/non/existent/path/file.swift"

        await #expect(throws: FileReadingError.self) {
            try await actor.read(at: nonExistentPath)
        }
    }

    @Test("Given a non-existent file, when reading, then error contains correct path")
    func fileNotFoundErrorContainsPath() async {
        let nonExistentPath = "/non/existent/path/file.swift"

        do {
            _ = try await actor.read(at: nonExistentPath)
            Issue.record("Expected error to be thrown")
        } catch let error as FileReadingError {
            switch error {
            case .fileNotFound(let path):
                #expect(path == nonExistentPath)
            case .readError:
                Issue.record("Expected fileNotFound error, got readError")
            }
        } catch {
            Issue.record("Expected FileReadingError, got \(error)")
        }
    }

    @Test("Given a directory path instead of file, when reading, then throws readError")
    func throwsReadErrorForDirectory() async {
        let tempDir = createTempDirectory()
        defer { removeTempDirectory(tempDir) }

        await #expect(throws: FileReadingError.self) {
            try await actor.read(at: tempDir)
        }
    }

    // MARK: - Write Tests

    @Test("Given valid content and path, when writing, then creates file with content")
    func writesContentToFile() async throws {
        let content = "Test content"
        let tempDir = createTempDirectory()
        let filePath = tempDir + "/test.txt"
        defer { removeTempDirectory(tempDir) }

        try await actor.write(content, to: filePath)

        let result = try String(contentsOfFile: filePath, encoding: .utf8)
        #expect(result == content)
    }

    @Test("Given an existing file, when writing, then overwrites content")
    func overwritesExistingFile() async throws {
        let originalContent = "Original"
        let newContent = "New content"
        let tempFile = createTempFile(content: originalContent)
        defer { removeTempFile(tempFile) }

        try await actor.write(newContent, to: tempFile)

        let result = try String(contentsOfFile: tempFile, encoding: .utf8)
        #expect(result == newContent)
    }

    @Test("Given an invalid path, when writing, then throws writeError")
    func throwsWriteErrorForInvalidPath() async {
        let invalidPath = "/non/existent/directory/file.txt"
        let content = "Test"

        await #expect(throws: FileWritingError.self) {
            try await actor.write(content, to: invalidPath)
        }
    }

    @Test("Given an invalid path, when writing, then error contains correct path")
    func writeErrorContainsPath() async {
        let invalidPath = "/non/existent/directory/file.txt"
        let content = "Test"

        do {
            try await actor.write(content, to: invalidPath)
            Issue.record("Expected error to be thrown")
        } catch let error as FileWritingError {
            switch error {
            case .writeError(let path, _):
                #expect(path == invalidPath)
            }
        } catch {
            Issue.record("Expected FileWritingError, got \(error)")
        }
    }

    // MARK: - Read and Write Integration

    @Test("Given content written to file, when reading back, then returns same content")
    func readWriteRoundTrip() async throws {
        let content = """
            struct Test {
                let value: Int
                func doSomething() {}
            }
            """
        let tempDir = createTempDirectory()
        let filePath = tempDir + "/roundtrip.swift"
        defer { removeTempDirectory(tempDir) }

        try await actor.write(content, to: filePath)
        let result = try await actor.read(at: filePath)

        #expect(result == content)
    }

    @Test("Given empty content, when writing and reading, then handles empty content")
    func handlesEmptyContent() async throws {
        let content = ""
        let tempDir = createTempDirectory()
        let filePath = tempDir + "/empty.txt"
        defer { removeTempDirectory(tempDir) }

        try await actor.write(content, to: filePath)
        let result = try await actor.read(at: filePath)

        #expect(result == content)
    }

    @Test("Given content with special characters, when writing and reading, then preserves special characters")
    func preservesSpecialCharacters() async throws {
        let content = "Hello 世界! 🎉\nLine 2\tTabbed"
        let tempDir = createTempDirectory()
        let filePath = tempDir + "/special.txt"
        defer { removeTempDirectory(tempDir) }

        try await actor.write(content, to: filePath)
        let result = try await actor.read(at: filePath)

        #expect(result == content)
    }
}
