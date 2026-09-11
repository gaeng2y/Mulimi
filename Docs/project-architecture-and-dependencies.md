# 프로젝트 전체 구조와 의존성

기준: `main`의 `c997f8659189ce5602d58a6311d5927199481d8c`, Mulimi **2.5.0 (33)**. 실제 `Project.swift` 17개와 진입점·DI·저장 구현을 확인한 스냅샷이다.

[전체 구조도 열기](diagrams/mulimi-project-architecture.html) · [다이어그램 원본 JSON](diagrams/mulimi-project-architecture.json) · [라이트·다크 화면 검증](diagrams/mulimi-project-architecture.visual-check.html)

## 읽는 방법

구조도는 11개 묶음으로 주요 의존 방향을 보여준다. 모든 간선을 그린 타깃 그래프는 아니며, 아래 표가 **선언된 53개 타깃과 직접 의존 선언 169개 전체**를 담는다. 이 중 15개는 테스트 타깃이고, 의존 선언은 내부 타깃 165개와 외부 제품 참조 4개다. Apple SDK의 암시적 링크와 전이 의존성은 이 개수에 포함하지 않는다.

화살표 `A → B`는 A가 B를 참조한다는 뜻이다. DI의 객체 조립, 프레임워크 링크, 앱의 확장 포함은 같은 실행 호출 흐름이 아니다. 특히 `Data → Domain`은 Repository 계약 구현에 필요한 **컴파일 의존 방향**이다. 실행 시에는 ViewModel이 UseCase를 호출하고, 주입된 Repository 구현이 시스템에 접근한다.

설명은 한국어이며 코드 식별자는 그대로 유지했다. archify의 고정 Viewer UI와 `<html lang>`는 지원 범위에 따라 영어다.

## 디렉터리와 소유권

```text
Project/
├── App/
│   ├── Project.swift            Mulimi·위젯·Watch·내비게이션 타깃
│   ├── Sources/                 앱 진입·RootView·ContentView·AppIntent
│   ├── Navigation/              MulimiNavigation: AppCoordinator·라우팅
│   ├── DependencyInjection/     iOS·Watch·미리보기·테스트 조립 루트
│   └── Watch/                   Watch 앱 진입·리소스·설정
├── Features/
│   ├── Account/                 인증·온보딩·설정·AppSession
│   ├── Hydration/               수분 기록·신체 정보·목표 추천
│   ├── Routine/                 루틴·루틴 알림·이행도
│   ├── Challenge/               챌린지·개인화·배지
│   ├── HydrationReminder/       수분 알림·권한
│   ├── WatchHydration/          Watch 전용 수분 기록·목표 조회
│   └── TestSupport/             테스트 타깃에 포함하는 공용 Mock 소스
├── Core/
│   ├── Analytics/               MulimiAnalytics + MulimiAnalyticsData
│   ├── Platform/                MulimiPlatform
│   ├── CloudKit/                MulimiCloudKit
│   ├── HealthKit/               MulimiHealthKit
│   └── Keychain/                MulimiKeychain
├── Shared/
│   ├── Localization/
│   ├── DesignSystem/
│   ├── Utils/
│   └── Persistence/             선언만 남은 Persistence·PersistenceWatch
└── Widget/                     위젯 소스·리소스; 타깃은 App에서 선언
```

각 기능은 `Domain / Data / Presentation`으로 나뉘며 Clean Architecture + MVVM을 따른다. iOS와 Watch의 최소 버전은 모두 26.0이다. `Workspace.swift`의 시작 프로젝트는 `Project/App`이고, 필요한 프로젝트를 의존성으로 따라간다. 따라서 저장소의 모든 선언이 제품 앱에서 사용된다는 뜻은 아니다.

`AppSession`은 **AccountPresentation**, `AppCoordinator`는 **App 소유의 MulimiNavigation**이다. 둘 다 Core 소속이 아니다. `TestSupport`는 독립 타깃이 아니라 여러 테스트 타깃에 소스로 포함된다.

## 실행·공유 경계

