# Tuist Previews

Mulimi의 Debug iOS Simulator 빌드를 공유하는 절차다. 연결 대상은 기존 Tuist 프로젝트 [`gaeng2y/mulimi`](https://tuist.dev/gaeng2y/mulimi)다.

## 설정과 준비

- `.mise.toml`이 Tuist **4.205.0**을 고정한다. `mise install` 후 `mise exec -- tuist version`으로 확인한다.
- 루트 `Tuist.swift`가 `fullHandle`과 Generated Project 구성을 선언한다. `Tuist/Tuist.swift`는 이 버전의 설정 탐색 위치에 포함되지 않는다.
- iOS/watchOS 26 이상 SDK가 포함된 Xcode가 필요하다. 실행할 Mac에는 iOS 26 이상 시뮬레이터 런타임도 설치한다.
- 인증 없이도 일반 프로젝트 생성과 `make preview-build`를 실행할 수 있다. `optionalAuthentication`을 사용하며, 모듈 캐시 저장소는 로컬로 한정한다.
- 공유할 때는 Tuist 계정에 해당 프로젝트의 업로드·조회 권한이 있어야 한다.

```sh
mise install
mise exec -- tuist auth login
mise exec -- tuist project show gaeng2y/mulimi
```

설정 위치는 Tuist 4.205.0의 [설정 로더](https://github.com/tuist/tuist/blob/4.205.0/cli/Sources/TuistConfigLoader/SwiftConfigLoader.swift)를 기준으로 한다. 로그인 세션과 CI 인증은 [공식 CI 안내](https://tuist.dev/en/docs/guides/integrations/continuous-integration)를 따른다.

## 로컬 빌드와 공유

```sh
# 빌드·산출물 검증
make preview-build

# 인증 확인 → 빌드·검증 → 업로드
make preview-share
```

두 명령은 `scripts/tuist-preview.py`를 실행한다.

1. `XCConfig/Secrets.xcconfig`가 없으면 템플릿과 `TEAM_ID`로 준비한다. 기본 팀 ID는 기존 CI와 같다.
2. Tuist/Xcode/SDK 버전을 출력하고 의존성을 설치한다.
3. `tuist generate --no-open --no-binary-cache`로 프로젝트를 생성한다.
4. 기존 Icon Composer 보정·검증 스크립트를 실행한다.
5. `Mulimi` 스킴을 Debug, `generic/platform=iOS Simulator`로 빌드한다. Watch 타깃의 SDK 선택을 위해 전역 `-sdk`는 지정하지 않는다.
6. 앱·위젯·워치의 bundle ID, 실행 파일, 시뮬레이터 플랫폼과 버전 일치 여부를 확인한다. 앱 에셋과 UI·현지화 프레임워크도 확인한다.
7. 공유 명령은 해당 실행의 DerivedData 경로와 `Debug`/iOS를 지정해 `tuist share --json`을 실행한다.

산출물은 Git에서 제외된 `.build/tuist-preview/run-*/`에 보관한다. 실행마다 새 DerivedData를 만들어 이전 앱을 업로드하지 않도록 한다. `build.json`에는 빌드 시작 시점의 커밋·미커밋 변경 여부·버전·앱 경로가 있고, 공유 성공 시 `preview.json`에 URL을 기록한다. 로그에 출력된 해당 실행 경로를 사용한다. 누적된 산출물은 필요할 때 `.build/tuist-preview/`에서 정리한다.

Preview에서는 코드 서명을 끄고 PostHog 설정을 빈 값으로 주입해 기존 NoOp 분석 경로로 동작한다. 앱의 실제 로그인·권한 흐름을 검증하려면 시뮬레이터에 필요한 테스트 계정을 준비한다.

### 빌드 번호

- CI: `GITHUB_RUN_NUMBER.GITHUB_RUN_ATTEMPT` — 재실행도 다른 번호를 사용한다.
- 로컬: UTC 시각 `YYYYMMDDHHMMSS` — 시뮬레이터 공유용 식별자다.
- 재현용 번호가 필요하면 `PREVIEW_BUILD_NUMBER=123.2 make preview-build`처럼 지정한다. 공유 시에는 아직 업로드하지 않은 값을 사용한다.
- `APP_BUILD_NUMBER`를 xcodebuild 인자로 전달하므로 앱·위젯·워치에 함께 적용된다. 릴리스 버전 SSOT는 `Tuist/ProjectDescriptionHelpers/AppVersion.swift`다.

Tuist는 같은 빌드·버전의 중복 업로드를 거부할 수 있으므로 CI에서 고유한 번호를 사용한다. [Previews 공식 안내](https://tuist.dev/en/docs/guides/features/previews)

## Preview 실행

공유 명령이 출력한 URL을 사용한다.

```sh
mise exec -- tuist run <preview-url>

# 해당 브랜치에 업로드된 Preview가 있을 때
mise exec -- tuist run Mulimi@develop
```

Tuist macOS 앱의 Preview 페이지에서도 실행할 수 있다. `Mulimi@latest`는 **Tuist 프로젝트의 기본 브랜치**를 따른다. GitHub 연동은 저장소 기본 브랜치를 동기화할 수 있으므로 `develop` 빌드는 `@develop` 또는 개별 URL로 선택한다. 접근자는 프로젝트 조회 권한과 호환되는 시뮬레이터가 필요하다. [실행 방법](https://tuist.dev/en/docs/guides/features/previews)

## GitHub 연결과 CI

### 최초 연결

Tuist 계정 설정의 **Integrations**에서 Tuist GitHub App 설치 상태를 확인하고 `gaeng2y/Mulimi` 접근을 허용한다. 이어서 기존 `gaeng2y/mulimi` 프로젝트를 해당 저장소와 연결한다. 이 연결은 OIDC 인증과 자동 PR 코멘트의 선행 조건이다. [GitHub 연결 절차](https://tuist.dev/en/docs/guides/integrations/gitforge/github)

### 실행 조건

`.github/workflows/tuist-preview.yml`은 다음 이벤트를 처리한다.

- 같은 저장소에서 `develop`으로 보내는 PR: PR의 head 커밋을 빌드한다.
- Actions의 **Tuist Preview → Run workflow**: 선택한 브랜치를 빌드한다. workflow가 기본 브랜치에 등록돼야 수동 실행 메뉴가 나타난다.
- fork PR: 업로드 job을 건너뛴다.

`macos-15`의 `latest-stable` Xcode를 선택하고, mise로 고정된 Tuist를 설치한다. `contents: read`, `id-token: write` 권한으로 `tuist auth login`을 실행해 OIDC로 인증한다. 사용자 토큰을 CI secret으로 복사할 필요가 없다. [CI 인증](https://tuist.dev/en/docs/guides/integrations/continuous-integration)

공유 성공 시 Actions summary에서 URL·빌드한 커밋·버전·실행 명령을 확인한다. Tuist GitHub 연동은 해당 PR에도 Preview 링크를 게시한다. 수동 실행은 Actions summary에서 결과를 확인한다. 업로드나 빌드가 실패하면 job이 실패하며 성공 링크를 만들지 않는다. 같은 PR의 새 실행은 이전 실행을 취소한다.

## 검증과 문제 해결

```sh
make lint
make arch-check
make preview-check
make preview-build
```

`make preview-check`는 외부 업로드 없이 오래된 산출물·버전 불일치·실기기 바이너리·리소스 누락·실패 후 잘못된 성공 링크 생성을 검사한다. 실제 업로드·설치 검증은 `make preview-share` 후 URL 실행으로 수행한다.

| 증상 | 확인할 항목 |
| --- | --- |
| 로그인 갱신 시간 초과 | `tuist auth login`으로 재인증하고 서버 접근을 확인한다. 일반 빌드는 `make preview-build`로 진행할 수 있다. |
| OIDC 인증 실패 | Tuist의 GitHub 저장소 연결과 job의 `id-token: write` 권한을 확인한다. |
| PR에 코멘트가 없음 | Actions summary의 업로드 결과, Tuist GitHub App 설치·저장소 연결을 확인한다. |
| Watch 아이콘 또는 플랫폼 오류 | 전역 `-sdk iphonesimulator` 없이 지정된 Preview 명령을 사용한다. |
| 빌드 번호·리소스 검사 실패 | 같은 실행의 산출물과 Icon Composer 검증 로그를 확인한다. 실패한 산출물은 공유하지 않는다. |
| 링크 실행 실패 | Tuist 조회 권한과 iOS 26+ 시뮬레이터 설치 상태, 빌드 아키텍처를 확인한다. |

PR에는 로컬 검사, 실제 공유·실행, Actions 결과를 각각 기록한다. 실기기용 배포는 서명·프로비저닝과 설치 검증을 포함해 별도로 진행한다.
