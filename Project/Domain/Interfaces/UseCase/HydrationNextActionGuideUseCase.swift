import Foundation

public protocol HydrationNextActionGuideUseCase: Sendable {
    func guide(referenceDate: Date, calendar: Calendar) async -> HydrationNextActionGuide
}
