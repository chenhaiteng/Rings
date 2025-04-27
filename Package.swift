// swift-tools-version:6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Rings",
    platforms: [.macOS(.v14), .iOS(.v14), .tvOS(.v13), .watchOS(.v6)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Common",
            targets: ["Common"]),
        .library(
            name: "Rings",
            targets: ["Rings"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/chenhaiteng/CoreGraphicsExtension.git", from: "0.5.0"),
        .package(url: "https://github.com/chenhaiteng/ArchimedeanSpiral.git", from: "1.1.0"),
        .package(url: "https://github.com/chenhaiteng/GradientBuilder.git", from: "1.2.0"),
        .package(url: "https://github.com/andtie/SequenceBuilder.git", from: "0.0.7"),
        .package(url: "https://github.com/GeorgeElsham/ViewExtractor", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
        .package(url: "https://github.com/chenhaiteng/SwiftClamping", from: "1.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "Common",
                dependencies: []),
        .target(
            name: "Rings",
            dependencies: ["CoreGraphicsExtension", "Common", "ArchimedeanSpiral", "GradientBuilder", "SequenceBuilder", "ViewExtractor", "SwiftClamping"]),
        .testTarget(
            name: "RingsTests",
            dependencies: ["Rings",
                           "CoreGraphicsExtension", "Common"]),
    ]
)
