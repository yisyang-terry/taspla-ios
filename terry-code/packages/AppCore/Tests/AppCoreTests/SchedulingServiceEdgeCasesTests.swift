import XCTest
@testable import AppCore

final class SchedulingServiceEdgeCasesTests: XCTestCase {
    func testRecurringWithEndBeforeStartReturnsEmpty() throws {
        let svc = SchedulingService()
        let cal = Calendar.current
        let start = cal.date(from: DateComponents(year: 2025, month: 1, day: 10))!
        let end = cal.date(from: DateComponents(year: 2025, month: 1, day: 5))!
        let sch = Schedule(
            taskId: UUID(),
            startDate: start,
            endDate: end,
            isFullDay: false,
            isRecurring: true,
            frequency: Frequency(type: .daily, interval: 1),
            startTimeMinutes: 8 * 60,
            endTimeMinutes: 9 * 60
        )
        let events = svc.events(for: sch)
        XCTAssertEqual(events.count, 0)
    }

    func testAllDayEventBoundaries() throws {
        let svc = SchedulingService()
        let cal = Calendar.current
        let day = cal.date(from: DateComponents(year: 2025, month: 2, day: 1))!
        let sch = Schedule(
            taskId: UUID(),
            startDate: day,
            isFullDay: true,
            startTimeMinutes: nil,
            endTimeMinutes: nil
        )
        let events = svc.events(for: sch)
        XCTAssertEqual(events.count, 1)
        let ev = try XCTUnwrap(events.first)
        XCTAssertTrue(ev.isAllDay)
        // Expect exclusive end-of-day (start of following day)
        XCTAssertLessThan(ev.start, ev.end)
        XCTAssertEqual(Calendar.current.startOfDay(for: ev.start), day)
    }

    func testIntervalFilter() throws {
        let svc = SchedulingService()
        let cal = Calendar.current
        let start = cal.date(from: DateComponents(year: 2025, month: 3, day: 1))!
        let end = cal.date(from: DateComponents(year: 2025, month: 3, day: 31))!
        let sch = Schedule(
            taskId: UUID(),
            startDate: start,
            endDate: end,
            isFullDay: false,
            isRecurring: true,
            frequency: Frequency(type: .weekly, interval: 1),
            startTimeMinutes: 10 * 60,
            endTimeMinutes: 11 * 60
        )
        let window = DateInterval(
            start: cal.date(from: DateComponents(year: 2025, month: 3, day: 10))!,
            end: cal.date(from: DateComponents(year: 2025, month: 3, day: 20))!
        )
        let events = svc.events(for: sch, within: window)
        XCTAssertGreaterThan(events.count, 0)
        XCTAssertTrue(events.allSatisfy { window.intersects(DateInterval(start: $0.start, end: $0.end)) })
    }
}

