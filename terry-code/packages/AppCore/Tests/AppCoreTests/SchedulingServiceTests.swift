import XCTest
@testable import AppCore

final class SchedulingServiceTests: XCTestCase {
    func testWeeklyRecurrenceGeneratesEvents() throws {
        let svc = SchedulingService()
        let cal = Calendar.current
        let start = cal.date(from: DateComponents(year: 2025, month: 1, day: 1))!
        let end = cal.date(from: DateComponents(year: 2025, month: 1, day: 29))!
        let sch = Schedule(
            taskId: UUID(),
            startDate: start,
            endDate: end,
            isFullDay: false,
            isRecurring: true,
            frequency: Frequency(type: .weekly, interval: 1),
            startTimeMinutes: 9 * 60,
            endTimeMinutes: 10 * 60
        )
        let events = svc.events(for: sch)
        XCTAssertEqual(events.count, 5, "Should create 5 weekly occurrences in Jan 2025")
        XCTAssertTrue(events.allSatisfy { !$0.isAllDay })
    }
}
