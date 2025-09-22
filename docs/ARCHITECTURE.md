# Architecture

## Overview
- iOS app (SwiftUI, iOS 16+)
- `AppCore` Swift package for domain entities, scheduling, ICS export, and LLM abstraction
- POC app uses an in-memory store; production can swap Core Data repositories

## Layers
- Domain (entities, value types, enums)
- Services
  - SchedulingService: schedules → events
  - ICSExporter: events → .ics content
  - LLMService: protocol + mock implementation for drafting items
- UI (SwiftUI): Values, Goals, Backlog, Kanban, Calendar, Composer

## Scheduling Logic (POC)
Inputs: Schedule (startDate, endDate, isFullDay, isRecurring, frequency, startTimeMinutes, endTimeMinutes)
Output: [Event]

Algorithm:
1) If not recurring → single event
2) Else, iterate from `startDate`, adding `frequency.interval` in unit (`daily|weekly|monthly`) until past `endDate`
3) For all-day events → start = start of day; end = start of next day
4) For timed events → apply `startTimeMinutes`/`endTimeMinutes` to the date; if end ≤ start, roll end to next day
5) If a DateInterval filter is provided, only include events that intersect it

Limitations:
- Basic recurrence only (no complex RRULE BYDAY, etc.)
- Time zone is `Calendar.current` for POC

## ICS Export
- Each event → VEVENT with UID, DTSTART/DTEND, DTSTAMP, SUMMARY, DESCRIPTION
- Full-day events use `;VALUE=DATE` with exclusive DTEND
- Keep SUMMARY succinct (e.g., Task name). DESCRIPTION may include notes

## LLM Integration
- `LLMService` protocol returns suggested Epics/Tasks for a Goal and primary Values
- Starts with `MockLLMService`. Swap for a real provider later (OpenAI, Gemini, Azure)

## Persistence Strategy (Next)
- Replace InMemory with Core Data repositories implementing simple CRUD protocols
- Optional CloudKit for sync

## Integrations (Later)
- EventKit to write events to Calendar directly
- OIDC SSO for multi-device accounts
- Jira, Miro, Slack via providers behind interfaces and feature flags
