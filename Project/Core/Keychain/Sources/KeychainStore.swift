import Foundation

public protocol KeychainStoring: Sendable {
    func save(key: String, value: String)
    func load(key: String) -> String
    func delete(key: String)
}

public struct KeychainStore: KeychainStoring {
    public init() {}

    public func save(key: String, value: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false) ?? .init()
        ]

        SecItemDelete(query)
        SecItemAdd(query, nil)
    }

    public func load(key: String) -> String {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            guard let data = dataTypeRef as? Data else { return "" }
            return String(data: data, encoding: .utf8) ?? ""
        }

        return ""
    }

    public func delete(key: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]

        SecItemDelete(query)
    }
}
