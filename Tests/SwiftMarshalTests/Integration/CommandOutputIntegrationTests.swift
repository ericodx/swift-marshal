import Foundation
import Testing

@Suite("Command Output Integration Tests")
struct CommandOutputIntegrationTests {

    // MARK: - CheckCommand Output

    @Test("Given files needing reorder with xcode flag, when running check, then prints xcode warning format")
    func checkXcodeWarningFormat() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["check", "--xcode", tempFile])

        #expect(result.stdout.contains("warning:"))
        #expect(result.stdout.contains("members need reordering"))
    }

    @Test("Given files needing reorder without quiet, when running check, then prints report text")
    func checkNonQuietPrintsReport() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["check", tempFile])

        #expect(result.stdout.contains("[needs reordering]"))
    }

    @Test("Given files needing reorder with quiet, when running check, then does not print report text")
    func checkQuietDoesNotPrintReport() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["check", "--quiet", tempFile])

        #expect(!result.stdout.contains("[needs reordering]"))
    }

    @Test("Given ordered files, when running check, then prints summary with checkmark")
    func checkOrderedPrintsSummary() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["check", "--quiet", tempFile])

        #expect(result.stdout.contains("✓"))
        #expect(result.stdout.contains("correctly ordered"))
    }

    @Test("Given single ordered file, when running check, then uses singular file word")
    func checkSingleFileSingular() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["check", "--quiet", tempFile])

        #expect(result.stdout.contains("1 file "))
        #expect(!result.stdout.contains("1 files"))
    }

    @Test("Given files needing reorder with quiet, when running check, then prints file paths")
    func checkQuietPrintsFilePaths() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["check", "--quiet", tempFile])

        #expect(result.stdout.contains(tempFile))
    }

    @Test("Given single type needing reorder, when running check, then prints singular type word")
    func checkSingleTypeSingular() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["check", tempFile])

        #expect(result.stdout.contains("1 type in"))
        #expect(result.stdout.contains("1 file needs"))
    }

    @Test("Given multiple files needing reorder, when running check, then prints plural words")
    func checkMultipleFilesPlural() throws {
        let tempFile1 = createTempFile(
            content: """
                struct Test1 {
                    func doSomething() {}
                    init() {}
                }
                """)
        let tempFile2 = createTempFile(
            content: """
                struct Test2 {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer {
            removeTempFile(tempFile1)
            removeTempFile(tempFile2)
        }

        let result = try run(args: ["check", tempFile1, tempFile2])

        #expect(result.stdout.contains("types"))
        #expect(result.stdout.contains("files need"))
    }

    @Test("Given xcode flag with ordered files, when running check, then does not print summary")
    func checkXcodeDoesNotPrintSummary() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["check", "--xcode", tempFile])

        #expect(!result.stdout.contains("✓"))
        #expect(!result.stdout.contains("correctly ordered"))
    }

    // MARK: - FixCommand Output

    @Test("Given files needing reorder without quiet, when running fix, then prints Reordered message")
    func fixPrintsReordered() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["fix", tempFile])

        #expect(result.stdout.contains("Reordered:"))
    }

    @Test("Given files needing reorder in dry-run, when running fix, then prints Would reorder message")
    func fixDryRunPrintsWouldReorder() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["fix", "--dry-run", tempFile])

        #expect(result.stdout.contains("Would reorder:"))
        #expect(result.stdout.contains("would be modified"))
    }

    @Test("Given files needing reorder with quiet, when running fix, then does not print Reordered message")
    func fixQuietDoesNotPrintReordered() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["fix", "--quiet", tempFile])

        #expect(!result.stdout.contains("Reordered:"))
    }

    @Test("Given ordered files, when running fix, then prints summary with checkmark")
    func fixOrderedPrintsSummary() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                    func doSomething() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["fix", "--quiet", tempFile])

        #expect(result.stdout.contains("✓"))
        #expect(result.stdout.contains("correctly ordered"))
    }

    @Test("Given single file in dry-run, when running fix, then prints singular file word")
    func fixDryRunSingular() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["fix", "--dry-run", tempFile])

        #expect(result.stdout.contains("1 file "))
        #expect(!result.stdout.contains("1 files"))
    }

    @Test("Given two files in dry-run, when running fix, then prints plural files word")
    func fixDryRunPlural() throws {
        let tempFile1 = createTempFile(
            content: """
                struct Test1 {
                    func doSomething() {}
                    init() {}
                }
                """)
        let tempFile2 = createTempFile(
            content: """
                struct Test2 {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer {
            removeTempFile(tempFile1)
            removeTempFile(tempFile2)
        }

        let result = try run(args: ["fix", "--dry-run", tempFile1, tempFile2])

        #expect(result.stdout.contains("2 files"))
    }

    @Test("Given single file needing reorder, when running fix, then prints singular summary")
    func fixSingleFileSingular() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["fix", "--quiet", tempFile])

        #expect(result.stdout.contains("1 file "))
        #expect(!result.stdout.contains("1 files"))
    }

    @Test("Given single ordered file, when running fix, then prints singular in summary")
    func fixOrderedSingular() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["fix", "--quiet", tempFile])

        #expect(result.stdout.contains("1 file "))
        #expect(!result.stdout.contains("1 files"))
    }

    @Test("Given files needing reorder without dry-run, when running fix, then summary says reordered")
    func fixNonDryRunSaysReordered() throws {
        let tempFile = createTempFile(
            content: """
                struct Test {
                    func doSomething() {}
                    init() {}
                }
                """)
        defer { removeTempFile(tempFile) }

        let result = try run(args: ["fix", tempFile])

        #expect(result.stdout.contains("reordered"))
        #expect(!result.stdout.contains("would be modified"))
    }
}
