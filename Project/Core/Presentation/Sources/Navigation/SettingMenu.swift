public enum SettingMenu: String, CaseIterable, Hashable, Identifiable, Sendable {
    case bodyProfile
    case dailyLimit
    case mainIcon
    case withdrawal

    public var id: Self { self }
}
