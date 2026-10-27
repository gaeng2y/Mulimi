# Tuist Builds와 캐시

Mulimi는 [`gaeng2y/mulimi`](https://tuist.dev/gaeng2y/mulimi)에 빌드 기록과 캐시를 연결한다. 설정 원본은 루트 `Tuist.swift`, CLI 버전은 `.mise.toml`의 **4.206.0**이다. 캐시 서비스 재시작과 구성 해시의 수정이 포함된 버전을 사용한다.

2026-10-26 검증에서 4.213.0은 현재 프로젝트의 원격 캐시 endpoint를 얻지 못해 로컬 캐시로 전환되었다. 4.206.0은 기존 원격 캐시 업로드를 확인한 버전이다. 이후 버전을 올릴 때는 실제 원격 적중·업로드까지 다시 확인한다.

## 설정 정책

| 기능 | 기본 동작 |
| --- | --- |
| Builds / Build Insights | 생성한 스킴의 `tuist inspect build`와 CLI의 `tuist xcodebuild`로 빌드 기록을 전송한다. |
| Xcode Cache | `enableCaching: true`로 컴파일 캐시를 활성화하고 `tuist setup cache`로 원격 캐시 서비스를 준비한다. |
| Module Cache | `.local`, `.remote` 저장소를 사용한다. 기본 프로필은 `only-external`이며 앱·기능 소스는 프로젝트에 남긴다. |

클라우드 기능은 기본으로 켜져 있다. 로그인하지 않은 환경과 fork PR은 `TUIST_MULIMI_CLOUD_ENABLED=0`으로 생성한다. 이 경우 `fullHandle`, 기록 전송, 원격·Xcode 캐시를 비활성화하고 로컬 모듈 캐시만 사용한다. 설정을 바꾼 뒤에는 프로젝트를 다시 생성해야 한다.

## 로컬 준비

```sh
mise install
mise exec -- tuist auth login
make fetch
make generate
```

`make generate`는 먼저 `make tuist-setup`으로 캐시 서비스를 준비한다. 직접 `tuist generate`를 쓰는 환경에서는 최초 한 번과 Xcode·Tuist 변경 후 `make tuist-setup`을 실행한다. 서비스 설정은 빌드가 실행 중이지 않을 때 수행한다.

모듈 바이너리를 처음 만들거나 변경된 의존성을 갱신할 때:

```sh
# 기본: Debug 외부 라이브러리 캐시를 만들고 공유
make tuist-cache
make generate

# 필요한 경우 앱 내부 모듈도 캐시
make tuist-cache CACHE_PROFILE=all-possible
mise exec -- tuist generate Mulimi --no-open --configuration Debug --cache-profile all-possible

# Release용 캐시는 별도로 준비
make tuist-cache CACHE_CONFIGURATION=Release
make generate CACHE_CONFIGURATION=Release
```

모듈 캐시는 일반 빌드만으로 생성되지 않는다. `tuist cache`로 바이너리를 준비하고, 이후 `tuist generate`에서 일치하는 캐시를 사용한다. `make tuist-cache`는 바이너리 준비 명령이며 작업용 프로젝트는 그 뒤 `make generate`로 복원한다. 캐시가 없거나 입력이 바뀌면 해당 모듈을 소스로 빌드한다.

준비와 생성의 `--configuration`을 동일하게 명시한다. 예를 들어 `--configuration Debug`로 준비한 캐시는 `tuist generate --configuration Debug`로 사용한다. Makefile과 CI·Preview는 이 값을 맞춘다. 이전 4.205.0에서는 구성 옵션 생략 여부만으로 해시가 달라지는 문제도 있었다.

`all-possible`은 캐시 가능한 내부 모듈도 바이너리로 바꾼다. 앱·기능 코드를 편집하거나 단위 테스트를 실행할 때는 기본 `only-external`로 생성한다. Xcode Cache는 이때 소스로 남은 모듈의 컴파일 결과를 재사용한다.

## 빌드 기록 확인

Xcode에서 생성된 `Mulimi` 스킴을 빌드하면 스킴 후처리가 기록을 전송한다. 터미널·CI에서는 다음 명령을 쓴다.

```sh
mise exec -- tuist xcodebuild build \
  -workspace Mulimi.xcworkspace \
  -scheme Mulimi \
  -destination 'generic/platform=iOS' \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO
```

Tuist wrapper는 `-resultBundlePath`가 없으면 실행별 결과 경로를 만든다. CI와 Preview 스크립트는 결과 경로를 명시한다. 기존 `.xcresult` 경로는 덮어쓸 수 없으므로 직접 지정할 때는 매번 새 경로를 사용한다. 빌드 실패와 기록 업로드 실패는 로그에서 각각 확인한다.

빌드 후 대시보드에서 다음을 확인한다.

- **Builds**: 스킴, 브랜치, 소요 시간, 성공 여부
- **Xcode Cache**: 컴파일 작업의 캐시 적중·전송 기록
- **Module Cache**: 바이너리 준비와 프로젝트 생성 시 캐시 사용 기록

첫 빌드는 캐시를 채운다. 같은 입력을 다시 빌드하거나 같은 Xcode·Tuist 버전의 다른 머신에서 생성할 때 재사용을 확인한다. 개발 머신의 `CompilationCache.noindex`까지 삭제하면 로컬 컴파일 캐시도 사라진다.

## CI

### GitHub Actions

`pr-unit-tests.yml`과 `tuist-preview.yml`은 같은 저장소 PR·수동 실행에서 OIDC로 인증한다. Tuist GitHub App 및 `gaeng2y/Mulimi` 연결, job의 `id-token: write`가 필요하다.

1. 고정된 Tuist와 의존성을 설치한다.
2. `tuist auth login`으로 인증한다.
3. `make tuist-cache`로 Xcode Cache를 준비하고 외부 모듈 캐시를 채운다.
4. 기본 프로필로 프로젝트를 생성한다.
5. `tuist xcodebuild`와 결과 번들로 빌드·테스트 기록을 전송한다.

단위 테스트의 fork PR은 클라우드 기능·인증·캐시 업로드를 건너뛰고 소스 테스트를 계속한다. Preview workflow는 기존과 같이 fork PR 전체를 건너뛴다. Preview 산출물 검증과 공유 절차는 [Tuist Previews](tuist-previews.md)를 따른다.

### Xcode Cloud

`ci_post_clone.sh`는 **비밀 환경 변수 `TUIST_TOKEN`이 있는 경우** 캐시 서비스를 준비하고 Release 외부 모듈 캐시를 사용한다. 토큰이 없으면 클라우드 기능을 끄고 Release 프로젝트를 생성한다. 토큰은 저장소에 넣지 않고 Xcode Cloud 콘솔에서 설정한다. 자세한 설정은 [Release Build](xcode-cloud-release-build.md)를 따른다.

## 인증 없이 빌드

```sh
TUIST_MULIMI_CLOUD_ENABLED=0 make generate
TUIST_MULIMI_CLOUD_ENABLED=0 make preview-build
```

클라우드 기능을 다시 쓰려면 로그인 후 `make generate`를 실행한다. 위 설정은 프로젝트 생성에 적용되므로 이미 생성한 프로젝트의 원격 캐시 설정을 자동으로 바꾸지는 않는다.

## 문제 해결

| 증상 | 확인·조치 |
| --- | --- |
| 인증·권한 오류 | 로컬은 `tuist auth login`, GitHub Actions는 저장소 연결과 OIDC 권한을 확인한다. |
| 캐시 socket·proxy 연결 오류 | 진행 중인 빌드가 끝난 뒤 `make tuist-setup`과 `make generate`를 실행한다. |
| Module Cache가 비어 있음 | `make tuist-cache` 완료 여부와 생성 프로필·Debug/Release 일치를 확인한다. |
| Builds에 CLI 빌드가 없음 | `tuist xcodebuild` 사용, 결과 번들 생성, 인증과 업로드 로그를 확인한다. |
| 캐시를 끄고 재현해야 함 | `TUIST_MULIMI_CLOUD_ENABLED=0 mise exec -- tuist generate --no-open --no-binary-cache` 후 빌드한다. |

## 공식 근거

- [Build Insights — Generated projects](https://tuist.dev/en/docs/guides/features/build-insights/generated-xcode-project)
- [Xcode Cache](https://tuist.dev/en/docs/guides/features/cache/xcode-cache)
- [Module Cache](https://tuist.dev/en/docs/guides/features/cache/module-cache)
- [Tuist 4.206.0 릴리스](https://github.com/tuist/tuist/releases/tag/4.206.0)
- [캐시 서비스 재시작 수정](https://github.com/tuist/tuist/pull/12437)
- [구성 해시 일관성 수정](https://github.com/tuist/tuist/pull/12524)
- [Tuist 4.206.0 생성 옵션](https://github.com/tuist/tuist/blob/4.206.0/cli/Sources/ProjectDescription/ConfigGenerationOptions.swift)
- [Tuist 4.206.0 CLI 빌드 기록·결과 번들 처리](https://github.com/tuist/tuist/blob/4.206.0/cli/Sources/TuistKit/Services/XcodeBuild/XcodeBuildBuildCommandService.swift)
