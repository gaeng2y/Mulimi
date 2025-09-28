import ProjectDescription

/// Centralized app version configuration
/// This ensures all modules use the same version and build number
public enum AppVersion {
    /// Marketing version shown to users (e.g., "1.0.8")
    public static let marketingVersion = "1.0.8"

    /// Build number for internal tracking (e.g., "10")
    public static let buildNumber = "10"

    /// Info.plist configuration with version settings
    public static func infoPlistExtension() -> [String: Plist.Value] {
        return [
            "CFBundleShortVersionString": .string(marketingVersion),
            "CFBundleVersion": .string(buildNumber)
        ]
    }
}