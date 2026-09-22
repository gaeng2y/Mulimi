# SignIn, Onboarding, HealthKit Gate

## Goal

로그인 이후 사용자가 막히지 않고 메인 화면까지 진입하도록 한다. 권한 요청은 맥락을 설명한 뒤에 수행한다.

## Current Flow

```text
SignIn
  -> Onboarding
  -> HydrationReminderPermissionGate
  -> HealthKitPermissionGate
  -> ContentView
```

수분 리마인더 알림 권한 프라이밍의 상세 규칙은 [Hydration Reminder Priming and Daily Nudges](hydration-reminder-priming.md)를 따른다.

## Product Rules

- 로그인 성공 전에는 메인 기능을 노출하지 않는다.
- 온보딩은 제품 가치와 권한 맥락을 설명하는 짧은 흐름이어야 한다.
- 온보딩 본문과 이전/다음 CTA는 작은 화면과 Accessibility Dynamic Type에서도 스크롤 또는 세로 배치로 접근 가능해야 한다.
- HealthKit 권한은 온보딩 뒤 별도 게이트에서 요청한다.
- 한 번 거부한 권한은 앱 내에서 재요청할 수 없으므로 설정 이동 경로를 안내한다.
- 권한 문구는 시스템 팝업과 앱 내부 화면에서 톤이 어긋나지 않게 유지한다.

## Seven-day Starter Plan (#320)

- 실험 플래그 없이 Debug/Release 모두 제공한다. 기존 온보딩과 권한 게이트는 바꾸지 않는다.
- 기능 도입 뒤 오늘의 양수인 물리미 소유 HealthKit 기록이 처음 조회되면 이 기기에서 안내를 시작한다. 신규·기존 사용자 모두 대상이며, 앱 생애 최초 기록일로 해석하지 않는다. 저장 실패·조회 가능한 기록 없음·다른 앱 기록만 있는 경우는 시작하지 않는다.
- 시작일 포함 기기 달력 기준 7일 동안 메인 기록 탭 상단의 ‘7일 시작 가이드’로 진입한다. 메인 WaterDrop 본문에 카드나 강제 팝업을 추가하지 않는다.
- 1단계는 시작일 이후 실제 남아 있는 물리미 수분 기록, 2단계는 실제 저장된 루틴 하나를 조회해 확인한다. 버튼 탭·편집 취소·저장 실패는 완료가 아니다. 알림 권한 없이 저장한 비활성 루틴도 ‘루틴 저장’에는 해당하며 알림 활성화를 의미하지 않는다.
- 미완료 기록 CTA는 기존 메인 기록 탭으로, 루틴 CTA는 기존 루틴 생성 편집기로 연결한다. 루틴 화면에서 돌아오거나 앱이 다시 활성화되면 상태를 갱신한다.
- 3단계는 홈 화면 위젯 / Apple Watch / Siri·단축어 안내를 읽고 사용할 방법 하나를 선택하는 것이다. 설치·권한 허용·실제 사용을 검증한 상태가 아니다. 위젯과 Watch 앱은 사용자가 직접 추가한다. Watch가 없어도 다른 방법을 선택할 수 있다.
- ‘준비 완료’는 세 단계를 다시 조회해 확인한 뒤 안내를 종료한다. 뒤로 가기는 진행을 유지하고, ‘이 안내 다시 보지 않기’는 영구 닫기다. 완료·닫기·7일 만료 후 새 기록이 생겨도 안내를 다시 시작하지 않는다.
- `hydrationStarterPlan.v1`에는 시작 시각·선택한 방법·완료/닫기 상태만 기기 로컬 UserDefaults에 저장한다. 기록·루틴 사본은 저장하지 않는다. 로그아웃으로 초기화하지 않으며 재설치·다른 기기 동기화는 지원 범위 밖이다.
- 기간 경계·저장소 재생성·실제 데이터 삭제·조회 취소·이벤트 중복은 자동 테스트로 검증한다. D7 리텐션 개선이나 설치 전환 효과는 이번 제품 적용만으로 입증하지 않는다.

수동 설치 안내는 Apple의 [iPhone 위젯 추가](https://support.apple.com/ko-kr/118610), [Apple Watch 앱 설치](https://support.apple.com/ko-kr/109023)를 기준으로 한다. Siri 문구는 기존 `LogWaterAppShortcuts`의 실제 phrase를 사용한다.

## State Expectations

- `signedOut`: 로그인 화면
- `signedIn + onboarding incomplete`: 온보딩
- `signedIn + onboarding complete + 알림 프라이밍 미노출`: 수분 리마인더 알림 권한 프라이밍(1회, 스킵 가능)
- `signedIn + onboarding complete + HealthKit unauthorized`: 권한 게이트
- `signedIn + onboarding complete + HealthKit authorized`: 메인 진입

## Constraints

- 루트 세션 관리는 `AppSession`
- 루트 흐름 전환은 `ContentView` 기준
- 권한 상태를 ViewModel끼리 직접 주고받지 않는다

## Measurement Plan

권한 전환 퍼널은 `AnalyticsUseCase` 추상화를 통해 측정한다. 이벤트 이름과 공통 파라미터는 [Analytics Events](analytics-events.md)를 기준으로 하고, PostHog dashboard와 QA 운영 기준은 [Analytics Operations](analytics-operations.md)를 따른다.

- `onboarding_completed`: 온보딩 마지막 CTA를 눌러 권한 게이트로 진입
- `healthkit_permission_gate_viewed`: HealthKit 권한 게이트 노출
- `healthkit_permission_request_tapped`: HealthKit 권한 요청 CTA 탭
- `healthkit_permission_authorized`: 권한 허용 후 메인 진입 가능 상태
- `healthkit_permission_denied`: 권한 거부 또는 설정 복구 필요 상태
- `healthkit_permission_settings_tapped`: 설정 이동 CTA 탭
- `healthkit_permission_refresh_tapped`: 설정 복귀 후 상태 재확인 CTA 탭

## Experiment Plan

온보딩/권한 게이트 카피나 CTA를 바꾸기 전에는 [Onboarding and HealthKit Conversion Experiments](onboarding-healthkit-conversion-experiments.md)를 기준으로 baseline, 성공 지표, 중단 기준을 먼저 정한다.

초기 MVP는 HealthKit 권한 게이트 신뢰 카피와 권한 거부 후 설정 복구 안내를 우선 실험한다. 온보딩 전체 리디자인이나 권한 요청 시점 변경은 baseline 분석 후 별도 이슈로 분리한다.

## Related Code

- `Project/App/Sources/ContentView.swift`
- `Project/Features/Hydration/Presentation/Sources/View/DrinkWater/HydrationStarterPlanView.swift`
- `Project/Features/Hydration/Presentation/Sources/ViewModel/HydrationStarterPlanViewModel.swift`
- `Project/App/Sources/RootView.swift`
- `Project/Features/Account/Presentation/Sources/View/Authentication/OnboardingView.swift`
- `Project/Features/HydrationReminder/Presentation/Sources/View/HydrationReminderPermissionGateView.swift`
- `Project/Features/Hydration/Presentation/Sources/View/Authentication/HealthKitPermissionGateView.swift`

## Related Docs

- `ARCHITECTURE.md`
- `Docs/product-specs/onboarding-healthkit-conversion-experiments.md`
- `Docs/skills/healthkit-flow.md`
- `Docs/skills/navigation-coordinator.md`
