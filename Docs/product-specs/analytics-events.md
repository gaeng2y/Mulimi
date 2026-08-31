# Analytics Events

## Goal

핵심 사용자 여정의 전환과 반복 행동을 같은 기준으로 측정한다. 이벤트 이름과 파라미터는 제품 데이터 계약이므로 구현보다 먼저 이 문서를 기준으로 맞춘다.

## Architecture Rules

- ViewModel은 PostHog SDK를 직접 알지 않는다.
- Presentation은 `AnalyticsUseCase` 추상화만 호출한다.
- PostHog SDK 직접 의존은 앱 초기화/조립 계층의 repository 구현으로 제한한다.
- 제품 이벤트는 `PostHogAnalyticsRepository` 한 곳으로만 전송한다.
- PostHog는 `POSTHOG_PROJECT_TOKEN`과 `POSTHOG_HOST`(`XCConfig/Secrets.xcconfig`)가 유효한 빌드에서만 초기화한다. 로컬 설정이 없으면 `NoOpAnalyticsRepository`로 동작하고, Release archive는 Xcode Cloud secret 검증에서 실패시킨다.
- PostHog autocapture(`captureScreenViews`, `captureElementInteractions`)와 Session Replay는 사용하지 않는다. 라이프사이클 이벤트(`Application Opened` 등)만 SDK 기본 수집을 허용한다.
- 이벤트 이름은 `snake_case`를 사용하고 40자 이하로 유지한다.
- 파라미터 이름도 `snake_case`를 사용하고 값은 문자열, 정수, 실수, 불리언만 보낸다.
- 개인정보, 건강 원본 값 전체, 자유 입력 텍스트는 이벤트 파라미터로 보내지 않는다.
- 금지 파라미터와 외부 SDK/privacy label 영향 검토는 `Docs/security-privacy.md`를 따른다.
- 같은 CTA가 여러 화면에 있으면 `source` 또는 `context` 파라미터로 구분한다.

## Common Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `source` | String | 이벤트가 발생한 화면 또는 진입점 |
| `context` | String | 카드, CTA, 퍼널 단계 같은 세부 맥락 |
| `status` | String | 권한 또는 상태 값 |
| `volume_ml` | Int | 기록 또는 시도한 수분량 |
| `daily_goal_ml` | Int | 이벤트 시점의 목표 수분량 |
| `failure_reason` | String | 실패 또는 차단 사유 |

## Event Catalog

| Event | Required Parameters | Trigger |
| --- | --- | --- |
| `onboarding_completed` | `source` | 온보딩 마지막 CTA로 권한 안내 흐름 진입 |
| `hydration_reminder_priming_viewed` | `status` | 수분 리마인더 알림 권한 프라이밍 화면 노출 |
| `hydration_reminder_request_tapped` | `status` | 알림 허용 CTA 탭 |
| `hydration_reminder_permission_authorized` | `source`, `status` | 알림 권한 허용 확인 |
| `hydration_reminder_permission_denied` | `source`, `status` | 알림 권한 거부 확인 |
| `hydration_reminder_priming_skipped` | `status` | 프라이밍에서 나중에 할게요 탭 |
| `healthkit_permission_gate_viewed` | `status` | HealthKit 권한 게이트 노출 |
| `healthkit_permission_request_tapped` | `status` | 권한 요청 CTA 탭 |
| `healthkit_permission_authorized` | `source`, `status` | 권한 허용 확인 |
| `healthkit_permission_denied` | `source`, `status` | 권한 거부 또는 설정 복구 필요 상태 확인 |
| `healthkit_permission_settings_tapped` | `status` | 설정 이동 CTA 탭 |
| `healthkit_permission_refresh_tapped` | `status` | 설정 복귀 후 상태 재확인 CTA 탭 |
| `water_logged` | `source`, `serving_type`, `volume_ml`, `daily_goal_ml` | 물 기록 성공 |
| `water_log_failed` | `source`, `serving_type`, `failure_reason` | 물 기록 권한/입력/목표 초과 차단 또는 HealthKit 저장 실패 |
| `water_preset_logged` | `source`, `preset`, `volume_ml` | 330ml/500ml 프리셋 기록 성공 |
| `app_review_request_attempted` | `source`, `context` | 반복 사용 후 목표 달성으로 시스템 리뷰 요청 API 호출 직전 |
| `routine_created` | `source`, `enabled`, `weekday_count` | 루틴 생성 저장 성공 |
| `routine_updated` | `source`, `enabled`, `weekday_count` | 루틴 수정 저장 성공 |
| `routine_deleted` | `source`, `enabled`, `weekday_count` | 루틴 삭제 성공 |
| `insight_cta_tapped` | `source`, `context`, `action` | 인사이트 루틴 복구/주간 코칭/empty state CTA 탭 |
| `challenge_cta_tapped` | `source`, `challenge_kind`, `action` | 추천 챌린지 CTA 탭 |
| `daily_goal_changed` | `source`, `previous_goal_ml`, `new_goal_ml` | 목표 수분량 변경 |

