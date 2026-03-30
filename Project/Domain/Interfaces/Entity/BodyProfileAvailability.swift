//
//  BodyProfileAvailability.swift
//  DomainLayerInterface
//
//  Created by Codex on 3/30/26.
//

import Foundation

public enum BodyProfileAvailability: Hashable, Sendable {
    case ready
    case needsPermission
    case permissionDenied
    case noData
    case incomplete
}
