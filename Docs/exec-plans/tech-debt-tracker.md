# Tech Debt Tracker

즉시 처리하지 않았지만 추적이 필요한 항목만 적는다. 장문의 회고 문서가 아니라 운영용 리스트로 유지한다.

## Open

| Area | Debt | Impact | Next Step |
| --- | --- | --- | --- |
| Documentation | `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`의 중복 안내를 장기적으로 정리할 필요가 있다 | 문서 수정 누락 위험 | 에이전트별 파일을 얇은 포인터 구조로 축소할지 검토 |
| Documentation | 기존 개별 도메인 문서와 `product-specs` 역할 분리가 아직 완전히 끝나지 않았다 | 요구사항 탐색 경로가 분산됨 | 기능 변경 시 관련 문서를 `product-specs` 기준으로 조금씩 재정리 |
| Reliability | HealthKit/알림/위젯/워치 복구 정책을 통합한 운영 문서가 없다 | 장애 대응 기준이 흩어질 수 있음 | 복구 규칙이 더 복잡해지면 `RELIABILITY.md` 추가 |
| Security | Apple 로그인, Firebase, App Group, iCloud KVS 운용 규칙을 따로 정리한 문서가 없다 | 민감 설정 변경 시 검토 비용 증가 | 보안 관련 설정 변경이 늘어나면 `SECURITY.md` 추가 |

## Closed

- 없음
