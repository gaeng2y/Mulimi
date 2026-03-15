import DomainLayerInterface
import Foundation
import Localization
import Observation

struct RoutineDetailRow: Identifiable, Equatable {
    let id: String
    let title: String
    let value: String
    let systemImage: String
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

    public private(set) var notificationStatus: RoutineNotificationAuthorizationStatus = .notDetermined
    public private(set) var routines: [HydrationRoutine] = []
    public var isEditorPresented = false
    public var isSaving = false
    public var errorMessage: String?
    var editorDraft = RoutineEditorDraft()

    public init(routineUseCase: RoutineUseCase) {
        self.routineUseCase = routineUseCase
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

    var detailRows: [RoutineDetailRow] {
        [
            RoutineDetailRow(
                id: "notificationStatus",
                title: L10n.tr("profileRoutineNotificationStatusTitle"),
                value: notificationStatus.displayName,
                systemImage: "bell.badge"
            ),
            RoutineDetailRow(
                id: "activeRoutineCount",
                title: L10n.tr("profileRoutineActiveCountTitle"),
                value: activeRoutineCountText,
                systemImage: "clock.badge"
            ),
            RoutineDetailRow(
                id: "time",
                title: L10n.tr("profileRoutineTimeTitle"),
                value: primaryRoutine?.timeText ?? L10n.tr("profileRoutineDetailEmptyValue"),
                systemImage: "clock"
            ),
            RoutineDetailRow(
                id: "repeat",
                title: L10n.tr("profileRoutineRepeatTitle"),
                value: primaryRoutine?.weekdayText ?? L10n.tr("profileRoutineDetailEmptyValue"),
                systemImage: "calendar"
            )
        ]
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

    public func load() async {
        notificationStatus = await routineUseCase.notificationAuthorizationStatus()
        routines = routineUseCase.fetchRoutines()
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
        editorDraft = RoutineEditorDraft()
        isEditorPresented = true
    }

    public func presentEditRoutine(_ routine: HydrationRoutine) {
        editorDraft = RoutineEditorDraft(routine: routine)
        isEditorPresented = true
    }

    public func dismissEditor() {
        isEditorPresented = false
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

        isSaving = true
        defer { isSaving = false }

        do {
            try await routineUseCase.saveRoutine(editorDraft.makeRoutine())
            await load()
            dismissEditor()
        } catch let error as RoutineError {
            await load()
            dismissEditor()
            switch error {
            case .permissionDenied:
                errorMessage = L10n.tr("profileRoutinePermissionDeniedError")
            }
        } catch {
            errorMessage = L10n.tr("profileRoutineSaveError")
        }
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

    private var activeRoutineCountText: String {
        if activeRoutineCount == 0 {
            return L10n.tr("profileRoutineActiveCountNoneValue")
        }

        return L10n.tr("profileRoutineCountFormat", activeRoutineCount)
    }

    private var primaryRoutine: HydrationRoutine? {
        routines.first(where: \.isEnabled) ?? routines.first
    }
}
