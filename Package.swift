// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "AXPSDK",
  defaultLocalization: "en",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "AXPCore",
      targets: ["AXPCoreWrapper"]
    ),
    .library(
      name: "AXPCalling",
      targets: ["AXPCallingWrapper"]
    ),
    .library(
      name: "AXPMessaging",
      targets: ["AXPMessagingWrapper"]
    ),
    .library(
      name: "AXPMessagingUI",
      targets: ["AXPMessagingUI"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-openapi-runtime", .upToNextMinor(from: "1.1.0")),
    .package(url: "https://github.com/apple/swift-openapi-urlsession", .upToNextMinor(from: "1.0.0")),
    .package(url: "https://github.com/elegantchaos/DictionaryCoding", .upToNextMajor(from: "1.0.9")),
    .package(url: "https://github.com/stasel/WebRTC", .upToNextMajor(from: "120.0.0")),
    .package(url: "https://github.com/Thomvis/BrightFutures", .upToNextMajor(from: "8.0.0")),
  ],
  targets: [
    .target(
      name: "AXPCoreWrapper",
      dependencies: [
        "AXPCore",
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
      ]
    ),
    .target(
      name: "AXPCallingWrapper",
      dependencies: [
        "AXPCalling",
        "AXPCore",
        "BrightFutures",
        "DictionaryCoding",
        "WebRTC",
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
      ]
    ),
    .target(
      name: "AXPMessagingWrapper",
      dependencies: [
        "AXPMessaging",
        "AXPCore",
        .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
        .product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
      ]
    ),
    .binaryTarget(
      name: "AXPCore",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v0.1.0/AXPCore.zip",
      checksum: "a6253dcca0539da442d0b976ab933eb7cf9c4488db7fab287c671cdc433c1127"
    ),
    .binaryTarget(
      name: "AXPCalling",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v0.1.0/AXPCalling.zip",
      checksum: "1a5d2bef54d08ba89235822c370cd4d011d94646249b8871fcdc5ee31c1230f6"
    ),
    .binaryTarget(
      name: "AXPMessaging",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v0.1.0/AXPMessaging.zip",
      checksum: "31beb2d448c575860aa1be5689fe0a35bd0196dfb6629cc1209043a61f6b94a9"
    ),
    .binaryTarget(
      name: "AXPMessagingUI",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v0.1.0/AXPMessagingUI.zip",
      checksum: "24d37c65b014585cfb42c54a6d653361d202e26e7ac8b7acecaa7aff92a7f4ad"
    )
  ]
)
