# Taspla

Taspla (TASk PLAnner) is a native iOS app (SwiftUI) for values‑aligned planning. This repo now has two parts:

- `Taspla.xcodeproj` + `Taspla/` — the Xcode app project scaffolded from Xcode 16
- `terry-code/` — prior code and docs moved here:
  - `packages/AppCore` — Swift package with domain models, scheduling, and ICS export
  - `samples/POCApp` — drop‑in SwiftUI prototype (tabs for Values, Goals, Kanban, Backlog, Calendar, Composer)
  - `docs/` — product brief, domain/architecture, and roadmap

## Quick Start

1) Open `Taspla.xcodeproj` in Xcode 16.
2) Add the local package dependency:
   - File → Add Package Dependencies… → Add Local… → select `terry-code/packages/AppCore`
3) Add the sample UI (optional, for a working app shell):
   - Drag `terry-code/samples/POCApp/Views` and `terry-code/samples/POCApp/Data/AppStore.swift` into the Taspla target (copy if needed).
4) Update the app entry to show the POC root:
   - In `Taspla/TasplaApp.swift`, render `RootView().environmentObject(AppStore())`.
5) Build and run (iOS 16+).

Tip: The project uses file‑system‑synced groups, so any `.swift` you add under `Taspla/` will be included automatically in the target.

## What’s in AppCore

- Entities: `Value`, `Goal`, `Epic`, `Task`, `Schedule`, `Event`
- Services:
  - `SchedulingService` — expands `Schedule` into concrete `Event`s (daily/weekly/monthly)
  - `ICSExporter` — exports events to `.ics` (RFC 5545 basics)
  - `LLMService` (+ `MockLLMService`) — protocol for AI‑assisted drafting of epics/tasks
- Utils: `DateHelpers`
- Tests: coverage for scheduling rules and ICS formatting

## Recent Refactors (Oct 13, 2025)

- Hardened `SchedulingService` against invalid ranges and runaway recurrence
- Added documentation comments across domain and services
- Implemented conservative ICS line folding and small export cleanups
- Added unit tests for edge cases and ICS exporter
- Updated docs to explain the new project layout and wiring steps

## Next

- Replace in‑memory store with persistence (Core Data + CloudKit optional)
- EventKit integration to write directly to Calendar
- Real LLM provider behind `LLMService`
- Expand recurrence (RRULE variants), DST/timezone edges, and calendar UI

