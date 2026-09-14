import Foundation
import Testing

@testable import HydrationDomain

struct HydrationStarterPlanTests {
    @Test("시작일 포함 7일이며 DST에도 자정에 날짜가 바뀐다", arguments: 0...7)
    func sevenCalendarDays(offset: Int) throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "America/Los_Angeles"))
        let start = try #require(calendar.date(from: DateComponents(year: 2026, month: 3, day: 7, hour: 23)))
        let date = offset == 0 ? start : try #require(calendar.date(
            byAdding: .day, value: offset, to: calendar.startOfDay(for: start)
        ))
        let plan = HydrationStarterPlan(startedAt: start)

        #expect(plan.dayNumber(on: date, calendar: calendar) == (offset < 7 ? offset + 1 : nil))
        #expect(plan.dayNumber(on: start.addingTimeInterval(-1), calendar: calendar) == nil)
    }
}
