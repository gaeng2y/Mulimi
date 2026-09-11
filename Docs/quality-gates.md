# Quality Gates

Mulimi 변경 사항을 PR 전에 어느 수준까지 검증할지 정리한 문서다. 세부 실행 명령은 `Docs/skills/xcode-build-test.md`와 `Docs/skills/lint-fix-loop.md`를 따르고, 이 문서는 변경 유형별 최소 기준을 정한다.

## Baseline

모든 코드 변경은 아래 순서를 기본값으로 본다.

1. `git diff --check`
2. `make lint`
3. `make arch-check`
4. 변경 레이어에 맞는 테스트 또는 빌드

문서만 바뀐 경우에도 `git diff --check`는 확인한다. 실행하지 않은 검증은 PR 본문에 통과했다고 적지 않는다.

`make verify`는 `make lint`와 `make arch-check`를 묶은 lightweight gate다. Unit test와 앱 빌드가 필요한 변경에서는 아래 matrix에 맞는 `xcodebuild test` 또는 `xcodebuild build`를 별도로 실행한다.

## Validation Levels

| Level | Scope | Commands |
| --- | --- | --- |
| Lightweight local | 공백, SwiftLint, architecture guardrail | `git diff --check`, `make lint`, `make arch-check` 또는 `make verify` |
| Unit local | 변경 기능/레이어별 Swift unit test | 변경된 `<Feature>Domain`, `<Feature>Data`, `<Feature>Presentation` 스킴 `xcodebuild test` |
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
| ViewModel 변경 | `make lint`, `make arch-check`, 해당 기능 `Presentation` 테스트 | 화면 라우팅 영향이 있으면 앱 빌드 |
| Domain Entity/UseCase 변경 | `make lint`, `make arch-check`, 해당 기능 `Domain` 테스트 | Presentation 모델 변환 영향이 있으면 해당 기능 `Presentation` 테스트 |
| Data/HealthKit 변경 | `make lint`, `make arch-check`, 관련 Unit Test, 앱 빌드 | 권한/동기화 흐름은 실제 시뮬레이터 또는 기기에서 수동 확인 |
| Widget 변경 | `make lint`, `make arch-check`, 앱 빌드 | 위젯 타깃 빌드와 App Group 데이터 확인 |
| Watch 변경 | `make lint`, `make arch-check`, 앱 빌드 | Watch 타깃 빌드와 앱/워치 수분 규칙 일치 확인 |
| Localization 변경 | `jq empty Project/Shared/Localization/Resources/Localizable.xcstrings`, 앱 빌드 | 문구가 권한/알림이면 관련 화면 수동 확인 |
| Tuist/Project.swift 변경 | `tuist generate`, `make lint`, `make arch-check`, 앱 빌드 | 변경된 scheme 테스트 |
| Feature 모듈 변경 | `make lint`, `make arch-check`, 변경 feature의 `Domain/Data/Presentation` 테스트 | 앱 조립이 바뀌면 앱 빌드 |
| CI/릴리스 변경 | 관련 스크립트 정적 확인, 앱 빌드 | Xcode Cloud 또는 GitHub Actions 실행 결과 확인 |

## Architecture Artifact Gate

문서 링크·설명만 바뀌었다면 구조도 재생성이나 Xcode 빌드는 필요하지 않다. 타깃·코드 변경이 함께 있으면 위 matrix의 해당 검증도 수행한다.

구조도 원본이나 HTML을 변경할 때는 다음을 확인한다.

1. 구조·의존성 목록과 원본 JSON의 커밋·소스 위치를 실제 `Project.swift` 및 구현과 대조한다. 개요 그림을 전체 직접 의존성 그래프라고 표시하지 않는다.
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
