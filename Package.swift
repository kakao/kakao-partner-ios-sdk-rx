// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

// sdk-version:2.29.0

import PackageDescription

let rxPackageName = "kakao-ios-sdk-rx"
let partnerPackageName = "kakao-partner-ios-sdk"

let package = Package(
    name: "RxKakaoPartnerSDK",
    platforms: [
        .iOS(.v15)
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
        .package(url: "https://github.com/kakao/kakao-ios-sdk-rx.git",
                 exact: "2.29.0"),
        .package(url: "https://github.com/kakao/kakao-partner-ios-sdk.git",
                 exact: "2.29.0")
    ],
    targets: [
        .target(
            name: "RxKakaoPartnerSDKAuth",
            dependencies: [
                .product(name: "KakaoPartnerSDKAuth", package: partnerPackageName),
                .product(name: "RxKakaoSDKAuth", package: rxPackageName),
                .product(name: "RxKakaoSDKCommon", package: rxPackageName),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "RxKakaoPartnerSDKUser",
            dependencies: [
                .target(name: "RxKakaoPartnerSDKAuth"),
                .product(name: "KakaoPartnerSDKUser", package: partnerPackageName),
                .product(name: "RxKakaoSDKUser", package: rxPackageName),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "RxKakaoPartnerSDKTalk",
            dependencies: [
                .target(name: "RxKakaoPartnerSDKUser"),
                .product(name: "KakaoPartnerSDKTalk", package: partnerPackageName),
                .product(name: "RxKakaoSDKTalk", package: rxPackageName),
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "RxKakaoPartnerSDKFriend",
            dependencies: [
                .product(name: "KakaoPartnerSDKFriend", package: partnerPackageName),
                .product(name: "RxKakaoSDKFriend", package: rxPackageName)
            ],
            exclude: ["Info.plist", "README.md"]
        ),
        .target(
            name: "RxKakaoPartnerSDKShare",
            dependencies: [
                .product(name: "KakaoPartnerSDKShare", package: partnerPackageName),
                .product(name: "RxKakaoSDKCommon", package: rxPackageName),
                .product(name: "RxKakaoSDKShare", package: rxPackageName)
            ],
            exclude: ["Info.plist", "README.md"]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
