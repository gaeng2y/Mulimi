# lint-fix-loop

## When to use

- 커밋 전
- PR 전
- `SwiftLint` 또는 아키텍처 검사 실패 후

## Goal

린트 실패를 사람이 수동 리뷰하기 전에 먼저 자동 수정 루프로 흡수한다.

## Source of Truth

- Swift 스타일 규칙: `.swiftlint.yml`
- 공통 실행: `scripts/lint.sh`, `scripts/lint-fix.sh`
- 구조 규칙: `ARCHITECTURE.md`, `Docs/skills/architecture-boundary.md`
- 구조 규칙 검사: `scripts/check-architecture.sh`, `scripts/check-ui-boundaries.py`
- UI 경계 검사기의 회귀 테스트: `scripts/test-ui-boundaries.py`
- 로컬 차단: `.githooks/pre-commit`
- CI 차단: `.github/workflows/lint.yml`

## Loop

1. `make lint`
2. 실패하면 `make lint-fix`
3. 다시 `make lint`
4. `make arch-check`
5. 남는 위반만 수동 수정

## Commands

```bash
make lint
make lint-fix
make arch-check
make verify
```

UI 경계 검사기를 바꿨다면 다음 명령도 실행한다.

```sh
python3 scripts/test-ui-boundaries.py
```

## Check Scope

- `check-architecture.sh`는 Domain의 UI·역방향 import, ViewModel의 시스템 API·다른 ViewModel 참조, `HydrationServing` 밖의 250ml 리터럴을 검사한다.
- 여기서 호출하는 `check-ui-boundaries.py`는 `Project/`의 Swift import와 리터럴 Tuist 타깃 의존 선언을 확인한다. Foundation 직접 소비, UI 계층의 역방향 의존, Domain의 UI 의존, 레거시 `DesignSystem` 사용을 차단한다.
- 이 검사들은 전체 Swift 의미 분석을 수행하지 않는다. 생성된 의존성이나 런타임 동작은 프로젝트 생성·테스트·빌드로 확인한다.
- `make verify`와 커밋 훅은 UI 경계 검사기를 실행한다. 별도의 fixture 회귀 테스트는 Lint CI에 포함되며 로컬에서는 위 명령으로 실행한다.
- 커밋 훅은 staged Swift 경로가 있어야 동작한다. 정확한 조건과 CI 범위는 [하네스 자동화 표](../harness-engineering.md#automation-harness)를 참고한다.

## Notes

- `swiftlint:disable`는 마지막 수단이다.
- 범위를 최소화하고 이유를 남긴다.
- 아키텍처 위반은 포맷 문제가 아니라 설계 문제로 본다.
