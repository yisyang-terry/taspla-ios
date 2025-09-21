import Foundation

public enum DateHelpers {
    public static let calendar: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone.current
        return cal
    }()

    public static func startOfDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    public static func applyingMinutes(_ minutes: Int, to date: Date) -> Date {
        let start = startOfDay(date)
        return calendar.date(byAdding: .minute, value: minutes, to: start) ?? date
    }

    public static func endOfDay(_ date: Date) -> Date {
        let start = startOfDay(date)
        return calendar.date(byAdding: .day, value: 1, to: start) ?? date
    }
}
