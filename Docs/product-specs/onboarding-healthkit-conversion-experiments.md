# Onboarding And HealthKit Conversion Experiments

## Goal

온보딩 완료부터 HealthKit 권한 허용, 첫 수분 기록까지의 전환을 개선하기 위한 실험 기준이다. #210의 Firebase 퍼널 운영화를 전제로 하며, 실험 없이 문구나 CTA를 바꾸지 않는다.

## Prerequisite

- #210 Firebase 분석 퍼널 및 대시보드 운영화 완료
- `Docs/product-specs/analytics-events.md`의 이벤트명과 파라미터가 DebugView에서 확인된 상태
- HealthKit 권한 요청은 현재 흐름처럼 온보딩 뒤 별도 게이트에서 수행

## Baseline Funnel

실험 전 baseline은 Firebase Funnel exploration에서 아래 순서로 본다.

```text
onboarding_completed
-> healthkit_permission_gate_viewed
-> healthkit_permission_request_tapped
-> healthkit_permission_authorized
-> water_logged
```

권한 거부 후 복구 baseline은 별도 permission recovery view로 본다.

```text
healthkit_permission_denied
-> healthkit_permission_settings_tapped
-> healthkit_permission_refresh_tapped
-> healthkit_permission_authorized
```

## Baseline Window

- 변경 전 최소 14일을 baseline으로 잡는다.
- 14일 동안 `healthkit_permission_gate_viewed`가 100회 미만이면 28일을 baseline으로 잡는다.
- 앱 버전, 주요 유입 경로, Firebase 이벤트 QA 상태가 다른 기간은 비교에서 제외한다.
- 대시보드는 전체 사용자와 신규 설치/첫 실행 사용자 segment를 함께 본다.

## Success Metrics

| Metric | Formula | Meaning |
| --- | --- | --- |
| HealthKit request rate | `healthkit_permission_request_tapped / healthkit_permission_gate_viewed` | 권한 설명 화면이 요청 CTA까지 설득했는지 |
| HealthKit authorization rate | `healthkit_permission_authorized / healthkit_permission_request_tapped` | 시스템 권한 팝업에서 허용으로 이어졌는지 |
| First water log conversion | first `water_logged / healthkit_permission_authorized` | 권한 허용 뒤 핵심 행동까지 도달했는지 |
| Settings recovery rate | `healthkit_permission_settings_tapped / healthkit_permission_denied` | 거부 후 설정 이동 안내가 작동했는지 |
| Recovery authorization rate | `healthkit_permission_authorized.source == healthkit_permission_gate / healthkit_permission_refresh_tapped` | 설정 복귀 후 실제 권한 복구가 되었는지 |

## Guardrails

- HealthKit 권한을 우회하거나 앱 기능 사용을 거짓으로 약속하지 않는다.
- HealthKit에서 읽는 신체 정보와 쓰는 수분 기록의 목적을 흐리지 않는다.
- 개인정보, 건강 원본 값, 자유 입력 텍스트를 새 이벤트 파라미터에 넣지 않는다.
- 이벤트 이름을 실험 중간에 바꾸지 않는다.
- 권한 요청 시점을 온보딩 이전으로 당기지 않는다.
- `water_logged / healthkit_permission_authorized`가 악화되면 권한 허용 뒤 첫 기록 CTA 노출도 함께 점검한다.

## Hypotheses

| ID | Assumption | Experiment | Metric | Success Threshold |
| --- | --- | --- | --- | --- |
| H1 | 사용자는 HealthKit에 무엇을 저장하고 무엇을 읽는지 명확히 알면 권한 요청 CTA를 더 누른다. | HealthKit 권한 게이트 title/description/access card copy를 데이터 경계 중심으로 조정한다. | HealthKit request rate | baseline 대비 +10% relative 이상, authorization rate -3pp 이하 |
| H2 | 권한 요청 CTA가 "허용"보다 "건강 앱에 수분 기록 저장"처럼 결과를 말하면 시스템 팝업 진입 전 이탈이 줄어든다. | 마지막 온보딩 CTA와 권한 게이트 primary CTA의 문구를 결과 중심으로 조정한다. | HealthKit request rate | baseline 대비 +8% relative 이상, First water log conversion 유지 |
| H3 | 한 번 거부한 사용자는 설정에서 무엇을 켜야 하는지 단계가 보이면 복구 행동이 늘어난다. | sharingDenied 상태의 recovery card를 2단계 안내와 설정/재확인 CTA 순서로 명확히 한다. | Settings recovery rate, Recovery authorization rate | Settings recovery rate +10% relative 이상, refresh 후 authorization rate 악화 없음 |
| H4 | 권한 허용 직후 사용자가 바로 한 잔을 기록하면 핵심 가치 체감이 빨라진다. | 권한 허용 후 Home의 기본 기록 CTA가 첫 화면에서 명확히 보이는지 점검하고, 필요 시 첫 기록 안내 문구를 추가한다. | First water log conversion | baseline 대비 +5% relative 이상 |

