//
//  HealthKitAuthorizationStatus.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/6/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import Foundation

public enum HealthKitAuthorizationStatus: Int, Sendable {
    case notDetermined
    case sharingDenied
    case sharingAuthorized
}
