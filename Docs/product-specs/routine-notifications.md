# Routine Notifications

## Goal

사용자가 원하는 시간대에 물 마실 리마인더를 설정하고, 권한 상태에 따라 다음 행동을 이해할 수 있게 한다.

## Product Rules

- 루틴은 사용자가 직접 추가, 수정, 삭제할 수 있다
- 루틴 화면은 최근 기록 기반 추천 루틴을 제안할 수 있다
- 알림 권한이 없으면 저장 전 또는 저장 후 적절한 안내를 제공한다
- 인사이트 루틴 카드의 복구 CTA는 권한 상태에 따라 루틴 수정/생성, 권한 요청, 설정 이동으로 분기한다
- 시스템 권한 팝업과 앱 내부 안내 문구는 현재 로컬라이제이션 톤을 따른다
- 루틴이 비활성화되면 해당 스케줄의 알림도 반영돼야 한다

## Permission States

- `notDetermined`
  - 권한 요청 CTA를 제공한다
- `denied`
  - 설정 이동 CTA를 제공한다
- `authorized`
  - 별도 차단 없이 루틴을 저장하고 스케줄링한다

## Data Expectations

- 현재 루틴 저장소는 `UserDefaults` JSON
- 알림 스케줄은 저장된 활성 루틴 기준으로 재구성한다
- 추천 루틴은 최근 `HealthKit` 기록과 현재 활성 루틴을 바탕으로 계산한다
- 루틴 수행률 인사이트는 저장된 루틴 시각과 `HealthKit` 기록 시각을 같은 Domain 매칭 규칙으로 비교한다
- 놓친 루틴 복구 CTA의 즉시 기록은 `DrinkWaterUseCase` 기본 기록 경로를 사용하고, 알림/루틴 CTA는 전역 `ContentView + AppCoordinator` push로 루틴 화면에 연결한다

## Related Code

- `Project/Presentation/Sources/View/Profile/ProfileRoutineView.swift`
- `Project/Presentation/Sources/View/Profile/RoutineEditorView.swift`
- `Project/Presentation/Sources/ViewModel/ProfileRoutineViewModel.swift`
- `Project/Domain/Sources/UseCase/RoutineRecommendationUseCaseImpl.swift`
- `Project/Domain/Sources/UseCase/HydrationRoutineAdherenceUseCaseImpl.swift`
- `Project/Data/Sources/DataSource/RoutineNotificationDataSource.swift`

## Related Docs

- `ARCHITECTURE.md`
- `Docs/skills/widget-watch-integration.md`
