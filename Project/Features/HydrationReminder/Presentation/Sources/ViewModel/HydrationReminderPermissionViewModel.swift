//
//  HydrationReminderPermissionViewModel.swift
//  HydrationReminder
//
//  Created by Claude on 7/25/26.
//

import CoreDomain
import Foundation
import HydrationReminderDomain
import Localization
import Observation

@Observable
@MainActor
public final class HydrationReminderPermissionViewModel {
    private enum Constant {
        static let analyticsSource = "hydration_reminder_priming"
    }

    public private(set) var authorizationStatus: HydrationReminderAuthorizationStatus = .notDetermined
    public private(set) var isFinished: Bool
    public private(set) var isPrepared = false
    public var isLoading = false
    public var errorMessage: String?

    private let hydrationReminderUseCase: HydrationReminderUseCase
    private let analyticsUseCase: AnalyticsUseCase
    private var didTrackPrimingViewed = false
    private var didSyncReminders = false

    public init(
        hydrationReminderUseCase: HydrationReminderUseCase,
        analyticsUseCase: AnalyticsUseCase = NoOpAnalyticsUseCase()
    ) {
        self.hydrationReminderUseCase = hydrationReminderUseCase
        self.analyticsUseCase = analyticsUseCase
        self.isFinished = hydrationReminderUseCase.hasSeenPermissionPriming()
    }

    public func prepareIfNeeded() async {
        authorizationStatus = await hydrationReminderUseCase.authorizationStatus()

        if isFinished || authorizationStatus != .notDetermined {
            finishPriming()
            isPrepared = true
            await syncRemindersIfNeeded()
            return
        }

        isPrepared = true

        if !didTrackPrimingViewed {
            analyticsUseCase.track(.hydrationReminderPrimingViewed(status: authorizationStatus))
            didTrackPrimingViewed = true
        }
    }

    public func requestPermission() async {
        isLoading = true
        errorMessage = nil
        analyticsUseCase.track(.hydrationReminderPermissionRequestTapped(status: authorizationStatus))

        do {
            authorizationStatus = try await hydrationReminderUseCase.requestAuthorizationAndSyncReminders()
        } catch {
            errorMessage = L10n.tr("hydrationReminderPrimingRequestFailureDescription")
            isLoading = false
            return
        }

        trackPermissionOutcome()
        didSyncReminders = true
        finishPriming()
        isLoading = false
    }

    public func skipPriming() {
        analyticsUseCase.track(.hydrationReminderPrimingSkipped(status: authorizationStatus))
        finishPriming()
    }

    public func markSignedOut() {
        errorMessage = nil
        isLoading = false
        isPrepared = false
        isFinished = hydrationReminderUseCase.hasSeenPermissionPriming()
    }

    private func finishPriming() {
        if !hydrationReminderUseCase.hasSeenPermissionPriming() {
            hydrationReminderUseCase.markPermissionPrimingSeen()
        }

        errorMessage = nil
        isFinished = true
    }

    private func syncRemindersIfNeeded() async {
        guard !didSyncReminders else {
            return
        }

        didSyncReminders = true
        await hydrationReminderUseCase.syncReminders()
    }

    private func trackPermissionOutcome() {
        switch authorizationStatus {
        case .authorized:
            analyticsUseCase.track(
                .hydrationReminderPermissionAuthorized(
                    source: Constant.analyticsSource,
                    status: authorizationStatus
                )
            )
        case .denied:
            analyticsUseCase.track(
                .hydrationReminderPermissionDenied(
                    source: Constant.analyticsSource,
                    status: authorizationStatus
                )
            )
        case .notDetermined:
            return
        }
    }
}
