import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            ValuesView()
                .tabItem { Label("Values", systemImage: "heart.fill") }

            GoalsView()
                .tabItem { Label("Goals", systemImage: "target") }

            KanbanView()
                .tabItem { Label("Kanban", systemImage: "rectangle.3.offgrid") }

            BacklogView()
                .tabItem { Label("Backlog", systemImage: "tray") }

            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }

            TaskComposerView()
                .tabItem { Label("Composer", systemImage: "square.and.pencil") }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(AppStore())
    }
}
