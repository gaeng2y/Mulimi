# Growth Scorecard

## Goal

마케팅 실험을 사용자 단위로 결합하지 않고 App Store Connect, 외부 채널, PostHog의 집계 결과로 판정한다. 제품 이벤트 계약은 [Analytics Events](analytics-events.md), 일반 대시보드 운영은 [Analytics Operations](analytics-operations.md)를 따른다.

## Measurement Boundary

| Source | Measures | Join Rule |
| --- | --- | --- |
| App Store Connect | 제품 페이지 조회, 최초 다운로드, 캠페인 성과 | App Store Connect 집계값만 사용 |
| External channel | 노출, 클릭, 영상 유지율, 커뮤니티 반응 | 채널 집계값만 사용 |
| PostHog | 활성화, 기록 빈도, 기능 진입점, 실패율 | PostHog `distinct_id` 안에서만 계산 |

- 서로 다른 source의 user-level join과 campaign ID의 제품 이벤트 전송은 하지 않는다.
- 모든 날짜 경계와 리포트 표기는 `Asia/Seoul`을 사용한다.
- 기본 baseline은 직전 14일이다. 분모가 30 미만이면 28일까지 늘리고, 그래도 30 미만이면 `판정 보류`로 기록한다.
- App Store Connect의 privacy threshold로 값이 숨겨지면 0으로 치환하지 않고 `측정 불가`로 기록한다.
- D7 지표는 D0-D6가 모두 끝난 cohort만 포함한다.

## Release Filter

PostHog insight와 dashboard에는 아래 필터를 공통 적용한다. PostHog iOS SDK가 이미 붙이는 속성을 재사용하며 별도 `build_channel` 이벤트 파라미터는 만들지 않는다.

| Property | Required Value |
| --- | --- |
| `$app_namespace` | `gaeng2y.DrinkWater` |
| `$is_testflight` | `false` |
| `$is_sideloaded` | `false` |
| `$is_emulator` | `false` |

로컬·Debug 빌드는 유효한 PostHog 설정이 없으면 `NoOpAnalyticsRepository`를 사용한다. 위 필터는 설정이 주입된 내부 빌드까지 Release 집계에 섞이는 것을 막는 최종 경계다.

## Metrics

### North Star

| Metric | Exact Definition | Source / View | Target | Alert |
| --- | --- | --- | --- | --- |
| D7 3일 수분 기록률 | 분모 중 D0-D6의 서로 다른 KST 날짜 3일 이상 `water_logged`한 사용자 / 활성화 분모 | PostHog SQL insight, weekly cohort line | baseline 대비 상대 +10% | 성숙 분모 30 이상에서 baseline의 85% 미만이 2회 연속 |

활성화 분모는 동일 `distinct_id`에서 다음 순서를 만족한 사용자다.

1. 첫 `onboarding_completed`
2. 이후 첫 `healthkit_permission_authorized`
3. 온보딩 완료 24시간 안의 첫 `water_logged`
4. 첫 기록의 KST 날짜를 D0로 두었을 때 D6가 종료된 cohort

`+10%`는 퍼센트포인트가 아닌 상대 개선이다. 예를 들어 baseline 20%의 목표는 22%다.

### Input And Health Metrics

| Metric | Exact Definition | Source / View | Target / Guardrail |
| --- | --- | --- | --- |
| App Store 전환율 | 최초 다운로드 / 제품 페이지 조회 | App Store Connect Trends | 실험별 baseline 대비 상대 개선 |
| 캠페인 D7 재방문 | 캠페인 최초 다운로드 cohort의 D7 앱 사용률 | App Store Connect campaign | privacy threshold 충족 시에만 판정 |
| 24시간 활성화율 | 위 순차 퍼널을 24시간 안에 완료한 unique users / `onboarding_completed` unique users | PostHog Funnel | baseline 대비 상대 개선 |
| 기록 source mix | `water_logged` event count의 `source`별 비중 | PostHog Trends, stacked area | allowlist 밖 `source` 0건 |
| 공유 CTA 사용자 | `action == share`인 기존 CTA event의 unique users | PostHog Trends | 실제 공유 UI 출시 뒤 설정 |
| HealthKit 기록 실패율 | `failure_reason == healthkit_write_failed`인 `water_log_failed` 수 / (`water_logged` 수 + 해당 실패 수) | PostHog Trends formula | baseline의 120% 초과 시 조사 |
| 이벤트 수집 건전성 | 대표 행동 1회당 기대 이벤트 1회, 필수 파라미터 누락 0건 | PostHog Activity | 위반 0건 |
| 스키마·privacy 건전성 | 미등록 event/property 및 금지 파라미터 건수 | Activity 표본 감사 | 위반 0건 |

현재 제품 범위에 revenue 지표는 두지 않는다. 수익 모델이 생기기 전까지 임의의 business KPI를 추가하지 않는다.

## PostHog Saved Insights

| Saved Name | Type | Configuration |
| --- | --- | --- |
| `Growth | NSM | D7 3-day hydration rate` | SQL | 위 North Star 분모·분자, KST 주간 cohort, Release filter |
| `Growth | Activation | 24h first log` | Funnel | `onboarding_completed -> healthkit_permission_authorized -> water_logged`, 순차, unique users, 24시간 window, incomplete period 제외 |
| `Growth | Retention | D0-D6 water logging` | Retention | start/return 모두 `water_logged`, daily, activated cohort filter |
| `Growth | Engagement | water source mix` | Trends | `water_logged` total count, `source` breakdown, stacked area |
| `Growth | Health | HealthKit write failure` | Trends formula | 실패 event count / (성공 + 실패), line |

