# 선별한 에이전트 절차 검증

2026-10-29, `develop`의 `69c84fc`에서 만든 `feature/pstack-verification` 작업 트리를 확인했다. 변경은 작업 규칙·스킬 진입점·문서·PR 템플릿이다. 앱 구현이나 CI 실행 코드는 변경하지 않았다.

## 실행한 검사

- `git diff --check`: 공백 오류 없음.
- 최종 설치 경로에서 변경 Markdown 13개의 로컬 파일·제목 앵커 링크 139개를 검사했고 모두 통과했다.
- 변경 문서의 `sh`·`bash` 코드 블록 18개를 `sh -n`으로 검사했고 모두 통과했다. 구문 검사이며 블록 안의 앱 실행·캡처 명령은 실행하지 않았다.
- `skill-creator/scripts/quick_validate.py`의 `validate_skill`로 `mulimi-verify`, `mulimi-blast-radius`, `mulimi-architect`를 준비 경로와 최종 설치 경로에서 검사했고 모두 `Skill is valid!`였다. 설치 파일이 준비한 파일과 바이트 단위로 같은지도 확인했다. 기본 Python에 PyYAML이 없어 아래 기존 캐시 의존성을 사용했으며 패키지를 설치하지 않았다.

최종 설치 후 저장소 루트에서 사용한 스킬 검사 방식은 다음과 같다.

```python
import runpy
import sys
from pathlib import Path

sys.path.insert(0, "/Users/gaeng2y/.cache/uv/archive-v0/_PcF9BZIucK7Tq6C")
validate = runpy.run_path(
    "/Users/gaeng2y/.codex/skills/.system/skill-creator/scripts/quick_validate.py"
)["validate_skill"]
for name in ("mulimi-verify", "mulimi-blast-radius", "mulimi-architect"):
    path = Path(".agents/skills") / name
    valid, message = validate(path)
    assert valid, (path, message)
    print(path.name, message)
```

## 독립적인 시나리오 검토

별도 에이전트에 세 스킬과 관련 문서, 아래 요청·상황만 제공하고 선택 절차와 완료 판단을 확인했다. 실제 앱을 실행한 검증은 아니다.

| 요청과 주어진 상황 | 검토 결과 |
| --- | --- |
| 마시기 후 숫자가 그대로인 버그 수정. 기존 설치 앱의 사후 캡처만 있고 시뮬레이터 실행 실패 | 수정 완료 불가. 실행 환경·빌드 확인, 수정 전 재현, 회귀 검사, 수정 빌드의 동일 경로 확인이 필요 |
| HealthKit 재조회 변경의 Watch 영향 리뷰. 단위 테스트 통과, 실기기 동기화 실행 불가 | 읽기 전용 영향 분석. 코드·테스트 범위의 결론과 실기기 미검증을 분리하며 자동 수정하지 않음 |
| 목표 저장소 교체의 설계만 요청 | 호출자·계약·소유권·검증 계획을 설계하고 구현·stub을 추가하지 않음 |
| README 오타 한 글자 수정 | 문맥·diff·공백 검사로 확인. 세 스킬의 전체 절차나 앱 빌드를 불필요하게 실행하지 않음 |

검토에서 나온 모호성 두 가지를 보정했다. 시뮬레이터 실행 불가 시 근거 있는 코드 수정은 가능하되 앱 재현은 미검증으로 남기도록 명시했다. 리뷰 중 발견한 결함은 보고하고 수정 요청이 있을 때만 수정 절차로 진행하도록 명시했다.

## 실행하지 않은 검사와 한계

- 앱 빌드·단위 테스트·시뮬레이터 조작·스크린샷: 앱 동작 변경이나 재현할 제품 버그가 없는 지침 변경이다. 새 절차로 실제 버그 한 건을 끝까지 검증한 상태는 아니다.
- SwiftLint·아키텍처 검사·Tuist 생성·Graphify 갱신: 소스·타깃·의존성 변경이 없다.
- CI의 증거 자동 검사나 기능별 UI 자동화는 추가하지 않았다. 스킬은 기존 검증 도구와 문서를 연결한다.
- 세 스킬의 형식과 링크 검증은 스킬 목록에 자동 표시되는지의 UI 확인을 대신하지 않는다. 세션이 목록을 갱신하기 전에는 `AGENTS.md`의 경로로 읽을 수 있다.
