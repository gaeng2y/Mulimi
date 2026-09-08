# Xcode Cloud: Release Build Only Setup

이 문서는 `#15` 이슈 범위를 "Release Build"로 한정해서 설정하는 절차입니다.
Xcode Cloud에는 PR 유닛 테스트 워크플로를 만들지 않습니다. PR lint와 유닛 테스트 게이트는 GitHub Actions의 `.github/workflows/lint.yml`, `.github/workflows/pr-unit-tests.yml`가 담당합니다.

## 1) 저장소 준비
- 커스텀 스크립트 경로를 Xcode Cloud 표준인 `ci_scripts/`로 사용
- 현재 스크립트: `ci_scripts/ci_post_clone.sh`
- 스크립트에서 수행:
  - `mise` 설치/활성화
  - `tuist install`
  - `tuist generate`

## 2) Xcode Cloud 워크플로 생성
Xcode > Report navigator > Cloud 또는 App Store Connect > Xcode Cloud에서 워크플로 생성:

1. Workflow name: `Release-Build`
2. Start Condition (권장):
   - `Tag changes` with pattern: `v*`
3. Action:
   - `Archive`
4. Scheme:
   - `Mulimi`
5. Configuration:
   - `Release`
6. Destination:
   - iOS

### Environment Variables

Xcode Cloud 워크플로에 아래 값을 설정한다. 실제 값은 저장소나 `Secrets.xcconfig.template`에 커밋하지 않는다.

| Name | Secret | Purpose |
| --- | --- | --- |
| `POSTHOG_PROJECT_TOKEN` | Yes | Release 앱의 PostHog 프로젝트 토큰 |
| `POSTHOG_CLI_API_KEY` | Yes | dSYM 업로드용 personal API key (`error tracking write`, `organization read`) |
| `POSTHOG_CLI_PROJECT_ID` | No | dSYM을 연결할 PostHog project ID |
| `POSTHOG_CLI_HOST` | No | 기본 US는 생략 가능, EU/self-hosted만 설정 |

`ci_post_clone.sh`는 필수 값이 없으면 archive 준비를 실패시키고, 토큰을 `Secrets.xcconfig`에 주입하며 PostHog CLI를 설치한다. Release archive의 마지막 build phase가 생성된 dSYM을 업로드한다.

참고: 태그 기반으로 두면 의도된 릴리즈 시점에만 아카이브가 실행됩니다.

### Release 기능 확인 (#322 / #323)

- `XCConfig/Release.xcconfig`는 `MULIMI_CONTROL_WIDGET_EXPERIMENT`와 `MULIMI_COMEBACK_EXPERIMENT`를 기본 활성화한다. App과 DependencyInjection 프로젝트가 이 파일을 공유한다. 앱 프로젝트에만 조건을 넣으면 별도 framework에서 결정하는 컴백 모드가 활성화되지 않는다.
- `Release-Build`의 일반 `Mulimi / Release` archive에는 Control Widget과 컴백 카드가 함께 포함된다. 별도 환경 변수나 명령행 플래그는 필요하지 않다. Debug는 기존 비활성 상태를 유지한다.
- TestFlight·App Store archive의 기본값은 같다. 설정 반영과 실제 서명·업로드·배포는 별개이며, 배포 전에 두 기능의 실기기 QA를 수행한다. 컴백 카드는 모든 실행에서 강제로 표시하지 않고 2~6일 기록 공백 등 기존 자격 조건을 따른다.
- 두 기능을 함께 검증한 결과를 각 기능의 단독 실험 성공으로 해석하지 않는다. 분리 비교용 플래그와 측정 절차는 [Control 실험](product-specs/hydration-logging.md#control-widget-experiment-322), [컴백 실험](product-specs/challenge-insight.md#comeback-experiment-323)을 따른다.

추가 플래그 없는 로컬 Release 검증:

```sh
tuist generate --no-open
xcodebuild -workspace Mulimi.xcworkspace -scheme Mulimi -configuration Release \
  -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build
```

생성된 두 소비 타깃의 실제 조건도 확인한다. 아래 명령은 조건 줄만 출력해 빌드 설정의 secret을 노출하지 않는다.

```sh
xcodebuild -workspace Mulimi.xcworkspace -scheme WidgetExtension -configuration Release \
  -destination 'generic/platform=iOS' -showBuildSettings \
  | rg 'SWIFT_ACTIVE_COMPILATION_CONDITIONS =.*MULIMI_CONTROL_WIDGET_EXPERIMENT'
xcodebuild -workspace Mulimi.xcworkspace -scheme DependencyInjection -configuration Release \
  -destination 'generic/platform=iOS' -showBuildSettings \
  | rg 'SWIFT_ACTIVE_COMPILATION_CONDITIONS =.*MULIMI_COMEBACK_EXPERIMENT'
```

모두 끄는 별도 Release 검증은 빌드 명령에 `SWIFT_ACTIVE_COMPILATION_CONDITIONS=''`를 지정한다. `$(inherited)`를 포함하면 Release 기본 실험 조건이 다시 합쳐지므로, 분리 실험/비활성 검증에서는 조건 전체를 명시적으로 덮어쓴다.

로컬 확인(2026-09-08): 추가 플래그 없는 Release와 Debug 앱 빌드 통과. 두 소비 타깃 모두 Release에서 두 실험 조건이 활성화되고 Debug에서는 `DEBUG`만 적용됨을 확인했다. 별도 baseline 조건은 기본 실험 조건을 덮어썼고, Release 위젯 바이너리에 Control 식별자가 포함됐다. 서명 archive·업로드·실기기 QA는 미실행이다.

## 3) (선택) 배포 연동
필요하면 같은 워크플로에 배포 단계를 추가:
- TestFlight distribute
- 또는 아카이브 산출물만 유지

## 4) 운영 방식
- 릴리즈 빌드 트리거:
  - `git tag v1.0.0`
  - `git push origin v1.0.0`
- 빌드 결과는 Xcode Cloud 대시보드에서 확인

## 5) 현재 범위
- 포함: Release Archive 자동화
- 포함: Release dSYM 생성 및 PostHog symbol set 업로드
- 제외: Xcode Cloud 기반 PR 유닛 테스트 게이팅
- GitHub Actions 담당: PR lint, architecture check, 기능별 `Domain`/`Data`/`Presentation` 유닛 테스트
