# #360 Tuist Previews 적용

## Context

- 이슈: [#360](https://github.com/gaeng2y/Mulimi/issues/360)
- 기존 Tuist 프로젝트: `gaeng2y/mulimi`
- 작업 브랜치: `feature/#360-tuist-previews`, PR base: `develop`
- `Tuist/Tuist.swift`는 Tuist 4.205.0 설정 탐색 경로에 없어 루트 `Tuist.swift`로 옮긴다.

## Goal

로컬과 GitHub Actions에서 같은 명령으로 Debug iOS Simulator 앱을 빌드·검증·공유하고, 리뷰어가 Preview URL로 실행한다.

## Constraints

- 앱·위젯·워치의 Preview 빌드 번호를 빌드 인자로 함께 주입한다.
- Tuist 버전은 `.mise.toml`로 고정한다.
- 인증은 로컬 Tuist 세션과 CI OIDC를 사용한다.
- 앱의 타깃과 기능 레이어 의존성은 현재 구성을 따른다.
- 실기기 배포와 원격 캐시 성능 검토는 각각 후속 작업과 #90에서 다룬다.

## Plan

1. Tuist 설정 위치·버전과 인증 상태를 확인한다.
2. 빌드·공유 진입점과 산출물 검증을 추가한다.
3. 같은 저장소 PR과 수동 실행용 CI를 구성한다.
4. 사용 방법·하네스·품질 게이트를 갱신한다.
5. 로컬 빌드·실행·공유와 PR CI 결과를 확인한다.
6. `gitmoji -c`로 커밋하고 템플릿에 맞춰 PR을 만든다.

## Validation

- `make lint`, `make arch-check`, `make preview-check`
- Tuist 설정 dump, 프로젝트 생성, Icon Composer 검증
- `make preview-build`, 시뮬레이터 설치·실행
- 인증이 가능한 환경에서 `make preview-share`, URL 다운로드·실행
- workflow 구문 검사, PR CI와 수동 실행 결과

## Rollback

Preview workflow와 명령을 되돌리면 기존 테스트·릴리스 경로를 사용한다. 앱 데이터 마이그레이션은 없다.

## Progress

- 2026-10-18: 구현 시작. 로컬 Tuist 인증 갱신이 시간 초과로 실패해 재로그인을 요청했다. 업로드·서버 연결 검증은 인증 복구 후 진행한다.
- 구현: 루트 Tuist 설정·버전 고정, `make preview-build/share/check`, PR·수동 CI와 사용 문서를 추가했다. 생성 단계의 인증은 선택 사항이고 모듈 캐시는 로컬로 한정한다.
- 로컬 검증: SwiftLint 328개 파일 위반 0개, 아키텍처 검사, Preview 회귀 테스트 10개, actionlint 1.7.12 검사를 통과했다. 일반 `tuist generate --no-open`도 인증 없이 통과했다.
- 빌드: Xcode 27.1 (`27A9275`), Tuist 4.205.0, Debug 시뮬레이터 빌드 성공. `x86_64`와 `arm64`를 포함하며 앱·위젯·워치 모두 `2.6.0 (20261017154552)`로 검증했다. 전역 `-sdk iphonesimulator`를 제거해 Watch가 `watchsimulator`로 빌드되도록 했다.
- 실행: iOS 27.0의 새 iPhone 18 Pro 시뮬레이터에 설치·실행해 로그인 초기 화면을 확인했다. 로컬 변경이 포함된 빌드이며 기준 커밋은 `ed71ce1`이다.
- 빌드 로그: 기존 소스의 FoundationModels deprecated API, AccentColor, AppIntents 메타데이터 경고가 있다. SSU archive 오류 문구도 출력되지만 xcodebuild는 성공으로 종료했고 앱 실행을 확인했다.
- 공유 검증: `make preview-share`는 프로젝트 조회 단계에서 `You must be logged in to do this`로 종료됐다. 업로드 성공이나 Preview URL 실행으로 보고하지 않는다.
- 공유 지식 그래프는 격리된 출력 경로에서 AST만 갱신했다. 4,244개 노드·11,299개 관계이며 세션 기록은 포함하지 않았다.

## Remaining Validation

- Tuist 프로젝트 조회·업로드 인증 복구와 실제 Preview URL 실행
- Tuist GitHub App의 `gaeng2y/Mulimi` 연결, PR OIDC 업로드·코멘트 확인
- workflow가 기본 브랜치에 등록된 후 `workflow_dispatch` 실행 확인

이 항목은 #360과 PR에서 계속 추적한다. 실제 공유 검증이 끝나기 전에는 완료로 표시하지 않는다.
