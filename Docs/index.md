# Docs Index

Mulimi 문서 허브다. 코드와 문서가 충돌하면 코드를 먼저 확인하고, 작업이 끝나면 문서를 맞춘다.

## Read Order

1. `AGENTS.md`
2. `README.md`
3. `ARCHITECTURE.md`
4. `Docs/index.md` (이 문서)
5. 작업 대상 이슈
6. 브랜치/PR 기준이 필요하면 `delivery-workflow.md`
7. 관련 도메인 문서 또는 `product-specs/`
8. 관련 `skills/`
9. 수정 대상 모듈의 `Project.swift`와 실제 구현

## Core Docs

- [README](../README.md)
- [AGENTS](../AGENTS.md)
- [ARCHITECTURE](../ARCHITECTURE.md)
- [Harness Engineering Structure (운영 구조도·자동화 범위)](harness-engineering.md)
- [Quality Gates](quality-gates.md)
- [Documentation Maintenance](documentation-maintenance.md)
- [Accessibility And Dynamic Type Audit](accessibility-dynamic-type-audit.md)
- [Security And Privacy Operations](security-privacy.md)
- [Tuist Builds와 캐시](tuist-builds-and-cache.md)

## Product Specs

- [Product Specs Index](product-specs/index.md)
- [SignIn, Onboarding, HealthKit Gate](product-specs/sign-in-onboarding-healthkit.md)
- [Onboarding and HealthKit Conversion Experiments](product-specs/onboarding-healthkit-conversion-experiments.md)
- [Hydration Logging](product-specs/hydration-logging.md)
- [Routine Notifications](product-specs/routine-notifications.md)
- [Challenge and Insight](product-specs/challenge-insight.md)
- [Analytics Events](product-specs/analytics-events.md)
- [Analytics Operations](product-specs/analytics-operations.md)
- [Growth Scorecard](product-specs/growth-scorecard.md)

## Domain And Architecture Docs

- [Design System (UI 계층·공개 API·리소스)](design-system.md)
- [Project Architecture And Dependencies (전체 구조도·타깃 의존성)](project-architecture-and-dependencies.md)
- [Feature Discovery (검증 후보와 선정 근거)](feature-discovery.md)
- [Profile Information Architecture](profile-information-architecture.md)
- [Personalized Challenge Strategy](personalized-challenge-strategy.md)
- [Challenge State Model](challenge-state-model.md)
- [SwiftData CloudKit Sync](swiftdata-cloudkit-sync.md)
- [SwiftData UserDefaults Migration](swiftdata-userdefaults-migration.md)

## Skills

- [mulimi-verify](../.agents/skills/mulimi-verify/SKILL.md): 시뮬레이터 재현·수정 전후 증거와 검증
- [mulimi-blast-radius](../.agents/skills/mulimi-blast-radius/SKILL.md): 호출자·저장 계약·앱/위젯/Watch 변경 영향 분석
- [mulimi-architect](../.agents/skills/mulimi-architect/SKILL.md): 인터페이스·상태 소유권·레이어 경계 설계
- [architecture-boundary](skills/architecture-boundary.md)
- [healthkit-flow](skills/healthkit-flow.md)
- [navigation-coordinator](skills/navigation-coordinator.md)
- [widget-watch-integration](skills/widget-watch-integration.md)
- [lint-fix-loop](skills/lint-fix-loop.md)
- [xcode-build-test](skills/xcode-build-test.md)

## Delivery And Operations

- [Tuist Previews 빌드·공유·CI](tuist-previews.md)
- [#360 Tuist Previews 적용 계획](exec-plans/active/2026-10-18-issue-360-tuist-previews.md)

- [#358 하네스 문서와 운영 구조도 갱신](exec-plans/active/2026-10-14-issue-358-harness-docs.md)
- [#356 디자인 시스템 계층 분리 (구현 머지 완료)](exec-plans/completed/2026-10-10-issue-356-design-system.md)
- [#350 HealthKit 조회 실패 복구 (구현 머지 완료)](exec-plans/completed/2026-10-03-issue-350-read-recovery.md)

- [빠른 물 기록 가이드 (발행 전 초안)](marketing/quick-recording-guide.md)
- [Exec Plans Active](exec-plans/active/README.md)
- [Tuist Builds·캐시 연결](exec-plans/active/2026-10-26-tuist-builds-cache.md)
- [Exec Plans Completed](exec-plans/completed/README.md)
- [#336 Watch 되돌리기 (실기기·수요 검증 대기)](exec-plans/active/2026-09-29-issue-336-watch-undo.md)
- [#329 빠른 기록 가이드 (발행·효과 검증 대기)](exec-plans/active/2026-09-25-issue-329-quick-recording-guide.md)
- [#321 알림 바로 기록 (실기기·측정 검증 대기)](exec-plans/active/2026-09-18-issue-321-notification-quick-log.md)
- [#320 7일 스타터 플랜 제품 적용 (구현 머지 완료)](exec-plans/completed/2026-09-13-issue-320-starter-plan.md)
- [Exec Plan Template](exec-plans/template.md)
- [Tech Debt Tracker](exec-plans/tech-debt-tracker.md)
- [Delivery Workflow](delivery-workflow.md)
- [Reliability Recovery](reliability-recovery.md)
- [Xcode Cloud Release Build](xcode-cloud-release-build.md)

## Maintenance Rule

- 제품 요구가 바뀌면 `Docs/product-specs/`를 우선 갱신한다.
- 구조 규칙이 바뀌면 `ARCHITECTURE.md`와 필요한 `Docs/skills/`를 갱신한다.
- 타깃·의존성·소스 공유 경계가 바뀌면 [구조·의존성 스냅샷](project-architecture-and-dependencies.md)과 관련 구조도를 갱신한다.
- 검증 기준이 바뀌면 `Docs/quality-gates.md`와 필요한 `Docs/skills/`를 갱신한다.
- 이슈/PR 운영 흐름이 바뀌면 `Docs/delivery-workflow.md`를 갱신한다.
- 문서 구조가 바뀌면 `Docs/documentation-maintenance.md`와 이 인덱스를 갱신한다.
- 긴 작업은 `Docs/exec-plans/active/`에 남기고, [머지·완료 조건](delivery-workflow.md#merge-and-issue-closure)을 확인한 뒤 `completed/`로 옮긴다.
