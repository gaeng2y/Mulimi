//
//  Record.swift
//  DomainLayer
//
//  Created by Kyeongmo Yang on 7/17/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public struct Record: Hashable, Identifiable {
    public let id: UUID
    public let date: Date
    public let mililiter: Double
    
    public init(id: UUID, date: Date, mililiter: Double) {
        self.id = id
        self.date = date
        self.mililiter = mililiter
    }
}
