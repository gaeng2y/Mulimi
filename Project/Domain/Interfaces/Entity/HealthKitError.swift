//
//  HealthKitError.swift
//  DomainLayerInterface
//
//  Created by Kyeongmo Yang on 7/17/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public enum HealthKitError: Error {
    case invalidObjectType
    case permissionDenied
    case healthKitInternalError
    case incompleteExecuteQuery
}
