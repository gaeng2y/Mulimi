# healthkit-flow

## When to use

- 수분 기록 기능 수정
- HealthKit 권한 흐름 수정
- 신체 정보(키/몸무게) 수정
- 목표 수분량 추천 관련 변경

## Goal

Mulimi의 건강 데이터 흐름을 한 규칙으로 유지한다.

## Rules

- 수분 섭취 기록 원본은 `HealthKit`
- 신체 정보 원본도 `HealthKit`
- `SignIn -> Onboarding -> HealthKitPermissionGate -> ContentView` 흐름 유지
- 로컬 캐시가 원본을 대체하면 안 된다
- HealthKit 문제를 이중 저장으로 덮지 않는다

## Storage Policy

- 수분 기록: `HealthKit`
- 신체 정보: `HealthKit`
- 목표 수분량: `iCloud KVS + App Group UserDefaults mirror`
- `mainIcon`: App Group `UserDefaults`

## Where to look

- 권한 게이트: `Project/Presentation/Sources/View/Authentication/HealthKitPermissionGateView.swift`
- 루트 흐름: `Project/Presentation/Sources/View/RootView.swift`
- HealthKit 구현: `Project/Data/Sources/DataSource/HealthKitDataSource.swift`
- 수분 원본 data source: `Project/Data/Sources/DataSource/DrinkWaterHealthKitDataSource.swift`

## Validation

```bash
make arch-check
xcodebuild test -workspace Mulimi.xcworkspace -scheme DomainLayer -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
xcodebuild test -workspace Mulimi.xcworkspace -scheme PresentationLayer -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
```

## Related Docs

- `Docs/reliability-recovery.md`
