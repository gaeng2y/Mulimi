# SwiftData + CloudKit Sync Strategy (Hydration Only)

## Scope
- Synced: `HydrationEventModel` only
- Not synced: user preference values (`mainAppearance`, `dailyLimit`) in UserDefaults

## Container
- CloudKit container: `iCloud.gaeng2y.DrinkWater`
- App Group store: `group.com.gaeng2y.drinkwater`

## Runtime Behavior
1. App/Widget requests a SwiftData container with `cloudKitDatabase: .automatic`.
2. If CloudKit-backed container creation succeeds, hydration events are synced across devices signed into the same Apple ID.
3. If CloudKit container creation fails (for example iCloud disabled/misconfigured), store creation automatically falls back to local-only (`cloudKitDatabase: .none`).
4. Core hydration features keep working in local-only mode.

## Fallback Guarantee
- Fallback is implemented in `SharedHydrationStore.makeModelContainer(...)`.
- If both CloudKit and local container creation fail, an explicit error is thrown (`failedToCreateContainer`).

## Capability Requirements
- App and Widget extension entitlements include:
  - `com.apple.developer.icloud-services = CloudKit`
  - `com.apple.developer.icloud-container-identifiers = iCloud.gaeng2y.DrinkWater`
  - existing App Group entitlement for shared local persistence
