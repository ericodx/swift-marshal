// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftMarshal",
    platforms: [
        .macOS(.v15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .visionOS(.v1),
    ],
    products: [
        .executable(name: "swift-marshal", targets: ["swift-marshal"]),
        .plugin(name: "SwiftMarshalPlugin", targets: ["SwiftMarshalPlugin"]),
        .plugin(name: "SwiftMarshalCommandPlugin", targets: ["SwiftMarshalCommandPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0")
    ],
    targets: [
        .executableTarget(
            name: "swift-marshal",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ],
            path: "Sources/SwiftMarshal",
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .testTarget(
            name: "SwiftMarshalTests",
            dependencies: ["swift-marshal"],
            resources: [
                .copy("Snapshots/Fixtures"),
                .copy("Snapshots/Expected"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v6)
            ]
        ),
        .plugin(
            name: "SwiftMarshalPlugin",
            capability: .buildTool(),
            dependencies: ["swift-marshal"]
        ),
        .plugin(
            name: "SwiftMarshalCommandPlugin",
            capability: .command(
                intent: .custom(
                    verb: "marshal",
                    description: "Reorder Swift type members according to .swift-marshal.yaml"
                ),
                permissions: [
                    .writeToPackageDirectory(
                        reason: "Reorders member declarations in Swift source files"
                    )
                ]
            ),
            dependencies: ["swift-marshal"]
        ),
    ]
)
