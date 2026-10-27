# Tech Debt Tracker

즉시 처리하지 않았지만 추적이 필요한 항목만 적는다. 장문의 회고 문서가 아니라 운영용 리스트로 유지한다.

## Open

| Area | Debt | Impact | Next Step |
| --- | --- | --- | --- |
| Documentation | 기존 개별 도메인 문서와 `product-specs` 역할 분리가 아직 완전히 끝나지 않았다 | 요구사항 탐색 경로가 분산됨 | 기능 변경 시 관련 문서를 `product-specs` 기준으로 조금씩 재정리 |

## Follow-up Validation

2026-10-14에 실행 계획과 PR 머지 상태를 대조했다. 아래 항목은 구현 기록에 남은 검증이며, 이번 문서 작업에서 기기·운영 검증을 새로 수행한 결과는 아니다.

| 대상 | 남은 확인 | 추적 위치·다음 단계 |
| --- | --- | --- |
| #320 스타터 플랜 | 실제 배포 버전, 작은 화면·큰 글씨·VoiceOver, Widget·Watch·Siri 안내, PostHog 수신·활성화 효과 | [완료된 구현 계획](completed/2026-09-13-issue-320-starter-plan.md), [스타터 플랜 요구](../product-specs/sign-in-onboarding-healthkit.md#seven-day-starter-plan-320). 이슈 종료와 별도로 기기·운영 근거를 기록 |
| #350 조회 복구 | 서명·설치·잠금/읽기 권한, Siri·잠금 화면 Widget 실사용 | [완료된 구현 계획](completed/2026-10-03-issue-350-read-recovery.md), [HealthKit 복구 검증](../quality-gates.md#healthkit-조회-복구-검증-350). 오류 주입 테스트와 실기기 확인 결과를 구분 |
| Preview/Testing DI | #320·#350 당시 전체 Preview 빌드 실패 및 Testing 스킴 부재 | [당시 실패·타입 검사 기록](completed/2026-10-03-issue-350-read-recovery.md#추가-검증의-제한)을 기준으로 현재 환경에서 재현 여부부터 확인. 이번 문서 작업에서는 재실행하지 않음 |
| #321·#336·#329 | 알림 기록 측정, Watch 수요·안전성, 가이드 발행·관찰 | 각 [활성 계획](../index.md#delivery-and-operations)에 현재 상태와 남은 작업을 유지 |

## Closed

- Harness: `CLAUDE.md`, `GEMINI.md`는 `AGENTS.md` symlink 진입점으로 유지하고, 문서 유지보수 규칙에 공통 규칙 복제 금지를 명시했다. 관련 이슈: [#217](https://github.com/gaeng2y/Mulimi/issues/217).
- Reliability: HealthKit/알림/위젯/워치 복구 정책은 `Docs/reliability-recovery.md`로 추가했다. 즉시 구현 후속은 [#219](https://github.com/gaeng2y/Mulimi/issues/219), [#220](https://github.com/gaeng2y/Mulimi/issues/220)로 분리했다.
- Security: Apple 로그인, 제품 분석, App Group, iCloud KVS, AdMob/IAP 사전 체크리스트는 `Docs/security-privacy.md`로 정리했다. 관련 이슈: [#215](https://github.com/gaeng2y/Mulimi/issues/215).
- Analytics: Firebase Analytics 의존성과 dual-write 운영 기준을 제거하고 제품 분석과 오류 추적을 PostHog로 통합했다. 관련 이슈: [#286](https://github.com/gaeng2y/Mulimi/issues/286).
