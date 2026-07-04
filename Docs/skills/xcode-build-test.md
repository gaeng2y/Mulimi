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
- GitHub Actions는 ephemeral runner라서 `id`를 고정하지 않고 `.github/workflows/pr-unit-tests.yml`의 이름 기반 destination을 사용한다.
- watch나 widget 변경이 직접 범위면 해당 타깃 빌드도 추가한다.
- 실행하지 않은 검증은 PR에 적지 않는다.

## Simulator Discovery

로컬 테스트 destination은 아래 순서로 확인한다.

```bash
xcodebuild -version
xcodebuild -showsdks
xcrun simctl list devices available
```

동일한 기기 이름이 여러 OS runtime에 있으면 `id`를 골라 `-destination 'platform=iOS Simulator,id=<SIM_ID>'` 형식으로 실행한다.

## Toolchain Troubleshooting

- `.mise.toml`은 현재 `tuist = "latest"`를 사용한다. Tuist 최신 버전 변경으로 생성 결과가 달라지면 `.mise.toml` pinning과 문서 갱신을 같은 변경으로 처리한다.
- GitHub Actions는 `latest-stable` Xcode를 사용한다. Xcode 업데이트로 SDK, simulator, Swift 컴파일 결과가 달라지면 실패 로그의 `xcodebuild -version`, `xcodebuild -showsdks` 출력부터 확인한다.
- Metal shader 또는 SwiftUI shader asset 빌드가 Metal toolchain 누락으로 실패하면 Xcode component 상태를 확인한다. CLI에서 가능한 환경이면 `xcodebuild -downloadComponent MetalToolchain` 실행 후 같은 빌드를 다시 확인한다.
