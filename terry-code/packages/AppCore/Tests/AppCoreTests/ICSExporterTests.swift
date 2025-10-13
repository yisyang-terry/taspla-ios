import XCTest
@testable import AppCore

final class ICSExporterTests: XCTestCase {
    func testBasicVCALENDARAndEvent() throws {
        let exporter = ICSExporter()
        let start = Date(timeIntervalSince1970: 0)
        let end = Date(timeIntervalSince1970: 3600)
        let ev = Event(taskId: UUID(), start: start, end: end, isAllDay: false)
        let ics = exporter.export(events: [ev], summary: { _ in "Test" })
        XCTAssertTrue(ics.contains("BEGIN:VCALENDAR"))
        XCTAssertTrue(ics.contains("END:VCALENDAR"))
        XCTAssertTrue(ics.contains("BEGIN:VEVENT"))
        XCTAssertTrue(ics.contains("END:VEVENT"))
        XCTAssertTrue(ics.contains("SUMMARY:Test"))
    }

    func testLineFolding() throws {
        let exporter = ICSExporter()
        let start = Date(timeIntervalSince1970: 0)
        let end = Date(timeIntervalSince1970: 3600)
        let ev = Event(taskId: UUID(), start: start, end: end, isAllDay: false)
        let longSummary = String(repeating: "A", count: 120)
        let ics = exporter.export(events: [ev], summary: { _ in longSummary })
        // Look for a folded line continuation (CRLF + space)
        XCTAssertTrue(ics.contains("SUMMARY:"))
        XCTAssertTrue(ics.contains("\r\n "))
    }
}

