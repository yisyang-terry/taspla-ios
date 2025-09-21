import Foundation

public struct SchedulingService: Sendable {
    public init() {}

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
            var current = schedule.startDate
            while current <= until {
                if let ev = makeEvent(on: current) {
                    result.append(ev)
                }
                current = advance(date: current, by: freq)
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
