// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CXTest",
    products: [
        .library(name: "CXTest", targets: ["CXTest"]),
    ],
    dependencies: [
        .package(url: "https://github.com/cx-org/CXShim", .branch("master"))
    ],
    targets: [
        .target(name: "CXTest", dependencies: ["CXShim"]),
    ]
)

// MARK: - Combine Implementations

enum CombineImplementation {
    
    case combine
    case combineX
    case openCombine
    
    static var `default`: CombineImplementation {
        #if canImport(Combine)
        return .combine
        #else
        return .combineX
        #endif
    }
    
    init?(_ description: String) {
        let desc = description.lowercased().filter { $0.isLetter }
        switch desc {
        case "combine":     self = .combine
        case "combinex":    self = .combineX
        case "opencombine": self = .openCombine
        default:            return nil
        }
    }
    
    var swiftSettings: [SwiftSetting] {
        switch self {
        case .combine:      return [.define("USE_COMBINE")]
        case .combineX:     return [.define("USE_COMBINEX")]
        case .openCombine:  return [.define("USE_OPEN_COMBINE")]
        }
    }
}

// MARK: - Helpers

import Foundation

extension ProcessInfo {
    
    var combineImplementation: CombineImplementation {
        return environment["CX_COMBINE_IMPLEMENTATION"].flatMap(CombineImplementation.init) ?? .default
    }
    
    var isCI: Bool {
        return (environment["CX_CONTINUOUS_INTEGRATION"] as NSString?)?.boolValue ?? false
    }
}

// MARK: - Config Package

var combineImp = ProcessInfo.processInfo.combineImplementation

if combineImp == .combine {
    package.platforms = [.macOS("10.15"), .iOS("13.0"), .tvOS("13.0"), .watchOS("6.0")]
}
