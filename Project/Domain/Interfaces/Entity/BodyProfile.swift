//
//  BodyProfile.swift
//  DomainLayerInterface
//
//  Created by Codex on 3/29/26.
//

import Foundation

public enum BodyProfileSource: String, Hashable, Sendable {
    case healthKit
    case manual
}

public struct BodyProfileValue: Hashable, Sendable {
    public let value: Double
    public let source: BodyProfileSource

    public init(value: Double, source: BodyProfileSource) {
        self.value = value
        self.source = source
    }
}

public struct BodyProfile: Hashable, Sendable {
    public let heightCM: BodyProfileValue?
    public let weightKG: BodyProfileValue?

    public init(
        heightCM: BodyProfileValue?,
        weightKG: BodyProfileValue?
    ) {
        self.heightCM = heightCM
        self.weightKG = weightKG
    }

    public static let empty = BodyProfile(heightCM: nil, weightKG: nil)

    public var isEmpty: Bool {
        heightCM == nil && weightKG == nil
    }

    public var isComplete: Bool {
        heightCM != nil && weightKG != nil
    }

    public func merging(preferred other: BodyProfile) -> BodyProfile {
        BodyProfile(
            heightCM: other.heightCM ?? heightCM,
            weightKG: other.weightKG ?? weightKG
        )
    }
}
