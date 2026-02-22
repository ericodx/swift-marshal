import Foundation
import Testing

@testable import swift_marshal

@Suite("PipelineCoordinator Tests")
struct PipelineCoordinatorTests {

    // MARK: - Initialization

    @Test("Given FileIOActor and Configuration, when creating coordinator, then can be used for operations")
    func initializesWithDependencies() async throws {
        let source = """
            struct Test {
                init() {}
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.checkFiles([tempFile])

        #expect(results.count == 1)
    }

    // MARK: - CheckResult Sendable

    @Test("Given CheckResult, when stored as Sendable, then can be recovered")
    func checkResultIsSendable() {
        let result = CheckResult(
            path: "/test/path.swift",
            results: [],
            needsReorder: true
        )
        let sendable: any Sendable = result

        #expect((sendable as? CheckResult)?.path == result.path)
        #expect((sendable as? CheckResult)?.needsReorder == result.needsReorder)
    }

    // MARK: - FixResult Sendable

    @Test("Given FixResult, when stored as Sendable, then can be recovered")
    func fixResultIsSendable() {
        let result = FixResult(
            path: "/test/path.swift",
            source: "struct Test {}",
            modified: true
        )
        let sendable: any Sendable = result

        #expect((sendable as? FixResult)?.path == result.path)
        #expect((sendable as? FixResult)?.modified == result.modified)
    }

    // MARK: - checkFiles Tests

    @Test("Given a file needing reorder, when checking, then returns needsReorder true")
    func checkFilesDetectsReorderNeeded() async throws {
        let source = """
            struct Test {
                func doSomething() {}
                init() {}
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.checkFiles([tempFile])

        #expect(results.count == 1)
        #expect(results[0].needsReorder == true)
        #expect(results[0].path == tempFile)
    }

    @Test("Given a file already ordered, when checking, then returns needsReorder false")
    func checkFilesDetectsNoReorderNeeded() async throws {
        let source = """
            struct Test {
                init() {}
                func doSomething() {}
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.checkFiles([tempFile])

        #expect(results.count == 1)
        #expect(results[0].needsReorder == false)
    }

    @Test("Given multiple files, when checking, then returns results for all files")
    func checkFilesHandlesMultipleFiles() async throws {
        let needsReorder = """
            struct Test1 {
                func a() {}
                init() {}
            }
            """
        let alreadyOrdered = """
            struct Test2 {
                init() {}
                func b() {}
            }
            """
        let tempFile1 = createTempFile(content: needsReorder)
        let tempFile2 = createTempFile(content: alreadyOrdered)
        defer {
            removeTempFile(tempFile1)
            removeTempFile(tempFile2)
        }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.checkFiles([tempFile1, tempFile2])

        #expect(results.count == 2)

        let result1 = results.first { $0.path == tempFile1 }
        let result2 = results.first { $0.path == tempFile2 }

        #expect(result1?.needsReorder == true)
        #expect(result2?.needsReorder == false)
    }

    @Test("Given empty paths array, when checking, then returns empty results")
    func checkFilesHandlesEmptyPaths() async throws {
        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.checkFiles([])

        #expect(results.isEmpty)
    }

    @Test("Given a file with multiple types, when checking, then includes all type results")
    func checkFilesIncludesAllTypeResults() async throws {
        let source = """
            struct First {
                func a() {}
                init() {}
            }
            struct Second {
                init() {}
                func b() {}
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.checkFiles([tempFile])

        #expect(results.count == 1)
        #expect(results[0].results.count == 2)
        #expect(results[0].needsReorder == true)
    }

    @Test("Given a non-existent file, when checking, then throws error")
    func checkFilesThrowsForNonExistentFile() async {
        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        await #expect(throws: FileReadingError.self) {
            _ = try await coordinator.checkFiles(["/non/existent/file.swift"])
        }
    }

    // MARK: - fixFiles Tests

    @Test("Given a file needing fix with dryRun false, when fixing, then modifies the file")
    func fixFilesModifiesFileWhenNotDryRun() async throws {
        let source = """
            struct Test {
                func doSomething() {}
                init() {}
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.fixFiles([tempFile], dryRun: false)

        #expect(results.count == 1)
        #expect(results[0].modified == true)

        let contentAfter = try String(contentsOfFile: tempFile, encoding: .utf8)
        #expect(contentAfter != source)
        #expect(contentAfter.contains("init()"))
    }

    @Test("Given a file needing fix with dryRun true, when fixing, then does not modify the file")
    func fixFilesDoesNotModifyFileWhenDryRun() async throws {
        let source = """
            struct Test {
                func doSomething() {}
                init() {}
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.fixFiles([tempFile], dryRun: true)

        #expect(results.count == 1)
        #expect(results[0].modified == true)

        let contentAfter = try String(contentsOfFile: tempFile, encoding: .utf8)
        #expect(contentAfter == source)
    }

    @Test("Given a file already ordered, when fixing, then returns modified false")
    func fixFilesReturnsNotModifiedForOrderedFile() async throws {
        let source = """
            struct Test {
                init() {}
                func doSomething() {}
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.fixFiles([tempFile], dryRun: false)

        #expect(results.count == 1)
        #expect(results[0].modified == false)

        let contentAfter = try String(contentsOfFile: tempFile, encoding: .utf8)
        #expect(contentAfter == source)
    }

    @Test("Given multiple files, when fixing, then processes all files")
    func fixFilesHandlesMultipleFiles() async throws {
        let needsFix = """
            struct Test1 {
                func a() {}
                init() {}
            }
            """
        let alreadyOrdered = """
            struct Test2 {
                init() {}
                func b() {}
            }
            """
        let tempFile1 = createTempFile(content: needsFix)
        let tempFile2 = createTempFile(content: alreadyOrdered)
        defer {
            removeTempFile(tempFile1)
            removeTempFile(tempFile2)
        }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.fixFiles([tempFile1, tempFile2], dryRun: false)

        #expect(results.count == 2)

        let result1 = results.first { $0.path == tempFile1 }
        let result2 = results.first { $0.path == tempFile2 }

        #expect(result1?.modified == true)
        #expect(result2?.modified == false)
    }

    @Test("Given empty paths array, when fixing, then returns empty results")
    func fixFilesHandlesEmptyPaths() async throws {
        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.fixFiles([], dryRun: false)

        #expect(results.isEmpty)
    }

    @Test("Given a file with multiple types, when fixing, then fixes all types")
    func fixFilesHandlesMultipleTypes() async throws {
        let source = """
            struct First {
                func a() {}
                init() {}
            }
            struct Second {
                func b() {}
                init() {}
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.fixFiles([tempFile], dryRun: false)

        #expect(results.count == 1)
        #expect(results[0].modified == true)

        let contentAfter = try String(contentsOfFile: tempFile, encoding: .utf8)
        #expect(contentAfter.contains("init()"))
    }

    @Test("Given a non-existent file, when fixing, then throws error")
    func fixFilesThrowsForNonExistentFile() async {
        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        await #expect(throws: FileReadingError.self) {
            _ = try await coordinator.fixFiles(["/non/existent/file.swift"], dryRun: false)
        }
    }

    @Test("Given fixed content, when fixFiles returns, then source contains reordered code")
    func fixFilesReturnsReorderedSource() async throws {
        let source = """
            struct Test {
                func doSomething() {}
                init() {}
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.fixFiles([tempFile], dryRun: true)

        #expect(results[0].source != source)
        #expect(results[0].source.contains("init()"))
    }

    // MARK: - Custom Configuration Tests

    @Test("Given custom configuration, when checking, then uses custom ordering rules")
    func checkFilesUsesCustomConfiguration() async throws {
        let source = """
            struct Test {
                init() {}
                func doSomething() {}
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let customConfig = Configuration(
            version: 1,
            memberOrderingRules: [
                .simple(.instanceMethod),
                .simple(.initializer),
            ],
            extensionsStrategy: .separate,
            respectBoundaries: true
        )

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: customConfig
        )

        let results = try await coordinator.checkFiles([tempFile])

        #expect(results[0].needsReorder == true)
    }

    @Test("Given custom configuration, when fixing, then applies custom ordering")
    func fixFilesUsesCustomConfiguration() async throws {
        let source = """
            struct Test {
                init() {}
                func doSomething() {}
            }
            """
        let tempFile = createTempFile(content: source)
        defer { removeTempFile(tempFile) }

        let customConfig = Configuration(
            version: 1,
            memberOrderingRules: [
                .simple(.instanceMethod),
                .simple(.initializer),
            ],
            extensionsStrategy: .separate,
            respectBoundaries: true
        )

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: customConfig
        )

        let results = try await coordinator.fixFiles([tempFile], dryRun: false)

        #expect(results[0].modified == true)

        let contentAfter = try String(contentsOfFile: tempFile, encoding: .utf8)
        guard let initRange = contentAfter.range(of: "init()"),
            let funcRange = contentAfter.range(of: "func doSomething()")
        else {
            Issue.record("Expected to find init() and func doSomething() in output")
            return
        }

        #expect(funcRange.lowerBound < initRange.lowerBound)
    }

    // MARK: - Parallel Processing Tests

    @Test("Given many files, when checking, then processes all files concurrently")
    func checkFilesProcessesConcurrently() async throws {
        var tempFiles: [String] = []
        for item in 0 ..< 10 {
            let source = """
                struct Test\(item) {
                    func method\(item)() {}
                    init() {}
                }
                """
            tempFiles.append(createTempFile(content: source))
        }
        defer {
            for file in tempFiles {
                removeTempFile(file)
            }
        }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.checkFiles(tempFiles)

        #expect(results.count == 10)
        #expect(results.allSatisfy { $0.needsReorder == true })
    }

    @Test("Given many files, when fixing, then processes all files concurrently")
    func fixFilesProcessesConcurrently() async throws {
        var tempFiles: [String] = []
        for item in 0 ..< 10 {
            let source = """
                struct Test\(item) {
                    func method\(item)() {}
                    init() {}
                }
                """
            tempFiles.append(createTempFile(content: source))
        }
        defer {
            for file in tempFiles {
                removeTempFile(file)
            }
        }

        let coordinator = PipelineCoordinator(
            fileIO: FileIOActor(),
            configuration: .defaultValue
        )

        let results = try await coordinator.fixFiles(tempFiles, dryRun: false)

        #expect(results.count == 10)
        #expect(results.allSatisfy { $0.modified == true })
    }
}
