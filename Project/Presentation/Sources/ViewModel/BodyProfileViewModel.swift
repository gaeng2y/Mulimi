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
    public enum AvailabilityState: Equatable {
        case ready
        case needsPermission
        case permissionDenied
        case noData
        case incomplete
    }

    public private(set) var authorizationStatus: HealthKitAuthorizationStatus
    public private(set) var resolvedBodyProfile: BodyProfile = .empty
    public private(set) var healthKitBodyProfile: BodyProfile = .empty
    public private(set) var manualBodyProfile: BodyProfile = .empty
    public private(set) var isLoading = false
    public private(set) var hasLoaded = false
    public var heightInput = ""
    public var weightInput = ""
    public var errorMessage: String?

    private let healthKitUseCase: HealthKitUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase

    public init(
        healthKitUseCase: HealthKitUseCase,
        userPreferencesUseCase: UserPreferencesUseCase
    ) {
        self.healthKitUseCase = healthKitUseCase
        self.userPreferencesUseCase = userPreferencesUseCase
        self.authorizationStatus = healthKitUseCase.authorisationStatus
    }

    public var availabilityState: AvailabilityState {
        if resolvedBodyProfile.isComplete {
            return .ready
        }

        switch authorizationStatus {
        case .notDetermined:
            return .needsPermission
        case .sharingDenied:
            return .permissionDenied
        case .sharingAuthorized:
            if healthKitBodyProfile.isEmpty && manualBodyProfile.isEmpty {
                return .noData
            }
            return .incomplete
        }
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

    public var manualSaveButtonTitle: String {
        manualBodyProfile.isEmpty
            ? L10n.tr("bodyProfileSaveManualTitle")
            : L10n.tr("bodyProfileSaveManualChangesTitle")
    }

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
        authorizationStatus = healthKitUseCase.authorisationStatus
        manualBodyProfile = userPreferencesUseCase.getManualBodyProfile()
        syncInputsFromManualProfile()
        errorMessage = nil

        if authorizationStatus == .sharingAuthorized {
            await refreshHealthKitBodyProfile()
        } else {
            healthKitBodyProfile = .empty
            updateResolvedProfile()
        }

        isLoading = false
    }

    public func requestHealthKitBodyProfile() async {
        isLoading = true
        errorMessage = nil

        if authorizationStatus == .notDetermined {
            do {
                try await healthKitUseCase.requestAuthorization()
            } catch {
                authorizationStatus = healthKitUseCase.authorisationStatus
                errorMessage = L10n.tr("bodyProfilePermissionRequestFailureDescription")
                updateResolvedProfile()
                isLoading = false
                return
            }
        }

        authorizationStatus = healthKitUseCase.authorisationStatus

        guard authorizationStatus == .sharingAuthorized else {
            errorMessage = L10n.tr("bodyProfilePermissionDeniedDescription")
            updateResolvedProfile()
            isLoading = false
            return
        }

        await refreshHealthKitBodyProfile()
        isLoading = false
    }

    public func saveManualBodyProfile() {
        let height = parseInput(heightInput)
        let weight = parseInput(weightInput)

        guard height.isValid, weight.isValid else {
            errorMessage = L10n.tr("bodyProfileManualInputValidationDescription")
            return
        }

        let profile = BodyProfile(
            heightCM: height.value.map { BodyProfileValue(value: $0, source: .manual) },
            weightKG: weight.value.map { BodyProfileValue(value: $0, source: .manual) }
        )

        userPreferencesUseCase.setManualBodyProfile(profile)
        manualBodyProfile = userPreferencesUseCase.getManualBodyProfile()
        syncInputsFromManualProfile()
        updateResolvedProfile()
        errorMessage = nil
    }

    private func refreshHealthKitBodyProfile() async {
        do {
            healthKitBodyProfile = try await healthKitUseCase.fetchBodyProfile()
        } catch {
            healthKitBodyProfile = .empty
            errorMessage = L10n.tr("bodyProfileHealthSyncFailureDescription")
        }

        updateResolvedProfile()
    }

    private func updateResolvedProfile() {
        resolvedBodyProfile = manualBodyProfile.merging(preferred: healthKitBodyProfile)
    }

    private func syncInputsFromManualProfile() {
        heightInput = manualBodyProfile.heightCM.map { Self.inputText(for: $0.value) } ?? ""
        weightInput = manualBodyProfile.weightKG.map { Self.inputText(for: $0.value) } ?? ""
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

    private func parseInput(_ value: String) -> (value: Double?, isValid: Bool) {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return (nil, true)
        }

        guard let number = Double(trimmed), number > 0 else {
            return (nil, false)
        }

        return (number, true)
    }

    private static func inputText(for value: Double) -> String {
        if value.rounded(.towardZero) == value {
            return String(Int(value))
        }

        return String(value)
    }
}
