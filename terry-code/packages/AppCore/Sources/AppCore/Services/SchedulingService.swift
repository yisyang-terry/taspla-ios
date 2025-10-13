import Foundation

/// Generates calendar events from `Schedule` definitions.
/// - Note: This service intentionally keeps logic simple and predictable
///   for daily/weekly/monthly recurrences. Edge cases like DST shifts are
///   handled by `Calendar`.
public struct SchedulingService: Sendable {
    public init() {}

    /// Expand a single schedule into concrete events.
    /// - Parameters:
    ///   - schedule: The schedule to expand.
    ///   - interval: Optional filter window. If provided, only events that
    ///     intersect this window are returned.
    /// - Returns: Sorted events by start date.
    public func events(for schedule: Schedule, within interval: DateInterval? = nil) -> [Event] {
        var result: [Event] = []
        let cal = DateHelpers.calendar

        func makeEvent(on date: Date) -> Event? {
            if schedule.isFullDay {
                let start = DateHelpers.startOfDay(date)
                let end = DateHelpers.endOfDay(date)
                let ev = Event(
                    taskId: schedule.taskId,
                    scheduleId: schedule.id,
                    start: start,
                    end: end,
                    isAllDay: true,
                    notes: schedule.notes
                )
                return include(ev, in: interval) ? ev : nil
            } else {
                guard let startM = schedule.startTimeMinutes else { return nil }
                let endM = schedule.endTimeMinutes ?? (startM + 60)
                let start = DateHelpers.applyingMinutes(startM, to: date)
                var end = DateHelpers.applyingMinutes(endM, to: date)
                if end <= start {
                    end = cal.date(byAdding: .day, value: 1, to: end) ?? end
                }
                let ev = Event(
                    taskId: schedule.taskId,
                    scheduleId: schedule.id,
                    start: start,
                    end: end,
                    isAllDay: false,
                    notes: schedule.notes
                )
                return include(ev, in: interval) ? ev : nil
            }
        }

        if schedule.isRecurring, let freq = schedule.frequency, let until = schedule.endDate {
            // Guard against invalid ranges to avoid accidental infinite loops.
            guard schedule.startDate <= until else { return [] }

            var current = schedule.startDate
            // Conservative upper bound to prevent runaway generation for
            // extremely long ranges (e.g., years of daily events).
            var safetyCounter = 0
            let safetyLimit = 10000
            while current <= until, safetyCounter < safetyLimit {
                if let ev = makeEvent(on: current) {
                    result.append(ev)
                }
                current = advance(date: current, by: freq)
                safetyCounter += 1
            }
        } else {
            if let ev = makeEvent(on: schedule.startDate) { result.append(ev) }
        }

        return result
    }

    public func events(for schedules: [Schedule], within interval: DateInterval? = nil) -> [Event] {
        schedules.flatMap { events(for: $0, within: interval) }
            .sorted { $0.start < $1.start }
    }

    private func advance(date: Date, by frequency: Frequency) -> Date {
        let cal = DateHelpers.calendar
        switch frequency.type {
        case .daily:
            return cal.date(byAdding: .day, value: frequency.interval, to: date) ?? date
        case .weekly:
            return cal.date(byAdding: .weekOfYear, value: frequency.interval, to: date) ?? date
        case .monthly:
            return cal.date(byAdding: .month, value: frequency.interval, to: date) ?? date
        }
    }

    private func include(_ event: Event, in interval: DateInterval?) -> Bool {
        guard let interval else { return true }
        let evInterval = DateInterval(start: event.start, end: event.end)
        return evInterval.intersects(interval)
    }
}
