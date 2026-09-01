# navigation-coordinator

## When to use

- 새 화면 push 추가
- 설정/프로필 이동 수정
- 탭 루트 내비게이션 구조 수정

## Goal

Mulimi의 루트 내비게이션 구조를 `ContentView + AppCoordinator` 기준으로 유지한다.

## Rules

- 전역 `NavigationStack`은 `ContentView`
- 전역 이동은 `AppCoordinator` (App 레이어 `MulimiNavigation` 타깃)
- feature는 `AppCoordinator`/`AppRoute`를 직접 참조하지 않는다. feature 화면에서 시작하는 push는 feature 소유 라우트 값(예: Account의 `AccountRoute`)을 `NavigationLink(value:)`로 밀거나, App이 배선한 클로저로 의도만 전달한다.
- App 내부에서만 push하는 목적지(딥링크, 클로저 배선)는 `AppRoute`
- 탭 내부에 별도 전역 `NavigationStack`을 새로 만들지 않는다

## Where to look

- 루트 내비게이션: `Project/App/Sources/ContentView.swift`
- 라우터: `Project/App/Navigation/Sources/AppCoordinator.swift`
- App 라우트 enum: `Project/App/Navigation/Sources/AppRoute.swift`
- feature 라우트 예시: `Project/Features/Account/Presentation/Sources/Navigation/AccountRoute.swift`

## Checklist

1. 새 화면이 탭 내부 로컬 상태인지, 앱 전역 push인지 구분한다.
2. feature 화면에서 시작하는 push라면 해당 feature의 라우트 enum에 추가한다. App만 push하면 `AppRoute`에 추가한다.
3. 목적지 조립은 `ContentView.destinationView`에서 처리한다. 새 라우트 타입은 `navigationDestination(for:)`를 추가한다.
4. feature-local sheet는 가능한 한 로컬 상태로 유지한다.

## Validation

```bash
make arch-check
xcodebuild test -workspace Mulimi.xcworkspace -scheme MulimiNavigation -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
```
