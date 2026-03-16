import Foundation
import Testing

@Suite("CommandPlugin Integration Tests")
struct CommandPluginIntegrationTests {

    // MARK: - fix --path on directory

    @Test("Given a directory with an unordered file, when running fix with --path, then file is reordered")
    func fixesUnorderedFileInDirectory() throws {
        let dir = createTempDirectory()
        defer { removeTempDirectory(dir) }

        let filePath = dir + "/Test.swift"
        let source = """
            struct Test {
                func doSomething() {}
                init() {}
            }
            """
        try source.write(toFile: filePath, atomically: true, encoding: .utf8)

        let result = try run(args: ["fix", "--path", dir])

        #expect(result.exitCode == 0)
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        #expect(content != source)
        #expect(content.contains("init()"))
    }

    @Test("Given a directory with an already-ordered file, when running fix with --path, then file is unchanged")
    func leavesOrderedFileUnchanged() throws {
        let dir = createTempDirectory()
        defer { removeTempDirectory(dir) }

        let filePath = dir + "/Test.swift"
        let source = """
            struct Test {
                init() {}
                func doSomething() {}
            }
            """
        try source.write(toFile: filePath, atomically: true, encoding: .utf8)

        let result = try run(args: ["fix", "--path", dir])

        #expect(result.exitCode == 0)
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        #expect(content == source)
    }

    @Test("Given a directory with multiple unordered files, when running fix with --path, then all files are reordered")
    func fixesMultipleFilesInDirectory() throws {
        let dir = createTempDirectory()
        defer { removeTempDirectory(dir) }

        let sources = [
            "A.swift": "struct A {\n    func a() {}\n    init() {}\n}\n",
            "B.swift": "struct B {\n    func b() {}\n    init() {}\n}\n",
        ]

        for (name, content) in sources {
            try content.write(toFile: dir + "/" + name, atomically: true, encoding: .utf8)
        }

        let result = try run(args: ["fix", "--path", dir])

        #expect(result.exitCode == 0)
        for name in sources.keys {
            let content = try String(contentsOfFile: dir + "/" + name, encoding: .utf8)
            let initRange = content.range(of: "init()")
            let funcRange = content.range(of: "func ")
            #expect(initRange != nil)
            #expect(funcRange != nil)
            #expect(initRange!.lowerBound < funcRange!.lowerBound)
        }
    }

    @Test(
        "Given a directory with nested subdirectories, when running fix with --path, then files in subdirectories are also fixed"
    )
    func fixesFilesInSubdirectories() throws {
        let dir = createTempDirectory()
        defer { removeTempDirectory(dir) }

        let subdir = dir + "/Sub"
        try FileManager.default.createDirectory(atPath: subdir, withIntermediateDirectories: true)

        let filePath = subdir + "/Test.swift"
        let source = """
            struct Test {
                func doSomething() {}
                init() {}
            }
            """
        try source.write(toFile: filePath, atomically: true, encoding: .utf8)

        let result = try run(args: ["fix", "--path", dir])

        #expect(result.exitCode == 0)
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        #expect(content != source)
    }

    @Test("Given a non-existent directory, when running fix with --path, then exits non-zero")
    func nonExistentPathExitsNonZero() throws {
        let result = try run(args: ["fix", "--path", "/tmp/does-not-exist-\(UUID().uuidString)"])
        #expect(result.exitCode != 0)
    }

    // MARK: - dry-run

    @Test("Given an unordered file, when running fix with --path and --dry-run, then file is not modified")
    func dryRunDoesNotModifyFile() throws {
        let dir = createTempDirectory()
        defer { removeTempDirectory(dir) }

        let filePath = dir + "/Test.swift"
        let source = """
            struct Test {
                func doSomething() {}
                init() {}
            }
            """
        try source.write(toFile: filePath, atomically: true, encoding: .utf8)

        let result = try run(args: ["fix", "--path", dir, "--dry-run"])

        #expect(result.exitCode == 1)
        let content = try String(contentsOfFile: filePath, encoding: .utf8)
        #expect(content == source)
    }
}
