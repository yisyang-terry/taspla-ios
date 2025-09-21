import SwiftUI
import AppCore

struct CalendarView: View {
    @EnvironmentObject var store: AppStore
    @State private var activeOnly = true
    @State private var shareICS = false

    var interval: DateInterval {
        let start = Date()
        let end = Calendar.current.date(byAdding: .day, value: 30, to: start)!
        return DateInterval(start: start, end: end)
    }

    var filteredEvents: [AppCore.Event] {
        let events = store.events(in: interval)
        if !activeOnly { return events }
        let activeTaskIds = Set(store.tasks.filter { [.open, .inProgress].contains($0.status) }.map { $0.id })
        return events.filter { activeTaskIds.contains($0.taskId) }
    }

    var groupedByDay: [(Date, [AppCore.Event])] {
        let cal = Calendar.current
        let groups = Dictionary(grouping: filteredEvents) { cal.startOfDay(for: $0.start) }
        return groups.keys.sorted().map { ($0, groups[$0]!.sorted { $0.start < $1.start }) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedByDay, id: \.0) { day, events in
                    Section(header: Text(day, style: .date)) {
                        ForEach(events) { ev in
                            HStack {
                                if ev.isAllDay { Text("All day").font(.caption).frame(width: 64) }
                                else { Text(timeRange(ev)).font(.caption).frame(width: 64, alignment: .leading) }
                                Text(taskName(for: ev)).font(.body)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Toggle(isOn: $activeOnly) { Text("Active only") }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { shareICS = true } label: { Image(systemName: "square.and.arrow.up") }
                }
            }
            .sheet(isPresented: $shareICS) {
                ICSSheet(events: filteredEvents, title: "ValuePath Events")
            }
        }
    }

    func taskName(for event: AppCore.Event) -> String {
        store.tasks.first(where: { $0.id == event.taskId })?.name ?? "Task"
    }

    func timeRange(_ ev: AppCore.Event) -> String {
        let df = DateFormatter(); df.timeStyle = .short; df.dateStyle = .none
        return "\(df.string(from: ev.start))–\(df.string(from: ev.end))"
    }
}

struct CalendarView_Previews: PreviewProvider { static var previews: some View { CalendarView().environmentObject(AppStore()) } }
