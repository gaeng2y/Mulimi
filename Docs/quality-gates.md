# Quality Gates

Mulimi 변경 사항을 PR 전에 어느 수준까지 검증할지 정리한 문서다. 세부 실행 명령은 `Docs/skills/xcode-build-test.md`와 `Docs/skills/lint-fix-loop.md`를 따르고, 이 문서는 변경 유형별 최소 기준을 정한다.

## Baseline

모든 코드 변경은 아래 순서를 기본값으로 본다.

1. `git diff --check`
2. `make lint`
3. `make arch-check`
4. 변경 레이어에 맞는 테스트 또는 빌드

문서만 바뀐 경우에도 `git diff --check`는 확인한다. 실행하지 않은 검증은 PR 본문에 통과했다고 적지 않는다.

`make verify`는 `make lint`와 `make arch-check`를 묶는다. UI import·Tuist 의존 경계 검사도 포함되지만 UI 경계 회귀 테스트, Unit test, 앱 빌드, 문서·구조도 검증은 별도다. 아래 matrix로 필요한 검증을 고른다. 각 자동화의 실제 실행 조건은 [하네스 자동화 범위](harness-engineering.md#automation-harness)를 따른다.

## 검증 증거

모든 작업은 주장에 맞는 증거를 남긴다. 설명·문서 변경도 근거 확인 대상이며, 실행하지 않은 동작을 코드 열람이나 빌드 성공만으로 검증했다고 보고하지 않는다.

| 주장 | 필요한 증거 |
| --- | --- |
| 코드·구조·정책 설명 | 확인한 소스의 파일·행 또는 문서 링크. 추론은 확인된 사실과 구분 |
| 테스트·빌드 성공 | 실행한 명령, 대상 버전·환경, 종료 결과와 로그 또는 `.xcresult` 경로 |
| 앱 동작·버그 수정 | 실제 사용자 조작 순서, 기대 결과·관찰 결과, 수정 전후 화면과 필요한 로그·저장 결과 |
| 문서·에셋 변경 | 변경한 링크·규격·내용의 검사 결과. 화면 표현은 실제 산출물을 열어 확인 |

각 검증은 `통과`, `실패`, `재현 안 됨`, `미검증`으로 구분한다. 환경·권한·도구 때문에 막혔다면 `미검증`에 원인과 다음 확인 방법을 적는다. `재현 안 됨`이나 리뷰 지적 없음은 수정 완료·안전성의 증거가 아니다. 스크린샷은 화면 상태만 증명하므로 저장·삭제·중복 방지 같은 동작은 실제 경로의 로그, 재조회 또는 관련 테스트로 함께 확인한다.

## 버그 재현과 수정 검증

앱 버그 수정은 아래 절차를 변경 레이어의 최소 검증에 추가한다.

1. 수정 전 버전과 데이터·권한·시간대 등 전제 조건을 기록하고, 담당 시뮬레이터에서 실제 사용자 경로로 버그를 재현한다. 화면을 캡처하고 기대 결과와 다른 지점을 적는다. 크래시·타이밍 문제는 로그나 영상을 함께 남긴다.
2. 원인을 좁히고 재현 가능한 최소 회귀 테스트를 만든다. 수정 전 코드에서 같은 이유로 실패하는지 확인한다. 자동화할 수 없는 UI 문제는 실제 조작 절차와 전후 증거를 회귀 검증으로 남기고 자동화하지 못한 이유를 적는다.
3. 원인을 수정한 뒤 `git diff --check`, `make lint`, `make arch-check`를 실행하고, 회귀 테스트와 영향받은 기존 테스트가 통과하는지 확인한다.
4. 수정된 코드를 빌드·설치해 실행 버전을 확인한다. 같은 시뮬레이터 환경과 동등한 시작 데이터·권한 상태에서 같은 사용자 경로를 다시 수행한다. 결과 상태를 내부 setter나 테스트 전용 성공 응답으로 직접 만들지 않는다.
5. 수정 후 화면을 캡처하고 실제 결과가 기대 결과와 일치하는지 직접 확인한다. 관련 저장 결과·실패 경로·다른 진입점도 변경 영향 범위에 따라 검증한다. 수정 전후 증거를 함께 연결한 뒤 완료를 판단한다.

재현 실패나 시뮬레이터 실행 불가를 이유로 앱 동작 검증을 조용히 생략하지 않는다. 원인 분석·수정·단위 테스트 결과와 남은 시뮬레이터 검증을 구분해 보고한다. 화면에서 관찰할 수 없는 로직·빌드 도구 버그는 실패 테스트·명령·로그로 전후 차이를 증명하며, 앱 사용자 경로에 영향이 있으면 시뮬레이터 검증도 수행한다.

시뮬레이터가 막혔어도 실패하는 회귀 테스트 등으로 원인을 확인했다면 요청된 코드 수정과 단위 검증은 진행할 수 있다. 이 경우 수정 전 버전을 보존하고 시뮬레이터 전후 재현을 `미검증`으로 남긴다. 추측만으로 고치거나 시뮬레이터 확인 전 앱 버그의 검증 완료를 선언하지 않는다.

HealthKit 실제 권한·잠금, iCloud 동기화, 기기 간 Watch 연동은 시뮬레이터나 오류 주입 테스트만으로 확인됐다고 하지 않는다. 필요한 실기기 QA는 `미검증` 항목으로 남긴다. 실행·캡처 방법은 [시뮬레이터 버그 검증](skills/xcode-build-test.md#시뮬레이터-버그-검증)을 따른다.

## 증거 보관

- 전후 화면과 검증 기록은 `Docs/validation/<task>/`에 둔다. 이슈 번호 또는 작업명으로 구분하고 기존 증거를 덮어쓰지 않는다.
- 같은 폴더의 `README.md`에 수정 전후 커밋·작업 트리 변경 상태, 빌드 식별 정보, Xcode·OS·시뮬레이터 UUID, 데이터·권한 전제, 실제 조작 순서, 기대·관찰 결과, 실행 명령과 증거 경로를 적는다.
- 큰 로그·영상·`.xcresult`는 위치 또는 CI 산출물 링크를 기록한다. 검증 후 프로세스·임시 데이터 정리로 증거를 지우지 않는다. 테스트 데이터와 개인정보가 없는 실제 실행 원본 캡처를 사용한다.
- 병렬 작업은 담당 시뮬레이터와 데이터를 분리한다. 사용자가 쓰는 시뮬레이터·데이터를 임의로 초기화하거나 여러 에이전트가 같은 인스턴스를 동시에 조작하지 않는다. 자신이 시작한 프로세스와 임시 데이터만 정리한다.

## Validation Levels

| Level | Scope | Commands |
| --- | --- | --- |
| Lightweight local | 공백, SwiftLint, architecture guardrail | `git diff --check`, `make lint`, `make arch-check` 또는 `make verify` |
| Unit local | 변경 기능/공용 모듈의 Swift unit test | 변경된 Feature 스킴, `MulimiUISystem`, `MulimiNavigation`, `WatchHydrationTests` 중 해당 스킴 `xcodebuild test` |
| Build local | 앱/위젯/워치 통합 빌드 | `xcodebuild build -workspace Mulimi.xcworkspace -scheme Mulimi ...` |
| PR CI | PR 단위 자동 검증 | `.github/workflows/lint.yml`, `.github/workflows/pr-unit-tests.yml` |
| Release CI | 릴리스 archive 검증 | Xcode Cloud `Release-Build` |

## Validation Matrix

| 변경 유형 | 최소 검증 | 추가 검증 |
| --- | --- | --- |
| 문서만 변경 | `git diff --check`, 변경한 상대 링크·이미지·앵커 확인 | 명령은 실제 스크립트와 대조하고 관련 README/인덱스 확인 |
| 구조·의존성 목록 변경 | `git diff --check`, 실제 `Project.swift`·구현과 대조 | 직접/전이 의존성, 소스 공유, 미참조 타깃을 구분하고 관련 그림 확인 |
| 구조도 원본·HTML 변경 | archify showcase 검증·원자적 생성, 화면 검증·캡처 직접 확인 | 아래 Architecture Artifact Gate 적용 |
| SwiftUI View 변경 | `make lint`, `make arch-check`, 앱 빌드 | ViewModel 상태가 바뀌면 해당 기능 `Presentation` 테스트 |
| 디자인 시스템 변경 | `make lint`, `make arch-check`, `MulimiUISystem` 테스트, 앱 빌드 | 영향받은 소비자의 Presentation 테스트와 색상·큰 글씨·선택 접근성·Reduce Motion/Transparency 확인; 타깃 변경이면 `tuist generate` |
| UI 경계 검사기 변경 | `make lint`, `make arch-check`, `python3 scripts/test-ui-boundaries.py` | 허용·차단 fixture와 실제 import·리터럴 의존 선언 확인. 제품 코드 변경 시 해당 레이어 검증도 수행 |
| ViewModel 변경 | `make lint`, `make arch-check`, 해당 기능 `Presentation` 테스트 | 화면 라우팅 영향이 있으면 앱 빌드 |
| Domain Entity/UseCase 변경 | `make lint`, `make arch-check`, 해당 기능 `Domain` 테스트 | Presentation 모델 변환 영향이 있으면 해당 기능 `Presentation` 테스트 |
| Data/HealthKit 변경 | `make lint`, `make arch-check`, 관련 Unit Test, 앱 빌드 | 권한/동기화 흐름은 실제 시뮬레이터 또는 기기에서 수동 확인 |
| Widget 변경 | `make lint`, `make arch-check`, 앱 빌드 | 위젯 타깃 빌드와 App Group 데이터 확인 |
| Watch 변경 | `make lint`, `make arch-check`, `WatchHydrationTests`, 앱 빌드 | watchOS 26+ Simulator 테스트·Watch 타깃 빌드와 앱/워치 수분 규칙 일치 확인 |
| Localization 변경 | `jq empty Project/Shared/Localization/Resources/Localizable.xcstrings`, 앱 빌드 | 문구가 권한/알림이면 관련 화면 수동 확인 |
| Tuist/Project.swift 변경 | `tuist generate`, `make lint`, `make arch-check`, 앱 빌드 | 변경된 scheme 테스트 |
| Feature 모듈 변경 | `make lint`, `make arch-check`, 변경 feature의 `Domain/Data/Presentation` 테스트 | 앱 조립이 바뀌면 앱 빌드 |
| CI/릴리스 변경 | 관련 스크립트 정적 확인, 앱 빌드 | Xcode Cloud 또는 GitHub Actions 실행 결과 확인 |
| Tuist Preview 변경 | `make preview-check`, `make preview-build`, workflow 구문 검사 | 실제 업로드·URL 실행, PR CI와 수동 실행 결과. [검증 절차](tuist-previews.md#검증과-문제-해결) |

## Architecture Artifact Gate

문서 링크·설명만 바뀌었다면 구조도 재생성이나 Xcode 빌드는 필요하지 않다. 타깃·코드 변경이 함께 있으면 위 matrix의 해당 검증도 수행한다.

구조도 원본이나 HTML을 변경할 때는 다음을 확인한다.

1. 원본 JSON의 커밋·소스 위치를 대조한다. 앱 구조도는 `Project.swift`·구현과 직접 의존성 목록, 하네스 운영 구조도는 문서·스크립트·CI를 기준으로 확인한다. 앱 개요 그림의 범위를 주요 관계로 표시한다.
2. archify `validate`와 `deliver`가 모두 성공하고 showcase **9/9, 오류 0, 경고 0**인지 확인한다.
3. `deliver`의 원본·HTML SHA-256 및 바이트 수를 남기고, `visual-check`가 같은 HTML 해시를 검사했는지 확인한다.
4. 1440×900, 1600×1000, 1920×1080, 2048×1320에서 가로·세로 넘침이 없어야 한다. 작은·큰 화면의 라이트·다크 캡처를 직접 확인한다.
5. 자동 검증과 육안 검증 결과를 분리한다. `visualReview: pending`은 육안 통과가 아니며, 확인하지 못했다면 생략 사유를 남기고 통과로 보고하지 않는다.

이 검증은 현재 `make verify`나 CI가 자동 실행하지 않는다. 명령과 산출물은 [하네스 산출물 관리](harness-engineering.md#architecture-artifacts)를 따른다.

## Required Reporting

PR이나 작업 완료 메시지에는 아래를 구분해 적는다.

- 실행한 로컬 검증
- 실행하지 않은 검증과 이유
- 자동화 결과: GitHub Actions, Xcode Cloud
- 검증 환경: Xcode, simulator/device, Tuist
- 기존 경고와 새 경고의 구분
- 구조, 제품, 하네스 변경 시 갱신한 문서

## Failure Handling

- `make lint` 실패는 `make lint-fix` 후 다시 확인한다.
- `make arch-check` 실패는 포맷 문제가 아니라 레이어 경계 문제로 본다.
- 테스트 실패를 우회하지 않는다. 실패가 기존 이슈로 확인되면 재현 명령과 근거를 남긴다.
- 검증 명령이 환경 문제로 실패하면 로그 경로, Xcode 버전, 시뮬레이터 ID를 같이 남긴다.

## Simulator Rule

`xcodebuild test`는 가능하면 시뮬레이터 이름보다 `id`를 사용한다.

```bash
xcodebuild test \
  -workspace Mulimi.xcworkspace \
  -scheme HydrationPresentation \
  -destination 'platform=iOS Simulator,id=<SIM_ID>' \
  -sdk iphonesimulator
```

## Related Docs

- `Docs/skills/xcode-build-test.md`
- `Docs/skills/lint-fix-loop.md`
- `Docs/delivery-workflow.md`
- `.github/pull_request_template.md`

## HealthKit 조회 복구 검증 (#350)

- Hydration Domain/Data/Presentation과 Routine·Challenge Domain/Presentation 테스트로 정상 빈 결과·실제 오류·부분 조회 실패를 구분한다.
- `WatchHydrationTests`는 Watch Data·Domain·Presentation을 watchOS Simulator에서 함께 검증한다. `xcodebuild test -workspace Mulimi.xcworkspace -scheme WatchHydrationTests -destination 'platform=watchOS Simulator,id=<WATCH_SIM_ID>'`를 실행한다.
- 저장 전 조회 오류 시 쓰기 0회, 저장 후 조회 오류와 읽기 재시도 시 쓰기 1회를 확인한다. 초기화 후 조회 실패도 쓰기를 반복하지 않아야 한다.
- 앱·Watch·Widget 빌드와 함께 날짜/기간 변경 시 이전 값 숨김, 오류 안내, 조회만 재시도하는 화면을 확인한다.
- HealthKit 실제 읽기 권한 거부 여부는 API의 빈 결과로 판정하지 않는다. 잠금/권한 실기기 QA와 오류 주입 단위 테스트 결과를 구분해 적는다.
