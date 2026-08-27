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
