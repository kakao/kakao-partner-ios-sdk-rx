// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

// sdk-version:2.18.0

import PackageDescription

let package = Package(
    name: "RxKakaoPartnerSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RxKakaoPartnerSDK",
            targets: ["RxKakaoPartnerSDKAuth", "RxKakaoPartnerSDKUser", "RxKakaoPartnerSDKTalk", "RxKakaoPartnerSDKFriend", "RxKakaoPartnerSDKShare"]),
        .library(
            name: "RxKakaoPartnerSDKAuth",
            targets: ["RxKakaoPartnerSDKAuth"]),
        .library(
            name: "RxKakaoPartnerSDKUser",
            targets: ["RxKakaoPartnerSDKUser"]),
        .library(
            name: "RxKakaoPartnerSDKTalk",
            targets: ["RxKakaoPartnerSDKTalk"]),
        .library(
            name: "RxKakaoPartnerSDKFriend",
            targets: ["RxKakaoPartnerSDKFriend"]),
        .library(
            name: "RxKakaoPartnerSDKShare",
            targets: ["RxKakaoPartnerSDKShare"])
    ],
    dependencies: [
        .package(name: "RxKakaoOpenSDK",
                 url: "https://github.com/kakao/kakao-ios-sdk-rx.git",
                 .exact("2.18.0")
                ),
        .package(name: "KakaoPartnerSDK",
                 url: "https://github.com/kakao/kakao-partner-ios-sdk.git",
                 .exact("2.18.0")
                )
    ],
    targets: [
        .target(
            name: "RxKakaoPartnerSDKAuth",
            dependencies: [
                .product(name: "KakaoPartnerSDKAuth", package: "KakaoPartnerSDK"),
                .product(name: "RxKakaoSDKAuth", package: "RxKakaoOpenSDK"),
                .product(name: "RxKakaoSDKCommon", package: "RxKakaoOpenSDK"),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "RxKakaoPartnerSDKUser",
            dependencies: [
                .target(name: "RxKakaoPartnerSDKAuth"),
                .product(name: "KakaoPartnerSDKUser", package: "KakaoPartnerSDK"),
                .product(name: "RxKakaoSDKUser", package: "RxKakaoOpenSDK"),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "RxKakaoPartnerSDKTalk",
            dependencies: [
                .target(name: "RxKakaoPartnerSDKUser"),
                .product(name: "KakaoPartnerSDKTalk", package: "KakaoPartnerSDK"),
                .product(name: "RxKakaoSDKTalk", package: "RxKakaoOpenSDK"),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "RxKakaoPartnerSDKFriend",
            dependencies: [
                .product(name: "KakaoPartnerSDKFriend", package: "KakaoPartnerSDK"),
                .product(name: "RxKakaoSDKFriend", package: "RxKakaoOpenSDK")
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "RxKakaoPartnerSDKShare",
            dependencies: [
                .product(name: "KakaoPartnerSDKShare", package: "KakaoPartnerSDK"),
                .product(name: "RxKakaoSDKCommon", package: "RxKakaoOpenSDK"),
                .product(name: "RxKakaoSDKShare", package: "RxKakaoOpenSDK")
            ],
            exclude: ["Info.plist", "README.md"]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
