import Foundation

public struct Value: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var name: String
    public var description: String

    public init(id: UUID = UUID(), name: String, description: String = "") {
        self.id = id
        self.name = name
        self.description = description
    }
}

public struct Goal: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var name: String
    public var description: String
    public var startDate: Date?
    public var endDate: Date?
    public var status: GoalStatus

    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        startDate: Date? = nil,
        endDate: Date? = nil,
        status: GoalStatus = .planned
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
    }
}

public struct Epic: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var goalId: UUID
    public var name: String
    public var description: String
    public var startDate: Date?
    public var endDate: Date?

    public init(
        id: UUID = UUID(),
        goalId: UUID,
        name: String,
        description: String = "",
        startDate: Date? = nil,
        endDate: Date? = nil
    ) {
        self.id = id
        self.goalId = goalId
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }
}

public struct Task: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var epicId: UUID?
    public var valueId: UUID?
    public var name: String
    public var description: String
    public var status: TaskStatus
    public var valuePoints: Int

    public init(
        id: UUID = UUID(),
        epicId: UUID? = nil,
        valueId: UUID? = nil,
        name: String,
        description: String = "",
        status: TaskStatus = .backlog,
        valuePoints: Int = 0
    ) {
        self.id = id
        self.epicId = epicId
        self.valueId = valueId
        self.name = name
        self.description = description
        self.status = status
        self.valuePoints = valuePoints
    }
}

public struct Schedule: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var taskId: UUID
    public var startDate: Date
    public var endDate: Date?
    public var isFullDay: Bool
    public var isRecurring: Bool
    public var frequency: Frequency?
    public var startTimeMinutes: Int?
    public var endTimeMinutes: Int?
    public var notes: String?

    public init(
        id: UUID = UUID(),
        taskId: UUID,
        startDate: Date,
        endDate: Date? = nil,
        isFullDay: Bool = false,
        isRecurring: Bool = false,
        frequency: Frequency? = nil,
        startTimeMinutes: Int? = nil,
        endTimeMinutes: Int? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.taskId = taskId
        self.startDate = startDate
        self.endDate = endDate
        self.isFullDay = isFullDay
        self.isRecurring = isRecurring
        self.frequency = frequency
        self.startTimeMinutes = startTimeMinutes
        self.endTimeMinutes = endTimeMinutes
        self.notes = notes
    }
}

public struct Event: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var taskId: UUID
    public var scheduleId: UUID?
    public var start: Date
    public var end: Date
    public var isAllDay: Bool
    public var notes: String?

    public init(
        id: UUID = UUID(),
        taskId: UUID,
        scheduleId: UUID? = nil,
        start: Date,
        end: Date,
        isAllDay: Bool,
        notes: String? = nil
    ) {
        self.id = id
        self.taskId = taskId
        self.scheduleId = scheduleId
        self.start = start
        self.end = end
        self.isAllDay = isAllDay
        self.notes = notes
    }
}
