import DomainLayerInterface

final class MockUserPreferencesUseCase: UserPreferencesUseCase, @unchecked Sendable {
    var mainAppearanceValue: MainAppearance = .default
    var dailyWaterLimitValue: Double = 2000

    private(set) var getMainAppearanceCallCount = 0
    private(set) var setMainAppearanceCallCount = 0
    private(set) var getDailyWaterLimitCallCount = 0
    private(set) var setDailyWaterLimitCallCount = 0

    private(set) var capturedMainAppearance: MainAppearance?
    private(set) var capturedDailyWaterLimit: Double?

    func getMainAppearance() -> MainAppearance {
        getMainAppearanceCallCount += 1
        return mainAppearanceValue
    }

    func setMainAppearance(_ appearance: MainAppearance) {
        setMainAppearanceCallCount += 1
        capturedMainAppearance = appearance
        mainAppearanceValue = appearance
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
}
