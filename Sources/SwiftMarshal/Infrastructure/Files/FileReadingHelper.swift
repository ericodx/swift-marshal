import Foundation

enum FileReadingHelper {

    static func read(at path: String) throws -> String {
        let url = URL(fileURLWithPath: path)

        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch let error as NSError
            where error.code == NSFileReadNoSuchFileError || error.code == NSFileNoSuchFileError
        {
            throw FileReadingError.fileNotFound(path)
        } catch {
            throw FileReadingError.readError(path, error)
        }
    }
}
