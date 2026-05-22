# Analytics Operations

## Goal

Firebase Analytics에 쌓이는 이벤트를 제품 의사결정에 쓸 수 있는 퍼널, 대시보드, QA 기준으로 운영한다. 이벤트 이름과 파라미터 계약은 [Analytics Events](analytics-events.md)를 기준으로 하고, 이 문서는 그 이벤트를 어떻게 볼지 정의한다.

## Non-Goals

- 새 analytics SDK 추가
- 이벤트 이름 대규모 변경
- 외부 BI 도구 도입
- 개인정보, 건강 원본 값, 자유 입력 텍스트 수집

## Core Funnel

첫 진입부터 반복 기록과 루틴 생성까지의 핵심 퍼널은 아래 순서로 본다.

```text
onboarding_completed
-> healthkit_permission_gate_viewed
-> healthkit_permission_request_tapped
-> healthkit_permission_authorized
-> water_logged
-> repeat water_logged
-> routine_created
```

### Funnel Step Definitions

| Step | Firebase Event | Measurement Meaning |
| --- | --- | --- |
| Onboarding complete | `onboarding_completed` | 사용자가 온보딩 마지막 CTA를 눌러 권한 게이트로 이동 |
| Permission gate viewed | `healthkit_permission_gate_viewed` | HealthKit 권한 설명 화면 노출 |
| Permission request tapped | `healthkit_permission_request_tapped` | 권한 요청 CTA 탭 |
| Permission authorized | `healthkit_permission_authorized` | HealthKit 권한 허용 확인 |
| First water logged | `water_logged` | 권한 허용 이후 첫 수분 기록 성공 |
| Repeat water logged | `water_logged` count >= 2 | 같은 사용자 또는 Firebase user pseudo id 기준 반복 기록 |
| Routine created | `routine_created` | 루틴 생성 저장 성공 |

`repeat water_logged`는 별도 이벤트가 아니라 `water_logged`의 반복 발생으로 계산한다. Firebase exploration에서 event count 또는 user segment 조건으로 산출한다.

## Dashboard Sections

### Activation

| Metric | Source | Use |
| --- | --- | --- |
| Onboarding completion count | `onboarding_completed` | 온보딩 통과 규모 확인 |
| HealthKit request rate | `healthkit_permission_request_tapped / healthkit_permission_gate_viewed` | 권한 CTA 설득력 확인 |
| HealthKit authorization rate | `healthkit_permission_authorized / healthkit_permission_request_tapped` | 시스템 권한 허용률 확인 |
| First water log conversion | first `water_logged / healthkit_permission_authorized` | 권한 허용 후 핵심 행동 전환 확인 |

### Engagement

| Metric | Source | Use |
| --- | --- | --- |
| Water log count by source | `water_logged.source` | 앱, AppIntent/Siri/Shortcuts, 인사이트 같은 기록 진입점 비교 |
| Serving type mix | `water_logged.serving_type` | 기본 잔, 프리셋, 직접 입력 사용 패턴 확인 |
| Preset usage | `water_preset_logged.preset` | bottle/tumbler 프리셋 사용성 확인 |
| Shortcut failure rate | `water_log_failed.source == app_intent`, `failure_reason` | Shortcuts 실행 차단 사유와 실패율 확인 |
| Goal change count | `daily_goal_changed.source` | 설정 또는 추천 기반 목표 변경 비중 확인 |

### Routine And Coaching

| Metric | Source | Use |
| --- | --- | --- |
| Routine create/update/delete count | `routine_created`, `routine_updated`, `routine_deleted` | 루틴 관리 활성도 확인 |
| Insight CTA by action | `insight_cta_tapped.action` | 인사이트 카드가 기록/루틴/권한 행동으로 이어지는지 확인 |
| Challenge CTA by action | `challenge_cta_tapped.action` | 추천 챌린지의 루틴 전환 기여 확인 |

### Permission Recovery

| Metric | Source | Use |
| --- | --- | --- |
| Settings tap rate | `healthkit_permission_settings_tapped / healthkit_permission_denied` | 거부 후 설정 이동 의지 확인 |
| Refresh after settings | `healthkit_permission_refresh_tapped` | 설정 복귀 후 재확인 행동 확인 |
| Recovery authorization | `healthkit_permission_authorized.source == healthkit_permission_gate` | 설정 복구 흐름의 성공 여부 확인 |

## Firebase Exploration Setup

### Funnel Exploration

1. Firebase Console에서 Explore > Funnel exploration을 생성한다.
2. Step은 Core Funnel 순서로 추가한다.
3. `water_logged`의 반복 기록은 별도 step 조건으로 `event_count >= 2` 또는 user segment를 사용한다.
4. Breakdown은 가능한 경우 `source`, `serving_type`, `status`를 우선 사용한다.
5. Date range는 출시 직후 7일, 안정화 후 28일 기준으로 본다.

