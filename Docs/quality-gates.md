# Quality Gates

Mulimi 변경 사항을 PR 전에 어느 수준까지 검증할지 정리한 문서다. 세부 실행 명령은 `Docs/skills/xcode-build-test.md`와 `Docs/skills/lint-fix-loop.md`를 따르고, 이 문서는 변경 유형별 최소 기준을 정한다.

## Baseline

모든 코드 변경은 아래 순서를 기본값으로 본다.

1. `git diff --check`
2. `make lint`
3. `make arch-check`
4. 변경 레이어에 맞는 테스트 또는 빌드

문서만 바뀐 경우에도 `git diff --check`는 확인한다. 실행하지 않은 검증은 PR 본문에 통과했다고 적지 않는다.

## Validation Matrix

| 변경 유형 | 최소 검증 | 추가 검증 |
| --- | --- | --- |
| 문서만 변경 | `git diff --check` | 링크나 명령이 바뀌면 관련 README/인덱스 확인 |
| SwiftUI View 변경 | `make lint`, `make arch-check`, 앱 빌드 | ViewModel 상태가 바뀌면 `PresentationLayer` 테스트 |
| ViewModel 변경 | `make lint`, `make arch-check`, `PresentationLayer` 테스트 | 화면 라우팅 영향이 있으면 앱 빌드 |
| Domain Entity/UseCase 변경 | `make lint`, `make arch-check`, `DomainLayer` 테스트 | Presentation 모델 변환 영향이 있으면 `PresentationLayer` 테스트 |
| Data/HealthKit 변경 | `make lint`, `make arch-check`, 관련 Unit Test, 앱 빌드 | 권한/동기화 흐름은 실제 시뮬레이터 또는 기기에서 수동 확인 |
| Widget 변경 | `make lint`, `make arch-check`, 앱 빌드 | 위젯 타깃 빌드와 App Group 데이터 확인 |
| Watch 변경 | `make lint`, `make arch-check`, 앱 빌드 | Watch 타깃 빌드와 앱/워치 수분 규칙 일치 확인 |
| Localization 변경 | `jq empty Project/Shared/Localization/Resources/Localizable.xcstrings`, 앱 빌드 | 문구가 권한/알림이면 관련 화면 수동 확인 |
| Tuist/Project.swift 변경 | `tuist generate`, `make lint`, `make arch-check`, 앱 빌드 | 변경된 scheme 테스트 |
| CI/릴리스 변경 | 관련 스크립트 정적 확인, 앱 빌드 | Xcode Cloud 또는 GitHub Actions 실행 결과 확인 |

## Required Reporting

PR이나 작업 완료 메시지에는 아래를 구분해 적는다.

- 실행한 검증
- 실행하지 않은 검증과 이유
- 기존 경고와 새 경고의 구분
- 구조 변경 시 갱신한 문서

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
  -scheme PresentationLayer \
  -destination 'platform=iOS Simulator,id=<SIM_ID>' \
  -sdk iphonesimulator
```

## Related Docs

- `Docs/skills/xcode-build-test.md`
- `Docs/skills/lint-fix-loop.md`
- `Docs/delivery-workflow.md`
- `.github/pull_request_template.md`
