# Docs Index

Mulimi 문서 허브다. 코드와 문서가 충돌하면 코드를 먼저 확인하고, 작업이 끝나면 문서를 맞춘다.

## Read Order

1. `AGENTS.md`
2. `README.md`
3. `ARCHITECTURE.md`
4. 작업 대상 이슈
5. 관련 `product-specs` 또는 도메인 문서
6. 수정 대상 모듈의 `Project.swift`와 실제 구현

## Core Docs

- [README](../README.md)
- [AGENTS](../AGENTS.md)
- [ARCHITECTURE](../ARCHITECTURE.md)

## Product Specs

- [Product Specs Index](product-specs/index.md)
- [SignIn, Onboarding, HealthKit Gate](product-specs/sign-in-onboarding-healthkit.md)
- [Hydration Logging](product-specs/hydration-logging.md)
- [Routine Notifications](product-specs/routine-notifications.md)
- [Challenge and Insight](product-specs/challenge-insight.md)

## Domain And Architecture Docs

- [Profile Information Architecture](profile-information-architecture.md)
- [Personalized Challenge Strategy](personalized-challenge-strategy.md)
- [Challenge State Model](challenge-state-model.md)
- [SwiftData CloudKit Sync](swiftdata-cloudkit-sync.md)
- [SwiftData UserDefaults Migration](swiftdata-userdefaults-migration.md)

## Skills

- [architecture-boundary](skills/architecture-boundary.md)
- [healthkit-flow](skills/healthkit-flow.md)
- [navigation-coordinator](skills/navigation-coordinator.md)
- [widget-watch-integration](skills/widget-watch-integration.md)
- [lint-fix-loop](skills/lint-fix-loop.md)
- [xcode-build-test](skills/xcode-build-test.md)

## Delivery And Operations

- [Exec Plans Active](exec-plans/active/README.md)
- [Exec Plans Completed](exec-plans/completed/README.md)
- [Tech Debt Tracker](exec-plans/tech-debt-tracker.md)
- [Xcode Cloud Release Build](xcode-cloud-release-build.md)

## Maintenance Rule

- 제품 요구가 바뀌면 `Docs/product-specs/`를 우선 갱신한다.
- 구조 규칙이 바뀌면 `ARCHITECTURE.md`와 필요한 `Docs/skills/`를 갱신한다.
- 긴 작업은 `Docs/exec-plans/active/`에 남기고, 종료 후 `completed/`로 옮긴다.
