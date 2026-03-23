//
//  HydrationEventModel.swift
//  Persistence
//
//  Created by Codex on 3/8/26.
//

import Foundation
import SwiftData

@Model
public final class HydrationEventModel {
    public var id: UUID = UUID()
    public var consumedAt: Date = Date.now
    public var volumeML: Int = 250

    public init(
        id: UUID = UUID(),
        consumedAt: Date = Date.now,
        volumeML: Int = 250
    ) {
        self.id = id
        self.consumedAt = consumedAt
        self.volumeML = volumeML
    }
}
