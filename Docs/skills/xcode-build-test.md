# xcode-build-test

## When to use

- 구현 후 검증
- PR 전 확인
- 빌드/테스트 실패 재현

## Goal

Mulimi에서 반복되는 검증 순서를 표준화한다.

## Default Order

1. `git diff --check`
2. `make lint`
3. `make arch-check`
4. `tuist generate`
5. `DomainLayer` 테스트
6. `DataLayer` 테스트
7. `PresentationLayer` 테스트
8. `Mulimi` 앱 빌드

`make verify`는 `make lint`와 `make arch-check`만 실행하는 lightweight gate다. Unit test나 앱 빌드까지 끝났다는 의미로 사용하지 않는다.

## Commands

```bash
make lint
make arch-check
tuist generate
xcodebuild test -workspace Mulimi.xcworkspace -scheme DomainLayer -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
xcodebuild test -workspace Mulimi.xcworkspace -scheme DataLayer -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
xcodebuild test -workspace Mulimi.xcworkspace -scheme PresentationLayer -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
xcodebuild build -workspace Mulimi.xcworkspace -scheme Mulimi -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO
```

## Validation Levels

| Level | Commands | Use when |
| --- | --- | --- |
| Lightweight | `git diff --check`, `make lint`, `make arch-check` 또는 `make verify` | 문서 변경, 작은 Swift 변경의 첫 검증 |
| Unit | `DomainLayer`, `DataLayer`, `PresentationLayer` `xcodebuild test` | UseCase, Repository, ViewModel, shared rule 변경 |
| Build | `Mulimi` 앱 빌드, 필요 시 Widget/Watch 타깃 빌드 | Project.swift, SwiftUI, App/Widget/Watch 통합 변경 |
| PR CI | `.github/workflows/lint.yml`, `.github/workflows/pr-unit-tests.yml` | `main`, `develop` 대상 PR 검증 |
| Release | Xcode Cloud `Release-Build` archive | 태그 기반 릴리스 검증 |

## Notes

- 시뮬레이터 이름보다 `id`가 더 안정적이다.
- watch나 widget 변경이 직접 범위면 해당 타깃 빌드도 추가한다.
- 실행하지 않은 검증은 PR에 적지 않는다.
