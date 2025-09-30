// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RealmPersistenceModule",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "RealmPersistenceModule",
            targets: ["RealmPersistenceModule"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift.git", branch: "master"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: .init(6, 9, 0)))
    ],
    targets: [
        .target(
            name: "RealmPersistenceModule", dependencies: [
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "RxSwift", package: "RxSwift"),
            ]),

    ]
)
