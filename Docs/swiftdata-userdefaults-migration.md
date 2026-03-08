# UserDefaults -> SwiftData Migration (Hydration)

## Scope
- Target data: today's water count (`glassesOfToday`)
- New storage: `HydrationEventModel` (SwiftData, App Group container)
- Migration owner: `DrinkWaterSwiftDataDataSource`

## Legacy Data Format
- Legacy key format: `yyyy-MM-dd` (for example `2026-03-08`)
- Legacy value: `Int` glass count for that day

## Migration Flow
1. `DrinkWaterSwiftDataDataSource` is initialized.
2. If migration flag `hydrationMigration.swiftData.v1.completed` is `false`, migration runs.
3. Read legacy today count from UserDefaults.
4. Fetch today's events in SwiftData.
5. Only when `existingEventCount == 0` and `legacyCount > 0`, insert `legacyCount` events (`250ml` each).
6. Save SwiftData.
7. Mirror SwiftData count back to legacy key (temporary compatibility for App/Widget code that still reads UserDefaults).
8. Set migration flag to `true`.

## Idempotency Rules
- Migration is skipped when the flag is already `true`.
- Even if the flag is manually reset, duplicate insertion is prevented by `existingEventCount == 0` guard.

## Compatibility During Rollout
- `drinkWater()` and `reset()` update SwiftData first.
- After each write, legacy UserDefaults count is synced from SwiftData.
- This allows staged rollout where some layers still read UserDefaults.

## Verification
- `DomainLayer` tests include UseCase delegation checks for event read/migration APIs.
- `DataLayer` tests validate:
  - one-time migration behavior,
  - event persistence on drink action,
  - event reset behavior.
