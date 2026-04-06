# xcode-build-test

## When to use

- 구현 후 검증
- PR 전 확인
- 빌드/테스트 실패 재현

## Goal

Mulimi에서 반복되는 검증 순서를 표준화한다.

## Default Order

1. `make lint`
2. `make arch-check`
3. `tuist generate`
4. `DomainLayer` 테스트
5. `PresentationLayer` 테스트
6. `Mulimi` 앱 빌드

## Commands

```bash
make lint
make arch-check
tuist generate
xcodebuild test -workspace Mulimi.xcworkspace -scheme DomainLayer -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
xcodebuild test -workspace Mulimi.xcworkspace -scheme PresentationLayer -destination 'platform=iOS Simulator,id=<SIM_ID>' -sdk iphonesimulator
xcodebuild build -workspace Mulimi.xcworkspace -scheme Mulimi -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO
```

## Notes

- 시뮬레이터 이름보다 `id`가 더 안정적이다.
- watch나 widget 변경이 직접 범위면 해당 타깃 빌드도 추가한다.
- 실행하지 않은 검증은 PR에 적지 않는다.
