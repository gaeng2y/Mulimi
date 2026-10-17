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

- 구현: 루트 Tuist 설정·버전 고정, `make preview-build/share/check`, PR·수동 CI와 사용 문서를 추가했다. 생성 단계의 인증은 선택 사항이고 모듈 캐시는 로컬로 한정한다.
- 전달: [PR #361](https://github.com/gaeng2y/Mulimi/pull/361), 구현 커밋 `a08324b`와 CI 인증 수정 `a711de3`을 `gitmoji -c`로 생성했다.
- 사용자 세션을 요구하는 `tuist project show`는 로컬 사전 확인에만 사용한다. CI는 OIDC 로그인 후 Preview API에서 업로드 권한을 확인한다.
- 공유 지식 그래프는 격리된 출력 경로에서 AST만 갱신했다. 4,245개 노드·11,300개 관계이며 세션 기록은 포함하지 않았다.

## 검증 결과 — 2026-10-18

| 항목 | 결과 |
| --- | --- |
| SwiftLint / 아키텍처 | 328개 파일 위반 0개, UI 경계 포함 통과 |
| Preview 회귀 검사 | 11개 통과 |
| workflow | actionlint 1.7.12 통과 |
| Tuist 설정 / 생성 | fullHandle·선택적 인증·로컬 캐시 확인, 인증 없이 일반 생성 통과 |
| 로컬 빌드 | Xcode 27.1 (`27A9275`), Tuist 4.205.0, Debug `arm64`/`x86_64` 성공 |
| 로컬 공유 | 앱·위젯·워치 `2.6.0 (20261017160536)` 검증 후 업로드 성공 |
| PR CI | [run 39047396063](https://github.com/gaeng2y/Mulimi/actions/runs/39047396063) 성공, Xcode 26.3, 빌드 `2.1`, Tuist PR 코멘트 확인 |
| 기존 PR 테스트 | [run 39047396050](https://github.com/gaeng2y/Mulimi/actions/runs/39047396050) 성공, 단위 테스트와 Watch undo 회귀 검사 포함 |
| 수동 CI | [run 39047611177](https://github.com/gaeng2y/Mulimi/actions/runs/39047611177) 성공, 빌드 `3.1` |
| Preview 설치·실행 | URL에서 내려받은 빌드 `20261017160536`의 설치 버전 확인 후 `simctl launch`, iOS 27.0 / iPhone 18 Pro 로그인 화면 확인 |
| `tuist run` 전체 명령 | 다운로드·설치 후 Simulator GUI 열기 실패: 현재 선택한 Xcode에 `Simulator.app`이 없음 |

검증한 [Preview URL](https://tuist.dev/gaeng2y/mulimi/previews/01a14a9b-9fd7-7fcb-a61d-6fed37d16125)은 같은 커밋의 PR·수동·로컬 빌드를 묶는다. 로컬 공유에는 `a711de3` 위의 문서 수정이 포함됐고 `build.json`에 미커밋 변경 여부를 기록했다.

빌드 로그에는 FoundationModels deprecated API, AccentColor, AppIntents 메타데이터 경고가 있다. 로컬 Xcode의 SSU archive 오류 문구도 출력되지만 xcodebuild는 성공으로 종료했고 앱 실행을 확인했다.

## Remaining Validation

- Simulator GUI가 포함된 Xcode에서 `tuist run <preview-url>` 전체 명령 성공 확인

남은 검증은 #360과 PR에서 추적한다. PR 머지 전까지 이 계획을 active에 유지한다.
