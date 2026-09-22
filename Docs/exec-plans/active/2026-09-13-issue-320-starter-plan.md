# #320 — 7일 스타터 플랜 제품 적용

## Context

- 이슈 #320의 세 단계 체크리스트를 사용자 요청에 따라 실험 분기 없이 실제 제품에 적용한다.
- 효과 검증·모집은 이번 구현의 완료 조건이 아니다. D7 개선을 검증했다고 보고하지 않는다.
- 기존 `Docs/feature-discovery.md` 우선순위 초안은 별도 stash에 보존하고 이 PR에 포함하지 않는다.

## Goal

- 성공한 물리미 기록이 확인되면 메인에서 7일 스타터 플랜에 진입한다.
- 기록 확인, 실제 루틴 저장, 빠른 기록 방법 선택을 구분한다.
- 기존 루트 내비게이션과 루틴 편집기를 사용한다. 완료·닫기는 재실행해도 유지한다.

## Non-Goals

- 새 스케줄러·건강 원장·타깃·의존성·실험 플래그·보상 시스템.
- Widget/Watch 자동 설치 또는 설치 확인으로 오해할 수 있는 완료 표시.

## Constraints And Decisions

- Hydration Domain은 7일 기간과 로컬 설정 상태, Data는 UserDefaults, Presentation은 조회·체크리스트를 담당한다.
- 수분 기록은 HealthKit, 루틴은 기존 RoutineUseCase에서 매번 확인한다.
- 신규·기존 사용자 모두 기능 도입 뒤 오늘의 물리미 기록이 처음 확인된 시점부터 기기 날짜 기준 7일(시작일 포함) 동안 한 번 안내한다. 앱의 생애 최초 기록일이라고 주장하지 않는다.
- 알림 없이 저장한 루틴도 ‘루틴 저장’ 단계는 완료다. 알림 허용을 강제하지 않는다.
- 기기 로컬 안내 상태는 로그아웃으로 초기화하지 않는다. 재설치·다른 기기 동기화는 범위 밖이다.

## Plan

1. Git Flow feature 브랜치 생성 및 기존 변경 분리.
2. 상태·저장소·ViewModel·화면·DI·루트 라우팅 구현.
3. 기간·영속화·취소/실패·실제 완료·분석 계약 테스트와 제품 문서 갱신.
4. lint, architecture, 프로젝트 생성, 변경 레이어 테스트, 앱 빌드.
5. 격리 Graphify 갱신, gitmoji 커밋, develop 대상 템플릿 PR.

## Validation

- `git diff --check`, `make lint`, `make arch-check`, `tuist generate --no-open`.
- Hydration Domain/Data/Presentation 및 MulimiNavigation 테스트, Mulimi 앱 빌드.
- 작은 화면·큰 글씨·VoiceOver·실기기 설치 안내는 확인한 범위만 보고한다.

## Rollback

- 스타터 진입점·DI·추가 코드를 되돌린다. 로컬 `hydrationStarterPlan.v1` 키는 건강 기록이나 루틴에 영향을 주지 않는다.

## Implementation Notes (2026-09-14)

- 개발과 로컬 검증을 마쳤다. feature 브랜치의 develop 대상 PR으로 전달하며, 병합 전까지 이 계획은 `active/`에 유지한다.

- 실험 플래그 없이 세 단계 체크리스트·기기 로컬 상태·기존 루틴/기록 라우팅·분석 이벤트 계약을 구현했다. 새 타깃이나 의존성은 추가하지 않았다.
- `make lint` 309개 파일 위반 0, `make arch-check`, `tuist generate --no-open`, `Localizable.xcstrings` JSON/신규 한국어 26개 키 검증 통과.
- Xcode 26.6 / Tuist 4.205.0 / iPhone 17 Pro iOS 26.5에서 HydrationDomain 62, HydrationData 4, HydrationPresentation 87, MulimiNavigation 3개 테스트 통과. 총 156개 테스트, 매개변수별 실행을 포함하면 183회, 실패·스킵 0.
- `xcodebuild build -workspace Mulimi.xcworkspace -scheme Mulimi -configuration Release -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO` 통과. 기존 AccentColor 자산 경고와 로컬 PostHog dSYM 업로드 자격 증명 미설정 경고가 있다.
- 추가 `DependencyInjectionPreview` 빌드는 기존 MockHealthKitUseCase의 `amount`/`mililiter` 불일치와 MockUserPreferencesUseCase의 `hasCompletedOnboarding` 재선언으로 실패했다. 두 파일과 관련 기존 API는 develop 대비 변경하지 않았다. 제품 Release 빌드와 기능 테스트에는 영향이 없으며 프리뷰 복구는 별도 범위다.
- UI 자동 조작 도구가 활성화되어 있지 않아 작은 화면/큰 글씨/VoiceOver 수동 확인과 Widget·Watch·Siri 실제 설치/실행 QA는 하지 않았다. 화면은 스크롤 List와 명시적인 완료 텍스트를 사용한다. 이 구현 사실을 수동 검증 통과로 대체하지 않는다.
- PostHog 실수신, GitHub Actions, Xcode Cloud archive, D7 효과 검증은 로컬 테스트 결과와 구분한다.
- Graphify는 격리 출력에서 AST-only 갱신했다. 문서 의미 재분석이나 새 LLM 라벨링은 하지 않았다.
- 검증 로그와 xcresult: `/tmp/mulimi-320-validation.2T3m55/` (로컬 임시 산출물, Git 제외).
