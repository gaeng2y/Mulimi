import DomainLayerInterface
import Foundation
import Localization
import Observation

struct RoutineGuidanceSummary: Equatable {
    let badgeText: String
    let headline: String
    let description: String
    let footnote: String
    let recommendedValueText: String?
    let actualValueText: String?
}

enum RoutinePermissionPrompt: String, Identifiable, Equatable {
    case requestAuthorization
    case openSettings

    var id: String { rawValue }
}

struct RoutinePermissionGuidance: Equatable {
    let title: String
    let description: String
    let showsOpenSettingsAction: Bool
}

struct RoutineEditorDraft: Equatable {
    var id: UUID?
    var title: String
    var time: Date
    var selectedWeekdays: Set<RoutineWeekday>
    var isEnabled: Bool

    init(
        id: UUID? = nil,
        title: String = "",
        time: Date = RoutineEditorDraft.defaultTime(),
        selectedWeekdays: Set<RoutineWeekday> = [.monday, .tuesday, .wednesday, .thursday, .friday],
        isEnabled: Bool = true
    ) {
        self.id = id
        self.title = title
        self.time = time
        self.selectedWeekdays = selectedWeekdays
        self.isEnabled = isEnabled
    }

    init(routine: HydrationRoutine) {
        self.id = routine.id
        self.title = routine.title
        self.time = Self.date(hour: routine.hour, minute: routine.minute)
        self.selectedWeekdays = Set(routine.weekdays)
        self.isEnabled = routine.isEnabled
    }

    var isEditing: Bool {
        id != nil
    }

    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !selectedWeekdays.isEmpty
    }

    func makeRoutine() -> HydrationRoutine {
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        return HydrationRoutine(
            id: id ?? UUID(),
            title: title,
            hour: components.hour ?? 9,
            minute: components.minute ?? 0,
            weekdays: Array(selectedWeekdays),
            isEnabled: isEnabled
        )
    }

    private static func defaultTime() -> Date {
        date(hour: 9, minute: 0)
    }

    private static func date(hour: Int, minute: Int) -> Date {
        Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) ?? .now
    }
}

@MainActor
@Observable
public final class ProfileRoutineViewModel {
    private let routineUseCase: RoutineUseCase
    private let drinkWaterUseCase: DrinkWaterUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase
    private let calendar: Calendar
    private let nowProvider: @Sendable () -> Date

    public private(set) var notificationStatus: RoutineNotificationAuthorizationStatus = .notDetermined
    public private(set) var routines: [HydrationRoutine] = []
    public private(set) var currentWaterCount = 0
    public private(set) var dailyWaterLimitML = 0
    public var isEditorPresented = false
    public var isSaving = false
    public var errorMessage: String?
    var permissionPrompt: RoutinePermissionPrompt?
    var editorDraft = RoutineEditorDraft()

    public init(
        routineUseCase: RoutineUseCase,
        drinkWaterUseCase: DrinkWaterUseCase,
        userPreferencesUseCase: UserPreferencesUseCase,
        calendar: Calendar = .current,
        nowProvider: @escaping @Sendable () -> Date = { .now }
    ) {
        self.routineUseCase = routineUseCase
        self.drinkWaterUseCase = drinkWaterUseCase
        self.userPreferencesUseCase = userPreferencesUseCase
        self.calendar = calendar
        self.nowProvider = nowProvider
        self.dailyWaterLimitML = Int(userPreferencesUseCase.getDailyWaterLimit().rounded())
    }

    public var hasConfiguredRoutine: Bool {
        !routines.isEmpty
    }

    public var activeRoutineCount: Int {
        routines.filter(\.isEnabled).count
    }

    public var summaryBadgeText: String {
        if hasConfiguredRoutine {
            return L10n.tr("profileRoutineStatusActiveCountFormat", activeRoutineCount)
        }

        return L10n.tr("profileRoutineStatusEmptyBadge")
    }

    public var summaryHeadline: String {
        if hasConfiguredRoutine {
            return L10n.tr("profileRoutineConfiguredHeadline")
        }

        return L10n.tr("profileRoutineEmptyHeadline")
    }

    public var summaryDescription: String {
        guard let primaryRoutine else {
            return L10n.tr("profileRoutineEmptyDescription")
        }

        return "\(primaryRoutine.timeText) · \(primaryRoutine.weekdayText)"
    }

    var displayedRoutines: [HydrationRoutine] {
        routines
    }

    var canSaveDraft: Bool {
        editorDraft.canSave
    }

    var isEditingDraft: Bool {
        editorDraft.isEditing
    }

