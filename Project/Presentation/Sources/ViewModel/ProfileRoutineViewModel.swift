import DomainLayerInterface
import Foundation
import Localization
import Observation

enum RoutineGuidanceTone: Equatable {
    case neutral
    case onTrack
    case behind
    case ahead
}

struct RoutineGuidanceMetric: Identifiable, Equatable {
    let id: String
    let title: String
    let value: String
    let detail: String
    let tone: RoutineGuidanceTone
}

enum RoutineGuidanceSlotStatus: Equatable {
    case elapsed
    case next
    case upcoming
}

struct RoutineGuidanceSlot: Identifiable, Equatable {
    let id: UUID
    let title: String
    let timeText: String
    let status: RoutineGuidanceSlotStatus
}

struct RoutineGuidanceSummary: Equatable {
    let badgeText: String
    let headline: String
    let description: String
    let footnote: String
    let tone: RoutineGuidanceTone
    let metrics: [RoutineGuidanceMetric]
    let nextRoutineValueText: String?
    let remainingRoutineValueText: String?
    let slots: [RoutineGuidanceSlot]
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

struct RoutineRecommendationCard: Identifiable, Equatable {
    let id: String
    let title: String
    let description: String
    let timeText: String
    let weekdayText: String
    let applyButtonTitle: String
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

    init(recommendation: HydrationRoutineRecommendation, title: String) {
        self.id = nil
        self.title = title
        self.time = Self.date(hour: recommendation.hour, minute: recommendation.minute)
        self.selectedWeekdays = Set(recommendation.weekdays)
        self.isEnabled = true
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
    private let routineRecommendationUseCase: RoutineRecommendationUseCase
    private let drinkWaterUseCase: DrinkWaterUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase
    private let calendar: Calendar
    private let nowProvider: @Sendable () -> Date

    public private(set) var notificationStatus: RoutineNotificationAuthorizationStatus = .notDetermined
    public private(set) var routines: [HydrationRoutine] = []
    private var routineRecommendations: [HydrationRoutineRecommendation] = []
    public private(set) var currentWaterIntakeML = 0.0
    public private(set) var dailyWaterLimitML = 0
    public var isEditorPresented = false
    public var isSaving = false
    public var errorMessage: String?
    var permissionPrompt: RoutinePermissionPrompt?
    var editorDraft = RoutineEditorDraft()

    public init(
        routineUseCase: RoutineUseCase,
        routineRecommendationUseCase: RoutineRecommendationUseCase,
        drinkWaterUseCase: DrinkWaterUseCase,
        userPreferencesUseCase: UserPreferencesUseCase,
        calendar: Calendar = .current,
        nowProvider: @escaping @Sendable () -> Date = { .now }
    ) {
        self.routineUseCase = routineUseCase
        self.routineRecommendationUseCase = routineRecommendationUseCase
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

    var recommendationCards: [RoutineRecommendationCard] {
        routineRecommendations.map { recommendation in
            RoutineRecommendationCard(
                id: recommendation.id,
                title: recommendationTitle(for: recommendation.kind),
                description: recommendationDescription(for: recommendation.kind),
                timeText: recommendation.timeText,
                weekdayText: recommendation.weekdayText,
                applyButtonTitle: L10n.tr("profileRoutineRecommendationApplyTitle")
            )
        }
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
                tone: .neutral,
                metrics: [],
                nextRoutineValueText: nil,
                remainingRoutineValueText: nil,
                slots: []
            )
        }

        let elapsedCount = elapsedRoutineCount(for: todayRoutines)
        let nextRoutine = nextRoutine(for: todayRoutines)
        let remainingCount = remainingRoutineCount(for: todayRoutines)
        let actualIntakeML = Int(currentWaterIntakeML.rounded())
        let recommendedIntakeML = recommendedIntakeML(
            elapsedCount: elapsedCount,
            totalCount: todayRoutines.count
        )
        let tone = guidanceTone(
            elapsedCount: elapsedCount,
            recommendedIntakeML: recommendedIntakeML,
            actualIntakeML: actualIntakeML
        )
        let recommendedValueText = L10n.tr("commonMilliliterFormat", recommendedIntakeML)
        let actualValueText = L10n.tr("commonMilliliterFormat", actualIntakeML)
        let gapValueText = L10n.tr("commonMilliliterFormat", abs(actualIntakeML - recommendedIntakeML))

        return RoutineGuidanceSummary(
            badgeText: L10n.tr(
                "profileRoutineGuidanceProgressCountFormat",
                elapsedCount,
                todayRoutines.count
            ),
            headline: guidanceHeadline(
                elapsedCount: elapsedCount,
                recommendedIntakeML: recommendedIntakeML,
                actualIntakeML: actualIntakeML
            ),
            description: guidanceDescription(
                elapsedCount: elapsedCount,
                nextRoutine: nextRoutine,
                remainingCount: remainingCount
            ),
            footnote: L10n.tr(
                "profileRoutineGuidanceFootnoteDetailFormat",
                L10n.tr("commonMilliliterFormat", dailyWaterLimitML),
                todayRoutines.count
            ),
            tone: tone,
            metrics: [
                RoutineGuidanceMetric(
                    id: "recommended",
                    title: L10n.tr("profileRoutineGuidanceRecommendedTitle"),
                    value: recommendedValueText,
                    detail: L10n.tr("profileRoutineGuidanceRecommendedDetail"),
                    tone: .neutral
                ),
                RoutineGuidanceMetric(
                    id: "actual",
                    title: L10n.tr("profileRoutineGuidanceActualTitle"),
                    value: actualValueText,
                    detail: L10n.tr("profileRoutineGuidanceActualDetail"),
                    tone: .neutral
                ),
                RoutineGuidanceMetric(
                    id: "difference",
                    title: L10n.tr("profileRoutineGuidanceDifferenceTitle"),
                    value: gapValueText,
                    detail: differenceDetailText(
                        elapsedCount: elapsedCount,
                        tone: tone
                    ),
                    tone: tone
                )
            ],
            nextRoutineValueText: nextRoutine.map {
                L10n.tr("profileRoutineGuidanceNextRoutineValueFormat", $0.timeText, $0.title)
            } ?? L10n.tr("profileRoutineGuidanceNextRoutineDoneValue"),
            remainingRoutineValueText: L10n.tr("profileRoutineGuidanceRemainingCountFormat", remainingCount),
            slots: guidanceSlots(for: todayRoutines, nextRoutineID: nextRoutine?.id)
        )
    }

