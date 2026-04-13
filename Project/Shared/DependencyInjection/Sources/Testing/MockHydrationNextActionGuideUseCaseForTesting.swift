import DomainLayerInterface
import Foundation

public final class MockHydrationNextActionGuideUseCaseForTesting: HydrationNextActionGuideUseCase, @unchecked Sendable {
    public var guideValue = HydrationNextActionGuide.make(
        currentIntakeML: 0,
        dailyGoalML: 2_000
    )

    public init() {}

    public func guide(referenceDate: Date, calendar: Calendar) async -> HydrationNextActionGuide {
        guideValue
    }
}
