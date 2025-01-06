// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Notifly",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Notifly", targets: ["Notifly"])
    ],
    targets: [
        .target(
            name: "Notifly",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "NotiflyTests",
            dependencies: ["Notifly"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
