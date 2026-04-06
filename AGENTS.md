# AGENTS.md

Mulimi에 새로 들어온 AI 에이전트를 위한 온보딩 문서다. 이 파일은 백과사전이 아니라 지도다. 세부 설계는 `Docs/`를 읽고, 여기서는 작업 순서와 금지 규칙을 먼저 따른다.

## Purpose

- 목표: Mulimi의 `Clean Architecture + MVVM` 규율 안에서 안전하게 변경한다.
- 원칙: 코드와 문서가 충돌하면 먼저 코드를 확인하고, 필요한 경우 문서를 함께 갱신한다.
- 기준: 작은 기능도 레이어 경계를 흐리지 않는다.

## Read Order

1. 이 파일
2. `README.md`
3. 작업 대상 이슈
4. 관련 도메인 문서
5. 수정 대상 모듈의 `Project.swift`와 실제 구현

## Project Snapshot

- 앱 타깃: `iOS 26.0+`
- 워치 타깃: `watchOS 26.0+`
- 진입 흐름: `SignIn -> Onboarding -> HealthKitPermissionGate -> ContentView`
- 루트 내비게이션: `Project/App/Sources/ContentView.swift`
- 루트 세션 상태: `Project/Presentation/Sources/State/AppSession.swift`
- 공용 라우팅: `Project/Presentation/Sources/Navigation/AppCoordinator.swift`
- 모듈 구조:
  - `App`: 앱 조립과 타깃
  - `Presentation`: View / ViewModel / Coordinator
  - `Domain`: Entity / UseCase / Repository interface
  - `Data`: repository 구현과 외부 시스템 연결
  - `Widget`: WidgetKit / AppIntent
  - `Shared`: DI / Localization / DesignSystem / Persistence / Utils

## Constitution

- `DomainLayerInterface`와 `DomainLayer`는 `SwiftUI`, `Localization`, UI 문구, 심볼 이름에 의존하지 않는다.
- ViewModel은 프레젠테이션 상태만 관리한다. `UIApplication`, `WidgetCenter`, `NotificationCenter`, `Bundle`, `UserDefaults`를 직접 다루지 않는다.
- ViewModel이 다른 ViewModel을 주입받아 상태를 직접 바꾸지 않는다.
- 앱 전역 push 내비게이션은 `ContentView + AppCoordinator`에서 처리한다.
- 수분 기록의 원본 저장소는 `HealthKit`이다. SwiftData hydration 원장을 다시 도입하지 않는다.
- `250ml = 1잔` 규칙은 `HydrationServing`으로만 다룬다. 하드코딩한 `250`을 새로 추가하지 않는다.
- 목표 수분량은 `iCloud KVS + App Group UserDefaults mirror` 정책을 따른다.
- `mainIcon`은 App Group 설정값이다. `mainAppearance`를 새로 확장하지 않는다.
- 신체 정보는 `HealthKit` 기준이다. 직접 입력 플로우를 새로 되살리지 않는다.
- 구조를 바꾸면 `README.md` 또는 관련 `Docs/`를 함께 갱신한다.

## Do

- 변경 전에 관련 모듈의 `Project.swift`와 의존성을 확인한다.
- 비즈니스 규칙은 `Domain`, 시스템 연동은 `Data`, 화면 조합은 `Presentation`에 둔다.
- 기능 추가 시 테스트 가능 단위를 먼저 찾고, 가능하면 `DomainLayer` 또는 `PresentationLayer` 테스트를 갱신한다.
- 설정/세션/라우팅은 기존 `AppSession`, `AppCoordinator`, DI 조립 흐름을 재사용한다.
- 오래된 규칙과 충돌하는 새 구조를 넣었다면 이 파일에 한 줄 규칙을 추가한다.

## Don't

- 도메인 엔티티에 로컬라이제이션 키, 표시 문자열, `systemImage` 같은 표현 로직을 넣지 않는다.
- 임시 해결을 위해 ViewModel에 시스템 API를 다시 집어넣지 않는다.
- 위젯/워치만 따로 다른 수분 계산 규칙을 만들지 않는다.
- 루트 흐름을 무시하고 탭 내부에 새로운 전역 `NavigationStack`을 추가하지 않는다.
- HealthKit 문제를 로컬 캐시 이중 저장으로 덮지 않는다.

