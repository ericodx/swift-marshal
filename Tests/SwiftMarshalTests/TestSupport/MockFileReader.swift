@testable import swift_marshal

// MARK: - Mock FileReader

final class MockFileReader: FileReading {
    let content: String
    let shouldThrow: Bool
    private(set) var lastReadPath: String?

    init(content: String = "", shouldThrow: Bool = false) {
        self.content = content
        self.shouldThrow = shouldThrow
    }

    func read(at path: String) async throws -> String {
        lastReadPath = path
        if shouldThrow {
            throw MockError.fileNotFound
        }
        return content
    }
}

// MARK: - Mock Error

enum MockError: Error {
    case fileNotFound
}
