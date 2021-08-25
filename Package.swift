// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Rings",
    platforms: [.macOS(.v11), .iOS(.v14), .tvOS(.v13), .watchOS(.v6)],
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
        .package(name: "CoreGraphicsExtension", url: "https://github.com/chenhaiteng/CoreGraphicsExtension.git", from: "0.2.0"),
        .package(name: "ArchimedeanSpiral", url: "https://github.com/chenhaiteng/ArchimedeanSpiral.git",  from: "1.0.12"),
        .package(name: "GradientBuilder", url: "https://github.com/chenhaiteng/GradientBuilder.git", .branch("main")),
        .package(name: "SequenceBuilder", url: "https://github.com/andtie/SequenceBuilder.git", .branch("main"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "Common",
                dependencies: [],
                exclude: ["PropertyWrapper/Clamping.md"]),
        .target(
            name: "Rings",
            dependencies: ["CoreGraphicsExtension", "Common", "ArchimedeanSpiral", "GradientBuilder", "SequenceBuilder"],
            exclude: ["RingText.md",
                      "ClockIndex.md",
                      "ArchimedeanSpiralText.md",
                      "HandAiguille.md",
                      "SphericText.md",
                      "Knob.md",
                      "KnobComponents/Layers/ArcKnobLayer.md",
                      "KnobComponents/Layers/ArcKnobDemo.gif"]),
        .testTarget(
            name: "RingsTests",
            dependencies: ["Rings",
                           "CoreGraphicsExtension", "Common"],
            exclude: ["RingText.md",
                      "ClockIndex.md",
                      "ArchimedeanSpiralText.md",
                      "HandAiguille.md",
                      "SphericText.md",
                      "Knob.md",
                      "KnobComponents/Layers/ArcKnobLayer.md",
                      "KnobComponents/Layers/ArcKnobDemo.gif"]),
    ]
)