    var editorPermissionGuidance: RoutinePermissionGuidance? {
        guard editorDraft.isEnabled else {
            return nil
        }

        switch notificationStatus {
        case .authorized:
            return RoutinePermissionGuidance(
                title: L10n.tr("profileRoutineEditorPermissionAuthorizedTitle"),
                description: L10n.tr("profileRoutineEditorPermissionAuthorizedDescription"),
                showsOpenSettingsAction: false
            )
        case .notDetermined:
            return RoutinePermissionGuidance(
                title: L10n.tr("profileRoutineEditorPermissionPendingTitle"),
                description: L10n.tr("profileRoutineEditorPermissionPendingDescription"),
                showsOpenSettingsAction: false
            )
        case .denied:
            return RoutinePermissionGuidance(
                title: L10n.tr("profileRoutineEditorPermissionDeniedTitle"),
                description: L10n.tr("profileRoutineEditorPermissionDeniedDescription"),
                showsOpenSettingsAction: true
            )
        }
    }

    var permissionPromptTitle: String {
        switch permissionPrompt {
        case .requestAuthorization:
            return L10n.tr("profileRoutinePermissionRequestAlertTitle")
        case .openSettings:
            return L10n.tr("profileRoutinePermissionDeniedAlertTitle")
        case .none:
            return ""
        }
    }

    var permissionPromptMessage: String {
        switch permissionPrompt {
        case .requestAuthorization:
            return L10n.tr("profileRoutinePermissionRequestAlertMessage")
        case .openSettings:
            return L10n.tr("profileRoutinePermissionDeniedAlertMessage")
        case .none:
            return ""
        }
    }

    var guidanceSummary: RoutineGuidanceSummary {
        let todayRoutines = todayActiveRoutines

        guard !todayRoutines.isEmpty else {
            return RoutineGuidanceSummary(
                badgeText: L10n.tr("profileRoutineGuidanceNoScheduleBadge"),
                headline: L10n.tr("profileRoutineGuidanceNoScheduleHeadline"),
                description: L10n.tr("profileRoutineGuidanceNoScheduleDescription"),
                footnote: L10n.tr("profileRoutineGuidanceNoScheduleFootnote"),
                recommendedValueText: nil,
                actualValueText: nil
            )
        }

        let elapsedCount = elapsedRoutineCount(for: todayRoutines)
        let actualIntakeML = currentWaterCount * 250
        let recommendedIntakeML = recommendedIntakeML(
            elapsedCount: elapsedCount,
            totalCount: todayRoutines.count
        )

        return RoutineGuidanceSummary(
            badgeText: L10n.tr(
                "profileRoutineGuidanceProgressFormat",
                Int(routineProgressPercentage(elapsedCount: elapsedCount, totalCount: todayRoutines.count).rounded())
            ),
            headline: guidanceHeadline(
                elapsedCount: elapsedCount,
                recommendedIntakeML: recommendedIntakeML,
                actualIntakeML: actualIntakeML
            ),
            description: L10n.tr(
                "profileRoutineGuidanceDescriptionFormat",
                L10n.tr("commonMilliliterFormat", recommendedIntakeML),
                L10n.tr("commonMilliliterFormat", actualIntakeML)
            ),
            footnote: L10n.tr("profileRoutineGuidanceFootnoteFormat", todayRoutines.count, elapsedCount),
            recommendedValueText: L10n.tr("commonMilliliterFormat", recommendedIntakeML),
            actualValueText: L10n.tr("commonMilliliterFormat", actualIntakeML)
        )
    }

    public func load() async {
        notificationStatus = await routineUseCase.notificationAuthorizationStatus()
        routines = routineUseCase.fetchRoutines()
        currentWaterCount = await drinkWaterUseCase.currentWater
        dailyWaterLimitML = Int(userPreferencesUseCase.getDailyWaterLimit().rounded())
    }

    public func refreshAuthorizationStatus() async {
        notificationStatus = await routineUseCase.notificationAuthorizationStatus()
    }

    public func requestNotificationAuthorization() async {
        do {
            notificationStatus = try await routineUseCase.requestNotificationAuthorization()
        } catch {
            errorMessage = L10n.tr("profileRoutineAuthorizationRequestError")
        }
    }

    public func presentCreateRoutine() {
        permissionPrompt = nil
        editorDraft = RoutineEditorDraft()
        isEditorPresented = true
    }

    public func presentEditRoutine(_ routine: HydrationRoutine) {
        permissionPrompt = nil
        editorDraft = RoutineEditorDraft(routine: routine)
        isEditorPresented = true
    }

    public func dismissEditor() {
        isEditorPresented = false
        permissionPrompt = nil
        editorDraft = RoutineEditorDraft()
    }

    public func toggleWeekday(_ weekday: RoutineWeekday) {
        if editorDraft.selectedWeekdays.contains(weekday) {
            editorDraft.selectedWeekdays.remove(weekday)
        } else {
            editorDraft.selectedWeekdays.insert(weekday)
        }
    }

