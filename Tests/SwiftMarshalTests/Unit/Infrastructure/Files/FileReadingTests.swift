import Foundation
import Testing

@testable import swift_marshal

@Suite("FileReading Tests")
struct FileReadingTests {

    @Test("Given an existing file with content, when reading the file, then reads existing file")
    func readsExistingFile() async throws {
        let tempFile = createTempFile(content: "Hello, World!")
        defer { removeTempFile(tempFile) }

        let reader = FileReader()
        let content = try await reader.read(at: tempFile)

        #expect(content == "Hello, World!")
    }

    @Test("Given a missing file path, when attempting to read, then throws fileNotFound for missing file")
    func throwsFileNotFound() async {
        let reader = FileReader()

        do {
            _ = try await reader.read(at: "/nonexistent/path/file.swift")
            Issue.record("Expected FileReadingError but read succeeded")
        } catch {
            #expect(error is FileReadingError)
        }
    }

    @Test("Given a Swift source file, when reading the file, then reads Swift source file")
    func readsSwiftSource() async throws {
        let source = """
            struct Test {
                let value: Int
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let reader = FileReader()
        let content = try await reader.read(at: tempFile)

        #expect(content.contains("struct Test"))
        #expect(content.contains("let value: Int"))
    }

    @Test("Given an empty file, when reading the file, then reads empty file")
    func readsEmptyFile() async throws {
        let tempFile = createTempFile(content: "")
        defer { removeTempFile(tempFile) }

        let reader = FileReader()
        let content = try await reader.read(at: tempFile)

        #expect(content.isEmpty)
    }

    @Test("Given a file with UTF-8 content, when reading the file, then reads UTF-8 content")
    func readsUtf8Content() async throws {
        let content = "// ã, é, çã"
        let tempFile = createTempFile(content: content)
        defer { removeTempFile(tempFile) }

        let reader = FileReader()
        let result = try await reader.read(at: tempFile)

        #expect(result == content)
    }

    // MARK: - Error Description Tests

    @Test(
        "Given a FileNotFound error, when getting the error description, then the FileNotFound error provides descriptive message"
    )
    func fileNotFoundErrorDescription() {
        let error = FileReadingError.fileNotFound("/path/to/missing.swift")

        #expect(error.errorDescription == "File not found: /path/to/missing.swift")
    }

    @Test(
        "Given a ReadError with underlying error, when getting the error description, then the ReadError provides descriptive message with underlying error"
    )
    func readErrorDescription() {
        let underlyingError = NSError(
            domain: "TestDomain",
            code: 1,
            userInfo: [NSLocalizedDescriptionKey: "Permission denied"]
        )
        let error = FileReadingError.readError("/path/to/file.swift", underlyingError)

        #expect(error.errorDescription == "Failed to read '/path/to/file.swift': Permission denied")
    }

    @Test(
        "Given a file with invalid UTF-8 content, when reading the file, then throws readError"
    )
    func throwsReadErrorForInvalidUTF8() async throws {
        let tempDir = FileManager.default.temporaryDirectory
        let filePath = tempDir.appendingPathComponent(UUID().uuidString + ".swift").path

        let invalidBytes: [UInt8] = [0xFF, 0xFE, 0x00, 0x01]
        let data = Data(invalidBytes)
        FileManager.default.createFile(atPath: filePath, contents: data)
        defer { try? FileManager.default.removeItem(atPath: filePath) }

        let reader = FileReader()

        do {
            _ = try await reader.read(at: filePath)
            Issue.record("Expected FileReadingError but read succeeded - some byte sequences may be valid UTF-8")
        } catch {
            #expect(error is FileReadingError)
        }
    }
}
