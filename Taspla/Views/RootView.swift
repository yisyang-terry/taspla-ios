import SwiftUI

struct RootView: View {
    private enum Tab: Hashable { case values, goals, kanban, backlog, calendar, composer }
    @State private var selection: Tab = .values

    var body: some View {
        TabView(selection: $selection) {
            ValuesView()
                .tabItem { Label("Values", systemImage: "heart.fill") }
                .tag(Tab.values)

            GoalsView()
                .tabItem { Label("Goals", systemImage: "target") }
                .tag(Tab.goals)

            KanbanView()
                .tabItem { Label("Kanban", systemImage: "rectangle.grid.1x2") }
                .tag(Tab.kanban)

            BacklogView()
                .tabItem { Label("Backlog", systemImage: "tray") }
                .tag(Tab.backlog)

            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }
                .tag(Tab.calendar)

            TaskComposerView()
                .tabItem { Label("Composer", systemImage: "square.and.pencil") }
                .tag(Tab.composer)
        }
        .tabViewStyle(.automatic)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(AppStore())
    }
}
