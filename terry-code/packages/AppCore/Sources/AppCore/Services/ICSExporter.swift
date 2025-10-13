import Foundation

public struct ICSExporter: Sendable {
    public init() {}

    public func export(
        events: [Event],
        summary: (Event) -> String,
        description: (Event) -> String? = { $0.notes }
    ) -> String {
        var lines: [String] = []
        lines.append("BEGIN:VCALENDAR")
        lines.append("VERSION:2.0")
        lines.append("PRODID:-//ValuePath//AppCore//EN")
        lines.append("CALSCALE:GREGORIAN")
        lines.append("METHOD:PUBLISH")

        for ev in events {
            lines.append("BEGIN:VEVENT")
            lines.append("UID:\(ev.id.uuidString)@valuepath")
            lines.append("DTSTAMP:\(formatUTC(Date()))")
            if ev.isAllDay {
                let startStr = formatDate(ev.start)
                let endStr = formatDate(ev.end) // exclusive end date for all-day
                lines.append("DTSTART;VALUE=DATE:\(startStr)")
                lines.append("DTEND;VALUE=DATE:\(endStr)")
            } else {
                lines.append("DTSTART:\(formatUTC(ev.start))")
                lines.append("DTEND:\(formatUTC(ev.end))")
            }
            lines.append("SUMMARY:\(escape(summary(ev)))")
            if let desc = description(ev), !desc.isEmpty {
                lines.append("DESCRIPTION:\(escape(desc))")
            }
            lines.append("END:VEVENT")
        }

        lines.append("END:VCALENDAR")
        return lines.joined(separator: "\r\n") + "\r\n"
    }

    private func formatUTC(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.calendar = Calendar(identifier: .gregorian)
        fmt.timeZone = TimeZone(secondsFromGMT: 0)
        fmt.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        return fmt.string(from: date)
    }

    private func formatDate(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.calendar = Calendar(identifier: .gregorian)
        fmt.timeZone = TimeZone(secondsFromGMT: 0)
        fmt.dateFormat = "yyyyMMdd"
        return fmt.string(from: date)
    }

    private func escape(_ s: String) -> String {
        s
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: ";", with: "\\;")
            .replacingOccurrences(of: ",", with: "\\,")
            .replacingOccurrences(of: "\n", with: "\\n")
    }
}
