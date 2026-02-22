import Foundation

enum SwiftFileResolver {

    static func resolve(files: [String], path: String?) -> [String] {
        var result = files

        if let path = path {
            let pathFiles = findSwiftFiles(in: path)
            result.append(contentsOf: pathFiles)
        }

        return result
    }

    // MARK: - Private

    private static func findSwiftFiles(in directory: String) -> [String] {
        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: directory)

        let enumerator = fileManager.enumerator(
            at: url,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        )

        var swiftFiles: [String] = []

        while let fileURL = enumerator?.nextObject() as? URL {
            if fileURL.pathExtension == "swift" {
                swiftFiles.append(fileURL.path)
            }
        }

        return swiftFiles.sorted()
    }
}
