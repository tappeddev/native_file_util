// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "native_file_util",
    platforms: [
        .iOS("13.0"),
    ],
    products: [
        // If the plugin name contains "_", replace with "-" for the library name.
        .library(name: "native-file-util", targets: ["native_file_util"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "native_file_util",
            dependencies: []
        ),
    ]
)


