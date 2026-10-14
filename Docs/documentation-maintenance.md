# Documentation Maintenance

Mulimi 문서가 코드와 함께 유지되도록 관리하는 규칙이다. 문서는 많아지는 것보다 책임 경계가 명확해야 한다.

## Source Of Truth

| 주제 | SSOT | 갱신 조건 |
| --- | --- | --- |
| 저장소 소개와 시작 방법 | `README.md` | 실행 방법, 주요 기능, 대표 문서 링크가 바뀔 때 |
| 작업 규칙과 금지 규칙 | `AGENTS.md` | 에이전트/개발자 공통 작업 규칙이 바뀔 때 |
| 에이전트별 진입 파일 | `CLAUDE.md`, `GEMINI.md` | `AGENTS.md` symlink로 유지한다. 도구 전용 예외가 필요해도 공통 규칙을 복제하지 않는다 |
| 구조 규칙 | `ARCHITECTURE.md` | 레이어 책임, Source of Truth, 전역 흐름이 바뀔 때 |
| 실제 타깃·직접 의존 선언 | `Project/**/Project.swift` | 타깃, 플랫폼, 의존성, 공유 소스 경계가 바뀔 때 |
| 구조·의존성 스냅샷과 구조도 | `Docs/project-architecture-and-dependencies.md`, `Docs/diagrams/` | 실제 선언·구현이 바뀌면 검토 기준 커밋, 직접 의존성 목록, 영향받는 그림을 함께 맞출 때 |
| 문서 허브 | `Docs/index.md` | 새 문서가 생기거나 읽기 경로가 바뀔 때 |
| 하네스 구조와 운영 구조도 | `Docs/harness-engineering.md`, `Docs/diagrams/mulimi-harness-architecture.*` | 문서 진입, 로컬 검사, CI, 실행 계획 정리 흐름이 바뀔 때 |
| 이슈/PR 전달 흐름 | `Docs/delivery-workflow.md` | 브랜치 전략, PR 템플릿 작성, 이슈 종료 기준이 바뀔 때 |
| 보안/개인정보 운영 | `Docs/security-privacy.md` | 권한, 민감 데이터 저장소, 외부 SDK, 광고/IAP, App Store privacy label 영향이 바뀔 때 |
| 제품 요구 | `Docs/product-specs/` | 사용자 흐름, 화면 상태, 정책 문구가 바뀔 때 |
| 구현 체크리스트 | `Docs/skills/` | 특정 기술 영역의 작업 절차가 바뀔 때 |
| 검증 기준 | `Docs/quality-gates.md` | 변경 유형별 필수 검증 기준이 바뀔 때 |
| 실행 계획 | `Docs/exec-plans/` | 긴 작업의 계획, 결정, 후속 작업을 남길 때 |

구조·의존성 문서와 그림은 코드를 설명하는 스냅샷이지 새로운 구조 규칙이 아니다. 원본·산출물의 보관과 재생성은 [하네스 산출물 관리](harness-engineering.md#architecture-artifacts), 검증 기준은 [품질 게이트](quality-gates.md#architecture-artifact-gate)를 따른다.

## When To Create A New Doc

새 문서는 아래 조건 중 하나를 만족할 때만 만든다.

- 기존 문서에 넣으면 책임이 섞인다.
- 같은 설명을 3번 이상 반복하게 된다.
- PR 리뷰나 이슈 진행에서 같은 판단 기준이 계속 필요하다.
- 코드만 보면 의도를 추적하기 어려운 장기 결정이다.

아래 상황은 새 문서보다 기존 문서 갱신을 우선한다.

- 단일 기능의 문구나 화면 상태 변경
- 기존 제품 스펙의 작은 보강
- 이미 `Docs/skills/`에 있는 절차의 세부 명령 추가
- README 링크만 필요한 변경

## Update Checklist

변경이 끝나기 전에 확인한다.

- 코드와 문서가 충돌하지 않는가?
- 새 문서가 `Docs/index.md`에 연결되어 있는가?
- README에 노출할 만큼 대표 문서인가?
- 변경한 상대 링크·이미지·문서 앵커가 실제 파일과 제목으로 연결되는가?
- 구조 규칙 변경이면 `ARCHITECTURE.md` 또는 `AGENTS.md`도 갱신했는가?
- 타깃·직접 의존성·공유 소스가 바뀌었다면 구조·의존성 목록과 관련 그림을 실제 `Project.swift`에 맞췄는가?
- 구조도를 바꿨다면 원본 JSON, 생성 HTML, 검증 해시, 화면 캡처가 같은 결과를 가리키는가?
- 하네스 변경이면 실제 `Makefile`·훅·스크립트·workflow와 실행 조건을 대조했는가? 자동 검사와 수동 확인 범위를 구분했는가?
- 에이전트 공통 규칙을 도구별 파일에 복제하지 않았는가?
- 긴 작업이면 `Docs/exec-plans/active/` 또는 `completed/`에 기록했는가?
- 과거 문서가 현재 구조를 오도하지 않는가?
- 참고 문서의 수치·커밋·검증 결과를 새로 확인하지 않고 최신 결과처럼 옮기지 않았는가?

## Execution Plan Maintenance

- 각 계획의 첫 문단에 현재 상태, 확인 날짜, 관련 PR과 남은 작업을 적는다. 아래 검증 기록은 실행 당시의 환경·결과로 유지한다.
- 이동 여부는 [머지·완료 조건](delivery-workflow.md#merge-and-issue-closure)을 따른다. GitHub 이슈의 열린/닫힌 상태만으로 실기기 QA나 효과 검증을 완료 처리하지 않는다.
- 계획을 옮기면 `Docs/index.md`와 다른 문서의 해당 링크를 함께 갱신한다. 같은 깊이의 `active/ → completed/` 이동이어도 이미지·상대 링크를 확인한다.
- 새로 실행한 검증은 날짜·명령·환경과 함께 추가한다. 과거 실패가 해결됐다는 근거가 있으면 후속 기록으로 연결하고 원래 실패 기록은 보존한다.
- 문구·링크 변경은 원문으로 확인한다. Graphify의 AST 갱신을 문서 의미 재분석의 근거로 사용하지 않는다.

## Naming

- 문서 파일명은 소문자 kebab-case를 사용한다.
- 실행 계획 파일명은 `YYYY-MM-DD-issue-###-short-title.md`를 권장한다.
- 제품 스펙은 사용자 흐름 기준으로 묶고, 구현 레이어 기준으로 쪼개지 않는다.
- 기술 체크리스트는 `Docs/skills/`에 두고 명령형 이름을 사용한다.

## Stale Document Handling

문서가 오래됐다고 판단되면 삭제보다 먼저 아래 중 하나를 선택한다.

- 현재 코드 기준으로 갱신한다.
- 레거시 참고 문서라면 제목 또는 첫 문단에 명시한다.
- 후속 정리가 필요하면 `Docs/exec-plans/tech-debt-tracker.md`에 남긴다.

## Anti-Patterns

- 같은 규칙을 README, AGENTS, ARCHITECTURE에 모두 길게 복제하지 않는다.
- `CLAUDE.md`, `GEMINI.md`에 `AGENTS.md` 원문을 복제하지 않는다.
- 제품 요구를 실행 계획 문서에만 남기지 않는다.
- 임시 예외를 문서로 합리화하지 않는다.
- 검증하지 않은 명령을 통과한 것처럼 기록하지 않는다.
