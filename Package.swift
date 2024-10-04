// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "AXPOmniSDK",
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
    .package(url: "https://github.com/apple/swift-openapi-runtime", .upToNextMinor(from: "1.4.0")),
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
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v1.1.0/AXPCore.zip",
      checksum: "69985045526ab57a3324a0be32b395834a63e02485355401909a7f82b2218308"
    ),
    .binaryTarget(
      name: "AXPCalling",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v1.1.0/AXPCalling.zip",
      checksum: "1229cdec868d20203b744564b85a2ee07d64674064a1bfbab5e2f8491fbfbcaa"
    ),
    .binaryTarget(
      name: "AXPMessaging",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v1.1.0/AXPMessaging.zip",
      checksum: "de3ea9777d22ee55ab5ccd1f10194c6ec7932b557706984050d754d02825d930"
    ),
    .binaryTarget(
      name: "AXPMessagingUI",
      url: "https://github.com/AvayaExperiencePlatform/omni-sdk-ios/releases/download/v1.1.0/AXPMessagingUI.zip",
      checksum: "ae777ea88b55d8e0dfc6b3ed02c9123f04bfc8827a3c29430df0f852c2d2172e"
    )
  ]
)
