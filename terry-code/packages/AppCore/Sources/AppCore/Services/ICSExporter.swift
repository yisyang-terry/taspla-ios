import Foundation

/// Exports events to iCalendar (ICS) format.
///
/// Conforms to RFC 5545 basics. Lines are conservatively folded at 73
/// characters to stay under the 75-octet limit once CRLF and UTF-8 are
/// considered.
public struct ICSExporter: Sendable {
    public init() {}

    /// Render a set of events as an ICS vCalendar string.
    /// - Parameters:
    ///   - events: Events to export (order is preserved as given).
    ///   - summary: Closure that returns the SUMMARY for each event.
    ///   - description: Optional closure for DESCRIPTION; defaults to notes.
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
            lines += fold("SUMMARY:\(escape(summary(ev)))")
            if let desc = description(ev), !desc.isEmpty {
                lines += fold("DESCRIPTION:\(escape(desc))")
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

    // RFC 5545 section 3.1: Lines should be folded to 75 octets.
    // We conservatively fold at 73 UTF-16 scalar characters.
    private func fold(_ line: String, limit: Int = 73) -> [String] {
        guard line.count > limit else { return [line] }
        var result: [String] = []
        var start = line.startIndex
        while start < line.endIndex {
            let end = line.index(start, offsetBy: limit, limitedBy: line.endIndex) ?? line.endIndex
            result.append(String(line[start..<end]))
            start = end
            if start < line.endIndex {
                // Prepend a single space to continuation lines
                let remaining = String(line[start...])
                if remaining.count <= limit {
                    result.append(" " + remaining)
                    break
                } else {
                    result.append(" " + String(remaining.prefix(limit)))
                    start = line.index(start, offsetBy: limit, limitedBy: line.endIndex) ?? line.endIndex
                }
            }
        }
        return result
    }
}
