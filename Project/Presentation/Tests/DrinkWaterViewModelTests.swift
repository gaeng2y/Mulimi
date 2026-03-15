import DomainLayerInterface
import Foundation
import Localization
import Testing

@testable import PresentationLayer

@Suite("DrinkWaterViewModel Tests")
struct DrinkWaterViewModelTests {
    private enum MockError: Error {
        case failed
    }

    @MainActor
    @Test("초기화 시 legacy 마이그레이션과 초기 상태를 반영한다")
    func initializeState() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.currentWaterValue = 2
        let healthKitUseCase = MockHealthKitUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.mainAppearanceValue = .heart
        userPreferencesUseCase.dailyWaterLimitValue = 1500

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            healthKitUseCase: healthKitUseCase,
            userPreferencesUseCase: userPreferencesUseCase
        )

        await viewModel.loadInitialState()

        #expect(waterUseCase.migrateLegacyDataIfNeededCallCount == 1)
        #expect(viewModel.drinkWaterCount == 2)
        #expect(viewModel.mainAppearance == .heart)
        #expect(viewModel.dailyLimit == 1500)
        #expect(viewModel.currentWaterIntakeInMl == 500)
        #expect(viewModel.mililiters == L10n.tr("commonMilliliterFormat", 500))
        #expect(viewModel.isLimitReached == false)
    }

    @MainActor
    @Test("drinkWater는 제한 이하일 때 로컬/UseCase 상태를 모두 갱신한다")
    func drinkWaterWithinLimit() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.currentWaterValue = 0
        let healthKitUseCase = MockHealthKitUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            healthKitUseCase: healthKitUseCase,
            userPreferencesUseCase: userPreferencesUseCase
        )

        await viewModel.loadInitialState()
        await viewModel.drinkWater()

        #expect(viewModel.drinkWaterCount == 1)
        #expect(waterUseCase.drinkWaterCallCount == 1)
        #expect(healthKitUseCase.drinkWaterCallCount == 1)
    }

    @MainActor
    @Test("drinkWater는 제한을 초과하면 동작하지 않는다")
    func drinkWaterOverLimit() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.currentWaterValue = 4
        let healthKitUseCase = MockHealthKitUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            healthKitUseCase: healthKitUseCase,
            userPreferencesUseCase: userPreferencesUseCase
        )

        await viewModel.loadInitialState()
        await viewModel.drinkWater()

        #expect(viewModel.drinkWaterCount == 4)
        #expect(waterUseCase.drinkWaterCallCount == 0)
        #expect(healthKitUseCase.drinkWaterCallCount == 0)
    }

    @MainActor
    @Test("drinkWater는 HealthKit 실패가 있어도 로컬 카운트를 유지한다")
    func drinkWaterHandlesHealthKitError() async {
        let waterUseCase = MockDrinkWaterUseCase()
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.drinkWaterError = MockError.failed
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            healthKitUseCase: healthKitUseCase,
            userPreferencesUseCase: userPreferencesUseCase
        )

        await viewModel.loadInitialState()
        await viewModel.drinkWater()

        #expect(viewModel.drinkWaterCount == 1)
        #expect(waterUseCase.drinkWaterCallCount == 1)
        #expect(healthKitUseCase.drinkWaterCallCount == 1)
    }

    @MainActor
    @Test("reset은 카운트를 0으로 만들고 UseCase 리셋을 호출한다")
    func reset() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.currentWaterValue = 3
        let healthKitUseCase = MockHealthKitUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            healthKitUseCase: healthKitUseCase,
            userPreferencesUseCase: userPreferencesUseCase
        )

        await viewModel.loadInitialState()
        await viewModel.reset()

        #expect(viewModel.drinkWaterCount == 0)
        #expect(waterUseCase.resetCallCount == 1)
        #expect(healthKitUseCase.resetCallCount == 1)
    }

    @MainActor
    @Test("refreshState는 UseCase 최신값으로 상태를 갱신한다")
    func refreshState() async {
        let waterUseCase = MockDrinkWaterUseCase()
        let healthKitUseCase = MockHealthKitUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            healthKitUseCase: healthKitUseCase,
            userPreferencesUseCase: userPreferencesUseCase
        )

        await viewModel.loadInitialState()

        waterUseCase.currentWaterValue = 5
        userPreferencesUseCase.mainAppearanceValue = .cloud
        userPreferencesUseCase.dailyWaterLimitValue = 2300

        await viewModel.refreshState()

        #expect(viewModel.drinkWaterCount == 5)
        #expect(viewModel.mainAppearance == .cloud)
        #expect(viewModel.dailyLimit == 2300)
    }

    @MainActor
    @Test("startAnimation은 offset을 360으로 설정한다")
    func startAnimation() {
        let viewModel = DrinkWaterViewModel(
            waterUseCase: MockDrinkWaterUseCase(),
            healthKitUseCase: MockHealthKitUseCase(),
            userPreferencesUseCase: MockUserPreferencesUseCase()
        )

        viewModel.startAnimation()

        #expect(viewModel.offset == 360)
    }
}
