//
//  KeyChainDataSource.swift
//  DataLayer
//
//  Created by Kyeongmo Yang on 8/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

public protocol KeyChainDataSource {
    func validateToken() -> Bool
    func save(property: TokenProperty, value: String)
    func load(property: TokenProperty) -> String
    func delete(property: TokenProperty)
}

public struct KeyChainDataSourceImpl: KeyChainDataSource {
    public func validateToken() -> Bool {
        load(property: .accessToken).isEmpty == false
    }
    
    public func save(property: TokenProperty, value: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: property.rawValue,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false) ?? .init()
        ]
        
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }
    
    public func load(property: TokenProperty) -> String {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: property.rawValue,
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
    
    public func delete(property: TokenProperty) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: property.rawValue
        ]
        
        SecItemDelete(query)
    }
}
