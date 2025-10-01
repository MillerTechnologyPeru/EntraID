// swift-tools-version: 6.1
import PackageDescription
import CompilerPluginSupport
import class Foundation.ProcessInfo

// get environment variables
let environment = ProcessInfo.processInfo.environment
let dynamicLibrary = environment["SWIFT_BUILD_DYNAMIC_LIBRARY"] == "1"

// force building as dynamic library
var libraryType: PackageDescription.Product.Library.LibraryType? = dynamicLibrary ? .dynamic : nil

let package = Package(
    name: "EntraID",
    platforms: [
        .macOS(.v13),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "EntraID",
            type: libraryType,
            targets: ["EntraID"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-http-types",
            from: "1.4.0"
        )
    ],
    targets: [
        .target(
            name: "EntraID",
            dependencies: [
                .product(
                    name: "HTTPTypes",
                    package: "swift-http-types"
                ),
                .product(
                    name: "HTTPTypesFoundation",
                    package: "swift-http-types"
                )
            ]
        ),
        .testTarget(
            name: "EntraIDTests",
            dependencies: ["EntraID"]
        ),
    ]
)
