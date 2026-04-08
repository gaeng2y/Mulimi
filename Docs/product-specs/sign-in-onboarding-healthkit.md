# SignIn, Onboarding, HealthKit Gate

## Goal

로그인 이후 사용자가 막히지 않고 메인 화면까지 진입하도록 한다. 권한 요청은 맥락을 설명한 뒤에 수행한다.

## Current Flow

```text
SignIn
  -> Onboarding
  -> HealthKitPermissionGate
  -> ContentView
```

## Product Rules

- 로그인 성공 전에는 메인 기능을 노출하지 않는다.
- 온보딩은 제품 가치와 권한 맥락을 설명하는 짧은 흐름이어야 한다.
- HealthKit 권한은 온보딩 뒤 별도 게이트에서 요청한다.
- 한 번 거부한 권한은 앱 내에서 재요청할 수 없으므로 설정 이동 경로를 안내한다.
- 권한 문구는 시스템 팝업과 앱 내부 화면에서 톤이 어긋나지 않게 유지한다.

## State Expectations

- `signedOut`: 로그인 화면
- `signedIn + onboarding incomplete`: 온보딩
- `signedIn + onboarding complete + HealthKit unauthorized`: 권한 게이트
- `signedIn + onboarding complete + HealthKit authorized`: 메인 진입

## Constraints

- 루트 세션 관리는 `AppSession`
- 루트 흐름 전환은 `ContentView` 기준
- 권한 상태를 ViewModel끼리 직접 주고받지 않는다

## Related Code

- `Project/App/Sources/ContentView.swift`
- `Project/Presentation/Sources/View/RootView.swift`
- `Project/Presentation/Sources/View/Authentication/OnboardingView.swift`
- `Project/Presentation/Sources/View/Authentication/HealthKitPermissionGateView.swift`

## Related Docs

- `ARCHITECTURE.md`
- `Docs/skills/healthkit-flow.md`
- `Docs/skills/navigation-coordinator.md`