## Workflow

1. 이슈와 관련 문서를 읽는다.
2. 수정 대상 레이어를 고른다.
3. 경계를 먼저 확인한다.
4. 코드 변경 후 `make lint`와 `make arch-check`를 우선 통과시킨다.
5. `tuist generate`가 필요한지 판단한다.
6. 최소 검증을 수행한다.
7. 구조가 바뀌면 문서까지 같이 반영한다.

## Lint Harness

- 린트 SSOT: `.swiftlint.yml`
- 공통 실행:
  - `scripts/lint.sh`
  - `scripts/lint-fix.sh`
  - `scripts/check-architecture.sh`
- 로컬 차단:
  - `.githooks/pre-commit`
- CI 차단:
  - `.github/workflows/lint.yml`
- 린트가 실패하면 먼저 수정하고, 실패 로그를 그대로 넘기지 않는다.
- `swiftlint:disable`는 최소 범위만 허용하고 이유를 남긴다.

## Default Validation

- 린트:
  - `make lint`
- 아키텍처 검사:
  - `make arch-check`
- 프로젝트 생성:
  - `tuist generate`
- 도메인 검증:
  - `xcodebuild test -workspace Mulimi.xcworkspace -scheme DomainLayer -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator`
- 프레젠테이션 검증:
  - `xcodebuild test -workspace Mulimi.xcworkspace -scheme PresentationLayer -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator`
- 앱 빌드:
  - `xcodebuild build -workspace Mulimi.xcworkspace -scheme Mulimi -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO`

## Key Docs

- 프로필 구조: `Docs/profile-information-architecture.md`
- 개인화 챌린지: `Docs/personalized-challenge-strategy.md`
- 챌린지 상태: `Docs/challenge-state-model.md`
- 스킬 문서:
  - `Docs/skills/architecture-boundary.md`
  - `Docs/skills/xcode-build-test.md`
  - `Docs/skills/lint-fix-loop.md`
  - `Docs/skills/healthkit-flow.md`
  - `Docs/skills/widget-watch-integration.md`
  - `Docs/skills/navigation-coordinator.md`
- 레거시 저장소 참고:
  - `Docs/swiftdata-cloudkit-sync.md`
  - `Docs/swiftdata-userdefaults-migration.md`
- Xcode Cloud: `Docs/xcode-cloud-release-build.md`

## Skills Index

- `architecture-boundary`
  - 레이어 이동, 새 UseCase/Repository 추가, ViewModel 경계 점검 시 읽는다.
- `xcode-build-test`
  - 구현 후 어떤 순서로 `tuist`, `xcodebuild`, 테스트를 돌릴지 정리한 문서다.
- `lint-fix-loop`
  - `SwiftLint`, 아키텍처 검사, pre-commit/CI 대응 순서를 정리한 문서다.
- `healthkit-flow`
  - 수분 기록, 권한, 신체 정보, 목표 추천 흐름을 다룰 때 읽는다.
- `widget-watch-integration`
  - 위젯, AppIntent, Apple Watch 변경 시 데이터 일관성 규칙을 확인한다.
- `navigation-coordinator`
  - `ContentView`, `AppCoordinator`, 탭 내비게이션 구조를 수정할 때 읽는다.

## Failure Log Rules

- 같은 실수가 두 번 나오면 금지 규칙 한 줄로 이 파일에 추가한다.
- 문서가 실제 코드와 달라졌다면 작업 끝에 바로 맞춘다.
- “일단 여기서만 예외”라는 표현이 필요하면, 설계가 잘못된 것이다.

## Compact Instructions

- `Domain`은 순수해야 한다.
- `Presentation`은 상태와 조합만 담당한다.
- 전역 상태는 `AppSession`, 전역 push는 `AppCoordinator`.
- 수분 기록 원본은 `HealthKit`.
- 단위 변환은 `HydrationServing`.
- 변경 후 `make lint`와 `make arch-check`를 먼저 본다.
- 구조 변경 시 테스트와 문서를 같이 갱신한다.
