import Foundation

enum SwiftFileResolver {

    static func resolve(files: [String], path: String?) -> [String] {
        resolve(files: files, paths: path.map { [$0] } ?? [])
    }

    static func resolve(files: [String], paths: [String]) -> [String] {
        var seen = Set(files)
        var result = files

        for path in paths {
            for file in findSwiftFiles(in: path) where seen.insert(file).inserted {
                result.append(file)
            }
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
