# Tuist Builds·Xcode Cache·Module Cache 연결

상태: 구현·로컬 빌드·문서 산출물 검증 완료(2026-10-26). 사용자 요청으로 `release/2.7.0`에서 진행한다. 관련 릴리스 PR은 [#367](https://github.com/gaeng2y/Mulimi/pull/367)이며 CI·머지 결과는 PR에서 확인한다.

## Context

- `Tuist.swift`의 모듈 캐시 저장소가 로컬로 제한되어 있었다.
- Xcode 컴파일 캐시 설정이 없었고 Preview는 바이너리 캐시를 명시적으로 끄고 있었다.
- 생성 스킴에는 Builds 수집 후처리가 있지만 CLI·CI 인증과 결과 번들 흐름이 연결되지 않았다.

## Goal

- 로컬과 같은 저장소 CI에서 빌드 기록을 전송하고 원격 캐시를 사용할 수 있다.
- 실제 캐시 업로드·적중과 앱 빌드를 확인한다.
- fork PR과 인증 없는 빌드에는 명시적인 클라우드 비활성화 경로를 제공한다.

## Constraints

- 앱·위젯·Watch의 제품 동작과 레이어 의존성은 유지한다.
- 기본 Module Cache 프로필은 `only-external`로 테스트 대상 소스를 유지한다.
- 유료 플랜 전환과 릴리스 배포는 이 작업에 포함하지 않는다.

## Plan

1. Tuist 설정, Makefile, Preview, GitHub Actions, Xcode Cloud 준비 스크립트를 연결한다.
2. 기존 4.205.0에서 확인한 서비스 재시작·구성 해시 문제의 수정 버전을 적용한다.
3. 캐시 준비·생성·빌드·테스트와 인증 없는 생성 경로를 검증한다.
4. 사용 문서, 하네스 구조도, 격리 Graphify 산출물을 갱신한다.

## Validation

- `make lint`, `make arch-check`, `make preview-check`, workflow·셸 구문 검사
- 모듈 캐시 업로드와 생성 시 재사용
- 캐시 사용 앱·Widget·Watch 빌드와 Builds 기록 조회
- 인증 없는 생성에서 원격 캐시·기록 후처리 제거 확인
- 구조도 showcase·화면 검증 및 Graphify 출처 검사

## Rollback

`TUIST_MULIMI_CLOUD_ENABLED=0 mise exec -- tuist generate --no-open --no-binary-cache`로 인증·캐시 없는 프로젝트를 생성할 수 있다. 앱 데이터는 변경하지 않는다.

## Open Questions

- Xcode Cloud의 `TUIST_TOKEN`은 콘솔의 비밀 환경 변수로 별도 설정해야 한다. 토큰 미설정 시 기존 archive 흐름을 유지한다.

## Completion Notes

Tuist 4.205.0의 반복 setup에서 launchd bootstrap 오류와 구성 옵션에 따른 캐시 해시 불일치를 확인했다. 4.213.0은 원격 endpoint 부재로 로컬 캐시만 사용해, 두 수정과 기존 서버 호환성을 갖춘 4.206.0을 선택했다. 이 버전으로 외부 모듈 7개를 원격 업로드했다.

- SwiftLint 328개 파일 위반 0개, 아키텍처 검사, Preview 회귀 검사 11개 통과.
- `actionlint`로 두 workflow, `sh -n`으로 Xcode Cloud 스크립트 확인.
- 외부 모듈 7개 원격 업로드 후 빈 `TUIST_XDG_CACHE_HOME`에서 5개 xcframework·2개 리소스 번들을 내려받아 생성에 사용.
- 시뮬레이터 앱·Widget·Watch 빌드와 산출물 검증 통과.
- 기기용 서명 없는 Debug 앱·Widget·Watch 빌드 통과, 모두 2.7.0(38).
- 새 DerivedData에서 동일 기기용 빌드 재실행: Xcode 로그 기준 `1096 hits / 1096 cacheable tasks (100%)`.
- 같은 빌드의 Tuist 서버 기록에서도 원격 캐시 `771/771` 적중을 확인. Xcode 로그와 서버가 집계하는 작업 수는 다르므로 각각 기록한다.
- `MulimiUISystem` 3개, `WatchHydrationTests` 20개 테스트 통과 및 Tuist 결과 업로드.
- 빈 인증 디렉터리와 클라우드 비활성화 설정으로 생성 성공. 생성된 앱 스킴과 프로젝트에서 원격 캐시·기록 후처리 제거를 확인한 뒤 기본 설정으로 복원.
- Builds 업로드: [시뮬레이터](https://tuist.dev/gaeng2y/mulimi/builds/build-runs/d13cbd22-4b44-4acb-b9d3-e6d77b2ef191), [기기용](https://tuist.dev/gaeng2y/mulimi/builds/build-runs/5ff52a4e-c3aa-4610-b990-40d5cf81c34f), [캐시 재사용](https://tuist.dev/gaeng2y/mulimi/builds/build-runs/4b0c7e6d-c346-4160-b394-04eb80754c51).
- 하네스 구조도: showcase 9/9, 오류·경고 0개. 네 화면 크기의 넘침 검사와 작은·큰 화면의 라이트·다크 캡처 4장 직접 확인. 해시·바이트 수는 [검증 기록](../../harness-engineering.md#harness-artifact-validation)에 보존.
- 격리 `GRAPHIFY_OUT`에서 AST 갱신: 4,391개 노드·11,460개 관계. 생성물 출처·세션 학습 섹션 제외를 확인했으며 문서 의미 분석은 실행하지 않음.

이 변경에서 Preview 공유·앱 설치·서명 archive·Xcode Cloud 실행은 수행하지 않았다. PR 머지 전에는 이 계획을 `active/`에 유지한다.