North Star SQL은 다음 알고리즘을 그대로 구현한다. Retention chart는 진단용이며 복합 활성화 분모를 대신하지 않는다.

1. Release filter를 적용한 세 이벤트만 읽는다.
2. 사용자별 첫 온보딩, 그 이후 첫 권한 허용, 그 이후 첫 기록을 순서대로 구한다.
3. 첫 기록이 온보딩 후 24시간 이내인 사용자만 남긴다.
4. 첫 기록 KST 날짜가 현재 KST 날짜보다 7일 이상 이전인 사용자만 분모로 둔다.
5. 각 사용자의 첫 기록 KST 날짜부터 여섯 번째 다음 날짜까지(D0-D6) `water_logged`가 발생한 서로 다른 KST 날짜 수를 센다.
6. 날짜 수가 3 이상인 사용자 수를 분자로 나눈다.

Dashboard 이름은 `Growth Scorecard`로 하고 아래 순서만 유지한다.

```text
North Star              Activation / D0-D6 retention
App Store / campaign   Source mix / sharing
HealthKit failure      Collection / schema QA
```

App Store Connect와 외부 채널 panel은 해당 시스템의 집계값과 원본 링크를 실험 기록에 붙인다. PostHog에 복사해 사용자 데이터를 결합하지 않는다.

## Experiment Record

```md
### <experiment name>

- Hypothesis:
- Channel:
- Campaign name/link:
- Run: YYYY-MM-DD HH:mm KST - YYYY-MM-DD HH:mm KST
- Baseline: 14 days / 28 days
- Primary metric:
- Numerator / denominator:
- Health metric result:
- Result: value, relative change, sample size
- Data limitation: none / privacy threshold / immature cohort / collection issue
- Decision: 확대 / 개선 후 재실험 / 중단 / 판정 보류
- Evidence: App Store Connect / external channel / PostHog links
- Owner / next review:
```

App Store campaign 이름은 30자 이하로 유지하고 `channel_content_yyyymm` 형식을 우선 사용한다. 캠페인 집계가 보이기 전 최소 최초 다운로드 수와 처리 시간은 App Store Connect 표시 기준을 따른다.

### Decision Rule

- `확대`: 표본 기준을 충족하고 primary metric 목표를 달성했으며 health guardrail 위반이 없다.
- `개선 후 재실험`: 표본은 충분하지만 목표 미달이고 개선할 단일 가설이 남아 있다.
- `중단`: 표본이 충분한데 baseline보다 악화됐거나 health guardrail을 위반했다.
- `판정 보류`: 분모 30 미만, privacy threshold, D7 미성숙, 수집 오류 중 하나가 있다.

## Release And QA Runbook

### Before Release

- Xcode Cloud의 `POSTHOG_PROJECT_TOKEN`, `POSTHOG_HOST`, `POSTHOG_CLI_ENV_ID`, `POSTHOG_CLI_TOKEN` 검증이 성공했는지 확인한다.
- 저장된 모든 insight에 Release filter와 KST가 적용됐는지 확인한다.
- [Analytics Events](analytics-events.md)의 event/property allowlist와 현재 코드를 대조한다.

### Release Activity Check

Release 배포마다 대표 흐름을 한 번 수행하고 PostHog Activity에서 아래를 확인한다.

- `onboarding_completed -> healthkit_permission_authorized -> water_logged`가 행동당 1회 도착한다.
- 필수 파라미터와 SDK Release filter 속성이 존재한다.
- 건강 원본 값, 자유 입력 텍스트, 이메일, 광고 식별자가 없다.
- 검증 기록에 앱 version/build, KST 시각, 담당자, Activity 링크를 남긴다.

### 72-Hour Audit

- 신규 event/property가 allowlist 밖에 없는지 확인한다.
- 필수 파라미터 누락과 비정상적인 event 중복을 확인한다.
- Debug/TestFlight/Simulator 값이 scorecard에서 제외되는지 확인한다.
- 위반이 있으면 해당 기간의 실험 판정을 멈추고 당일 수정 이슈를 만든다.

## Cadence And Ownership

| Cadence | Review | Response |
| --- | --- | --- |
| Release + 72 hours | Activity, schema, privacy, Release filter | 프로젝트 운영자가 당일 차단·수정 이슈 생성 |
| Weekly | North Star, activation, source mix, HealthKit failure | 2회 연속 alert면 다음 주간 리뷰에서 원인과 owner 지정 |
| Per experiment | primary/health metrics와 표본 조건 | 종료 시 네 가지 decision 중 하나 기록 |
| Monthly | App Store, campaign, external channel 집계 | 유지할 채널과 다음 실험 선택 |

## Deferred Scope

- Widget extension과 Watch 앱은 현재 PostHog 초기화 경로를 공유하지 않으므로 해당 기록은 scorecard에 완전하게 잡히지 않는다. 확장은 별도 이슈에서 다룬다.
- 공유 UI가 실제 추가될 때만 기존 `insight_cta_tapped` 또는 `challenge_cta_tapped`에 `action=share`와 필요한 allowlist/test를 함께 추가한다. 그 전에는 공유 이벤트를 만들지 않는다.
- 외부 채널 attribution과 제품 이벤트의 user-level 결합은 도입하지 않는다.

## References

- App Store Connect Campaign Links: https://developer.apple.com/help/app-store-connect-analytics/acquisition/campaign-links
- App Store Connect Metrics: https://developer.apple.com/help/app-store-connect-analytics/reference/metrics-definitions
- PostHog Funnels: https://posthog.com/docs/product-analytics/funnels
- PostHog Trends: https://posthog.com/docs/product-analytics/trends/overview
- PostHog Retention: https://posthog.com/docs/product-analytics/retention
