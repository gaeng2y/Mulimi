# Challenge and Insight

## Goal

사용자가 기록만 남기고 끝나지 않도록 현재 패턴, 목표 대비 상태, 유지 동기를 함께 제공한다.

## Product Rules

- 챌린지는 장기 달성 레이어와 개인화 추천 레이어를 구분한다
- 인사이트는 최근 기록과 목표 흐름을 해석해 보여준다
- 루틴 수행률은 루틴 저장값과 실제 `HealthKit` 기록 시각을 공통 Domain 규칙으로 매칭해 계산한다
- 추천 챌린지는 고정 배지 체계를 대체하지 않고 보조한다

## Current Sections

- 추천 챌린지
- 진행 중 챌린지
- 획득한 챌린지
- 수분 인사이트, 루틴 수행률, 기록 요약

## Behavior Expectations

- 반복형 챌린지와 누적형 챌린지는 상태 규칙이 다르다
- 추천은 최근 기록과 루틴 상태를 반영한다
- 루틴 수행률은 이번 주에 도래한 활성 루틴만 분모에 넣고, 비활성 루틴과 아직 도래하지 않은 루틴은 구분해 보여준다
- 사용자가 성취와 부족분을 모두 읽을 수 있어야 한다

## Related Docs

- `Docs/challenge-state-model.md`
- `Docs/personalized-challenge-strategy.md`

## Related Code

- `Project/Presentation/Sources/View/ChallengeView.swift`
- `Project/Presentation/Sources/View/HydrationInsightView.swift`
- `Project/Presentation/Sources/ViewModel/ChallengeViewModel.swift`
- `Project/Presentation/Sources/ViewModel/HydrationInsightViewModel.swift`
- `Project/Domain/Sources/UseCase/HydrationRoutineAdherenceUseCaseImpl.swift`
- `Project/Domain/SharedInterfaces/Entity/HydrationRoutineAdherenceInsight.swift`
