import Foundation

struct FileReader: FileReading {

    // MARK: - FileReading

    func read(at path: String) async throws -> String {
        try FileReadingHelper.read(at: path)
    }
}