- iOS 진입: `DrinkWaterApp → RootView`. 인증 후 `Onboarding → HydrationReminderPermissionGate → HealthKitPermissionGate → ContentView` 순서로 진입한다. 전역 push는 `ContentView + AppCoordinator`가 담당한다.
- iOS DI: `DataAssembly / DomainAssembly / PresentationAssembly`가 Swinject로 구현·UseCase·ViewModel을 연결한다. 제품, Preview, Testing은 별도 타깃으로 선언돼 있다.
- 위젯: `WidgetExtension`은 Account·Hydration·Routine Domain과 제품 DI를 재사용한다. `LogWaterAppIntent.swift`는 앱과 위젯 양쪽 타깃에서 컴파일한다.
- Watch: `MulimiWatch → MulimiWatchExtension → WatchDependencyInjection`. `WatchDIContainer`는 Swinject 없이 Repository·UseCase·ViewModel을 직접 조립한다.
- Watch의 `HydrationServing`, `HydrationWriteResult`, `HydrationNextActionGuide`는 iOS Hydration의 **동일 소스 파일을 별도 컴파일**한다. `WatchHydrationDomain → HydrationDomain`이라는 타깃 의존성은 없다.
- `MulimiCloudKit`과 `MulimiHealthKit`은 iOS·watchOS 공용 타깃이다. `MulimiCloudKit`의 현재 구현은 CloudKit 레코드 DB가 아니라 `NSUbiquitousKeyValueStore`와 UserDefaults mirror다.

## 기능 간 직접 의존에서 주의할 점

`ChallengeDomain → RoutineDomain → HydrationDomain → AccountDomain`이라는 주요 줄기 외에도 `ChallengeDomain → HydrationDomain`, `RoutineDomain → AccountDomain` 직접 참조가 있다. `HydrationReminderDomain`과 `WatchHydrationDomain`에는 선언된 타깃 의존성이 없다.

Presentation은 자기 Domain만 참조하는 구조가 아니다. 예를 들어 `AccountPresentation`은 `HydrationPresentation`과 `RoutinePresentation`을, `ChallengePresentation`은 `RoutinePresentation`을 직접 참조해 화면을 조합한다. 현재 선언을 그대로 아래에 기록했으며, 이 작업에서 의존성을 변경하지 않았다.

## 저장·외부 연동

| 데이터·서비스 | 실제 경계 |
| --- | --- |
| 수분 기록·신체 정보 | HealthKit 원본; HydrationData·WatchHydrationData가 MulimiHealthKit 사용 |
| 목표 수분량 | iCloud KVS + App Group UserDefaults mirror; AccountData·WatchHydrationData가 MulimiCloudKit 사용 |
| 루틴·챌린지·수분 알림 설정 | 각 기능 Data의 App Group UserDefaults 저장 |
| Apple 로그인·인증 정보 | AccountData의 AuthenticationServices 연동 + MulimiKeychain |
| 목표 추천 | HydrationData의 Foundation Models 연동 |
| 루틴 알림 | RoutineData의 AlarmKit 연동 |
| 수분 리마인더 | HydrationReminderData의 UserNotifications 연동 |
| 분석 | MulimiAnalytics 계약 ← MulimiAnalyticsData 구현 → PostHog |
| UI 시스템 동작 | MulimiPlatform의 AppInfoProviding·WidgetTimelineReloading 경계 |

`Persistence`·`PersistenceWatch` 타깃과 SwiftData 관련 소스는 남아 있지만, 17개 manifest 어디에서도 이 두 타깃을 소비하지 않는다. 현재 수분 기록 경로에 SwiftData 원장이 있다고 해석하면 안 된다.

외부 패키지 선언은 [Tuist/Package.swift](../Tuist/Package.swift)에 있는 Swinject와 PostHog 두 개다. 선언 범위는 각각 `2.8.0..<3.0.0`, `3.0.0..<4.0.0`이며 설치된 정확한 버전이라는 뜻은 아니다. Swinject는 iOS DI 세 타깃에서, PostHog는 MulimiAnalyticsData에서 직접 참조한다. 시스템 SDK는 별도의 SPM 패키지로 세지 않는다.

## 전체 타깃 직접 의존 목록

첫 열은 해당 타깃의 manifest 선언 위치로 연결된다. 아래의 “없음”은 **선언된 내부 타깃·외부 제품 의존성이 없음**을 뜻하며 Foundation 등 시스템 SDK를 사용하지 않는다는 뜻은 아니다.

### App · 조립 루트 — 9개

