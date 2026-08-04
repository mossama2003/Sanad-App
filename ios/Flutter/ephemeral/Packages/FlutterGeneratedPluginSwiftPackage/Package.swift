// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .iOS("15")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "url_launcher_ios", path: "../.packages/url_launcher_ios-6.4.1"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation-2.5.6"),
        .package(name: "share_plus", path: "../.packages/share_plus-13.3.0"),
        .package(name: "permission_handler_apple", path: "../.packages/permission_handler_apple-9.5.0"),
        .package(name: "open_file_ios", path: "../.packages/open_file_ios-1.1.0"),
        .package(name: "mobile_scanner", path: "../.packages/mobile_scanner-7.4.0"),
        .package(name: "image_picker_ios", path: "../.packages/image_picker_ios-0.8.13+6"),
        .package(name: "image_gallery_saver_plus", path: "../.packages/image_gallery_saver_plus-5.1.1"),
        .package(name: "image_cropper", path: "../.packages/image_cropper-12.2.1"),
        .package(name: "package_info_plus", path: "../.packages/package_info_plus-10.2.1"),
        .package(name: "geolocator_apple", path: "../.packages/geolocator_apple-2.3.14"),
        .package(name: "webview_flutter_wkwebview", path: "../.packages/webview_flutter_wkwebview-3.26.0"),
        .package(name: "just_audio", path: "../.packages/just_audio-0.10.6"),
        .package(name: "audio_session", path: "../.packages/audio_session-0.2.4"),
        .package(name: "video_player_avfoundation", path: "../.packages/video_player_avfoundation-2.11.0"),
        .package(name: "wakelock_plus", path: "../.packages/wakelock_plus-1.7.0"),
        .package(name: "sqflite_darwin", path: "../.packages/sqflite_darwin-2.4.3+1"),
        .package(name: "flutter_image_compress_common", path: "../.packages/flutter_image_compress_common-1.1.1"),
        .package(name: "firebase_messaging", path: "../.packages/firebase_messaging-16.4.3"),
        .package(name: "firebase_core", path: "../.packages/firebase_core-4.12.1"),
        .package(name: "file_selector_ios", path: "../.packages/file_selector_ios-0.5.3+5"),
        .package(name: "emoji_picker_flutter", path: "../.packages/emoji_picker_flutter-4.5.3"),
        .package(name: "connectivity_plus", path: "../.packages/connectivity_plus-7.3.1"),
        .package(name: "audioplayers_darwin", path: "../.packages/audioplayers_darwin-6.5.0"),
        .package(name: "FlutterFramework", path: "../.packages/FlutterFramework")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "url-launcher-ios", package: "url_launcher_ios"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "share-plus", package: "share_plus"),
                .product(name: "permission-handler-apple", package: "permission_handler_apple"),
                .product(name: "open-file-ios", package: "open_file_ios"),
                .product(name: "mobile-scanner", package: "mobile_scanner"),
                .product(name: "image-picker-ios", package: "image_picker_ios"),
                .product(name: "image-gallery-saver-plus", package: "image_gallery_saver_plus"),
                .product(name: "image-cropper", package: "image_cropper"),
                .product(name: "package-info-plus", package: "package_info_plus"),
                .product(name: "geolocator-apple", package: "geolocator_apple"),
                .product(name: "webview-flutter-wkwebview", package: "webview_flutter_wkwebview"),
                .product(name: "just-audio", package: "just_audio"),
                .product(name: "audio-session", package: "audio_session"),
                .product(name: "video-player-avfoundation", package: "video_player_avfoundation"),
                .product(name: "wakelock-plus", package: "wakelock_plus"),
                .product(name: "sqflite-darwin", package: "sqflite_darwin"),
                .product(name: "flutter-image-compress-common", package: "flutter_image_compress_common"),
                .product(name: "firebase-messaging", package: "firebase_messaging"),
                .product(name: "firebase-core", package: "firebase_core"),
                .product(name: "file-selector-ios", package: "file_selector_ios"),
                .product(name: "emoji-picker-flutter", package: "emoji_picker_flutter"),
                .product(name: "connectivity-plus", package: "connectivity_plus"),
                .product(name: "audioplayers-darwin", package: "audioplayers_darwin"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
