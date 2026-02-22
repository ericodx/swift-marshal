import Foundation

enum FileReadingHelper {

    static func read(at path: String) throws -> String {
        let url = URL(fileURLWithPath: path)

        guard FileManager.default.fileExists(atPath: path) else {
            throw FileReadingError.fileNotFound(path)
        }

        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            throw FileReadingError.readError(path, error)
        }
    }
}