## MVP Experiment Plan

### Experiment A: HealthKit Gate Trust Copy

우선순위 1번이다. 온보딩 전체 리디자인 없이 HealthKit 권한 게이트 문구만 조정한다.

변경 후보:

- title: 권한 필요성보다 결과를 먼저 설명한다.
- description: "수분 기록은 건강 앱에 저장", "키와 몸무게는 목표 추천에만 사용"을 분리해 말한다.
- access card: write/read 목적을 짧게 구분한다.
- privacy footnote: 권한은 Apple 건강 앱에서 관리되고 언제든 끌 수 있다는 문장을 유지한다.

측정:

- Primary: HealthKit request rate
- Secondary: HealthKit authorization rate
- Guardrail: First water log conversion

성공:

- 14일 또는 최소 100 gate view 이후 request rate가 baseline 대비 +10% relative 이상
- authorization rate가 baseline 대비 -3pp보다 더 나빠지지 않음
- First water log conversion이 baseline 대비 -3pp보다 더 나빠지지 않음

중단:

- request rate가 baseline 대비 -5% relative 이하
- authorization rate가 -5pp 이상 악화
- 사용자가 권한 범위를 오해할 수 있는 카피가 리뷰에서 발견됨

### Experiment B: Denied Recovery Step Copy

우선순위 2번이다. 권한 거부 사용자의 설정 복구 흐름만 다룬다.

변경 후보:

- recovery card를 "1. 설정에서 건강 권한 켜기", "2. 물리미로 돌아와 다시 확인" 순서로 읽히게 조정한다.
- primary CTA는 설정 이동, secondary CTA는 다시 확인 역할을 유지한다.
- 설정 경로 안내는 현재 문구보다 짧고 행동 중심으로 만든다.

측정:

- Primary: Settings recovery rate
- Secondary: Recovery authorization rate
- Guardrail: `healthkit_permission_refresh_tapped` 후 denied 상태 반복 비율

성공:

- denied segment가 충분한 기간에서 Settings recovery rate가 baseline 대비 +10% relative 이상
- Recovery authorization rate가 baseline 대비 악화되지 않음

중단:

- settings tap은 늘었지만 refresh 후 authorization이 개선되지 않음
- 설정 경로 문구가 OS 버전별 실제 경로와 맞지 않음

## Not Selected For MVP

- 온보딩 화면 순서 전체 변경: 전환 병목이 HealthKit gate 이전인지 먼저 확인해야 한다.
- 외부 A/B 테스트 플랫폼 도입: 현재 규모에서는 Firebase before/after 분석으로 먼저 학습한다.
- 권한 요청을 온보딩 중간에 삽입: 신뢰 문맥이 부족하고 현재 루트 흐름 규칙을 흔든다.

## Event Parameter Review

초기 MVP는 릴리스 전후 비교로 운영하므로 새 이벤트 파라미터가 필요하지 않다.

동시 A/B 테스트를 실행하기로 결정하면 아래 파라미터를 관련 퍼널 이벤트에 추가하는 후속 이슈가 필요하다.

| Parameter | Type | Allowed Values |
| --- | --- | --- |
| `experiment_key` | String | 예: `healthkit_gate_copy_v1` |
| `experiment_variant` | String | `control`, `variant_a`, `variant_b` |

추가 대상 이벤트 후보:

- `onboarding_completed`
- `healthkit_permission_gate_viewed`
- `healthkit_permission_request_tapped`
- `healthkit_permission_authorized`
- `healthkit_permission_denied`
- `healthkit_permission_settings_tapped`
- `healthkit_permission_refresh_tapped`

## Decision Rules

- request rate만 오르고 authorization rate가 떨어지면 CTA가 과장되었을 가능성이 있으므로 롤백한다.
- authorization rate가 오르지만 first water log conversion이 떨어지면 권한 허용 뒤 Home 진입/첫 기록 흐름을 점검한다.
- denied recovery가 개선되지 않으면 설정 경로 안내보다 권한 거부 전 설명 카피를 먼저 개선한다.
- 실험은 한 번에 하나의 주요 가설만 바꾼다.

## Related Docs

- `Docs/product-specs/sign-in-onboarding-healthkit.md`
- `Docs/product-specs/analytics-events.md`
- `Docs/product-specs/analytics-operations.md`
- `Docs/security-privacy.md`
