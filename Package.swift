// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Rings",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CommonExts",
            targets: ["CommonExts"]),
        .library(
            name: "Rings",
            targets: ["Rings"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "CoreGraphicsExtension", url: "https://github.com/chenhaiteng/CoreGraphicsExtension.git", from: "0.2.0"),
        .package(name: "ArchimedeanSpiral", url: "https://github.com/chenhaiteng/ArchimedeanSpiral.git",  from: "1.0.12")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "CommonExts",
                dependencies: []),
        .target(
            name: "Rings",
            dependencies: ["CoreGraphicsExtension", "CommonExts", "ArchimedeanSpiral"]),
        .testTarget(
            name: "RingsTests",
            dependencies: ["Rings",
                           "CoreGraphicsExtension", "CommonExts"]),
    ]
)
