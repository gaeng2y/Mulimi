import Foundation

public protocol HydrationComebackRepository: Sendable {
    func fetchLastHandledDate() -> Date?
    func saveLastHandledDate(_ date: Date)
}
