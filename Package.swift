// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftMarshal",
    platforms: [
        .macOS(.v15),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v8),
        .visionOS(.v1),
    ],
    products: [
        .plugin(name: "SwiftMarshalPlugin", targets: ["SwiftMarshalPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
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
    ]
)
