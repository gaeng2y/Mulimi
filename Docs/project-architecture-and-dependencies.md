# 프로젝트 전체 구조와 의존성

기준: 코드 커밋 `6fd6b9fb9cb0f3fcc9ae43f8fa73727b07dd0d51` (#356), Mulimi **2.6.0 (37)**. 실제 `Project.swift` 18개와 관련 구현을 확인한 스냅샷이다. 구조도 소스 링크도 이 코드 커밋에 고정했다.

[전체 구조도 열기](diagrams/mulimi-project-architecture.html) · [다이어그램 원본 JSON](diagrams/mulimi-project-architecture.json) · [라이트·다크 화면 검증](diagrams/mulimi-project-architecture.visual-check.html)

## 읽는 방법

구조도는 12개 묶음으로 주요 의존 방향을 보여준다. 모든 간선을 그린 타깃 그래프는 아니며, 아래 표가 **선언된 55개 타깃과 직접 의존 선언 176개 전체**를 담는다. 이 중 17개는 테스트 타깃이고, 의존 선언은 내부 타깃 172개와 외부 제품 참조 4개다. Apple SDK의 암시적 링크와 전이 의존성은 이 개수에 포함하지 않는다.

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
│   ├── DesignSystemFoundation/   기본 토큰·UI 원시 요소
│   ├── MulimiUISystem/           Mulimi 테마·컴포넌트·브랜드 리소스
│   ├── Utils/
│   └── Persistence/             선언만 남은 Persistence·PersistenceWatch
└── Widget/                     위젯 소스·리소스; 타깃은 App에서 선언
```

각 기능은 `Domain / Data / Presentation`으로 나뉘며 Clean Architecture + MVVM을 따른다. iOS와 Watch의 최소 버전은 모두 26.0이다. `Workspace.swift`의 시작 프로젝트는 `Project/App`이고, 필요한 프로젝트를 의존성으로 따라간다. 따라서 저장소의 모든 선언이 제품 앱에서 사용된다는 뜻은 아니다.

`AppSession`은 **AccountPresentation**, `AppCoordinator`는 **App 소유의 MulimiNavigation**이다. 둘 다 Core 소속이 아니다. `TestSupport`는 독립 타깃이 아니라 여러 테스트 타깃에 소스로 포함된다.

## 실행·공유 경계

- iOS 진입: `DrinkWaterApp → RootView`. 인증 후 `Onboarding → HydrationReminderPermissionGate → HealthKitPermissionGate → ContentView` 순서로 진입한다. 전역 push는 `ContentView + AppCoordinator`가 담당한다.
- iOS DI: `DataAssembly / DomainAssembly / PresentationAssembly`가 Swinject로 구현·UseCase·ViewModel을 연결한다. 제품, Preview, Testing은 별도 타깃으로 선언돼 있다.
- 위젯: `WidgetExtension`은 Account·Hydration·Routine Domain과 제품 DI를 재사용한다. 오류 안내는 `Localization`을 직접 참조한다. `LogWaterAppIntent.swift`는 앱과 위젯 양쪽 타깃에서 컴파일한다.
- Watch: `MulimiWatch → WatchDependencyInjection`. 단일 `.app` 타깃이 진입 코드·전체 리소스·HealthKit/App Group/iCloud 권한을 소유하며, `WKApplication`을 선언한다. 앱 번들 ID `gaeng2y.DrinkWater.watchkitapp`과 iOS 앱의 Watch 포함 관계는 유지한다. `WatchDIContainer`는 Swinject 없이 Repository·UseCase·ViewModel을 직접 조립한다.
- Watch의 `HydrationServing`, `HydrationWriteResult`, `HydrationNextActionGuide`는 iOS Hydration의 **동일 소스 파일을 별도 컴파일**한다. `WatchHydrationDomain → HydrationDomain`이라는 타깃 의존성은 없다.
- `MulimiCloudKit`과 `MulimiHealthKit`은 iOS·watchOS 공용 타깃이다. `MulimiCloudKit`의 현재 구현은 CloudKit 레코드 DB가 아니라 `NSUbiquitousKeyValueStore`와 UserDefaults mirror다.
- `WatchHydrationTests`는 watchOS 전용 테스트 번들이다. Watch Presentation·Domain·Data와 공용 HealthKit 어댑터의 기록 영수증·단건 취소를 함께 검증하며 제품 앱에는 포함하지 않는다.

## 디자인 시스템 경계

`HydrationPresentation / ChallengePresentation → MulimiUISystem → DesignSystemFoundation`으로 의존한다. Foundation은 기본 값·장식 원시 요소, UISystem은 브랜드 색상 리소스·의미 테마·세그먼트와 물방울 효과를 소유한다. 두 framework는 iOS 26 이상이며, Domain·App·Feature·Localization을 참조하지 않는다. Foundation의 직접 소비는 UISystem으로 제한한다.

색상은 UISystem framework 번들을 지정해 로드한다. 상세 API·플랫폼 경계·리소스 이관 근거는 [디자인 시스템](design-system.md)을 참고한다.

## 기능 간 직접 의존에서 주의할 점

`ChallengeDomain → RoutineDomain → HydrationDomain → AccountDomain`이라는 주요 줄기 외에도 `ChallengeDomain → HydrationDomain`, `RoutineDomain → AccountDomain` 직접 참조가 있다. `HydrationReminderDomain`과 `WatchHydrationDomain`에는 선언된 타깃 의존성이 없다.

Presentation은 자기 Domain만 참조하는 구조가 아니다. 예를 들어 `AccountPresentation`은 `HydrationPresentation`과 `RoutinePresentation`을, `ChallengePresentation`은 `RoutinePresentation`을 직접 참조해 화면을 조합한다. 현재 선언을 아래에 기록했다.

## 저장·외부 연동

| 데이터·서비스 | 실제 경계 |
| --- | --- |
| 수분 기록·신체 정보 | HealthKit 원본; HydrationData·WatchHydrationData가 MulimiHealthKit 사용 |
| 목표 수분량 | iCloud KVS + App Group UserDefaults mirror; AccountData·WatchHydrationData가 MulimiCloudKit 사용 |
| 루틴·챌린지·수분 알림 설정 | 각 기능 Data의 App Group UserDefaults 저장 |
| Apple 로그인·인증 정보 | AccountData의 AuthenticationServices 연동 + MulimiKeychain |
| 목표 추천 | HydrationData의 Foundation Models 연동 |
| 루틴 알림 | RoutineData의 AlarmKit 연동 |
| 수분 리마인더 | AppDelegate → HydrationReminderData의 카테고리·실패 안내, HydrationPresentation의 액션 상태 → DrinkWaterUseCase → HealthKit |
| 분석 | MulimiAnalytics 계약 ← MulimiAnalyticsData 구현 → PostHog |
| UI 시스템 동작 | MulimiPlatform의 AppInfoProviding·WidgetTimelineReloading 경계 |

`Persistence`·`PersistenceWatch` 타깃과 SwiftData 관련 소스는 남아 있지만, 18개 manifest 어디에서도 이 두 타깃을 소비하지 않는다. 현재 수분 기록 경로에 SwiftData 원장이 있다고 해석하면 안 된다.

외부 패키지 선언은 [Tuist/Package.swift](../Tuist/Package.swift)에 있는 Swinject와 PostHog 두 개다. 선언 범위는 각각 `2.8.0..<3.0.0`, `3.0.0..<4.0.0`이며 설치된 정확한 버전이라는 뜻은 아니다. Swinject는 iOS DI 세 타깃에서, PostHog는 MulimiAnalyticsData에서 직접 참조한다. 시스템 SDK는 별도의 SPM 패키지로 세지 않는다.

## 전체 타깃 직접 의존 목록

첫 열은 해당 타깃의 manifest 선언 위치로 연결된다. 아래의 “없음”은 **선언된 내부 타깃·외부 제품 의존성이 없음**을 뜻하며 Foundation 등 시스템 SDK를 사용하지 않는다는 뜻은 아니다.

### App · 조립 루트 — 8개

| 타깃 (선언 위치) | 직접 의존하는 타깃·외부 제품 |
| --- | --- |
| [DependencyInjection](../Project/App/DependencyInjection/Project.swift#L30) | `AccountDomain`, `AccountData`, `AccountPresentation`, `ChallengeDomain`, `ChallengeData`, `ChallengePresentation`, `MulimiAnalytics`, `MulimiNavigation`, `MulimiPlatform`, `MulimiAnalyticsData`, `HydrationDomain`, `HydrationData`, `HydrationPresentation`, `HydrationReminderDomain`, `HydrationReminderData`, `HydrationReminderPresentation`, `RoutineDomain`, `RoutineData`, `RoutinePresentation`, `Utils`, `Swinject` (외부) |
| [WatchDependencyInjection](../Project/App/DependencyInjection/Project.swift#L73) | `WatchHydrationData`, `WatchHydrationDomain`, `WatchHydrationPresentation` |
| [DependencyInjectionPreview](../Project/App/DependencyInjection/Project.swift#L97) | `DependencyInjection`, `AccountDomain`, `AccountPresentation`, `ChallengeDomain`, `ChallengePresentation`, `MulimiAnalytics`, `MulimiNavigation`, `MulimiPlatform`, `HydrationDomain`, `HydrationPresentation`, `HydrationReminderDomain`, `HydrationReminderPresentation`, `RoutineDomain`, `RoutinePresentation`, `Swinject` (외부) |
| [DependencyInjectionTesting](../Project/App/DependencyInjection/Project.swift#L130) | `DependencyInjection`, `AccountDomain`, `ChallengeDomain`, `MulimiAnalytics`, `HydrationDomain`, `HydrationReminderDomain`, `RoutineDomain`, `Swinject` (외부) |
| [Mulimi](../Project/App/Project.swift#L36) | `MulimiWatch`, `WidgetExtension`, `MulimiNavigation`, `DependencyInjection`, `AccountDomain`, `AccountPresentation`, `ChallengePresentation`, `MulimiAnalytics`, `HydrationDomain`, `HydrationPresentation`, `HydrationReminderData`, `HydrationReminderPresentation`, `RoutinePresentation`, `Localization`, `Utils` |
| [WidgetExtension](../Project/App/Project.swift#L110) | `AccountDomain`, `MulimiAnalytics`, `HydrationDomain`, `RoutineDomain`, `Localization`, `Utils`, `DependencyInjection` |
| [MulimiNavigation](../Project/App/Project.swift#L152) | `RoutineDomain` |
| [MulimiWatch](../Project/App/Project.swift#L196) | `WatchDependencyInjection` |

### Features — 18개

| 타깃 (선언 위치) | 직접 의존하는 타깃·외부 제품 |
| --- | --- |
| [AccountDomain](../Project/Features/Account/Project.swift#L19) | 없음 |
| [AccountData](../Project/Features/Account/Project.swift#L27) | `AccountDomain`, `MulimiCloudKit`, `MulimiKeychain`, `Utils` |
| [AccountPresentation](../Project/Features/Account/Project.swift#L44) | `AccountDomain`, `MulimiAnalytics`, `MulimiPlatform`, `HydrationDomain`, `HydrationPresentation`, `RoutinePresentation`, `HydrationReminderDomain`, `Localization` |
| [ChallengeDomain](../Project/Features/Challenge/Project.swift#L19) | `HydrationDomain`, `RoutineDomain` |
| [ChallengeData](../Project/Features/Challenge/Project.swift#L31) | `ChallengeDomain`, `Utils` |
| [ChallengePresentation](../Project/Features/Challenge/Project.swift#L43) | `ChallengeDomain`, `MulimiAnalytics`, `HydrationDomain`, `RoutineDomain`, `RoutinePresentation`, `MulimiUISystem`, `Localization` |
| [HydrationDomain](../Project/Features/Hydration/Project.swift#L19) | `AccountDomain` |
| [HydrationData](../Project/Features/Hydration/Project.swift#L30) | `HydrationDomain`, `MulimiHealthKit`, `Utils` |
| [HydrationPresentation](../Project/Features/Hydration/Project.swift#L43) | `HydrationDomain`, `AccountDomain`, `MulimiAnalytics`, `MulimiPlatform`, `RoutineDomain`, `MulimiUISystem`, `Localization` |
| [HydrationReminderDomain](../Project/Features/HydrationReminder/Project.swift#L22) | 없음 |
| [HydrationReminderData](../Project/Features/HydrationReminder/Project.swift#L30) | `HydrationReminderDomain`, `Localization`, `Utils` |
| [HydrationReminderPresentation](../Project/Features/HydrationReminder/Project.swift#L49) | `HydrationReminderDomain`, `MulimiAnalytics`, `Localization` |
| [RoutineDomain](../Project/Features/Routine/Project.swift#L19) | `AccountDomain`, `HydrationDomain` |
| [RoutineData](../Project/Features/Routine/Project.swift#L31) | `RoutineDomain`, `Localization`, `Utils` |
| [RoutinePresentation](../Project/Features/Routine/Project.swift#L44) | `RoutineDomain`, `AccountDomain`, `MulimiAnalytics`, `HydrationDomain`, `Localization` |
| [WatchHydrationDomain](../Project/Features/WatchHydration/Project.swift#L19) | 없음 |
| [WatchHydrationData](../Project/Features/WatchHydration/Project.swift#L32) | `WatchHydrationDomain`, `MulimiCloudKit`, `MulimiHealthKit` |
| [WatchHydrationPresentation](../Project/Features/WatchHydration/Project.swift#L45) | `WatchHydrationDomain` |

### Core — 6개

| 타깃 (선언 위치) | 직접 의존하는 타깃·외부 제품 |
| --- | --- |
| [MulimiAnalytics](../Project/Core/Analytics/Project.swift#L19) | 없음 |
| [MulimiAnalyticsData](../Project/Core/Analytics/Project.swift#L27) | `MulimiAnalytics`, `PostHog` (외부) |
| [MulimiCloudKit](../Project/Core/CloudKit/Project.swift#L19) | 없음 |
| [MulimiHealthKit](../Project/Core/HealthKit/Project.swift#L19) | 없음 |
| [MulimiKeychain](../Project/Core/Keychain/Project.swift#L19) | 없음 |
| [MulimiPlatform](../Project/Core/Platform/Project.swift#L19) | 없음 |

### Shared — 6개

| 타깃 (선언 위치) | 직접 의존하는 타깃·외부 제품 |
| --- | --- |
| [DesignSystemFoundation](../Project/Shared/DesignSystemFoundation/Project.swift#L29) | 없음 |
| [Localization](../Project/Shared/Localization/Project.swift#L23) | 없음 |
| [MulimiUISystem](../Project/Shared/MulimiUISystem/Project.swift#L29) | `DesignSystemFoundation` |
| [Persistence](../Project/Shared/Persistence/Project.swift#L29) | 없음 |
| [PersistenceWatch](../Project/Shared/Persistence/Project.swift#L37) | 없음 |
| [Utils](../Project/Shared/Utils/Project.swift#L29) | 없음 |

### Tests — 17개

| 타깃 (선언 위치) | 직접 의존하는 타깃·외부 제품 |
| --- | --- |
| [MulimiNavigationTests](../Project/App/Project.swift#L174) | `MulimiNavigation` |
| [AccountDomainTests](../Project/Features/Account/Project.swift#L65) | `AccountDomain` |
| [AccountPresentationTests](../Project/Features/Account/Project.swift#L78) | `AccountPresentation`, `MulimiAnalytics`, `MulimiPlatform`, `HydrationReminderDomain` |
| [ChallengeDomainTests](../Project/Features/Challenge/Project.swift#L60) | `ChallengeDomain`, `HydrationDomain`, `RoutineDomain` |
| [ChallengeDataTests](../Project/Features/Challenge/Project.swift#L79) | `ChallengeData`, `ChallengeDomain` |
| [ChallengePresentationTests](../Project/Features/Challenge/Project.swift#L88) | `ChallengePresentation`, `MulimiAnalytics`, `HydrationDomain`, `RoutineDomain`, `Localization` |
| [HydrationDomainTests](../Project/Features/Hydration/Project.swift#L60) | `HydrationDomain`, `AccountDomain` |
| [HydrationDataTests](../Project/Features/Hydration/Project.swift#L78) | `HydrationData`, `HydrationDomain` |
| [HydrationPresentationTests](../Project/Features/Hydration/Project.swift#L87) | `HydrationPresentation`, `AccountDomain`, `MulimiAnalytics`, `MulimiPlatform`, `RoutineDomain`, `Localization` |
| [HydrationReminderDomainTests](../Project/Features/HydrationReminder/Project.swift#L68) | `HydrationReminderDomain` |
| [HydrationReminderDataTests](../Project/Features/HydrationReminder/Project.swift#L79) | `HydrationReminderData`, `HydrationReminderDomain` |
| [HydrationReminderPresentationTests](../Project/Features/HydrationReminder/Project.swift#L91) | `HydrationReminderPresentation`, `HydrationReminderDomain`, `MulimiAnalytics`, `Localization` |
| [RoutineDomainTests](../Project/Features/Routine/Project.swift#L59) | `RoutineDomain`, `AccountDomain`, `HydrationDomain` |
| [RoutineDataTests](../Project/Features/Routine/Project.swift#L77) | `RoutineData`, `RoutineDomain` |
| [RoutinePresentationTests](../Project/Features/Routine/Project.swift#L86) | `RoutinePresentation`, `AccountDomain`, `MulimiAnalytics`, `HydrationDomain`, `Localization` |
| [WatchHydrationTests](../Project/Features/WatchHydration/Project.swift#L54) | `WatchHydrationDomain`, `WatchHydrationData`, `WatchHydrationPresentation`, `MulimiHealthKit` |
| [MulimiUISystemTests](../Project/Shared/MulimiUISystem/Project.swift#L42) | `MulimiUISystem` |

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

archify로 실제 소스 참조 33개를 검증하고 HTML을 생성했다. 아래 해시는 최종 `deliver`가 검증한 원본·산출물 바이트의 SHA-256이며, 화면 검증 receipt의 HTML 해시와도 일치한다.

```text
diagram_type: architecture
output: Docs/diagrams/mulimi-project-architecture.html
specification_sha256: 5f0bdf01118ea7c8dad79fda0de20d12b13d3022460cbf83dfe795b6b629c9eb
specification_bytes: 13099
artifact_sha256: b04e846b3619c83e7220d9d41dd8b999e292aa6ff450f7ceff43b162325f1657
artifact_bytes: 724193
validation: 9/9 showcase, 0 errors, 0 warnings
visual_review: passed
correction_rounds: 2 (소스 커밋·기존 타깃 위치 확정; 레이아웃 수정 0회)
```

화면 검증: 1440×900, 1600×1000, 1920×1080, 2048×1320에서 가로·세로 넘침 없음. 1440×900과 2048×1320의 라이트·다크 캡처 4장을 직접 확인했다. READ·정지 화면 기준이다. 자동 검증 receipt의 `visualReview: pending`과 별도로 캡처를 직접 확인했다.

저장소 검증(2026-10-10, #356): Xcode **27.0 (27A266a)**, Tuist **4.205.0**. `make lint` 328개 파일 위반 0, `make arch-check`, 경계 fixture 7개, `tuist generate --no-open` 통과. iPhone 17e/iOS 26.5에서 MulimiUISystem 5개(9건), Hydration Domain/Data/Presentation 67/7/104개, Challenge Domain/Data/Presentation 10/3/6개 통과. Mulimi 서명 없는 iOS Debug 빌드도 성공했다. UI 비교와 접근성 확인 결과는 [#356 실행 기록](exec-plans/active/2026-10-10-issue-356-design-system.md)에 남긴다.

이전 저장소 검증(2026-09-29, #336): Xcode **27.0 (27A266a)**, Tuist **4.205.0**에서 `make lint`(316개 파일, 위반 0), `make arch-check`, `tuist generate --no-open`을 통과했다. Watch SE 3 40mm/watchOS 27의 `WatchHydrationTests`는 정의 6개·매개변수 포함 12건, iPhone 17e/iOS 27의 `HydrationDomain` 65개·`HydrationData` 6개·`HydrationPresentation` 91개가 통과했다. Watch Debug Simulator 및 워치를 포함한 iOS Release 서명 없는 빌드도 통과했다. 실기기 HealthKit 동기화·권한 검증은 별도다.

이전 저장소 검증(2026-09-26): Xcode **27.0 (27A266a)**, Tuist **4.205.0**에서 다음을 직접 확인했다.

- `make lint`: 315개 파일에서 위반 0개. `make arch-check`, `tuist generate --no-open`, `git diff --check` 통과.
- `xcodebuild build -workspace Mulimi.xcworkspace -scheme MulimiWatch -destination 'generic/platform=watchOS Simulator' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO`: Debug/watchOS Simulator 27 SDK 빌드 통과. 첫 실행은 샌드박스의 CoreSimulator 접근 차단으로 실패했으며, 시스템 접근을 허용한 재실행에서 통과했다.
- `xcodebuild build -workspace Mulimi.xcworkspace -scheme Mulimi -configuration Release -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO`: 워치 포함 iOS Release 빌드 통과. 시뮬레이터 워치 앱과 iOS 앱에 포함된 워치 앱 모두 실행 파일·DI 프레임워크·현지화·HealthKit 설명·`WKApplication`을 확인했고, WatchKit 확장 번들은 없다.
- `xcodebuild test -workspace Mulimi.xcworkspace -scheme HydrationPresentation -destination 'platform=iOS Simulator,id=AE461422-2BC0-40BF-BD1A-6AE54AEFECB8' -sdk iphonesimulator -only-testing:HydrationPresentationTests/HydrationReminderActionHandlerTests -parallel-testing-enabled NO`: iPhone 18 Pro/iOS 27.0에서 테스트 정의 4개, 매개변수 실행 포함 6건 통과.
- `graphify update .`: 격리된 `GRAPHIFY_OUT`에서 AST-only 갱신. 공유 그래프에 생성물 출처 노드와 세션 학습 섹션이 없는 것을 확인했다. 문서 의미 재분석은 수행하지 않았다.

[#321 실행 당시](exec-plans/active/2026-09-18-issue-321-notification-quick-log.md) 전체 빌드를 막던 WatchKit 확장 형식은 [Apple의 단일 타깃 전환 지침](https://developer.apple.com/documentation/watchos-apps/migrating-to-a-single-target-watchos-app)에 맞춰 제거했다. 이후 드러난 `AppDelegate`의 Swift 6 전송 오류도 알림 객체 대신 `String`·`Date`·`Bool` 값만 MainActor에 전달하도록 수정했다. 실기기 서명·설치와 HealthKit 권한 동작은 이번 서명 없는 빌드 검증에 포함하지 않았다.

#321에서는 AppDelegate가 HydrationReminderData의 카테고리·전달 영수증·실패 안내를 직접 호출한다. 영수증은 `UserDefaults.standard`에 요청별 마지막 성공 전달 시각만 보관하고, 실제 수분 기록과 중복 방지 sync metadata는 HealthKit에 둔다.

#350에서는 WatchHydrationTests를 추가해 실제 Data 오류 전파, 저장 전 조회 실패, 저장·초기화 후 조회 실패와 날짜 경계를 검증한다. 수분 조회는 오류를 던지는 계약이며 마지막 정상 값은 화면 메모리에만 남는다. 위젯은 실패 상태로 앱의 기존 기록 딥링크를 연다.