    public func load() async {
        notificationStatus = await routineUseCase.notificationAuthorizationStatus()
        routines = routineUseCase.fetchRoutines()
        routineRecommendations = await routineRecommendationUseCase.fetchRecommendations(
            referenceDate: nowProvider(),
            calendar: calendar
        )
        currentWaterIntakeML = await drinkWaterUseCase.currentWaterIntakeML
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

    public func presentEditRoutine(id routineID: UUID) {
        guard let routine = routines.first(where: { $0.id == routineID }) else {
            return
        }

        presentEditRoutine(routine)
    }

    public func presentRecommendation(id: String) {
        guard let recommendation = routineRecommendations.first(where: { $0.id == id }) else {
            return
        }

        permissionPrompt = nil
        editorDraft = RoutineEditorDraft(
            recommendation: recommendation,
            title: recommendationRoutineTitle(for: recommendation.kind)
        )
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

    private func recommendationTitle(for kind: HydrationRoutineRecommendationKind) -> String {
        switch kind {
        case .morningStart:
            return L10n.tr("profileRoutineRecommendationMorningTitle")
        case .afternoonGap:
            return L10n.tr("profileRoutineRecommendationAfternoonTitle")
        case .frequentHydrationWindow:
            return L10n.tr("profileRoutineRecommendationFrequentTitle")
        }
    }

    private func recommendationDescription(for kind: HydrationRoutineRecommendationKind) -> String {
        switch kind {
        case .morningStart:
            return L10n.tr("profileRoutineRecommendationMorningDescription")
        case .afternoonGap:
            return L10n.tr("profileRoutineRecommendationAfternoonDescription")
        case .frequentHydrationWindow:
            return L10n.tr("profileRoutineRecommendationFrequentDescription")
        }
    }

    private func recommendationRoutineTitle(for kind: HydrationRoutineRecommendationKind) -> String {
        switch kind {
        case .morningStart:
            return L10n.tr("profileRoutineRecommendationMorningRoutineName")
        case .afternoonGap:
            return L10n.tr("profileRoutineRecommendationAfternoonRoutineName")
        case .frequentHydrationWindow:
            return L10n.tr("profileRoutineRecommendationFrequentRoutineName")
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

    private func nextRoutine(for routines: [HydrationRoutine]) -> HydrationRoutine? {
        let currentMinutes = minuteOfDay(for: nowProvider())
        return routines.first { routine in
            minuteOfDay(hour: routine.hour, minute: routine.minute) > currentMinutes
        }
    }

    private func remainingRoutineCount(for routines: [HydrationRoutine]) -> Int {
        let currentMinutes = minuteOfDay(for: nowProvider())
        return routines.filter { routine in
            minuteOfDay(hour: routine.hour, minute: routine.minute) > currentMinutes
        }
        .count
    }

    private func recommendedIntakeML(elapsedCount: Int, totalCount: Int) -> Int {
        guard totalCount > 0 else {
            return 0
        }

        return Int((Double(dailyWaterLimitML) * Double(elapsedCount) / Double(totalCount)).rounded())
    }

    private func guidanceTone(
        elapsedCount: Int,
        recommendedIntakeML: Int,
        actualIntakeML: Int
    ) -> RoutineGuidanceTone {
        if elapsedCount == 0 {
            return .neutral
        }

        if actualIntakeML == recommendedIntakeML {
            return .onTrack
        }

        return actualIntakeML < recommendedIntakeML ? .behind : .ahead
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

    private func guidanceDescription(
        elapsedCount: Int,
        nextRoutine: HydrationRoutine?,
        remainingCount: Int
    ) -> String {
        if elapsedCount == 0, let nextRoutine {
            return L10n.tr(
                "profileRoutineGuidanceBeforeStartDescriptionFormat",
                L10n.tr("profileRoutineGuidanceNextRoutineValueFormat", nextRoutine.timeText, nextRoutine.title),
                remainingCount
            )
        }

        if let nextRoutine {
            return L10n.tr(
                "profileRoutineGuidanceUpcomingDescriptionFormat",
                L10n.tr("profileRoutineGuidanceNextRoutineValueFormat", nextRoutine.timeText, nextRoutine.title),
                remainingCount
            )
        }

        return L10n.tr("profileRoutineGuidanceCompletedDescription")
    }

    private func differenceDetailText(
        elapsedCount: Int,
        tone: RoutineGuidanceTone
    ) -> String {
        if elapsedCount == 0 {
            return L10n.tr("profileRoutineGuidanceDifferencePendingDetail")
        }

        switch tone {
        case .neutral, .onTrack:
            return L10n.tr("profileRoutineGuidanceDifferenceOnTrackDetail")
        case .behind:
            return L10n.tr("profileRoutineGuidanceDifferenceBehindDetail")
        case .ahead:
            return L10n.tr("profileRoutineGuidanceDifferenceAheadDetail")
        }
    }

    private func guidanceSlots(
        for routines: [HydrationRoutine],
        nextRoutineID: UUID?
    ) -> [RoutineGuidanceSlot] {
        routines.map { routine in
            let status: RoutineGuidanceSlotStatus
            if let nextRoutineID, routine.id == nextRoutineID {
                status = .next
            } else if nextRoutineID == nil || minuteOfDay(hour: routine.hour, minute: routine.minute) < minuteOfDay(for: nowProvider()) {
                status = .elapsed
            } else {
                status = .upcoming
            }

            return RoutineGuidanceSlot(
                id: routine.id,
                title: routine.title,
                timeText: routine.timeText,
                status: status
            )
        }
    }

    private func minuteOfDay(for date: Date) -> Int {
        let components = calendar.dateComponents([.hour, .minute], from: date)
        return minuteOfDay(hour: components.hour ?? 0, minute: components.minute ?? 0)
    }

    private func minuteOfDay(hour: Int, minute: Int) -> Int {
        hour * 60 + minute
    }
}
