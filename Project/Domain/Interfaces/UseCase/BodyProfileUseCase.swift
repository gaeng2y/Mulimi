//
//  BodyProfileUseCase.swift
//  DomainLayerInterface
//
//  Created by Codex on 3/30/26.
//

import Foundation

public protocol BodyProfileUseCase: Sendable {
    func loadBodyProfile() async -> BodyProfileSnapshot
    func requestHealthKitSync() async throws -> BodyProfileSnapshot
}
