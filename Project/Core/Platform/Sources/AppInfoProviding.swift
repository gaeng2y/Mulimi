import Foundation

public protocol AppInfoProviding: Sendable {
    var appVersion: String { get }
    var appBuildNumber: String { get }
}

public struct BundleAppInfoProvider: AppInfoProviding {
    public init() {}

    public var appVersion: String {
        Self.bundleValue(for: "CFBundleShortVersionString")
    }

    public var appBuildNumber: String {
        Self.bundleValue(for: "CFBundleVersion")
    }

    private static func bundleValue(for key: String) -> String {
        (Bundle.main.object(forInfoDictionaryKey: key) as? String) ?? "-"
    }
}

public struct StaticAppInfoProvider: AppInfoProviding {
    public let appVersion: String
    public let appBuildNumber: String

    public init(appVersion: String, appBuildNumber: String) {
        self.appVersion = appVersion
        self.appBuildNumber = appBuildNumber
    }
}
