# Data Model

## Entities

Value
- id: UUID
- name: String
- description: String

Goal
- id: UUID
- name: String
- description: String
- startDate: Date?
- endDate: Date?
- status: GoalStatus (planned, active, paused, completed, cancelled)

Epic
- id: UUID
- goalId: UUID
- name: String
- description: String
- startDate: Date?
- endDate: Date?

Task
- id: UUID
- epicId: UUID?
- valueId: UUID?
- name: String
- description: String
- status: TaskStatus (backlog, open, inProgress, done, blocked)
- valuePoints: Int (reflects alignment strength)

Schedule
- id: UUID
- taskId: UUID
- startDate: Date (first occurrence anchor)
- endDate: Date? (recurrence window end)
- isFullDay: Bool
- isRecurring: Bool
- frequency: { type: daily|weekly|monthly, interval: Int }
- startTimeMinutes: Int? (minutes from 00:00 local)
- endTimeMinutes: Int? (minutes from 00:00 local)
- notes: String?

Event
- id: UUID
- taskId: UUID
- scheduleId: UUID?
- start: Date
- end: Date
- isAllDay: Bool
- notes: String?

## Relationships
- Value 1—* Task (via valueId)
- Goal 1—* Epic (via goalId)
- Epic 1—* Task (via epicId)
- Task 1—* Schedule (0..*)
- Schedule 1—* Event (generated)

## Scheduling Rules (POC)
- Non-recurring: generate one Event using startDate and time window
- Recurring: advance by frequency.interval in unit type until after endDate
- Full-day events: DTSTART/DTEND are date-only; time window ignored
- If endTimeMinutes ≤ startTimeMinutes, event end spills to next day

## Example JSON (Task + Schedule)
```json
{
  "task": {
    "id": "D45E0A4D-9F48-4C27-96D2-6BFEA3B6141A",
    "epicId": "7F2EA545-49F8-4B41-8A3E-3AF5E5360CA2",
    "valueId": "17D8B7CA-9B61-4B28-9E19-5A994CC0FBD6",
    "name": "Morning run",
    "description": "5km easy run",
    "status": "open",
    "valuePoints": 3
  },
  "schedule": {
    "id": "E3A8C1B9-1B31-40A3-9539-DF396F5E37FE",
    "taskId": "D45E0A4D-9F48-4C27-96D2-6BFEA3B6141A",
    "startDate": "2025-01-01T00:00:00Z",
    "endDate": "2025-03-01T00:00:00Z",
    "isFullDay": false,
    "isRecurring": true,
    "frequency": { "type": "weekly", "interval": 3 },
    "startTimeMinutes": 420,
    "endTimeMinutes": 480,
    "notes": "M/W/F cadence via 3-week blocks"
  }
}
```
