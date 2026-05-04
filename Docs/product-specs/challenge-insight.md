# Challenge and Insight

## Goal

사용자가 기록만 남기고 끝나지 않도록 현재 패턴, 목표 대비 상태, 유지 동기를 함께 제공한다.

## Product Rules

- 챌린지는 장기 달성 레이어와 개인화 추천 레이어를 구분한다
- 챌린지 탭은 `추천`, `진행 중`, `완료` 카테고리로 나누고 Liquid Glass segmented control로 전환한다
- 인사이트는 최근 기록과 목표 흐름을 해석해 보여준다
- 인사이트 탭은 `요약`, `패턴`, `루틴`, `리포트` 카테고리로 나누고 Liquid Glass segmented control로 전환한다
- 주간 리포트는 이번 주 elapsed 구간과 전주 동일 일수 구간을 비교해 평균 섭취량 변화를 보여준다
- 루틴 수행률은 루틴 저장값과 실제 `HealthKit` 기록 시각을 공통 Domain 규칙으로 매칭해 계산한다
- 추천 챌린지는 고정 배지 체계를 대체하지 않고 보조한다
- 추천 챌린지 CTA는 전역 `ContentView + AppCoordinator` push를 통해 루틴 생성/수정 흐름으로 연결한다

## Current Sections

- 챌린지 추천: 루틴과 최근 기록 기반 개인화 CTA
- 챌린지 진행 중: 현재 달성 중인 고정 챌린지
- 챌린지 완료: 획득한 챌린지 기록
- 인사이트 요약: 주간/월간 평균과 목표 기준
- 인사이트 패턴: 요일별 섭취 패턴
- 인사이트 루틴: 루틴 수행률과 놓친 시간대
- 인사이트 루틴 복구 CTA: 놓친 루틴 또는 자주 비는 시간대에서 즉시 기록, 루틴 수정/생성, 알림 권한/설정으로 연결
- 인사이트 리포트: 주간 리포트와 전주 비교, 다음 주 코칭 액션

## Behavior Expectations

- 반복형 챌린지와 누적형 챌린지는 상태 규칙이 다르다
- 추천은 최근 기록과 루틴 상태를 반영한다
- 챌린지 segmented control은 표시 카테고리만 바꾸며 저장 모델이나 진행 규칙을 바꾸지 않는다
- 챌린지 카테고리는 데이터가 없을 때도 카테고리별 empty state를 보여준다
- 인사이트 segmented control은 표시 카테고리만 바꾸며 계산 규칙을 바꾸지 않는다
- 주간 리포트는 평균 섭취량, 목표 달성일, 오전/오후/저녁 중 자주 비는 시간대를 요약한다
- 루틴 수행률은 이번 주에 도래한 활성 루틴만 분모에 넣고, 비활성 루틴과 아직 도래하지 않은 루틴은 구분해 보여준다
- 루틴 기반 추천은 기존 루틴 수정으로, 기록 기반 추천은 새 루틴 생성으로 이어진다
- 루틴 복구 CTA도 같은 정책을 따른다. 놓친 기존 루틴은 수정 흐름으로, 기록 기반 빈 시간대는 새 루틴 생성 흐름으로 이어진다
- 주간 코칭은 놓친 기존 루틴 수정, 빈 시간대 새 루틴 생성, 목표 부족/초과 시 목표 조정, 추천 없음 상태의 유지 안내 중 하나 이상을 보여준다
- 사용자가 성취와 부족분을 모두 읽을 수 있어야 한다

## Related Docs

- `Docs/challenge-state-model.md`
- `Docs/personalized-challenge-strategy.md`

## Related Code

- `Project/Presentation/Sources/View/Challenge/ChallengeView.swift`
- `Project/Presentation/Sources/View/HydrationInsight/HydrationInsightView.swift`
- `Project/Presentation/Sources/ViewModel/ChallengeViewModel.swift`
- `Project/Presentation/Sources/ViewModel/HydrationInsightViewModel.swift`
- `Project/Presentation/Sources/Navigation/AppRoute.swift`
- `Project/Presentation/Sources/Navigation/RoutineActionIntent.swift`
- `Project/Domain/Sources/UseCase/HydrationRoutineAdherenceUseCaseImpl.swift`
- `Project/Domain/SharedInterfaces/Entity/HydrationRoutineAdherenceInsight.swift`
