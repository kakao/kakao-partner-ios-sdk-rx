// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription



let package = Package(
    name: "RxKakaoPartnerSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "RxKakaoPartnerSDK",
            targets: ["RxKakaoPartnerSDKAuth", "RxKakaoPartnerSDKUser", "RxKakaoPartnerSDKTalk", "RxKakaoPartnerSDKLink"]),
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
            name: "RxKakaoPartnerSDKLink",
            targets: ["RxKakaoPartnerSDKLink"])
    ],
    dependencies: [
        .package(name: "RxKakaoOpenSDK",
                 url: "https://github.com/kakao/kakao-ios-sdk-rx.git", .branch("develop")),
        .package(name: "KakaoPartnerSDK",
                 url: "https://github.com/kakao/kakao-partner-ios-sdk.git", .branch("develop"))
    ],
    targets: [
        .target(
            name: "RxKakaoPartnerSDKAuth",
            dependencies: [
                .product(name: "KakaoPartnerSDKAuth", package: "KakaoPartnerSDK"),
                .product(name: "RxKakaoSDKAuth", package: "RxKakaoOpenSDK"),
                .product(name: "RxKakaoSDKCommon", package: "RxKakaoOpenSDK"),
            ],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RxKakaoPartnerSDKUser",
            dependencies: [
                .target(name: "RxKakaoPartnerSDKAuth"),
                .product(name: "KakaoPartnerSDKUser", package: "KakaoPartnerSDK"),
                .product(name: "RxKakaoSDKUser", package: "RxKakaoOpenSDK"),
            ],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RxKakaoPartnerSDKTalk",
            dependencies: [
                .target(name: "RxKakaoPartnerSDKUser"),
                .product(name: "KakaoPartnerSDKTalk", package: "KakaoPartnerSDK"),
                .product(name: "RxKakaoSDKTalk", package: "RxKakaoOpenSDK"),
            ],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "RxKakaoPartnerSDKLink",
            dependencies: [
                .product(name: "KakaoPartnerSDKLink", package: "KakaoPartnerSDK"),
                .product(name: "RxKakaoSDKCommon", package: "RxKakaoOpenSDK"),
                .product(name: "RxKakaoSDKLink", package: "RxKakaoOpenSDK")
            ],
            exclude: ["Info.plist"]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)