//
//  AuthenticationError.swift
//  DomainLayerInterface
//
//  Created by Claude on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public enum AuthenticationError: Error {
    case cancelled
    case invalidCredential
    case networkFailed
    case serverError(String)
    case unknown(Error)
}
