// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "audio_session", path: "../.packages/audio_session-0.2.4"),
        .package(name: "connectivity_plus", path: "../.packages/connectivity_plus-7.3.1"),
        .package(name: "device_info_plus", path: "../.packages/device_info_plus-13.2.0"),
        .package(name: "file_picker", path: "../.packages/file_picker-12.0.0-beta.7"),
        .package(name: "file_selector_macos", path: "../.packages/file_selector_macos-0.9.4+2"),
        .package(name: "firebase_core", path: "../.packages/firebase_core-4.13.0"),
        .package(name: "firebase_messaging", path: "../.packages/firebase_messaging-16.5.0"),
        .package(name: "flutter_local_notifications", path: "../.packages/flutter_local_notifications-22.3.0"),
        .package(name: "geocoding_darwin", path: "../.packages/geocoding_darwin-1.0.2"),
        .package(name: "geolocator_apple", path: "../.packages/geolocator_apple-2.3.14"),
        .package(name: "in_app_review", path: "../.packages/in_app_review-2.0.12"),
        .package(name: "just_audio", path: "../.packages/just_audio-0.10.6"),
        .package(name: "package_info_plus", path: "../.packages/package_info_plus-10.2.1"),
        .package(name: "path_provider_foundation", path: "../.packages/path_provider_foundation-2.4.1"),
        .package(name: "syncfusion_pdfviewer_macos", path: "../.packages/syncfusion_pdfviewer_macos-34.2.3"),
        .package(name: "url_launcher_macos", path: "../.packages/url_launcher_macos-3.2.2"),
        .package(name: "FlutterFramework", path: "../.packages/FlutterFramework")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "audio-session", package: "audio_session"),
                .product(name: "connectivity-plus", package: "connectivity_plus"),
                .product(name: "device-info-plus", package: "device_info_plus"),
                .product(name: "file-picker", package: "file_picker"),
                .product(name: "file-selector-macos", package: "file_selector_macos"),
                .product(name: "firebase-core", package: "firebase_core"),
                .product(name: "firebase-messaging", package: "firebase_messaging"),
                .product(name: "flutter-local-notifications", package: "flutter_local_notifications"),
                .product(name: "geocoding-darwin", package: "geocoding_darwin"),
                .product(name: "geolocator-apple", package: "geolocator_apple"),
                .product(name: "in-app-review", package: "in_app_review"),
                .product(name: "just-audio", package: "just_audio"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "path-provider-foundation", package: "path_provider_foundation"),
                .product(name: "syncfusion-pdfviewer-macos", package: "syncfusion_pdfviewer_macos"),
                .product(name: "url-launcher-macos", package: "url_launcher_macos"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
