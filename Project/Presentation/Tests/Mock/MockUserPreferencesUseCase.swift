import DomainLayerInterface

final class MockUserPreferencesUseCase: UserPreferencesUseCase, @unchecked Sendable {
    var mainIconValue: MainIcon = .default
    var dailyWaterLimitValue: Double = 2000
    var manualBodyProfileValue: BodyProfile = .empty

    private(set) var getMainIconCallCount = 0
    private(set) var setMainIconCallCount = 0
    private(set) var getDailyWaterLimitCallCount = 0
    private(set) var setDailyWaterLimitCallCount = 0
    private(set) var getManualBodyProfileCallCount = 0
    private(set) var setManualBodyProfileCallCount = 0

    private(set) var capturedMainIcon: MainIcon?
    private(set) var capturedDailyWaterLimit: Double?
    private(set) var capturedManualBodyProfile: BodyProfile?

    func getMainIcon() -> MainIcon {
        getMainIconCallCount += 1
        return mainIconValue
    }

    func setMainIcon(_ icon: MainIcon) {
        setMainIconCallCount += 1
        capturedMainIcon = icon
        mainIconValue = icon
    }

    func getDailyWaterLimit() -> Double {
        getDailyWaterLimitCallCount += 1
        return dailyWaterLimitValue
    }

    func setDailyWaterLimit(_ limit: Double) {
        setDailyWaterLimitCallCount += 1
        capturedDailyWaterLimit = limit
        dailyWaterLimitValue = limit
    }

    func getManualBodyProfile() -> BodyProfile {
        getManualBodyProfileCallCount += 1
        return manualBodyProfileValue
    }

    func setManualBodyProfile(_ profile: BodyProfile) {
        setManualBodyProfileCallCount += 1
        capturedManualBodyProfile = profile
        manualBodyProfileValue = profile
    }
}
