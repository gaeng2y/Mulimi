<p align="center">
  <img src="https://github.com/gaeng2y/Mulimi/blob/main/Images/app%20icon.png?raw=true" width="300" height="300">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/iOS-26.0%2B-0A84FF?style=for-the-badge&logo=apple&logoColor=white" alt="iOS 26.0+">
  <img src="https://img.shields.io/badge/watchOS-26.0%2B-111111?style=for-the-badge&logo=applewatch&logoColor=white" alt="watchOS 26.0+">
  <img src="https://img.shields.io/badge/Swift-6.0-F05138?style=for-the-badge&logo=swift&logoColor=white" alt="Swift 6.0">
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Clean_Architecture-MVVM-1A73E8?style=for-the-badge" alt="Clean Architecture + MVVM">
  <img src="https://img.shields.io/badge/Tuist-Modular_Project-00B4D8?style=for-the-badge" alt="Tuist">
  <img src="https://img.shields.io/badge/HealthKit-Source_of_Truth-D32F2F?style=for-the-badge" alt="HealthKit">
</p>
<p align="center">
  <img src="https://img.shields.io/badge/WidgetKit-Home_%26_Lock_Screen-0F766E?style=for-the-badge" alt="WidgetKit">
  <img src="https://img.shields.io/badge/Watch_App-MulimiWatch-374151?style=for-the-badge" alt="Watch App">
  <img src="https://img.shields.io/badge/Firebase-Analytics_%26_Crashlytics-FF6F00?style=for-the-badge&logo=firebase&logoColor=white" alt="Firebase">
</p>

## 물리미 (Mulimi)

