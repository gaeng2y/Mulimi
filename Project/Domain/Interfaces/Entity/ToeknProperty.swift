//
//  ToeknProperty.swift
//  DomainLayerInterface
//
//  Created by Kyeongmo Yang on 8/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public enum TokenProperty: String, CaseIterable {
    case accessToken = "ACCESS-TOKEN"
    case refreshToken = "REFRESH-TOKEN"
    
    case userIdentifier = "USER-IDENTIFIER"
    case nickname = "NICKNAME"
    case email = "EMAIL"
}
