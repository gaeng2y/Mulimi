# ARCHITECTURE

Mulimi의 구조 SSOT다. 제품 설명은 `README.md`, 작업 규칙은 `AGENTS.md`, 세부 기능 요구는 `Docs/product-specs/`, 실행 기록은 `Docs/exec-plans/`에 둔다.

## Goals

- `Clean Architecture + MVVM` 규율을 유지한다.
- 앱, 위젯, 워치가 같은 비즈니스 규칙을 보도록 한다.
- 시스템 연동과 화면 조합을 분리해 변경 비용을 낮춘다.

## System Map

```text
Project/
├── App
├── Presentation
├── Domain
├── Data
├── Widget
└── Shared
```

## Layer Responsibilities

### App
- 앱 타깃, 엔트리포인트, 루트 조립
- `ContentView`와 앱 수준 흐름 연결

### Presentation
- `View`, `ViewModel`, `Coordinator`
- 화면 상태, 포맷된 프레젠테이션 모델, 라우팅 조합
- 시스템 API 직접 호출은 지양하고 필요한 경우 추상화 뒤에서 사용

### Domain
- 엔티티, 유스케이스, 저장소 인터페이스
- UI 문구, 로컬라이제이션, 심볼 이름에 의존하지 않는 비즈니스 규칙

### Data
- `Repository` 구현
- `HealthKit`, `UserDefaults`, `iCloud KVS`, 알림 등 외부 시스템 연동

### Widget
- `WidgetKit`, `AppIntent`, 위젯별 표현 조합

### Shared
- `DependencyInjection`, `Localization`, `DesignSystem`, `Persistence`, `Utils`

## Dependency Direction

```text
App -> Presentation -> Domain interfaces
App -> Data -> Domain interfaces
Widget -> Domain interfaces / Shared / AppIntent glue
Presentation -> Shared
Data -> Shared
Domain -> no UI dependency
```

## Core User Flow

```text
SignIn
  -> Onboarding
  -> HealthKitPermissionGate
  -> ContentView
```

- 루트 세션 상태는 `AppSession`
- 전역 push 내비게이션은 `ContentView + AppCoordinator`
- 탭 내부에 새 전역 `NavigationStack`을 추가하지 않는다

## Source of Truth

| Concern | Source of Truth | Notes |
| --- | --- | --- |
| 수분 섭취 기록 | `HealthKit` | 앱, 위젯, 워치가 같은 기록 기준을 본다 |
| 신체 정보 | `HealthKit` | 직접 입력 플로우를 되살리지 않는다 |
| 목표 수분량 | `iCloud KVS + App Group UserDefaults mirror` | 다중 디바이스 동기화 기준 |
| 메인 아이콘 | App Group `UserDefaults` | `mainIcon`만 사용 |
| 온보딩 완료 여부 | `UserDefaults` | 로컬 상태 |
| 루틴 | `UserDefaults` JSON | 현재 로컬 저장 기반 |
| 챌린지 상태 | 앱 계산 + 저장 상태 merge | 세부 규칙은 관련 문서 참조 |

## Non-Negotiable Rules

- `DomainLayerInterface`와 `DomainLayer`는 `SwiftUI`, `Localization`, UI 문구에 의존하지 않는다.
- ViewModel은 프레젠테이션 상태만 관리한다.
- ViewModel이 다른 ViewModel의 상태를 직접 변경하지 않는다.
- `250ml = 1잔` 규칙은 `HydrationServing`으로만 다룬다.
- 앱/워치가 함께 써야 하는 수분 단위, next-action, 루틴 수행률 계산은 `Project/Domain/SharedInterfaces/`에 둔다.
- HealthKit 문제를 로컬 수분 원장 이중 저장으로 덮지 않는다.
- 워치/위젯이 앱과 다른 수분 계산 규칙을 만들지 않는다.

## Documentation Map

- 제품/기능 요구: `Docs/product-specs/`
- 깊은 설계 배경: `Docs/*.md`
- 작업 계획/결정 기록: `Docs/exec-plans/`
- 구현 전 체크리스트: `Docs/skills/`
- 변경 유형별 검증 기준: `Docs/quality-gates.md`
- 문서 유지보수 기준: `Docs/documentation-maintenance.md`

## When To Update This File

- 레이어 책임이 바뀔 때
- Source of truth가 바뀔 때
- 루트 흐름 또는 전역 내비게이션 구조가 바뀔 때
- 앱, 위젯, 워치 사이 경계 규칙이 달라질 때
