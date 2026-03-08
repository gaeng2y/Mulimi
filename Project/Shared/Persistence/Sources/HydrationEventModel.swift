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
    @Attribute(.unique) public var id: UUID
    public var consumedAt: Date
    public var volumeML: Int

    public init(
        id: UUID = UUID(),
        consumedAt: Date,
        volumeML: Int
    ) {
        self.id = id
        self.consumedAt = consumedAt
        self.volumeML = volumeML
    }
}
