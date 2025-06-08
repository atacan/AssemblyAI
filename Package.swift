// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AssemblyAI",
    platforms: [
        .iOS(.v15),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "AssemblyAI",
            targets: ["AssemblyAI"]
        ),
        .library(
            name: "AssemblyAIStreaming",
            targets: ["AssemblyAIStreaming"]
        ),
        .library(
            name: "AssemblyAI_AHC",
            targets: ["AssemblyAI_AHC"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        // .package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.0.0"),
        .package(url: "https://github.com/swift-server/swift-openapi-async-http-client", from: "1.0.0"),
        .package(url: "git@github.com:atacan/UsefulThings.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AssemblyAI"
        ),
        .target(
            name: "AssemblyAICommon",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
            ],
            exclude: []
        ),
        .target(
            name: "AssemblyAI_AHC",
            dependencies: [
                "AssemblyAICommon"
            ],
            exclude: [
                "openapi.yaml",
                "openapi-generator-config.yaml",
                "original.yaml",
            ]
        ),
        .target(
            name: "AssemblyAIStreaming",
            dependencies: [
                "AssemblyAICommon"
            ],
            exclude: []
        ),
        .testTarget(
            name: "AssemblyAITests",
            dependencies: ["AssemblyAI"],
            resources: [.copy("Resources")]
        ),
        .testTarget(
            name: "AssemblyAIStreamingTests",
            dependencies: ["AssemblyAIStreaming"]
        ),
        .testTarget(
            name: "AssemblyAI_AHCTests",
            dependencies: [
                "AssemblyAI_AHC",
                .product(name: "UsefulThings", package: "UsefulThings"),
            ],
            resources: [
                .copy("Resources")
            ]
        ),
        .executableTarget(
            name: "Prepare",
            dependencies: []
        ),
    ]
)

let swiftSettings: [SwiftSetting] = [
    // -enable-bare-slash-regex becomes
    .enableUpcomingFeature("BareSlashRegexLiterals"),
    // -warn-concurrency becomes
    .enableUpcomingFeature("StrictConcurrency"),
    .unsafeFlags(
        ["-enable-actor-data-race-checks"],
        .when(configuration: .debug)
    ),
]

for target in package.targets {
    target.swiftSettings = target.swiftSettings ?? []
    target.swiftSettings?.append(contentsOf: swiftSettings)
}
