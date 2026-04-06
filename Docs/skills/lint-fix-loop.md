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
- 구조 규칙: `scripts/check-architecture.sh`
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

## Notes

- `swiftlint:disable`는 마지막 수단이다.
- 범위를 최소화하고 이유를 남긴다.
- 아키텍처 위반은 포맷 문제가 아니라 설계 문제로 본다.
