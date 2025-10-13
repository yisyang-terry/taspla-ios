import Foundation

public protocol LLMService: Sendable {
    func suggestEpicsAndTasks(goal: Goal, primaryValues: [Value]) async -> [EpicSuggestion]
}

public struct EpicSuggestion: Sendable, Hashable {
    public var epicName: String
    public var epicDescription: String
    public var tasks: [TaskSuggestion]
    public init(epicName: String, epicDescription: String, tasks: [TaskSuggestion]) {
        self.epicName = epicName
        self.epicDescription = epicDescription
        self.tasks = tasks
    }
}

public struct TaskSuggestion: Sendable, Hashable {
    public var name: String
    public var description: String
    public var valuePoints: Int
    public init(name: String, description: String, valuePoints: Int) {
        self.name = name
        self.description = description
        self.valuePoints = valuePoints
    }
}

public struct MockLLMService: LLMService {
    public init() {}
    public func suggestEpicsAndTasks(goal: Goal, primaryValues: [Value]) async -> [EpicSuggestion] {
        let title = goal.name
        let valueHint = primaryValues.first?.name ?? "Personal Growth"
        return [
            EpicSuggestion(
                epicName: "Kickstart \(title)",
                epicDescription: "First steps aligned with \(valueHint)",
                tasks: [
                    TaskSuggestion(name: "Define success for \(title)", description: "Write 3 measurable outcomes", valuePoints: 3),
                    TaskSuggestion(name: "Create weekly ritual", description: "Recurring 30m review", valuePoints: 2)
                ]
            )
        ]
    }
}
