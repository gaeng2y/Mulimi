# Delivery Workflow

Mulimi에서 이슈를 실제 변경과 PR로 연결하는 운영 흐름이다. 코드 구조 규칙은 `ARCHITECTURE.md`, 검증 기준은 `Docs/quality-gates.md`, 문서 갱신 기준은 `Docs/documentation-maintenance.md`를 따른다. 이 문서는 그 규칙을 GitHub 작업 단위로 묶는다.

## Goals

- 이슈, 브랜치, 커밋, PR의 기준을 한 곳에서 확인한다.
- 기능 PR과 릴리스 PR의 base/head를 섞지 않는다.
- PR 본문에 실제로 수행한 검증만 기록한다.
- 본문이 빈 이슈라도 작업 범위와 근거가 PR에 남게 한다.

## Issue Intake

1. 이슈 제목, 본문, 댓글을 확인한다.
2. 본문이 비어 있으면 최근 관련 이슈, PR, 문서에서 범위를 추론한다.
3. 추론한 범위는 PR Summary 또는 실행 계획에 명시한다.
4. 제품 흐름 변경이면 관련 `Docs/product-specs/`를 먼저 확인한다.
5. 구조나 운영 규칙 변경이면 `ARCHITECTURE.md`, `Docs/harness-engineering.md`, `Docs/skills/` 중 어느 문서가 SSOT인지 먼저 정한다.

## Branch Strategy

기능 또는 문서 작업의 기본 흐름은 아래와 같다.

```text
develop -> feature/#<issue-number>-<short-title> -> PR to develop
```

- 새 작업은 `develop`에서 `feature/#<issue-number>-<short-title>` 브랜치를 만든다.
- 릴리스 목적이 아니면 `develop -> main` PR을 만들지 않는다.
- `develop -> main`은 릴리스 또는 배포 동기화 PR로만 사용한다.
- 실수로 `develop`에 먼저 커밋했다면, 리뷰용 feature 브랜치를 변경 전 커밋에서 만들고 해당 커밋을 cherry-pick해 PR 범위를 좁힌다.
- 같은 이슈 안에서도 서로 독립적인 코드 변경과 문서 변경이 너무 커지면 PR을 분리한다.

## Commit Rules

- 커밋은 하나의 리뷰 가능한 변경 단위를 담는다.
- 커밋 메시지는 프로젝트에서 사용하는 `gitmoji -c` 흐름을 우선한다.
- 커밋 전에는 작업 트리에 이슈 범위 밖 변경이 섞였는지 확인한다.
- 사용자가 만든 미관련 변경은 스테이징하거나 되돌리지 않는다.

## PR Creation

PR은 `.github/pull_request_template.md`를 기준으로 작성한다.

- 제목은 변경의 관찰 가능한 결과를 적는다.
- `Related Issues`에는 `Closes #<issue-number>` 또는 `Related to #<issue-number>`를 명시한다.
- `Changes Made`는 Added, Changed, Fixed, Removed를 실제 변경에 맞게 채운다.
- UI 변경이 없으면 Screenshots 섹션에 첨부 없음으로 명시한다.
- Draft PR은 리뷰 전 정리나 CI 확인이 남아 있을 때 사용한다.
- Ready for review 전환은 남은 검증과 문서 갱신이 끝난 뒤에 한다.

## AI Review Automation

`.github/workflows/ai-pr-review.yml`은 Git Flow 흐름에 맞는 PR이 생성되거나 Draft에서 Ready for review로 전환될 때만 AI 리뷰를 남긴다.

- `feature/*`, `bugfix/*`, `release/*` -> `develop`
- `develop`, `release/*`, `hotfix/*` -> `main`
- 일반 push나 PR 동기화(`synchronize`)에는 재실행하지 않는다.
- 외부 모델 호출에는 `OPENAI_API_KEY` Actions secret이 필요하다.
- 모델은 repository variable `OPENAI_REVIEW_MODEL`로 바꿀 수 있고, 기본값은 workflow에 둔다.
- fork PR에는 secrets가 기본 전달되지 않으므로 리뷰가 건너뛸 수 있다.

## Validation Reporting

검증 기준은 `Docs/quality-gates.md`가 SSOT다.

- 실행한 명령과 결과만 `Test Results`에 적는다.
- 실행하지 않은 검증은 이유를 적는다.
- 시뮬레이터 문제로 재실행했다면 실패한 조건과 성공한 조건을 모두 남긴다.
- 문서 전용 변경이라도 `git diff --check`는 확인한다.
- 코드 변경이면 최소한 `make lint`와 `make arch-check`를 먼저 본다.

## Documentation Updates

- 새 제품 정책이나 화면 상태가 생기면 `Docs/product-specs/`를 갱신한다.
- 구조 규칙이 바뀌면 `ARCHITECTURE.md` 또는 관련 `Docs/skills/`를 갱신한다.
- 작업 운영 규칙이 바뀌면 이 문서와 `Docs/harness-engineering.md`를 갱신한다.
- 새 문서를 만들면 `Docs/index.md`와 필요한 README 링크를 갱신한다.
- 장기 결정이나 후속 작업은 `Docs/exec-plans/`에 남긴다.

## Merge And Issue Closure

- `Closes #<issue-number>`가 PR 본문에 있으면 merge 시 이슈가 닫히는지 확인한다.
- 구현이 일부만 끝났다면 `Closes` 대신 `Related to`를 사용하고 남은 범위를 이슈 댓글이나 후속 이슈로 남긴다.
- 머지 후 남은 기술 부채는 `Docs/exec-plans/tech-debt-tracker.md` 또는 새 GitHub issue로 옮긴다.
- 릴리스 PR은 여러 feature PR이 이미 `develop`에 머지된 상태에서만 `main`으로 올린다.

## Anti-Patterns

- 기능 리뷰용 PR을 `develop -> main`으로 만드는 것
- PR 본문에 실행하지 않은 테스트를 통과로 적는 것
- 빈 이슈의 범위를 PR에 설명하지 않는 것
- 문서가 필요한 구조 변경을 코드만 바꾸고 끝내는 것
- unrelated 변경을 한 커밋에 섞는 것
