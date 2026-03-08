//
//  HydrationEvent.swift
//  DomainLayerInterface
//
//  Created by Codex on 3/8/26.
//

import Foundation

public struct HydrationEvent: Hashable, Identifiable, Sendable {
    public let id: UUID
    public let consumedAt: Date
    public let volumeML: Int

    public init(
        id: UUID,
        consumedAt: Date,
        volumeML: Int
    ) {
        self.id = id
        self.consumedAt = consumedAt
        self.volumeML = volumeML
    }
}