### Event Tables

아래 표는 dashboard 또는 exploration에서 먼저 만들어야 한다.

| View | Rows | Columns / Filters |
| --- | --- | --- |
| Permission Funnel | 이벤트 단계 | `status`, date range |
| Water Logging Mix | `source`, `serving_type` | event count, users |
| Preset Usage | `preset` | event count |
| Routine Lifecycle | event name | create/update/delete count |
| Coaching CTA | `context`, `action` | insight/challenge source filter |
| Goal Changes | `source` | previous/new goal distribution |

## DebugView QA Checklist

QA는 Firebase DebugView에서 이벤트명과 파라미터가 문서와 맞는지만 확인한다. 건강 원본 값이나 자유 입력 텍스트가 전송되면 실패로 본다.

### Onboarding And Permission

- 온보딩 마지막 CTA 탭 시 `onboarding_completed`가 발생한다.
- HealthKit 권한 게이트 진입 시 `healthkit_permission_gate_viewed`가 1회 발생한다.
- 권한 요청 CTA 탭 시 `healthkit_permission_request_tapped`가 발생한다.
- 권한 허용 시 `healthkit_permission_authorized`가 발생하고 `status`는 `authorized`다.
- 권한 거부 또는 설정 필요 상태에서는 `healthkit_permission_denied`가 발생한다.
- 설정 이동 CTA 탭 시 `healthkit_permission_settings_tapped`가 발생한다.
- 설정 복귀 후 재확인 CTA 탭 시 `healthkit_permission_refresh_tapped`가 발생한다.

### Water Logging

- 기본 물 기록 성공 시 `water_logged`가 발생한다.
- 기본 기록의 `serving_type`은 `default_glass`다.
- 330ml/500ml 프리셋 기록 성공 시 `water_logged`와 `water_preset_logged`가 모두 발생한다.
- 직접 입력 기록 성공 시 `water_logged.serving_type`은 `custom`이다.
- AppIntent/Siri/Shortcuts 기록 성공 시 `water_logged.source`는 `app_intent`다.
- AppIntent/Siri/Shortcuts 기록 차단 시 `water_log_failed.source`는 `app_intent`이고 `failure_reason`이 포함된다.
- 목표 초과로 기록이 차단된 경우 성공 이벤트를 보내지 않는다.

### Routine, Insight, Challenge

- 루틴 생성/수정/삭제 성공 시 각각 `routine_created`, `routine_updated`, `routine_deleted`가 발생한다.
- 인사이트 CTA 탭 시 `insight_cta_tapped`가 발생하고 `context`, `action`이 채워진다.
- 추천 챌린지 CTA 탭 시 `challenge_cta_tapped`가 발생하고 `challenge_kind`, `action`이 채워진다.
- 목표 수분량 변경 시 `daily_goal_changed`가 발생하고 이전/새 목표 값이 정수 ml로 들어간다.

## Decision Rules

- HealthKit request rate가 낮으면 권한 게이트 카피와 CTA 우선순위를 점검한다.
- HealthKit authorization rate가 낮으면 시스템 권한 요청 전 설명과 신뢰 문구를 점검한다.
- First water log conversion이 낮으면 권한 허용 직후 기록 CTA 노출 여부를 점검한다.
- Repeat water logged 비중이 낮으면 위젯, Watch, Siri/Shortcuts 같은 빠른 기록 진입점을 우선 검토한다.
- `serving_type == default_glass`에 과도하게 몰리면 기본 기록량 설정 또는 Shortcuts 수분량 파라미터 확장을 검토한다.
- `insight_cta_tapped`는 높지만 `routine_created`가 낮으면 CTA 이후 루틴 생성 흐름의 마찰을 점검한다.
- 온보딩/권한 전환 실험은 [Onboarding and HealthKit Conversion Experiments](onboarding-healthkit-conversion-experiments.md)의 baseline window, success threshold, stop rule을 따른다.

## Follow-Up Handling

운영 중 이벤트나 파라미터가 부족하면 바로 이름을 바꾸지 않는다.

1. 누락된 의사결정 질문을 적는다.
2. 기존 이벤트와 파라미터로 답할 수 있는지 확인한다.
3. 답할 수 없을 때만 `Docs/product-specs/analytics-events.md`를 먼저 갱신한다.
4. 코드 변경 이슈를 별도로 생성한다.

## Related Docs

- `Docs/product-specs/analytics-events.md`
- `Docs/security-privacy.md`
- `Docs/product-specs/onboarding-healthkit-conversion-experiments.md`
- `Docs/product-specs/sign-in-onboarding-healthkit.md`
- `Docs/product-specs/hydration-logging.md`
- `Docs/product-specs/routine-notifications.md`
- `Docs/product-specs/challenge-insight.md`
