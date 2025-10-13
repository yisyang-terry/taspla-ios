import Foundation

/// Convenience helpers for date calculations.
public enum DateHelpers {
    public static let calendar: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current
        return cal
    }()

    /// Start of day in the current calendar/time zone.
    public static func startOfDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    /// Returns `date` at `minutes` since start of that day.
    public static func applyingMinutes(_ minutes: Int, to date: Date) -> Date {
        let start = startOfDay(date)
        return calendar.date(byAdding: .minute, value: minutes, to: start) ?? date
    }

    /// Exclusive end-of-day boundary (start of following day).
    public static func endOfDay(_ date: Date) -> Date {
        let start = startOfDay(date)
        return calendar.date(byAdding: .day, value: 1, to: start) ?? date
    }
}
