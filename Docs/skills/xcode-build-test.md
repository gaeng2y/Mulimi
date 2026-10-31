# xcode-build-test

## When to use

- 구현 후 검증
- PR 전 확인
- 빌드/테스트 실패 재현

## Goal

Mulimi에서 반복되는 검증 순서를 표준화한다.

## Default Order

먼저 [변경 유형별 품질 게이트](../quality-gates.md#validation-matrix)에서 필요한 단계를 고른다. 문서 전용 변경은 공백·링크·근거를 확인하고, 구조도 변경 시 산출물 검증을 추가한다.

1. `git diff --check`
2. `make lint`
3. `make arch-check`
4. 타깃·의존성·소스·리소스 구성이 바뀌면 `tuist generate`
5. 변경 기능의 `Domain` 테스트
6. 변경 기능의 `Data` 테스트
7. 변경 기능의 `Presentation` 테스트
8. `Mulimi` 앱 빌드

`make verify`는 `make lint`와 `make arch-check`만 실행하는 lightweight gate다. Unit test나 앱 빌드까지 끝났다는 의미로 사용하지 않는다.

버그 수정은 코드를 바꾸기 전에 [버그 재현과 수정 검증](../quality-gates.md#버그-재현과-수정-검증)을 시작한다. 아래 빌드·테스트 순서는 수정 전 재현과 수정 후 사용자 경로 확인을 대체하지 않는다.

## Commands

```bash
make lint
make arch-check
tuist generate
xcodebuild test -workspace Mulimi.xcworkspace -scheme HydrationDomain -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
xcodebuild test -workspace Mulimi.xcworkspace -scheme HydrationData -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
xcodebuild test -workspace Mulimi.xcworkspace -scheme HydrationPresentation -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
xcodebuild build -workspace Mulimi.xcworkspace -scheme Mulimi -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO
```

## Validation Levels

| Level | Commands | Use when |
| --- | --- | --- |
| 문서 | `git diff --check`, 변경한 링크·앵커·이미지·근거 대조 | 문서 전용 변경; 구조도 변경 시 별도 품질 게이트 추가 |
| Lightweight | `git diff --check`, `make lint`, `make arch-check` 또는 `make verify` | 코드 변경의 첫 검증 |
| Unit | 변경 기능·공용 UI·내비게이션·Watch 스킴의 `xcodebuild test` | UseCase, Repository, ViewModel, 공용 규칙·컴포넌트 변경 |
| Build | `Mulimi` 앱 빌드, 필요 시 Widget/Watch 타깃 빌드 | Project.swift, SwiftUI, App/Widget/Watch 통합 변경 |
| PR CI | `.github/workflows/lint.yml`, `.github/workflows/pr-unit-tests.yml` | `main`, `develop` 대상 PR 검증 |
| Release | Xcode Cloud `Release-Build` archive | 태그 기반 릴리스 검증 |

## Notes

- 시뮬레이터 이름보다 `id`가 더 안정적이다.
- GitHub Actions의 iOS 테스트는 workflow의 이름 기반 destination을 사용한다. Watch는 실행 시 사용 가능한 watchOS 26+ 기기의 `id`를 조회한다.
- watch나 widget 변경이 직접 범위면 해당 타깃 빌드도 추가한다.
- 실행하지 않은 검증은 PR의 `실행하지 않은 검증과 이유`에 적는다.

## Shared UI And Watch Commands

```sh
xcodebuild test -workspace Mulimi.xcworkspace -scheme MulimiUISystem -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
xcodebuild test -workspace Mulimi.xcworkspace -scheme MulimiNavigation -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
xcodebuild test -workspace Mulimi.xcworkspace -scheme WatchHydrationTests -destination 'platform=watchOS Simulator,id=<WATCH_SIM_ID>' -sdk watchsimulator -parallel-testing-enabled NO
```

`DesignSystemFoundation`에는 별도 테스트 타깃이 없다. 현재 공용 UI 검증은 `MulimiUISystem` 스킴과 영향받는 화면 테스트·빌드에서 수행한다. `WatchHydrationTests`는 watchOS 전용 스킴이다.

Icon Composer 유형 보정과 실제 앱 Resources 연결을 확인할 때는 프로젝트 생성 후 [아이콘 검증 명령](../xcode-cloud-release-build.md#icon-composer-아이콘)을 사용한다.

## PR CI Scope

실제 선언은 [pr-unit-tests.yml](../../.github/workflows/pr-unit-tests.yml)을 기준으로 한다. `ed71ce1`에서 확인한 순서다.

1. Xcode 선택, `Secrets.xcconfig` 준비, mise·Tuist 설치, `tuist install`. 같은 저장소 PR·수동 실행은 OIDC 인증과 `make tuist-cache` 후 `tuist generate --no-open --configuration Debug`를 실행한다. fork PR은 클라우드 기능을 끄고 생성한다.
2. Icon Composer 유형 보정과 회귀 테스트·실제 `Mulimi` 타깃 Resources 연결 검사.
3. iOS Simulator 스킴 16개: `MulimiUISystem`, `MulimiNavigation`, `AccountDomain`, `AccountPresentation`, 그리고 `Hydration`·`Routine`·`Challenge`·`HydrationReminder`의 `Domain`·`Data`·`Presentation`.
4. watchOS 26+ Simulator에서 `WatchHydrationTests`. 사용 가능한 기기가 없으면 실패한다.

CI의 iOS 스킴은 서명을 끈 Simulator 테스트이며 Watch는 watchOS Simulator에서 실행한다. 실제 HealthKit 권한·동기화·VoiceOver와 Cloud archive 결과는 별도로 보고한다. 트리거·draft·문서 PR 처리 조건은 [하네스 자동화 표](../harness-engineering.md#automation-harness)를 따른다.

CI 테스트는 `tuist xcodebuild test`와 스킴별 `.build/test-results/*.xcresult`를 사용해 빌드·테스트 기록을 수집한다. 기본 모듈 캐시 프로필은 `only-external`이므로 테스트 대상 앱·기능 코드는 소스로 유지한다. 설정과 인증 없는 실행은 [Tuist Builds와 캐시](../tuist-builds-and-cache.md)를 따른다.

## Simulator Discovery

로컬 테스트 destination은 아래 순서로 확인한다.

```bash
xcodebuild -version
xcodebuild -showsdks
xcrun simctl list devices available
```

동일한 기기 이름이 여러 OS runtime에 있으면 `id`를 골라 `-destination 'platform=iOS Simulator,id=<SIM_ID>'` 형식으로 실행한다.

## 시뮬레이터 버그 검증

완료 조건은 [품질 게이트](../quality-gates.md#버그-재현과-수정-검증), 기록할 항목과 격리 규칙은 [증거 보관](../quality-gates.md#증거-보관)을 따른다.

1. 사용 가능한 XcodeBuildMCP 도구가 있으면 먼저 `session_show_defaults`로 workspace·scheme·담당 simulator를 확인하고 필요한 값만 설정한다. 기기 조회, 빌드·설치·실행, UI 스냅샷과 `screenshot`을 우선 사용한다. 도구가 반환한 임시 캡처는 증거 폴더로 복사하고 직접 연다. UI 조작은 현재 세션에서 지원하는 도구의 실제 접근성 라벨·식별자를 확인해 수행한다.
2. 담당 시뮬레이터 UUID와 실행 빌드를 확인한 후 수정 전 재현 경로를 수행한다. 재현 시점에 아래 명령이나 도구로 화면을 저장한다.
3. 수정·필수 검사·테스트 후 새 앱을 빌드·설치한다. 시작 조건을 복원하고 같은 경로를 수행한 뒤 수정 후 화면을 저장한다. 설치하지 않은 이전 앱의 캡처를 수정 결과로 사용하지 않는다.
4. 두 캡처를 직접 열어 차이를 확인하고 동작별 로그·재조회·테스트 결과를 연결한다. 인스턴스를 정리한 뒤에도 증거가 남아 있는지 확인한다.

CLI 캡처는 조회한 UUID를 `SIM_ID`에, 이 작업의 새 `Docs/validation/<task>` 경로를 `mulimi_evidence_dir`에 설정한 뒤 실행한다. 현재 부팅 기기를 암묵적으로 고르는 `booted` 대신 담당 UUID를 사용한다.

```sh
: "${SIM_ID:?담당 시뮬레이터 UUID를 설정하세요}"
: "${mulimi_evidence_dir:?이 작업의 증거 폴더 경로를 설정하세요}"
mkdir -p "$mulimi_evidence_dir"
xcrun simctl io "$SIM_ID" screenshot "$mulimi_evidence_dir/before.png"
```

수정된 앱을 설치하고 같은 재현 경로를 수행한 후 캡처한다.

```sh
xcrun simctl io "$SIM_ID" screenshot "$mulimi_evidence_dir/after.png"
```

시간에 따라 발생하는 문제는 화면 녹화와 시간 정보가 있는 로그를 추가한다. `snapshot_ui`의 접근성 트리와 단위 테스트 결과만으로 실제 화면을 확인했다고 보고하지 않는다. 시뮬레이터에서 검증할 수 없는 동작은 실기기 확인 항목으로 남긴다.

## Toolchain Troubleshooting

- `.mise.toml`은 Tuist `4.206.0`을 고정한다. 버전을 변경하면 프로젝트 생성·테스트·Preview 명령과 관련 문서를 함께 검증한다.
- GitHub Actions는 `latest-stable` Xcode를 사용한다. Xcode 업데이트로 SDK, simulator, Swift 컴파일 결과가 달라지면 실패 로그의 `xcodebuild -version`, `xcodebuild -showsdks` 출력부터 확인한다.
- Metal shader 또는 SwiftUI shader asset 빌드가 Metal toolchain 누락으로 실패하면 Xcode component 상태를 확인한다. CLI에서 가능한 환경이면 `xcodebuild -downloadComponent MetalToolchain` 실행 후 같은 빌드를 다시 확인한다.
