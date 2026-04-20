# Exec Plan Template

이 파일은 긴 작업을 시작할 때 복사해서 사용한다. 저장 위치는 `Docs/exec-plans/active/YYYY-MM-DD-issue-###-short-title.md`를 권장한다.

## Title

이슈 번호와 작업 이름을 적는다.

## Context

- 왜 이 작업이 필요한가?
- 관련 이슈, PR, 문서는 무엇인가?
- 현재 코드나 제품 상태는 어떤가?

## Goal

- 이 작업이 끝났을 때 달라져야 하는 사용자/개발자 관찰 결과를 적는다.
- 구현 세부보다 완료 조건을 먼저 적는다.

## Non-Goals

- 이번 작업에서 하지 않을 범위를 명시한다.
- 후속 작업으로 분리할 항목이 있으면 적는다.

## Constraints

- 아키텍처 경계
- 데이터 source of truth
- 호환성, 권한, capability
- 마이그레이션 필요 여부

## Plan

1. 관련 문서와 코드 경계를 확인한다.
2. 변경할 레이어와 파일 범위를 정한다.
3. 구현한다.
4. 문서를 갱신한다.
5. 검증한다.
6. 후속 작업을 남긴다.

## Validation

- 실행할 검증 명령을 적는다.
- 변경 유형별 기준은 `Docs/quality-gates.md`를 따른다.

## Rollback

- 문제가 생기면 어떤 변경을 되돌리면 되는지 적는다.
- 데이터나 설정 변경이 있으면 복구 방법을 적는다.

## Open Questions

- 결정이 필요한 질문을 남긴다.
- 답이 나오면 결정 내용과 근거를 기록한다.

## Completion Notes

- 완료 후 실제 변경 요약을 적는다.
- 실행한 검증 결과를 적는다.
- 남은 후속 작업은 `Docs/exec-plans/tech-debt-tracker.md` 또는 GitHub issue로 옮긴다.
