# Tech Debt Tracker

즉시 처리하지 않았지만 추적이 필요한 항목만 적는다. 장문의 회고 문서가 아니라 운영용 리스트로 유지한다.

## Open

| Area | Debt | Impact | Next Step |
| --- | --- | --- | --- |
| Documentation | 기존 개별 도메인 문서와 `product-specs` 역할 분리가 아직 완전히 끝나지 않았다 | 요구사항 탐색 경로가 분산됨 | 기능 변경 시 관련 문서를 `product-specs` 기준으로 조금씩 재정리 |

## Closed

- Harness: `CLAUDE.md`, `GEMINI.md`는 `AGENTS.md` symlink 진입점으로 유지하고, 문서 유지보수 규칙에 공통 규칙 복제 금지를 명시했다. 관련 이슈: [#217](https://github.com/gaeng2y/Mulimi/issues/217).
- Reliability: HealthKit/알림/위젯/워치 복구 정책은 `Docs/reliability-recovery.md`로 추가했다. 즉시 구현 후속은 [#219](https://github.com/gaeng2y/Mulimi/issues/219), [#220](https://github.com/gaeng2y/Mulimi/issues/220)로 분리했다.
- Security: Apple 로그인, Firebase, App Group, iCloud KVS, AdMob/IAP 사전 체크리스트는 `Docs/security-privacy.md`로 정리했다. 관련 이슈: [#215](https://github.com/gaeng2y/Mulimi/issues/215).
