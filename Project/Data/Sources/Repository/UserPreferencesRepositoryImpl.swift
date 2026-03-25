//
//  UserPreferencesRepositoryImpl.swift
//  DomainLayer
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

public struct UserPreferencesRepositoryImpl: UserPreferencesRepository {
    private let dataSource: UserPreferencesDataSource
    
    public init(dataSource: UserPreferencesDataSource) {
        self.dataSource = dataSource
    }
    
    public func getMainIcon() -> MainIcon {
        dataSource.getMainIcon()
    }
    
    public func setMainIcon(_ icon: MainIcon) {
        dataSource.setMainIcon(icon)
    }
    
    public func getDailyWaterLimit() -> Double {
        dataSource.getDailyWaterLimit()
    }
    
    public func setDailyWaterLimit(_ limit: Double) {
        dataSource.setDailyWaterLimit(limit)
    }
}
