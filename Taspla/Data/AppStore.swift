import Foundation
import AppCore
import SwiftUI
internal import Combine

@MainActor
final class AppStore: ObservableObject {
    @Published var values: [Value] = []
    @Published var goals: [Goal] = []
    @Published var epics: [Epic] = []
    @Published var tasks: [Task] = []
    @Published var schedules: [Schedule] = []

    private let scheduler = SchedulingService()

    init() {
        seed()
    }

    func seed() {
        let health = Value(name: "Health", description: "Energy and longevity")
        let growth = Value(name: "Growth", description: "Learning and mastery")
        values = [health, growth]

        let g1 = Goal(name: "Run a 10k")
        goals = [g1]

        let e1 = Epic(goalId: g1.id, name: "Base building")
        epics = [e1]

        let t1 = Task(epicId: e1.id, valueId: health.id, name: "Morning run", description: "5km easy", status: .open, valuePoints: 3)
        let t2 = Task(epicId: e1.id, valueId: growth.id, name: "Cross-training", description: "Mobility", status: .backlog, valuePoints: 1)
        tasks = [t1, t2]

        let start = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let end = Calendar.current.date(byAdding: .month, value: 1, to: start)!
        let sch1 = Schedule(
            taskId: t1.id,
            startDate: start,
            endDate: end,
            isFullDay: false,
            isRecurring: true,
            frequency: Frequency(type: .weekly, interval: 1),
            startTimeMinutes: 7 * 60,
            endTimeMinutes: 7 * 60 + 45,
            notes: "Easy day"
        )
        schedules = [sch1]
    }

    func addValue(name: String, description: String) {
        values.append(Value(name: name, description: description))
    }

    func addGoal(name: String, description: String) {
        goals.append(Goal(name: name, description: description))
    }

    func addEpic(goalId: UUID, name: String, description: String) {
        epics.append(Epic(goalId: goalId, name: name, description: description))
    }

    func addTask(epicId: UUID?, valueId: UUID?, name: String, description: String, points: Int) {
        tasks.append(Task(epicId: epicId, valueId: valueId, name: name, description: description, status: .backlog, valuePoints: points))
    }

    func addSchedule(_ schedule: Schedule) {
        schedules.append(schedule)
    }

    func events(in interval: DateInterval? = nil) -> [Event] {
        scheduler.events(for: schedules, within: interval)
    }

    func tasks(for epic: Epic?) -> [Task] {
        tasks.filter { $0.epicId == epic?.id }
    }

    func epics(for goal: Goal) -> [Epic] {
        epics.filter { $0.goalId == goal.id }
    }

    func value(by id: UUID?) -> Value? { values.first { $0.id == id } }

    func updateTask(_ task: Task) {
        if let idx = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[idx] = task
        }
    }
}