## Parameter Values

### `source`

- `onboarding`
- `hydration_reminder_priming`
- `healthkit_permission_gate`
- `drink_water_main`
- `app_intent`
- `insight_recovery`
- `insight_weekly_coaching`
- `insight_empty`
- `challenge_recommendation`
- `profile_routine`
- `settings`
- `recommendation`

### `serving_type`

- `default_glass`
- `preset`
- `custom`

### `preset`

- `bottle`
- `tumbler`

### `context`

- `sustained_goal_achievement`
- `routine_recovery`
- `weekly_coaching`
- `empty_state`

### `failure_reason`

- `healthkit_permission_required`
- `healthkit_write_failed`
- `custom_amount_missing`
- `custom_amount_out_of_range`
- `daily_goal_exceeded`

### `action`

- `record_now`
- `go_record`
- `create_routine`
- `edit_routine`
- `request_notification_permission`
- `open_settings`
- `daily_goal`
- `none`

### `challenge_kind`

- `routineAnchor`
- `morningKickstart`
- `dailyGoalBooster`
- `consistencyDefender`

### `status`

- HealthKit: `not_determined`, `denied`, `authorized`
- Routine notification: `not_determined`, `denied`, `authorized`
- Hydration reminder notification: `not_determined`, `denied`, `authorized`

## SDK Properties

PostHog iOS SDK가 기본으로 추가하는 아래 속성은 제품 event parameter가 아니라 Release 집계 필터로 사용한다.

- `$app_namespace`
- `$app_version`
- `$app_build`
- `$is_testflight`
- `$is_sideloaded`
- `$is_emulator`

필터 값과 운영 기준은 [Growth Scorecard](growth-scorecard.md)를 따른다. 별도 `build_channel` 파라미터는 추가하지 않는다.

## Validation

- 이벤트 추가 또는 이름 변경 시 이 문서를 먼저 갱신한다.
- PostHog Funnels, Insights, Activity QA 기준은 [Analytics Operations](analytics-operations.md)를 따른다.
- 코드 변경 후 `make lint`와 `make arch-check`를 통과시킨다.
- ViewModel 단위 테스트에서는 PostHog SDK 대신 Analytics mock으로 이벤트 호출을 확인한다.
- 시스템 리뷰 요청은 표시나 작성 완료 콜백이 없으므로 `shown` 또는 `completed` 이벤트를 만들지 않는다.

## Related Code

- `Project/Core/Analytics/Domain/Sources/Entity/ProductAnalyticsEvent.swift`
- `Project/Core/Analytics/Domain/Sources/UseCase/AnalyticsUseCase.swift`
- `Project/Core/Analytics/Domain/Sources/UseCase/AnalyticsUseCaseImpl.swift`
- `Project/App/Sources/DrinkWaterApp.swift`
- `Project/Core/Analytics/Data/Sources/PostHogAnalyticsRepository.swift`
- `Project/Shared/DependencyInjection/Sources/Production/DomainAssembly.swift`
- `Project/Shared/DependencyInjection/Sources/Production/DataAssembly.swift`

## Related Docs

- `Docs/product-specs/analytics-operations.md`
- `Docs/product-specs/growth-scorecard.md`
- `Docs/security-privacy.md`
