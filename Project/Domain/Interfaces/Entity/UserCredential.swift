//
//  UserCredential.swift
//  DomainLayerInterface
//
//  Created by Claude on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public struct UserCredential: Sendable {
    public let userIdentifier: String
    public let email: String?
    public let name: String?

    public init(userIdentifier: String, email: String?, name: String?) {
        self.userIdentifier = userIdentifier
        self.email = email
        self.name = name
    }
}
