// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIEmbedded",
    platforms: [
        .macOS(.v10_15), .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftUIEmbedded",
            targets: ["SwiftUIEmbedded"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Cosmo/OpenSwiftUI.git", .branch("master")),
        .package(url: "https://github.com/Cosmo/Nodes.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftUIEmbedded",
            dependencies: ["OpenSwiftUI", "Nodes"]),
        .testTarget(
            name: "SwiftUIEmbeddedTests",
            dependencies: ["SwiftUIEmbedded"]),
    ]
)
