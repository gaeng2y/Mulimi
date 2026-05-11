# widget-watch-integration

## When to use

- WidgetKit 변경
- AppIntent 변경
- Apple Watch 앱 변경
- 앱/위젯/워치 공용 수분 상태 변경

## Goal

앱, 위젯, 워치가 같은 수분 규칙과 같은 목표량 정책을 보게 한다.

## Rules

- 수분 기록 원본은 `HealthKit`
- 표시 계산은 `HydrationServing`
- 다음 한 잔 계산은 `HydrationNextActionGuide`
- 목표량은 앱과 동일한 `iCloud KVS + App Group mirror` 흐름을 따른다
- 위젯/워치만의 독자 단위 규칙을 만들지 않는다
- 기본 기록량 사용자 설정은 아직 없다. Widget/AppIntent/Watch 기본 기록은 `HydrationServing.defaultGlassVolumeML`을 사용한다
- 기본 기록량 개인화를 구현할 때는 앱, Widget/AppIntent, Watch가 같은 App Group 기반 설정을 읽도록 설계한다

## Where to look

- 위젯 공유 로직: `Project/Widget/Sources/DrinkWaterWidgetShared.swift`
- AppIntent: `Project/Widget/Sources/AppIntent.swift`
- watch 앱 진입: `Project/App/Watch/Sources/App/MulimiWatchApp.swift`
- watch DI: `Project/Shared/DependencyInjection/Sources/Watch`
- 공용 수분 계산: `Project/Domain/SharedInterfaces/`
- 앱 기본 기록: `Project/Presentation/Sources/ViewModel/DrinkWaterViewModel.swift`

## Validation

```bash
make lint
make arch-check
xcodebuild build -workspace Mulimi.xcworkspace -scheme Mulimi -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO
```

범위가 watch면 watch 빌드도 추가한다.

## Related Docs

- `Docs/reliability-recovery.md`
