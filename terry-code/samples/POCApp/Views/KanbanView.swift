import SwiftUI
import AppCore

struct KanbanView: View {
    @EnvironmentObject var store: AppStore

    let columns: [(TaskStatus, String)] = [(.open, "Open"), (.inProgress, "Doing"), (.done, "Done")]

    var body: some View {
        NavigationStack {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 16) {
                    ForEach(columns, id: \.0) { status, title in
                        KanbanColumn(title: title, tasks: store.tasks.filter { $0.status == status }) { task in
                            var t = task
                            t.status = nextStatus(from: status)
                            store.updateTask(t)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Kanban")
        }
    }

    func nextStatus(from status: TaskStatus) -> TaskStatus {
        switch status { case .open: return .inProgress; case .inProgress: return .done; case .done: return .open; default: return .open }
    }
}

struct KanbanColumn: View {
    let title: String
    let tasks: [AppCore.Task]
    var onTap: (AppCore.Task) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(tasks) { task in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.name)
                        if !task.description.isEmpty { Text(task.description).font(.caption).foregroundStyle(.secondary) }
                    }
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(.secondarySystemBackground)))
                    .onTapGesture { onTap(task) }
                }
            }
            .frame(maxWidth: 280)
        }
        .frame(width: 300)
    }
}

struct KanbanView_Previews: PreviewProvider { static var previews: some View { KanbanView().environmentObject(AppStore()) } }
