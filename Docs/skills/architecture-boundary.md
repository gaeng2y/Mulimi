# architecture-boundary

## When to use

- 레이어 이동
- 새 `UseCase`, `Repository`, `DataSource` 추가
- ViewModel 책임 분리
- 아키텍처 리뷰

## Goal

Mulimi의 `Clean Architecture + MVVM` 경계를 유지한다.

## Rules

- `Domain`은 UI와 로컬라이제이션에 의존하지 않는다.
- `Presentation`은 상태와 화면 조합을 담당한다.
- `Data`는 외부 시스템과 저장소 연동을 담당한다.
- `App`은 루트 조립과 타깃 정의를 담당한다.
- `Widget`과 `Watch`는 앱과 다른 도메인 규칙을 만들지 않는다.

## Guardrails

- `Project/Domain`에서 `SwiftUI`, `UIKit`, `WidgetKit`, `Localization` import 금지
- `Project/Presentation/Sources/ViewModel`에서 시스템 side-effect API 직접 접근 금지
- ViewModel 간 직접 타입 참조 금지
- 전역 push는 `ContentView + AppCoordinator`
- `250ml = 1잔`은 `HydrationServing`

## Checklist

1. 이 변경이 어느 레이어 책임인지 먼저 정한다.
2. 인터페이스는 `Domain`, 구현은 `Data`, 표현은 `Presentation`에 둔다.
3. 루트 상태가 필요하면 `AppSession`, 루트 내비게이션이 필요하면 `AppCoordinator`를 본다.
4. `make arch-check`로 구조 위반 여부를 확인한다.

## Validation

```bash
make arch-check
```
