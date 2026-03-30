//
//  BodyProfileViewModel.swift
//  PresentationLayer
//
//  Created by Codex on 3/29/26.
//

import DomainLayerInterface
import Foundation
import Localization
import Observation

@Observable
@MainActor
public final class BodyProfileViewModel {
    public private(set) var authorizationStatus: HealthKitAuthorizationStatus
    public private(set) var resolvedBodyProfile: BodyProfile = .empty
    public private(set) var healthKitBodyProfile: BodyProfile = .empty
    public private(set) var isLoading = false
    public private(set) var hasLoaded = false
    public var errorMessage: String?

    private let bodyProfileUseCase: BodyProfileUseCase

    public init(
        bodyProfileUseCase: BodyProfileUseCase
    ) {
        self.bodyProfileUseCase = bodyProfileUseCase
        self.authorizationStatus = .notDetermined
    }

    public var availabilityState: BodyProfileAvailability {
        if resolvedBodyProfile.isComplete {
            return .ready
        }

        return currentSnapshot?.availability ?? .needsPermission
    }

    public var summaryText: String {
        let heightText = resolvedHeightText
        let weightText = resolvedWeightText

        switch (heightText, weightText) {
        case let (height?, weight?):
            return "\(height) · \(weight)"
        case let (height?, nil):
            return "\(height) · \(L10n.tr("bodyProfileWeightMissingValue"))"
        case let (nil, weight?):
            return "\(L10n.tr("bodyProfileHeightMissingValue")) · \(weight)"
        case (nil, nil):
            return L10n.tr("bodyProfileSummaryNeedsInput")
        }
    }

    public var helperText: String {
        switch availabilityState {
        case .ready:
            return L10n.tr("bodyProfileSourcePriorityDescription")
        case .needsPermission:
            return L10n.tr("bodyProfilePermissionNeededDescription")
        case .permissionDenied:
            return L10n.tr("bodyProfilePermissionDeniedDescription")
        case .noData:
            return L10n.tr("bodyProfileNoDataDescription")
        case .incomplete:
            return L10n.tr("bodyProfileIncompleteDescription")
        }
    }

    public var resolvedHeightText: String? {
        resolvedBodyProfile.heightCM.map {
            L10n.tr("bodyProfileHeightValueFormat", Int($0.value.rounded()))
        }
    }

    public var resolvedWeightText: String? {
        resolvedBodyProfile.weightKG.map {
            L10n.tr("bodyProfileWeightValueFormat", Int($0.value.rounded()))
        }
    }

    public var heightSourceText: String? {
        sourceText(for: resolvedBodyProfile.heightCM?.source)
    }

    public var weightSourceText: String? {
        sourceText(for: resolvedBodyProfile.weightKG?.source)
    }

    private var currentSnapshot: BodyProfileSnapshot?

    public func load() async {
        guard !hasLoaded else {
            await refresh()
            return
        }

        hasLoaded = true
        await refresh()
    }

    public func refresh() async {
        isLoading = true
        errorMessage = nil
        let snapshot = await bodyProfileUseCase.loadBodyProfile()
        apply(snapshot)
        if snapshot.didFailHealthKitSync {
            errorMessage = L10n.tr("bodyProfileHealthSyncFailureDescription")
        }
        isLoading = false
    }

    public func requestHealthKitBodyProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            let snapshot = try await bodyProfileUseCase.requestHealthKitSync()
            apply(snapshot)

            if snapshot.authorizationStatus != .sharingAuthorized {
                errorMessage = L10n.tr("bodyProfilePermissionDeniedDescription")
            } else if snapshot.didFailHealthKitSync {
                errorMessage = L10n.tr("bodyProfileHealthSyncFailureDescription")
            }
        } catch {
            let snapshot = await bodyProfileUseCase.loadBodyProfile()
            apply(snapshot)
            errorMessage = L10n.tr("bodyProfilePermissionRequestFailureDescription")
            isLoading = false
            return
        }
        isLoading = false
    }

    private func apply(_ snapshot: BodyProfileSnapshot) {
        currentSnapshot = snapshot
        authorizationStatus = snapshot.authorizationStatus
        healthKitBodyProfile = snapshot.healthKitBodyProfile
        resolvedBodyProfile = snapshot.resolvedBodyProfile
    }

    private func sourceText(for source: BodyProfileSource?) -> String? {
        switch source {
        case .healthKit:
            return L10n.tr("bodyProfileSourceHealthKit")
        case .manual:
            return L10n.tr("bodyProfileSourceManual")
        case nil:
            return nil
        }
    }

    private func currentAvailability(
        authorizationStatus: HealthKitAuthorizationStatus,
        healthKitBodyProfile: BodyProfile,
        resolvedBodyProfile: BodyProfile
    ) -> BodyProfileAvailability {
        if resolvedBodyProfile.isComplete {
            return .ready
        }

        switch authorizationStatus {
        case .notDetermined:
            return .needsPermission
        case .sharingDenied:
            return .permissionDenied
        case .sharingAuthorized:
            if healthKitBodyProfile.isEmpty {
                return .noData
            }
            return .incomplete
        }
    }
}
