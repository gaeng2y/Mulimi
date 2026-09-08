import Foundation

enum WatchL10n {
    private static let tableName = "Localizable"

    static func tr(_ key: String) -> String {
        Bundle.main.localizedString(forKey: key, value: nil, table: tableName)
    }

    static func tr(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: tr(key), locale: .current, arguments: arguments)
    }
}
