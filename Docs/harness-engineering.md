# Harness Engineering Structure

Mulimi에서 말하는 하네스 엔지니어링은 AI 에이전트와 개발자가 같은 기준으로 작업할 수 있게 문서, 규칙, 검증 흐름을 구조화하는 운영 레이어다. 이 문서는 각 문서가 어떤 책임을 갖는지와 어디를 먼저 읽어야 하는지를 정리한다.

## Goals

- 작업 시작 전에 읽어야 할 문서를 빠르게 찾게 한다.
- 제품 요구, 구조 규칙, 실행 계획, 검증 규칙을 분리한다.
- 문서가 늘어나도 SSOT가 어디인지 헷갈리지 않게 한다.

## Top-Level Map

```text
AGENTS.md          -> 작업 규칙과 읽기 순서
README.md          -> 제품 개요와 개발 시작점
ARCHITECTURE.md    -> 구조 SSOT
Docs/index.md      -> 문서 허브
Docs/product-specs -> 사용자 흐름 요구사항
Docs/skills        -> 구현 전 체크리스트
Docs/exec-plans    -> 실행 계획과 기술 부채
Docs/quality-gates.md -> 변경 유형별 검증 기준
Docs/documentation-maintenance.md -> 문서 유지보수 규칙
Docs/delivery-workflow.md -> 이슈, 브랜치, PR 전달 흐름
Docs/security-privacy.md -> 보안/개인정보 운영 기준
Docs/*.md          -> 도메인/설계 배경 문서
```

## Reading Path

1. `AGENTS.md`
2. `README.md`
3. `ARCHITECTURE.md`
4. `Docs/index.md`
5. 작업 대상 이슈
6. 브랜치/PR 기준이 필요하면 `Docs/delivery-workflow.md`
7. 관련 `Docs/product-specs/`
8. 관련 `Docs/skills/`
9. 실제 코드와 `Project.swift`

## Document Roles

### `AGENTS.md`
- 작업 순서, 금지 규칙, 기본 검증 절차
- 에이전트/자동화 작업의 운영 기준

### `README.md`
- 저장소 소개
- 기술 스택, 실행 방법, 빠른 문서 진입점

### `ARCHITECTURE.md`
- 레이어 책임
- 데이터 source of truth
- 전역 구조 규칙의 SSOT

### `Docs/index.md`
- 문서 허브
- 어떤 상황에 어떤 문서를 읽어야 하는지 연결

### `Docs/product-specs/`
- 현재 사용자 흐름 요구사항
- 화면이나 상태 전이가 바뀌면 먼저 갱신할 문서

### `Docs/skills/`
- 구현 전에 확인할 기술 규칙
- 예: 아키텍처 경계, HealthKit 흐름, 내비게이션, 워치/위젯, 검증 순서

### `Docs/exec-plans/`
- 긴 작업의 계획과 결정 기록
- 진행 중 작업, 완료 기록, 기술 부채 추적
- 새 실행 계획은 `Docs/exec-plans/template.md`를 복사해 작성

### `Docs/*.md`
- 특정 도메인에 대한 깊은 설계 배경
- 예: 챌린지 상태, 개인화 전략, 프로필 구조

### `Docs/quality-gates.md`
- 변경 유형별 최소 검증 기준
- PR 본문에 어떤 검증을 적어야 하는지 판단하는 기준

### `Docs/documentation-maintenance.md`
- 문서별 SSOT와 갱신 조건
- 새 문서를 만들지 기존 문서를 갱신할지 판단하는 기준

### `Docs/delivery-workflow.md`
- 이슈를 브랜치, 커밋, PR로 전달하는 기준
- 기능 PR과 릴리스 PR의 base/head 분리 규칙
- PR 템플릿 작성과 검증 결과 보고 기준

### `Docs/security-privacy.md`
- 민감 데이터 저장소, 권한, 외부 SDK, App Store privacy label 영향 검토 기준
- 광고/IAP/서버 연동 전 확인할 개인정보 체크리스트

## Update Rules

- 제품 요구 변경: `Docs/product-specs/` 우선 갱신
- 구조 규칙 변경: `ARCHITECTURE.md`와 관련 `Docs/skills/` 갱신
- 검증 기준 변경: `Docs/quality-gates.md`와 관련 `Docs/skills/` 갱신
- 이슈/PR 운영 기준 변경: `Docs/delivery-workflow.md`와 필요한 템플릿 갱신
- 보안/개인정보 경계 변경: `Docs/security-privacy.md` 갱신
- 문서 구조 변경: `Docs/documentation-maintenance.md`, `Docs/index.md`, `README.md` 링크 갱신
- 긴 작업 시작: `Docs/exec-plans/active/`에 계획 기록
- 긴 작업 종료: `Docs/exec-plans/completed/`로 이동하거나 `tech-debt-tracker.md`에 후속 항목 기록
- 코드와 문서가 어긋나면 코드를 먼저 확인하고 작업 끝에 문서를 맞춘다

## What Is Intentionally Missing

- `DESIGN.md`, `FRONTEND.md`, `SECURITY.md`, `RELIABILITY.md` 같은 루트 대형 운영 문서는 아직 만들지 않았다.
- 이유는 현재 Mulimi 규모에서 유지비가 더 크기 때문이다.
- 보안/개인정보 운영 기준은 `Docs/security-privacy.md`로 분리한다.
- 신뢰성, 디자인 운영 규칙이 실제로 복잡해질 때 별도 SSOT로 분리한다.

## Maintenance Principle

- 문서는 많이 두는 것보다 경계가 명확해야 한다.
- 같은 내용을 여러 파일에 복제하지 않는다.
- 루트 문서는 방향을 잡고, `Docs/`는 역할별 세부 문서를 제공하는 구조를 유지한다.
