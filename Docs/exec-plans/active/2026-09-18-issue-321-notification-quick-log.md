# #321 수분 알림 바로 기록

## Context

- [#321](https://github.com/gaeng2y/Mulimi/issues/321)의 “마셨어요” 액션을 Release에서도 사용할 수 있도록 구현하고 git flow feature PR로 전달한다.
- 기준 브랜치: `develop` (`d187dac`), 작업 브랜치: `feature/#321-notification-quick-log`.
- 기존 #320 작업 폴더와 `Docs/feature-discovery.md` 미커밋 변경을 보존하기 위해 별도 worktree를 사용했다.

## Goal

알림에서 기본 한 잔을 실제 HealthKit 저장 결과에 따라 처리하고, 실패·중복을 구분하며 측정 가능한 범위를 문서화한다.

## Non-Goals

스누즈, 별도 수분 원장, 알림 스케줄 정책/목표 정책 변경, 전환 개선을 검증했다고 주장하는 것은 범위 밖이다.

## Constraints

- 수분 기록 원본은 HealthKit, 기본 단위는 HydrationServing.
- `.authenticationRequired` 후 백그라운드 처리, 조회 실패 시 쓰기 차단.
- 반복 요청 ID와 실제 전달 시각으로 멱등 키를 만들며 HealthKit sync metadata와 성공 전달 영수증으로 중복 방지.
- App에서 시스템 알림·라우팅을 조립하고 Domain에 기록 규칙, Data에 저장, Presentation에 액션 상태·분석을 둔다.

## Plan

1. 기존 알림과 HealthKit 저장·DI·분석 흐름 확인 완료.
2. 액션·실패 안내·멱등 저장·측정 이벤트 구현 완료.
3. Domain/Data/Presentation 테스트와 Release 앱 빌드 검증.
4. 제품·분석·의존성 문서, 구조도, graphify 공유 산출물 갱신.
5. `gitmoji -c` 커밋 후 템플릿으로 `develop` 대상 PR 생성.

## Validation

`make lint`, `make arch-check`, `tuist generate --no-open`, 변경 기능 테스트, Release 앱 빌드, archify 구조도 검증. 최종 결과는 PR의 로컬 검증에 기록한다.

## Rollback

이 PR을 되돌리고 다음 앱 실행에서 기존 알림 스케줄을 재동기화한다. 저장된 HealthKit 기록을 자동 삭제하지 않는다. 전달 영수증은 수분 원장이 아니므로 기록 복구에 사용하지 않는다.

## Open Questions

- 실제 잠금/백그라운드/앱 종료/권한 철회 환경에서 HealthKit 샘플 검증은 TestFlight 기기 QA가 필요하다.
- 기준선과 실제 전달·노출 분모가 없으므로 전환 개선 판정은 보류한다. 선택 대비 결과율만 보조 지표로 보고한다.

## Completion Notes

구현 PR은 #321과 `Related to`로 연결한다. 위 실험·기기 검증이 남아 있으므로 이슈를 자동 종료하지 않는다. [측정 및 기기 QA](../../product-specs/hydration-reminder-priming.md#notification-quick-logging-321)를 따른다.

### 로컬 검증 결과

- Xcode 27.0 (27A266a), Tuist 4.205.0, iPhone 17 Pro iOS 26.5 (`125B9A31-6A4A-466D-A8AB-410730B22446`).
- `git diff --check`, `make lint`(307개 파일, 위반 0), `make arch-check`, localization JSON 검사, `tuist generate --no-open` 통과.
- Hydration Domain 64 / Data 5 / Presentation 84, HydrationReminder Domain 10 / Data 8 / Presentation 10, RoutinePresentation 17: 총 198개 테스트 정의 통과(파라미터 실행 별도).
- 초기 Presentation 테스트는 Metal Toolchain 누락으로 실패했으며 `xcodebuild -downloadComponent MetalToolchain` 설치 후 통과.
- 전체 `Mulimi` Release 빌드는 로컬 Xcode 27이 기존 `watchkit2-extension` 제품 형식을 거부해 차단됐다. Watch 구조 마이그레이션 또는 지원되는 Xcode 환경에서 전체 빌드 재검증이 필요하다.
- 제품용 `DependencyInjection`과 iOS 기능 의존 모듈 Release 컴파일 및 해당 산출물을 사용한 `AppDelegate.swift` Swift 6 타입 검사는 통과했다. 자동 생성 DI 스킴은 기존 Testing 타깃 오류도 포함하므로, 무시되는 로컬 검증 스킴 `Mulimi321ProductionDI`에서 제품 타깃 하나만 선택했다. 이는 전체 앱 빌드 통과를 의미하지 않는다.
- 실제 기기의 HealthKit 저장·잠금 상태 및 PostHog 전송/전환 지표는 미검증이다.
