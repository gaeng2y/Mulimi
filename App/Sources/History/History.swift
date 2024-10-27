//
//  History.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/6/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import Foundation

struct History: Hashable, Identifiable {
    let id: UUID
    var date: Date
    var mililiter: Double
}

