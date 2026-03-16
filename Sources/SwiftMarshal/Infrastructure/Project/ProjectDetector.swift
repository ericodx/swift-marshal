import Foundation

enum ProjectDetector {

    static func detect(in directory: String) -> ProjectKind {
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: directory + "/Package.swift") {
            return .spm(sourcesPath: "Sources")
        }

        let url = URL(fileURLWithPath: directory)
        let contents =
            (try? fileManager.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: nil,
                options: .skipsHiddenFiles
            )) ?? []

        for item in contents where item.pathExtension == "xcodeproj" {
            return .xcode(sourcesPath: item.deletingPathExtension().lastPathComponent)
        }

        return .unknown
    }
}
