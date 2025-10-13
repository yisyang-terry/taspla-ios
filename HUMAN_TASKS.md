# Human Tasks

Authoritative place for any manual, non-automatable steps. Keep this file up to date; do not put manual action steps in README files.

## Repo wiring (one-time)

- [ ] Open `Taspla.xcodeproj` in Xcode 16 or later.
- [ ] Add local package dependency to `terry-code/packages/AppCore` (File → Add Package Dependencies… → Add Local…).
- [ ] Drag the sample UI into the app target (optional but recommended for a working shell):
  - [ ] `terry-code/samples/POCApp/Views`
  - [ ] `terry-code/samples/POCApp/Data/AppStore.swift`
- [ ] Update the app entry point in `Taspla/TasplaApp.swift` to render the POC root and remove the SwiftData template boilerplate:
  - Replace `ContentView()` with `RootView().environmentObject(AppStore())`.
  - Remove the `ModelContainer`/`SwiftData` scaffolding unless you plan to use it now.
- [ ] Remove template files you no longer need from the target:
  - `Taspla/ContentView.swift`
  - `Taspla/Item.swift`
- [ ] Ensure signing is valid (Targets → Taspla → Signing & Capabilities): set Development Team and unique Bundle Identifier.

## Build validation (local)

- [ ] Clean build folder if you see stale references (Product → Clean Build Folder or Shift+Cmd+K).
- [ ] If package caching acts up, Xcode → File → Packages → Reset Package Caches.
- [ ] Build and run on iOS 16+ simulator or device. Expected: app launches to POC `RootView` with tabs (Values, Goals, Kanban, Backlog, Calendar, Composer).
- [ ] Quick functional smoke:
  - Create a couple of Values/Goals and a Task with a Schedule, verify events render in Calendar.
  - Use Share on an event list and verify `.ics` export.

## After the next PR (test build request)

- [ ] Perform a fresh build on latest `main`:
  - Xcode: open `Taspla.xcodeproj`, select a simulator (iOS 16+), Product → Build.
  - CLI (optional):
    ```
    xcodebuild -project Taspla.xcodeproj -scheme Taspla -destination 'platform=iOS Simulator,name=iPhone 15'
    ```
- [ ] Confirm compile succeeds and the app runs to `RootView`.

### CI build on pull requests

- A GitHub Actions workflow runs `xcodebuild` for every PR (and on manual dispatch).
- Ensure the `Taspla` scheme is present; sharing it in Xcode helps CI discover it:
  - Product → Scheme → Manage Schemes… → check `Shared` for `Taspla`.
  - Commit the generated `xcshareddata/xcschemes` files.
  - If the scheme name changes, update `.github/workflows/ios-pr-build.yml`.

## Notes

- The legacy demo Xcode project under `terry-code/apps/POCApp` was removed to avoid confusion. Use the root `Taspla.xcodeproj` going forward.
- Keep `terry-code/samples/POCApp` as a source for drop‑in UI; do not add `POCApp.swift` to the app (it contains a separate `@main`).
