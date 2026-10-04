# #336 Watch 최근 기록 한 건 되돌리기

## Context

- [#336](https://github.com/gaeng2y/Mulimi/issues/336)은 수요·안전성 검증 후보다. 사용자의 구현 요청에 따라 이슈의 최소 범위를 개발하며 사용자 수요가 검증됐다고 간주하지 않는다.
- 변경 전 Watch 저장 결과는 성공 여부만 반환했다. 화면의 최신 시각·용량으로 삭제 대상을 추정해서는 안 된다.

## Goal

- 이번 Watch 앱 실행 중 마지막으로 성공한 기록의 양·시각을 확인하고 그 샘플 한 건만 취소한다.
- 실패·권한 철회·이미 삭제된 기록을 취소 성공으로 표시하지 않는다.

## Non-Goals

- 전체 기록 편집기, 영속적인 취소 이력, 새 건강 원장, 사용자 수요·효과를 입증하는 주장.

## Constraints

- HealthKit을 원본으로 유지한다. 저장 성공 후 실제 샘플 UUID를 전달하고 UUID 조건의 단건 삭제 결과를 확인한다.
- Core는 시스템 API, Watch Data는 오류 변환, Domain은 기록·취소 흐름, Presentation은 최근 저장 영수증과 화면 상태를 담당한다.

## Plan

1. 저장 UUID 반환과 삭제 건수 확인을 Core에 반영한다.
2. Watch 저장 영수증·단건 삭제·되돌리기 UI를 연결한다.
3. 같은 시각·용량의 다른 기록, iPhone 동시 기록, 권한 철회·삭제 실패·중복 동작을 검증한다.
4. 제품 스펙·테스트 타깃 구조·공유 그래프를 갱신하고 gitmoji 커밋·PR로 전달한다.

## Validation

- `make lint`, `make arch-check`, `tuist generate --no-open`
- WatchHydration 테스트, 기존 Hydration 테스트, watchOS Simulator 및 iOS 앱 빌드
- 테스트 데이터 화면 확인. 실기기 권한·동기화·사용자 시안 비교는 결과를 별도로 기록한다.

## Rollback

- 이 기능 커밋을 되돌린다. 새 영속 저장소·마이그레이션은 없다. 이미 삭제한 HealthKit 기록을 자동으로 복원하지 않는다.

## Open Questions

- 실제 Watch 오입력 사례와 시안 비교 결과는 미확인이다. 구현 PR만으로 원래 수요 검증 이슈를 닫지 않는다.

## Completion Notes

- 최소 구현·로컬 검증 완료, PR 전달 단계다. 미머지이므로 active에 유지한다.
- 실제 저장 샘플 UUID를 전달하고 HealthKit 조건부 삭제 건수가 1일 때만 성공한다. 취소 대상은 메모리에만 유지한다.
- `WatchHydrationTests` 정의 6개·매개변수 포함 12건 통과: 같은 시각·용량의 외부/iPhone 기록, 동시 기록, 권한 철회, 이미 삭제됨, 삭제 실패, 저장 실패/목표 차단, 취소 대상 수명, 중복 동작, Core UUID·삭제 건수 계약.
- 기존 iOS `HydrationDomain` 65개·`HydrationData` 6개·`HydrationPresentation` 91개 통과. `make lint` 316개 파일 위반 0, `make arch-check`, `tuist generate --no-open`, Watch Debug Simulator·iOS Release 서명 없는 빌드, `git diff --check` 통과.
- Xcode 27.0(27A266a), Tuist 4.205.0, Watch SE 3 40mm/watchOS 27, iPhone 17e/iOS 27 사용. 첫 Watch 테스트의 테스트 대역 Sendable 오류는 문자열 스냅샷으로 수정 후 통과했다. Release 빌드의 샌드박스 서비스 접근 실패는 시스템 접근 허용 후 통과했다.
- 실제 View·ViewModel과 임시 테스트 UseCase로 확인 창 닫기·성공·큰 글씨의 권한 실패 화면 확인. [제품 스펙과 캡처](../../product-specs/hydration-logging.md#watch-recent-record-undo-336)에 기록했다. 임시 QA 앱은 제품에 포함하지 않는다.
- 테스트 타깃과 CI 연결, 구조도 showcase 9/9·오류/경고 0 및 라이트/다크 4장 확인 완료. 격리 `GRAPHIFY_OUT` AST-only 갱신과 공유 산출물 검증 완료; 문서 의미 재분석은 하지 않았다.
- 실제 Watch 사용자 사례·시안 평가·실기기 HealthKit 동기화/권한·VoiceOver 낭독은 미검증이다. 원래 #336은 이 PR만으로 닫지 않는다.