| 타깃 (선언 위치) | 직접 의존하는 타깃·외부 제품 |
| --- | --- |
| [DependencyInjection](../Project/App/DependencyInjection/Project.swift#L29) | `Swinject` (외부), `AccountDomain`, `AccountData`, `AccountPresentation`, `ChallengeDomain`, `ChallengeData`, `ChallengePresentation`, `MulimiAnalytics`, `MulimiNavigation`, `MulimiPlatform`, `MulimiAnalyticsData`, `HydrationDomain`, `HydrationData`, `HydrationPresentation`, `HydrationReminderDomain`, `HydrationReminderData`, `HydrationReminderPresentation`, `RoutineDomain`, `RoutineData`, `RoutinePresentation`, `Utils` |
| [WatchDependencyInjection](../Project/App/DependencyInjection/Project.swift#L72) | `WatchHydrationData`, `WatchHydrationDomain`, `WatchHydrationPresentation` |
| [DependencyInjectionPreview](../Project/App/DependencyInjection/Project.swift#L96) | `DependencyInjection`, `Swinject` (외부), `AccountDomain`, `AccountPresentation`, `ChallengeDomain`, `ChallengePresentation`, `MulimiAnalytics`, `MulimiNavigation`, `MulimiPlatform`, `HydrationDomain`, `HydrationPresentation`, `HydrationReminderDomain`, `HydrationReminderPresentation`, `RoutineDomain`, `RoutinePresentation` |
| [DependencyInjectionTesting](../Project/App/DependencyInjection/Project.swift#L129) | `DependencyInjection`, `Swinject` (외부), `AccountDomain`, `ChallengeDomain`, `MulimiAnalytics`, `HydrationDomain`, `HydrationReminderDomain`, `RoutineDomain` |
| [Mulimi](../Project/App/Project.swift#L35) | `MulimiWatch`, `WidgetExtension`, `MulimiNavigation`, `DependencyInjection`, `AccountDomain`, `AccountPresentation`, `ChallengePresentation`, `MulimiAnalytics`, `HydrationDomain`, `HydrationPresentation`, `HydrationReminderPresentation`, `RoutinePresentation`, `Localization`, `Utils` |
| [WidgetExtension](../Project/App/Project.swift#L100) | `AccountDomain`, `MulimiAnalytics`, `HydrationDomain`, `RoutineDomain`, `Utils`, `DependencyInjection` |
| [MulimiNavigation](../Project/App/Project.swift#L141) | `RoutineDomain` |
| [MulimiWatch](../Project/App/Project.swift#L185) | `MulimiWatchExtension` |
| [MulimiWatchExtension](../Project/App/Project.swift#L213) | `WatchDependencyInjection` |

### Features — 18개

| 타깃 (선언 위치) | 직접 의존하는 타깃·외부 제품 |
| --- | --- |
| [AccountDomain](../Project/Features/Account/Project.swift#L18) | 없음 |
| [AccountData](../Project/Features/Account/Project.swift#L26) | `AccountDomain`, `MulimiCloudKit`, `MulimiKeychain`, `Utils` |
| [AccountPresentation](../Project/Features/Account/Project.swift#L43) | `AccountDomain`, `MulimiAnalytics`, `MulimiPlatform`, `HydrationDomain`, `HydrationPresentation`, `RoutinePresentation`, `HydrationReminderDomain`, `Localization` |
| [ChallengeDomain](../Project/Features/Challenge/Project.swift#L18) | `HydrationDomain`, `RoutineDomain` |
| [ChallengeData](../Project/Features/Challenge/Project.swift#L30) | `ChallengeDomain`, `Utils` |
| [ChallengePresentation](../Project/Features/Challenge/Project.swift#L42) | `ChallengeDomain`, `MulimiAnalytics`, `HydrationDomain`, `RoutineDomain`, `RoutinePresentation`, `DesignSystem`, `Localization` |
| [HydrationDomain](../Project/Features/Hydration/Project.swift#L18) | `AccountDomain` |
| [HydrationData](../Project/Features/Hydration/Project.swift#L29) | `HydrationDomain`, `MulimiHealthKit`, `Utils` |
| [HydrationPresentation](../Project/Features/Hydration/Project.swift#L42) | `HydrationDomain`, `AccountDomain`, `MulimiAnalytics`, `MulimiPlatform`, `RoutineDomain`, `DesignSystem`, `Localization` |
| [HydrationReminderDomain](../Project/Features/HydrationReminder/Project.swift#L21) | 없음 |
| [HydrationReminderData](../Project/Features/HydrationReminder/Project.swift#L29) | `HydrationReminderDomain`, `Localization`, `Utils` |
| [HydrationReminderPresentation](../Project/Features/HydrationReminder/Project.swift#L48) | `HydrationReminderDomain`, `MulimiAnalytics`, `Localization` |
| [RoutineDomain](../Project/Features/Routine/Project.swift#L18) | `AccountDomain`, `HydrationDomain` |
| [RoutineData](../Project/Features/Routine/Project.swift#L30) | `RoutineDomain`, `Localization`, `Utils` |
| [RoutinePresentation](../Project/Features/Routine/Project.swift#L43) | `RoutineDomain`, `AccountDomain`, `MulimiAnalytics`, `HydrationDomain`, `Localization` |
| [WatchHydrationDomain](../Project/Features/WatchHydration/Project.swift#L18) | 없음 |
| [WatchHydrationData](../Project/Features/WatchHydration/Project.swift#L31) | `WatchHydrationDomain`, `MulimiCloudKit`, `MulimiHealthKit` |
| [WatchHydrationPresentation](../Project/Features/WatchHydration/Project.swift#L44) | `WatchHydrationDomain` |

### Core — 6개

| 타깃 (선언 위치) | 직접 의존하는 타깃·외부 제품 |
| --- | --- |
| [MulimiAnalytics](../Project/Core/Analytics/Project.swift#L18) | 없음 |
| [MulimiAnalyticsData](../Project/Core/Analytics/Project.swift#L26) | `MulimiAnalytics`, `PostHog` (외부) |
| [MulimiCloudKit](../Project/Core/CloudKit/Project.swift#L18) | 없음 |
| [MulimiHealthKit](../Project/Core/HealthKit/Project.swift#L18) | 없음 |
| [MulimiKeychain](../Project/Core/Keychain/Project.swift#L18) | 없음 |
| [MulimiPlatform](../Project/Core/Platform/Project.swift#L18) | 없음 |

### Shared — 5개

| 타깃 (선언 위치) | 직접 의존하는 타깃·외부 제품 |
| --- | --- |
| [DesignSystem](../Project/Shared/DesignSystem/Project.swift#L28) | 없음 |
| [Localization](../Project/Shared/Localization/Project.swift#L22) | 없음 |
| [Persistence](../Project/Shared/Persistence/Project.swift#L28) | 없음 |
| [PersistenceWatch](../Project/Shared/Persistence/Project.swift#L36) | 없음 |
| [Utils](../Project/Shared/Utils/Project.swift#L28) | 없음 |

### Tests — 15개

| 타깃 (선언 위치) | 직접 의존하는 타깃·외부 제품 |
| --- | --- |
| [MulimiNavigationTests](../Project/App/Project.swift#L163) | `MulimiNavigation` |
| [AccountDomainTests](../Project/Features/Account/Project.swift#L64) | `AccountDomain` |
| [AccountPresentationTests](../Project/Features/Account/Project.swift#L77) | `AccountPresentation`, `MulimiAnalytics`, `MulimiPlatform`, `HydrationReminderDomain` |
| [ChallengeDomainTests](../Project/Features/Challenge/Project.swift#L59) | `ChallengeDomain`, `HydrationDomain`, `RoutineDomain` |
| [ChallengeDataTests](../Project/Features/Challenge/Project.swift#L78) | `ChallengeData`, `ChallengeDomain` |
| [ChallengePresentationTests](../Project/Features/Challenge/Project.swift#L87) | `ChallengePresentation`, `MulimiAnalytics`, `HydrationDomain`, `RoutineDomain`, `Localization` |
| [HydrationDomainTests](../Project/Features/Hydration/Project.swift#L59) | `HydrationDomain`, `AccountDomain` |
| [HydrationDataTests](../Project/Features/Hydration/Project.swift#L77) | `HydrationData`, `HydrationDomain` |
| [HydrationPresentationTests](../Project/Features/Hydration/Project.swift#L86) | `HydrationPresentation`, `AccountDomain`, `MulimiAnalytics`, `MulimiPlatform`, `RoutineDomain`, `Localization` |
| [HydrationReminderDomainTests](../Project/Features/HydrationReminder/Project.swift#L67) | `HydrationReminderDomain` |
| [HydrationReminderDataTests](../Project/Features/HydrationReminder/Project.swift#L78) | `HydrationReminderData`, `HydrationReminderDomain` |
| [HydrationReminderPresentationTests](../Project/Features/HydrationReminder/Project.swift#L90) | `HydrationReminderPresentation`, `HydrationReminderDomain`, `MulimiAnalytics`, `Localization` |
| [RoutineDomainTests](../Project/Features/Routine/Project.swift#L58) | `RoutineDomain`, `AccountDomain`, `HydrationDomain` |
| [RoutineDataTests](../Project/Features/Routine/Project.swift#L76) | `RoutineData`, `RoutineDomain` |
| [RoutinePresentationTests](../Project/Features/Routine/Project.swift#L85) | `RoutinePresentation`, `AccountDomain`, `MulimiAnalytics`, `HydrationDomain`, `Localization` |

## 검증과 갱신

이 목록은 `Project/**/Project.swift`의 타깃 선언 및 `.target / .project / .external` 직접 의존을 대조했다. 타깃 이름 중복·누락과 알 수 없는 내부 참조가 없으며, 선언된 내부 타깃 그래프에는 순환이 없다. 테스트 목록은 manifest의 `.unitTests` 타깃 기준이며 실제 테스트를 실행했다는 뜻은 아니다.

타깃이나 의존성 변경 시 이 표와 [구조도 JSON](diagrams/mulimi-project-architecture.json)을 함께 갱신한다. 구조도 JSON의 `meta.repository.revision`은 실제 검토한 커밋으로 맞추고, [ARCHITECTURE](../ARCHITECTURE.md)의 규율을 따른다.

archify 설치 디렉터리에서 다음 명령으로 검증·재생성한다. `<repo>`는 저장소의 절대 경로다.

```sh
node bin/archify.mjs validate architecture <repo>/Docs/diagrams/mulimi-project-architecture.json --quality showcase --repo-root <repo> --json
node bin/archify.mjs deliver architecture <repo>/Docs/diagrams/mulimi-project-architecture.json <repo>/Docs/diagrams/mulimi-project-architecture.html --quality showcase --repo-root <repo> --json
node bin/archify.mjs visual-check <repo>/Docs/diagrams/mulimi-project-architecture.html --json
```

HTML은 직접 편집하지 않는다. 검증 기준은 showcase 9/9, 오류·경고 0이며, 화면 검증 후 라이트·다크 캡처도 직접 확인한다. 자동 화면 검증 receipt의 `visualReview: pending`은 육안 검증 결과를 대신하지 않는다.


## 생성 검증 결과

archify로 실제 소스 참조 31개를 검증하고 HTML을 생성했다. 아래 해시는 최종 `deliver`가 검증한 원본·산출물 바이트의 SHA-256이며, 화면 검증 receipt의 HTML 해시와도 일치한다.

```text
diagram_type: architecture
output: /Users/gaeng2y/Documents/github/Mulimi/Docs/diagrams/mulimi-project-architecture.html
specification_sha256: cd2de1e4a4041062b3abadb08865c2032d3711d322e4c6d81bfdb2b291463697
specification_bytes: 12167
artifact_sha256: 357bb138ec030191c76d0b38d8d851a00ecf31876030f9d0f611b311c84aa1fa
artifact_bytes: 721381
validation: 9/9 showcase, 0 errors, 0 warnings
visual_review: passed
correction_rounds: 1
```

화면 검증: 1440×900, 1600×1000, 1920×1080, 2048×1320에서 가로·세로 넘침 없음. 1440×900과 2048×1320의 라이트·다크 캡처 4장을 직접 확인했다. READ·정지 화면 기준이며, 첫 검증의 12px 세로 넘침은 중복된 카드 제목을 줄여 해결했다.

저장소 검증: `make lint`는 301개 파일에서 위반 0개, `make arch-check` 통과. 문서·다이어그램만 변경했으므로 프로젝트 재생성·앱 빌드·기능 테스트는 실행하지 않았다.
