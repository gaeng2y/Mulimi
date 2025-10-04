//
//  MainAppearance.swift
//  DomainLayerInterface
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public enum MainAppearance: CaseIterable, Identifiable {
    case drop
    case heart
    case cloud
    
    public var id: Self { self }
    
    public var displayName: String {
        switch self {
        case .drop:
            return "물방울"
        case .heart:
            return "하트"
        case .cloud:
            return "구름"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .drop:
            return "drop"
        case .heart:
            return "heart"
        case .cloud:
            return "cloud"
        }
    }

    public var fillSystemImage: String {
        switch self {
        case .drop:
            return "drop.fill"
        case .heart:
            return "heart.fill"
        case .cloud:
            return "cloud.fill"
        }
    }
    
    public var description: String {
        switch self {
        case .drop:
            return "물방울 모양으로 물의 본질을 표현합니다"
        case .heart:
            return "하트 모양으로 사랑스럽고 친근한 느낌을 줍니다"
        case .cloud:
            return "구름 모양으로 부드럽고 편안한 느낌을 줍니다"
        }
    }
    
    // Default appearance
    public static let `default`: MainAppearance = .drop
}
