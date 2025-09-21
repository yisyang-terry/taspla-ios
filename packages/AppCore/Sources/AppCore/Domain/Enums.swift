import Foundation

public enum GoalStatus: String, Codable, CaseIterable, Sendable {
    case planned
    case active
    case paused
    case completed
    case cancelled
}

public enum TaskStatus: String, Codable, CaseIterable, Sendable {
    case backlog
    case open
    case inProgress
    case done
    case blocked
}

public enum FrequencyType: String, Codable, CaseIterable, Sendable {
    case daily
    case weekly
    case monthly
}

public struct Frequency: Codable, Hashable, Sendable {
    public var type: FrequencyType
    public var interval: Int

    public init(type: FrequencyType, interval: Int = 1) {
        self.type = type
        self.interval = max(1, interval)
    }
}
