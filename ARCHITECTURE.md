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
├── Core
├── Features
│   ├── Account
│   ├── Challenge
│   ├── Hydration
│   ├── HydrationReminder
│   ├── Routine
│   └── WatchHydration
├── Widget
└── Shared
```

## Layer Responsibilities

### App
- 앱 타깃, 엔트리포인트, 루트 조립
- 조립 루트 `DependencyInjection`(`Project/App/DependencyInjection`) 소유 — 소비자는 실행 타깃뿐이다
- `ContentView`와 앱 수준 흐름 연결
- 전역 내비게이션 소유: `MulimiNavigation` 타깃(`AppCoordinator`, `AppRoute`). feature는 coordinator를 직접 알지 않고 feature 소유 라우트 값 또는 클로저로 의도만 전달한다.

### Feature Presentation
- `View`, `ViewModel`, `Coordinator`
- 화면 상태, 포맷된 프레젠테이션 모델, 라우팅 조합
- 시스템 API 직접 호출은 지양하고 필요한 경우 추상화 뒤에서 사용

### Feature Domain
- 엔티티, 유스케이스, 저장소 인터페이스
- UI 문구, 로컬라이제이션, 심볼 이름에 의존하지 않는 비즈니스 규칙

### Feature Data
- `Repository` 구현
- `HealthKit`, `UserDefaults`, `iCloud KVS`, 알림 등 외부 시스템 연동

### Core
- `Project/Core`는 시스템 인프라 서비스 레이어로, 비즈니스 기능·UI를 소유하지 않고 feature나 Localization에 역방향 의존하지 않는다.
- `Project/Core/Analytics`: `MulimiAnalytics`(분석 계약)와 `MulimiAnalyticsData`(PostHog 구현). 분석 소비자는 `MulimiAnalytics`만 의존하고, `MulimiAnalyticsData`는 DI 조립(`DataAssembly`)에서만 사용한다.
- `Project/Core/Platform`: `MulimiPlatform`. `Bundle`·`WidgetCenter` 등 시스템 API를 프레젠테이션이 직접 만지지 않게 하는 어댑터(`AppInfoProviding`, `WidgetTimelineReloading`)를 가진다.
- `Project/Core/Keychain`: `MulimiKeychain`. String 키 기반 범용 Keychain 저장소(`KeychainStoring`). feature Data가 자기 키 체계를 얹어 사용한다.
- `Project/Core/CloudKit`: `MulimiCloudKit`(iOS+watchOS). iCloud KVS 원본 + 로컬 UserDefaults 미러 규칙을 구현한 `UbiquitousMirroredStore`를 가진다. 목표 수분량 동기화의 단일 구현이며 Account Data와 WatchHydration Data가 함께 사용한다.

### Features
- `Account`, `Hydration`, `Routine`, `Challenge`, `HydrationReminder`는 각각 `Domain`, `Data`, `Presentation` 타깃을 가진다.
- `WatchHydration`도 Watch 전용 `Domain`, `Data`, `Presentation` 타깃을 가진다.

### Widget
- `WidgetKit`, `AppIntent`, 위젯별 표현 조합

### Shared
- `Localization`, `DesignSystem`, `Persistence`, `Utils`

## Dependency Direction

```text
App -> Feature Presentation
App / DependencyInjection -> Feature Presentation + Feature Data + Feature Domain
Feature Presentation -> Feature Domain
Feature Data -> Feature Domain
Widget -> AccountDomain + HydrationDomain + RoutineDomain
ChallengeDomain -> RoutineDomain -> HydrationDomain -> AccountDomain
Feature Presentation / Data -> Shared as needed
Feature Domain -> no UI dependency
```

## Core User Flow

```text
SignIn
  -> Onboarding
  -> HydrationReminderPermissionGate
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

- 기능 모듈의 `Domain`은 UI, 로컬라이제이션, `Data`, `Presentation`에 의존하지 않는다.
- ViewModel은 프레젠테이션 상태만 관리한다.
- ViewModel이 다른 ViewModel의 상태를 직접 변경하지 않는다.
- `250ml = 1잔` 규칙은 `HydrationServing`으로만 다룬다.
- 앱/워치가 함께 쓰는 `HydrationServing`, `HydrationWriteResult`, `HydrationNextActionGuide`는 `Hydration` 소스를 `WatchHydrationDomain`에서도 컴파일한다.
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
