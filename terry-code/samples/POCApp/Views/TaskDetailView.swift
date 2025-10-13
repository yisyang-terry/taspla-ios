import SwiftUI
import AppCore

struct TaskDetailView: View {
    @EnvironmentObject var store: AppStore
    @State var task: AppCore.Task
    @State private var showingScheduleForm = false
    @State private var shareICS = false

    var body: some View {
        List {
            Section("Details") {
                Text(task.name).font(.headline)
                if !task.description.isEmpty { Text(task.description) }
                Picker("Status", selection: Binding(get: { task.status }, set: { task.status = $0; store.updateTask(task) })) {
                    ForEach(TaskStatus.allCases, id: \.self) { s in Text(String(describing: s.rawValue)).tag(s) }
                }
            }

            Section("Schedules") {
                let sForTask = store.schedules.filter { $0.taskId == task.id }
                if sForTask.isEmpty {
                    Text("No schedules yet")
                } else {
                    ForEach(sForTask, id: \.id) { sch in
                        VStack(alignment: .leading) {
                            Text(sch.isRecurring ? "Recurring" : "One-time")
                            Text(summary(of: sch)).font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                Button { showingScheduleForm = true } label: { Label("Add Schedule", systemImage: "calendar.badge.plus") }
            }

            Section("Export") {
                Button { shareICS = true } label: { Label("Share .ics for this task", systemImage: "square.and.arrow.up") }
            }
        }
        .navigationTitle("Task")
        .sheet(isPresented: $showingScheduleForm) {
            ScheduleFormView(task: task) { newSchedule in
                store.addSchedule(newSchedule)
            }
        }
        .sheet(isPresented: $shareICS) {
            ICSSheet(events: store.events().filter { $0.taskId == task.id }, title: task.name)
        }
    }

    func summary(of sch: Schedule) -> String {
        var parts: [String] = []
        if sch.isFullDay { parts.append("All day") }
        if sch.isRecurring, let f = sch.frequency { parts.append("Every \(f.interval) \(f.type.rawValue)") }
        let df = DateFormatter(); df.dateStyle = .medium; df.timeStyle = sch.isFullDay ? .none : .short
        if sch.isFullDay {
            parts.append(df.string(from: sch.startDate))
        } else {
            let start = DateHelpers.applyingMinutes(sch.startTimeMinutes ?? 0, to: sch.startDate)
            parts.append(df.string(from: start))
        }
        return parts.joined(separator: " • ")
    }
}

struct ICSSheet: View {
    let events: [AppCore.Event]
    let title: String
    var body: some View {
        let exporter = ICSExporter()
        let content = exporter.export(events: events, summary: { _ in title })
        ShareView(activityItems: [content.data(using: .utf8) ?? Data(), "\(title).ics"])
    }
}

struct ShareView: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct TaskDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { TaskDetailView(task: AppStore().tasks.first!) }.environmentObject(AppStore())
    }
}
