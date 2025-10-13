# Roadmap

## Milestone 0: POC (This repo)
- Domain models and scheduling logic
- SwiftUI sample with in-memory store
- ICS export via share sheet
- Mock LLM suggestions

## Milestone 1: MVP
- Core Data persistence + basic migrations
- EventKit integration (opt-in calendar write)
- Expanded recurrence (weekdays, ends/occurrence count)
- Improved Calendar UX (group by day/weeks)
- Basic onboarding to capture primary values

## Milestone 2: Productization
- OIDC sign-in & account model
- Cloud sync (CloudKit or backend)
- Audit/logging for changes
- Attachments and notes for tasks/events
- Notifications (scheduled reminders)

## Milestone 3: Integrations
- Jira import/export (goals/epics/tasks mapping)
- Miro board export for planning views
- Slack notifications (daily plan, reminders)

## Milestone 4: Scale
- Multi-tenancy (SaaS) and org roles
- Observability and resilience (SLOs)
- Feature flags + A/B experiment harness
