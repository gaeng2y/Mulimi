import Foundation

public enum L10n {
    private final class BundleToken {}
    private static let tableName = "Localizable"

    public static let bundle: Bundle = Bundle(for: BundleToken.self)
    private static let fallbackBundle: Bundle? = {
        guard let path = bundle.path(forResource: "ko", ofType: "lproj") else {
            return nil
        }

        return Bundle(path: path)
    }()

    public static func tr(_ key: String) -> String {
        localizedString(forKey: key)
    }

    public static func tr(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: localizedString(forKey: key), locale: .current, arguments: arguments)
    }

    private static func localizedString(forKey key: String) -> String {
        let localized = bundle.localizedString(forKey: key, value: nil, table: tableName)
        if localized != key {
            return localized
        }

        guard let fallbackBundle else {
            return localized
        }

        return fallbackBundle.localizedString(forKey: key, value: nil, table: tableName)
    }
}
