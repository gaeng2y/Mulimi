//
//  MainAppearance.swift
//  DomainLayerInterface
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation
import Localization

public enum MainAppearance: CaseIterable, Identifiable, Sendable {
    case drop
    case heart
    case cloud
    
    public var id: Self { self }
    
    public var displayName: String {
        switch self {
        case .drop:
            return L10n.tr("mainAppearanceDropName")
        case .heart:
            return L10n.tr("mainAppearanceHeartName")
        case .cloud:
            return L10n.tr("mainAppearanceCloudName")
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
            return L10n.tr("mainAppearanceDropDescription")
        case .heart:
            return L10n.tr("mainAppearanceHeartDescription")
        case .cloud:
            return L10n.tr("mainAppearanceCloudDescription")
        }
    }
    
    // Default appearance
    public static var `default`: MainAppearance { .drop }
}
