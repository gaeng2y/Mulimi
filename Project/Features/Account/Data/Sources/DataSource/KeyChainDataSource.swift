//
//  KeyChainDataSource.swift
//  AccountData
//
//  Created by Kyeongmo Yang on 8/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import AccountDomain
import Foundation
import MulimiKeychain

public protocol KeyChainDataSource: Sendable {
    func validateToken() -> Bool
    func save(property: TokenProperty, value: String)
    func load(property: TokenProperty) -> String
    func delete(property: TokenProperty)
}

public struct KeyChainDataSourceImpl: KeyChainDataSource {
    private let store: KeychainStoring

    public init(store: KeychainStoring = KeychainStore()) {
        self.store = store
    }

    public func validateToken() -> Bool {
        load(property: .accessToken).isEmpty == false
    }

    public func save(property: TokenProperty, value: String) {
        store.save(key: property.rawValue, value: value)
    }

    public func load(property: TokenProperty) -> String {
        store.load(key: property.rawValue)
    }

    public func delete(property: TokenProperty) {
        store.delete(key: property.rawValue)
    }
}
