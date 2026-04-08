# Hydration Logging

## Goal

사용자가 앱, 위젯, 워치 어디서 기록하더라도 같은 수분 기록과 같은 단위 규칙을 보게 한다.

## Product Rules

- 수분 기록의 원본 저장소는 `HealthKit`
- 로컬에 별도 hydration 원장을 다시 두지 않는다
- `250ml = 1잔` 규칙은 `HydrationServing`으로만 다룬다
- 앱, 위젯, 워치가 서로 다른 계산 규칙을 만들지 않는다

## User Expectations

- 빠르게 한 잔을 기록할 수 있다
- 오늘 섭취량과 목표 진행률이 같은 기준으로 보인다
- 워치/위젯 기록이 앱 기록과 어긋나지 않는다

## Scope

- 메인 화면의 물 마시기 액션
- 오늘 섭취량 집계
- 위젯/AppIntent 기록
- Apple Watch 기록

## Constraints

- HealthKit 권한이 없으면 기록/집계 UX가 그 상태를 설명해야 한다
- 저장 형식보다 사용자 체감 일관성이 우선이다

## Related Code

- `Project/Domain/Interfaces/Entity/HydrationServing.swift`
- `Project/Data/Sources/Repository/HealthKitRepositoryImpl.swift`
- `Project/Widget/Sources/`
- `Project/Domain/WatchSources/`

## Related Docs

- `ARCHITECTURE.md`
- `Docs/skills/healthkit-flow.md`
- `Docs/skills/widget-watch-integration.md`
