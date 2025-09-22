import SwiftUI
import AppCore

struct ScheduleFormView: View {
    let task: AppCore.Task
    var onAdd: (Schedule) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var startDate: Date = Date()
    @State private var endDate: Date = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
    @State private var isFullDay: Bool = false
    @State private var isRecurring: Bool = false
    @State private var freqType: FrequencyType = .weekly
    @State private var freqInterval: Int = 1
    @State private var startTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
    @State private var endTime: Date = Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                Toggle("All day", isOn: $isFullDay)
                if !isFullDay {
                    DatePicker("Start time", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("End time", selection: $endTime, displayedComponents: .hourAndMinute)
                }
                Toggle("Recurring", isOn: $isRecurring)
                if isRecurring {
                    Picker("Every", selection: $freqInterval) {
                        ForEach(1..<13, id: \.self) { Text("\($0)").tag($0) }
                    }
                    Picker("Unit", selection: $freqType) {
                        ForEach(FrequencyType.allCases, id: \.self) { Text($0.rawValue.capitalized).tag($0) }
                    }
                    DatePicker("Until", selection: $endDate, displayedComponents: .date)
                }
                TextField("Notes", text: $notes, axis: .vertical)
            }
            .navigationTitle("New Schedule")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) { Button("Add") { add() } }
            }
        }
    }

    func add() {
        let startM = isFullDay ? nil : minutes(from: startTime)
        let endM = isFullDay ? nil : minutes(from: endTime)
        let freq = isRecurring ? Frequency(type: freqType, interval: freqInterval) : nil
        let schedule = Schedule(taskId: task.id, startDate: startDate, endDate: isRecurring ? endDate : nil, isFullDay: isFullDay, isRecurring: isRecurring, frequency: freq, startTimeMinutes: startM, endTimeMinutes: endM, notes: notes)
        onAdd(schedule)
        dismiss()
    }

    func minutes(from date: Date) -> Int {
        let comps = Calendar.current.dateComponents([.hour, .minute], from: date)
        return (comps.hour ?? 0) * 60 + (comps.minute ?? 0)
    }
}

struct ScheduleFormView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleFormView(task: AppStore().tasks.first!, onAdd: { _ in })
            .environmentObject(AppStore())
    }
}
