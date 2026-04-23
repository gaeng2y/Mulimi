# Hydration Logging

## Goal

사용자가 앱, 위젯, 워치 어디서 기록하더라도 같은 수분 기록과 같은 단위 규칙을 보게 한다.

## Product Rules

- 수분 기록의 원본 저장소는 `HealthKit`
- 로컬에 별도 hydration 원장을 다시 두지 않는다
- `250ml = 1잔` 규칙은 `HydrationServing`으로만 다룬다
- 다음 한 잔 가이드는 목표까지 남은 양, 남은 잔 수, 다음 루틴 문맥을 함께 본다
- 기록 탭의 오늘/주간/월간 요약은 HealthKit 기록을 일별 합산한 표시 모델로 만든다
- 기록 탭의 잔 수와 달성일 계산은 `HydrationServing`과 사용자 목표 수분량을 기준으로 한다
- 앱, 위젯, 워치가 서로 다른 계산 규칙을 만들지 않는다

## User Expectations

- 빠르게 한 잔을 기록할 수 있다
- 오늘 섭취량과 목표 진행률이 같은 기준으로 보인다
- 기록 탭에서 기간별 총 섭취량, 일평균, 기록 횟수, 목표 달성일을 빠르게 확인할 수 있다
- 목표까지 남은 양과 다음 한 잔 기준을 바로 이해할 수 있다
- 워치/위젯 기록이 앱 기록과 어긋나지 않는다

## Scope

- 메인 화면의 물 마시기 액션
- 오늘 섭취량 집계
- 위젯/AppIntent 기록
- Apple Watch 기록
- 메인 화면/위젯/워치의 다음 한 잔 가이드
- 기록 탭의 오늘/주간/월간 기간 필터와 일별 요약

## Constraints

- HealthKit 권한이 없으면 기록/집계 UX가 그 상태를 설명해야 한다
- 저장 형식보다 사용자 체감 일관성이 우선이다

## Related Code

- `Project/Domain/SharedInterfaces/Entity/HydrationServing.swift`
- `Project/Domain/SharedInterfaces/Entity/HydrationNextActionGuide.swift`
- `Project/Domain/Sources/UseCase/HydrationNextActionGuideUseCaseImpl.swift`
- `Project/Data/Sources/Repository/HealthKitRepositoryImpl.swift`
- `Project/Widget/Sources/`
- `Project/Domain/WatchSources/`

## Related Docs

- `ARCHITECTURE.md`
- `Docs/skills/healthkit-flow.md`
- `Docs/skills/widget-watch-integration.md`
