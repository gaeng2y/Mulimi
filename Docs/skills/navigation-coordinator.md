# navigation-coordinator

## When to use

- 새 화면 push 추가
- 설정/프로필 이동 수정
- 탭 루트 내비게이션 구조 수정

## Goal

Mulimi의 루트 내비게이션 구조를 `ContentView + AppCoordinator` 기준으로 유지한다.

## Rules

- 전역 `NavigationStack`은 `ContentView`
- 공용 push 목적지는 `AppRoute`
- 전역 이동은 `AppCoordinator`
- 탭 내부에 별도 전역 `NavigationStack`을 새로 만들지 않는다

## Where to look

- 루트 내비게이션: `Project/App/Sources/ContentView.swift`
- 라우터: `Project/Presentation/Sources/Navigation/AppCoordinator.swift`
- 목적지 enum: `Project/Presentation/Sources/Navigation/AppRoute.swift`

## Checklist

1. 새 화면이 탭 내부 로컬 상태인지, 앱 전역 push인지 구분한다.
2. 전역 push라면 `AppRoute`에 추가한다.
3. 목적지 조립은 `ContentView.destinationView`에서 처리한다.
4. feature-local sheet는 가능한 한 로컬 상태로 유지한다.

## Validation

```bash
make arch-check
xcodebuild test -workspace Mulimi.xcworkspace -scheme PresentationLayer -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
```
