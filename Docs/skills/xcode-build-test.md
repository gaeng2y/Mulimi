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

1. Xcode 선택, `Secrets.xcconfig` 준비, mise·Tuist 설치, `tuist install`, `tuist generate --no-open`.
2. Icon Composer 유형 보정과 회귀 테스트·실제 `Mulimi` 타깃 Resources 연결 검사.
3. iOS Simulator 스킴 16개: `MulimiUISystem`, `MulimiNavigation`, `AccountDomain`, `AccountPresentation`, 그리고 `Hydration`·`Routine`·`Challenge`·`HydrationReminder`의 `Domain`·`Data`·`Presentation`.
4. watchOS 26+ Simulator에서 `WatchHydrationTests`. 사용 가능한 기기가 없으면 실패한다.

CI의 iOS 스킴은 서명을 끈 Simulator 테스트이며 Watch는 watchOS Simulator에서 실행한다. 실제 HealthKit 권한·동기화·VoiceOver와 Cloud archive 결과는 별도로 보고한다. 트리거·draft·문서 PR 처리 조건은 [하네스 자동화 표](../harness-engineering.md#automation-harness)를 따른다.

## Simulator Discovery

로컬 테스트 destination은 아래 순서로 확인한다.

```bash
xcodebuild -version
xcodebuild -showsdks
xcrun simctl list devices available
```

동일한 기기 이름이 여러 OS runtime에 있으면 `id`를 골라 `-destination 'platform=iOS Simulator,id=<SIM_ID>'` 형식으로 실행한다.

## Toolchain Troubleshooting

- `.mise.toml`은 Tuist `4.205.0`을 고정한다. 버전을 변경하면 프로젝트 생성·테스트·Preview 명령과 관련 문서를 함께 검증한다.
- GitHub Actions는 `latest-stable` Xcode를 사용한다. Xcode 업데이트로 SDK, simulator, Swift 컴파일 결과가 달라지면 실패 로그의 `xcodebuild -version`, `xcodebuild -showsdks` 출력부터 확인한다.
- Metal shader 또는 SwiftUI shader asset 빌드가 Metal toolchain 누락으로 실패하면 Xcode component 상태를 확인한다. CLI에서 가능한 환경이면 `xcodebuild -downloadComponent MetalToolchain` 실행 후 같은 빌드를 다시 확인한다.