    public func saveDraft() async {
        guard canSaveDraft else {
            errorMessage = L10n.tr("profileRoutineValidationError")
            return
        }

        permissionPrompt = nil
        let routine = editorDraft.makeRoutine()

        guard routine.isEnabled else {
            await persistDraft(routine)
            return
        }

        notificationStatus = await routineUseCase.notificationAuthorizationStatus()

        switch notificationStatus {
        case .authorized:
            await persistDraft(routine)
        case .notDetermined:
            permissionPrompt = .requestAuthorization
        case .denied:
            permissionPrompt = .openSettings
        }
    }

    public func requestDraftNotificationAuthorization() async {
        do {
            notificationStatus = try await routineUseCase.requestNotificationAuthorization()

            switch notificationStatus {
            case .authorized:
                permissionPrompt = nil
                await persistDraft(editorDraft.makeRoutine())
            case .notDetermined, .denied:
                permissionPrompt = .openSettings
            }
        } catch {
            errorMessage = L10n.tr("profileRoutineAuthorizationRequestError")
        }
    }

    public func saveDraftWithoutNotifications() async {
        var routine = editorDraft.makeRoutine()
        routine.isEnabled = false
        permissionPrompt = nil
        await persistDraft(routine)
    }

    public func dismissPermissionPrompt() {
        permissionPrompt = nil
    }

    public func deleteRoutine(_ routine: HydrationRoutine) async {
        do {
            try await routineUseCase.deleteRoutine(id: routine.id)
            await load()
        } catch {
            errorMessage = L10n.tr("profileRoutineDeleteError")
        }
    }

    public func clearErrorMessage() {
        errorMessage = nil
    }

    private func persistDraft(_ routine: HydrationRoutine) async {
        isSaving = true
        defer { isSaving = false }

        do {
            try await routineUseCase.saveRoutine(routine)
            await load()
            dismissEditor()
        } catch let error as RoutineError {
            switch error {
            case .permissionDenied:
                notificationStatus = await routineUseCase.notificationAuthorizationStatus()
                permissionPrompt = .openSettings
            }
        } catch {
            errorMessage = L10n.tr("profileRoutineSaveError")
        }
    }
    private var primaryRoutine: HydrationRoutine? {
        routines.first(where: \.isEnabled) ?? routines.first
    }

    private var todayActiveRoutines: [HydrationRoutine] {
        guard let weekday = RoutineWeekday(rawValue: calendar.component(.weekday, from: nowProvider())) else {
            return []
        }

        return routines
            .filter { $0.isEnabled && $0.weekdays.contains(weekday) }
            .sorted {
                if $0.hour == $1.hour {
                    return $0.minute < $1.minute
                }

                return $0.hour < $1.hour
            }
    }

    private func elapsedRoutineCount(for routines: [HydrationRoutine]) -> Int {
        let now = nowProvider()
        let currentMinutes = minuteOfDay(for: now)

        return routines.filter { routine in
            minuteOfDay(hour: routine.hour, minute: routine.minute) <= currentMinutes
        }
        .count
    }

    private func recommendedIntakeML(elapsedCount: Int, totalCount: Int) -> Int {
        guard totalCount > 0 else {
            return 0
        }

        return Int((Double(dailyWaterLimitML) * Double(elapsedCount) / Double(totalCount)).rounded())
    }

    private func routineProgressPercentage(elapsedCount: Int, totalCount: Int) -> Double {
        guard totalCount > 0 else {
            return 0
        }

        return Double(elapsedCount) / Double(totalCount) * 100
    }

    private func guidanceHeadline(
        elapsedCount: Int,
        recommendedIntakeML: Int,
        actualIntakeML: Int
    ) -> String {
        if elapsedCount == 0 {
            return L10n.tr("profileRoutineGuidanceBeforeStartHeadline")
        }

        if actualIntakeML == recommendedIntakeML {
            return L10n.tr("profileRoutineGuidanceOnTrackHeadline")
        }

        let gap = abs(actualIntakeML - recommendedIntakeML)
        let gapText = L10n.tr("commonMilliliterFormat", gap)

        if actualIntakeML < recommendedIntakeML {
            return L10n.tr("profileRoutineGuidanceBehindHeadlineFormat", gapText)
        }

        return L10n.tr("profileRoutineGuidanceAheadHeadlineFormat", gapText)
    }

    private func minuteOfDay(for date: Date) -> Int {
        let components = calendar.dateComponents([.hour, .minute], from: date)
        return minuteOfDay(hour: components.hour ?? 0, minute: components.minute ?? 0)
    }

    private func minuteOfDay(hour: Int, minute: Int) -> Int {
        hour * 60 + minute
    }
}
