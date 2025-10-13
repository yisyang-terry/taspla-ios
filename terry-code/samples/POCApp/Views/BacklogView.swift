import SwiftUI
import AppCore

struct BacklogView: View {
    @EnvironmentObject var store: AppStore
    @State private var showingAdd = false
    @State private var name = ""
    @State private var desc = ""
    @State private var selectedValue: Value?

    var backlog: [AppCore.Task] { store.tasks.filter { $0.status == .backlog || $0.status == .open } }

    var body: some View {
        NavigationStack {
            List {
                ForEach(backlog) { task in
                    NavigationLink(value: task) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(task.name)
                                if let v = store.value(by: task.valueId) {
                                    Text(v.name).font(.caption).foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            StatusBadge(status: task.status)
                        }
                    }
                }
            }
            .navigationTitle("Backlog")
            .toolbar {
                Button { showingAdd = true } label: { Image(systemName: "plus") }
            }
            .navigationDestination(for: AppCore.Task.self) { task in
                TaskDetailView(task: task)
            }
            .sheet(isPresented: $showingAdd) {
                NavigationStack {
                    Form {
                        TextField("Task name", text: $name)
                        TextField("Description", text: $desc, axis: .vertical)
                        Picker("Value", selection: Binding(get: { selectedValue?.id }, set: { id in selectedValue = store.values.first { $0.id == id } })) {
                            Text("None").tag(UUID?.none)
                            ForEach(store.values) { v in Text(v.name).tag(UUID?.some(v.id)) }
                        }
                    }
                    .navigationTitle("New Task")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) { Button("Cancel") { showingAdd = false; reset() } }
                        ToolbarItem(placement: .confirmationAction) { Button("Add") { add(); showingAdd = false; reset() }.disabled(name.isEmpty) }
                    }
                }
            }
        }
    }

    func reset() { name = ""; desc = ""; selectedValue = nil }
    func add() { store.addTask(epicId: nil, valueId: selectedValue?.id, name: name, description: desc, points: 1) }
}

struct StatusBadge: View {
    let status: TaskStatus
    var body: some View {
        Text(statusLabel)
            .font(.caption2)
            .padding(.horizontal, 6).padding(.vertical, 3)
            .background(Capsule().fill(color.opacity(0.2)))
            .foregroundStyle(color)
    }
    var statusLabel: String {
        switch status { case .backlog: return "Backlog"; case .open: return "Open"; case .inProgress: return "Doing"; case .done: return "Done"; case .blocked: return "Blocked" }
    }
    var color: Color {
        switch status { case .backlog: return .gray; case .open: return .blue; case .inProgress: return .orange; case .done: return .green; case .blocked: return .red }
    }
}

struct BacklogView_Previews: PreviewProvider { static var previews: some View { BacklogView().environmentObject(AppStore()) } }
