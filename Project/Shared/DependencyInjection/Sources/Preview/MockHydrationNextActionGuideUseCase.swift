import DomainLayerInterface
import Foundation

public final class MockHydrationNextActionGuideUseCase: HydrationNextActionGuideUseCase, @unchecked Sendable {
    public var guideValue = HydrationNextActionGuide.make(
        currentIntakeML: 750,
        dailyGoalML: 2_000
    )

    public init() {}

    public func guide(referenceDate: Date, calendar: Calendar) async -> HydrationNextActionGuide {
        guideValue
    }
}
