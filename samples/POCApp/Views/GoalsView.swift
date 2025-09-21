import SwiftUI
import AppCore

struct GoalsView: View {
    @EnvironmentObject var store: AppStore
    @State private var showingAdd = false
    @State private var name = ""
    @State private var desc = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.goals) { goal in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(goal.name).font(.headline)
                        if !goal.description.isEmpty {
                            Text(goal.description).font(.subheadline).foregroundStyle(.secondary)
                        }
                        let epics = store.epics(for: goal)
                        let tasks = store.tasks.filter { t in epics.contains { $0.id == t.epicId } }
                        HStack(spacing: 12) {
                            Label("\(epics.count) epics", systemImage: "rectangle.grid.2x2")
                            Label("\(tasks.count) tasks", systemImage: "checklist")
                        }.font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Goals")
            .toolbar {
                Button { showingAdd = true } label: { Image(systemName: "plus") }
            }
            .sheet(isPresented: $showingAdd) {
                NavigationStack {
                    Form {
                        TextField("Name", text: $name)
                        TextField("Description", text: $desc, axis: .vertical)
                    }
                    .navigationTitle("New Goal")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showingAdd = false; name = ""; desc = "" }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                store.addGoal(name: name, description: desc)
                                showingAdd = false; name = ""; desc = ""
                            }.disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
        }
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        GoalsView().environmentObject(AppStore())
    }
}
