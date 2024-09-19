//
//  String+Extensions.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/07/20.
//

import Foundation

extension String {
    static let appGroupId = "group.com.gaeng2y.drinkwater"
    static let widgetKind: String = "MulimeeWidget"
    
    static var glassesOfToday: String {
        let now = Date()
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df
        }()
        return dateFormatter.string(from: now)
    }
}
