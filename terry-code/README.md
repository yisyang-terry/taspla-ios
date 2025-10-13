# Taspla (ValuePath Prototype + Core)

Taspla is a personal growth iOS app. This folder contains the prototype and the reusable core that helps users:

- Identify primary life values and align goals to them
- Break big goals into epics and actionable tasks
- Schedule tasks and automatically generate calendar events
- View work across backlog, kanban, and calendar
- Experiment with LLM-assisted goal/epic/task drafting

This repo includes product docs, a core Swift package with domain logic, and a SwiftUI POC you can drop into an Xcode app.

## What’s Here

- `docs/` — product brief, domain model, architecture, roadmap
- `packages/AppCore/` — Swift package with core entities, scheduling, ICS export, LLM stubs
- `samples/POCApp/` — SwiftUI POC views and in-memory store (for a new Xcode iOS project)

## MVP Scope

- CRUD for Values, Goals, Epics, Tasks
- Per-task Schedules
- Auto-generate Events from Schedules (one-off and recurring)
- Views: Values list, Goals list, Backlog, Kanban, Calendar, simple Task Composer
- Share events via iCalendar (.ics) export (share sheet)
- Mock LLM integration (replace with a real provider later)

## Non-Goals (for MVP)

- Cloud sync, multi-tenancy, OIDC SSO, external integrations (Jira/Miro/Slack)
- Push notifications and background sync
- Advanced calendar UI (week/month grid)

## Getting Started (POC)

1) If you already created the `Taspla` Xcode project at the repo root (Xcode 16 template), skip to step 2. Otherwise, create a new iOS App project (SwiftUI, iOS 16+).
2) Add the local Swift Package dependency:
   - File → Add Package Dependencies… → Add Local… → select `terry-code/packages/AppCore`
3) Add the sample POC sources:
   - Drag the contents of `terry-code/samples/POCApp/` into your app target (copy items if needed). Include both `Views/` and `Data/AppStore.swift`.
4) Replace your `App` entry point to render `RootView()` (see sample `POCApp.swift`).
5) Build and run on iOS 16+ simulator or device.

Notes:
- The POC uses an in-memory store. No persistence is included yet.
- Events are generated from Schedules on the fly using `SchedulingService`.
- Use the Calendar tab to see generated events. Use the Share action to export `.ics`.

## Next Steps

- Replace in-memory with Core Data (+ CloudKit optional)
- Add EventKit integration to write directly to Calendar
- Hook up a real LLM provider (OpenAI/Gemini/Azure) behind the `LLMService` protocol
- Add sign-in (OIDC), and external integrations behind feature flags
- Expand recurrence rules (RRULE), edge cases, and time zone handling

See `docs/ROADMAP.md` for milestone planning.

## Using with the Taspla Xcode Project (root)

The repo root includes `Taspla.xcodeproj` created from Xcode 16. To wire it up:

1) Open `Taspla.xcodeproj`.
2) Add local package `terry-code/packages/AppCore` (File → Add Package Dependencies…).
3) Drag `terry-code/samples/POCApp/Views` and `terry-code/samples/POCApp/Data/AppStore.swift` into the Taspla target.
4) In `Taspla/TasplaApp.swift`, set the window content to `RootView().environmentObject(AppStore())`.
5) Remove the SwiftData template files (`Item.swift`, default `ContentView.swift`) if you no longer need them.

Note: The Xcode project uses file-system-synced groups, so any `.swift` files you put under the `Taspla/` folder are added to the target automatically.