- 앱스토어 링크: [링크](https://apps.apple.com/us/app/%EB%AC%BC%EB%A6%AC%EB%AF%B8/id6451200968)

물리미는 `HealthKit` 기반으로 수분 섭취를 기록하고, 목표량 관리, 루틴, 챌린지, 위젯, Apple Watch 앱까지 한 흐름으로 연결한 수분 트래커입니다.

## ✨ 주요 기능

- `HealthKit` 기반 수분 기록 및 오늘 섭취량 집계
- 로그인 후 `온보딩 -> HealthKit 권한 게이트 -> 메인 화면` 흐름
- 일일 목표량 설정 및 AI 기반 목표량 추천
- 수분 기록 히스토리, 인사이트, 챌린지, 루틴 관리
- 홈 화면/잠금화면 위젯과 Apple Watch 앱 지원

## 🛠️ 기술 스택

- `Swift 6.0`, `SwiftUI`, `Swift Concurrency`
- `Tuist` 기반 모듈형 프로젝트
- `HealthKit`, `WidgetKit`, `AppIntents`
- `Firebase Analytics`, `Firebase Crashlytics`
- `Swinject` 기반 의존성 주입

## 🏗️ 아키텍처

물리미는 `Clean Architecture + MVVM` 기준으로 레이어를 분리합니다.

- `App`
  - 앱 진입점, `ContentView`, 루트 조립
  - iOS 앱, 위젯, watch 앱 타깃 정의
- `Presentation`
  - SwiftUI View / ViewModel
  - `AppCoordinator`, `AppSession` 등 화면 상태와 라우팅
- `Domain`
  - Entity, UseCase, Repository 인터페이스
  - UI/로컬라이제이션 의존성이 없는 비즈니스 규칙
- `Data`
  - Repository 구현체, HealthKit/UserDefaults/iCloud KVS 연동
- `Shared`
  - `DependencyInjection`, `Localization`, `DesignSystem`, `Persistence`, `Utils`
- `Widget`
  - 홈 화면/잠금화면 위젯과 AppIntent

### 앱 흐름

```text
SignIn
  -> Onboarding
  -> HealthKitPermissionGate
  -> ContentView
```

- 루트 내비게이션은 `ContentView`의 단일 `NavigationStack`에서 관리합니다.
- 탭 간 공용 이동은 `AppCoordinator`와 `AppRoute`로 처리합니다.
- 인증 상태는 `AppSession`으로 관리하고, ViewModel 간 직접 결합을 줄였습니다.

## 💾 데이터/저장소 전략

| 항목 | 현재 원본 저장소 | 비고 |
|---|---|---|
| 수분 섭취 기록 | `HealthKit` | 앱/위젯/워치가 같은 수분 기록 기준을 봅니다. |
| 신체 정보(키/몸무게) | `HealthKit` | 추천 기능과 프로필 화면에서 사용합니다. |
| 목표 수분량 | `iCloud KVS` + App Group `UserDefaults` 미러 | 같은 Apple 계정 목표량 동기화용입니다. |
| `mainIcon` | App Group `UserDefaults` | 앱과 위젯이 같은 메인 심볼 설정을 공유합니다. |
| 온보딩 완료 여부 | `UserDefaults` | 로컬 상태입니다. |
| 루틴 | `UserDefaults`(JSON) | 현재는 로컬 저장 기반입니다. |
| 챌린지 배지 이력 | `UserDefaults`(JSON) | 완료 이력 표시용입니다. |

## 📁 프로젝트 구조

```text
Mulimi/
├── Project/
│   ├── App/
│   │   ├── Sources/
│   │   └── Watch/
│   ├── Domain/
│   │   ├── Interfaces/
│   │   ├── Sources/
│   │   ├── WatchInterfaces/
│   │   └── WatchSources/
│   ├── Data/
│   │   ├── Sources/
│   │   └── WatchSources/
│   ├── Presentation/
│   │   ├── Sources/
│   │   ├── Tests/
│   │   └── WatchSources/
│   ├── Widget/
│   │   ├── Sources/
│   │   └── Resources/
│   └── Shared/
│       ├── DependencyInjection/
│       ├── DesignSystem/
│       ├── Localization/
│       ├── Persistence/
│       └── Utils/
├── Tuist/
├── XCConfig/
├── Docs/
└── ci_scripts/
```

### 대표 모듈

- `Project/App`
  - `Mulimi`, `WidgetExtension`, `MulimiWatch`, `MulimiWatchExtension`
- `Project/Domain`
  - `DomainLayerInterface`, `DomainLayer`
  - `WatchDomainLayerInterface`, `WatchDomainLayer`
- `Project/Data`
  - `DataLayer`, `WatchDataLayer`
- `Project/Presentation`
  - `PresentationLayer`, `WatchPresentationLayer`
- `Project/Shared/DependencyInjection`
  - `DependencyInjection`, `WatchDependencyInjection`

## 🚀 시작하기

### 권장: Makefile 사용

```bash
make setup TEAM_ID=YOUR_APPLE_DEVELOPER_TEAM_ID
```

이 명령은 아래 작업을 순서대로 수행합니다.

1. `XCConfig/Secrets.xcconfig` 생성
2. `tuist install`
3. `tuist generate`
4. `git hooks` 경로 설정

### 수동 설정

1. 저장소 복제

```bash
git clone https://github.com/gaeng2y/Mulimi.git
cd Mulimi
```

2. Tuist 설치

```bash
curl https://mise.run | sh
mise install tuist
```

3. 팀 설정

- `XCConfig/Secrets.xcconfig.template`를 복사해 `XCConfig/Secrets.xcconfig` 생성
- `DEVELOPMENT_TEAM` 값을 본인 Apple Developer Team ID로 설정

4. 의존성 설치 및 프로젝트 생성

```bash
tuist install
tuist generate
```

5. 생성된 `Mulimi.xcworkspace`를 Xcode에서 엽니다.

### 개발용 명령

```bash
make hooks
make lint
make lint-fix
make arch-check
make verify
```

## ✅ 개발 환경 메모

- `iOS 26.0+`, `watchOS 26.0+` 타깃을 사용합니다.
- iOS 26 SDK가 포함된 Xcode가 필요합니다.
- 일부 기능은 `HealthKit`, `iCloud`, `Apple Watch`, `WidgetKit` capability 설정이 필요합니다.

## 📚 문서

- [프로필 정보 구조](Docs/profile-information-architecture.md)
- [개인화 챌린지 전략](Docs/personalized-challenge-strategy.md)
- [챌린지 상태 모델](Docs/challenge-state-model.md)
- [Xcode Cloud Release Build](Docs/xcode-cloud-release-build.md)
