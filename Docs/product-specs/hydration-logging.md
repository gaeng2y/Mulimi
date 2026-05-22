# Hydration Logging

## Goal

사용자가 앱, 위젯, 워치 어디서 기록하더라도 같은 수분 기록과 같은 단위 규칙을 보게 한다.

## Product Rules

- 수분 기록의 원본 저장소는 `HealthKit`
- 로컬에 별도 hydration 원장을 다시 두지 않는다
- `250ml = 1잔` 규칙은 `HydrationServing`으로만 다룬다
- 메인 화면은 기본 1잔 기록을 유지하고, `HydrationServing`에 정의된 330ml/500ml 프리셋과 직접 ml 입력을 추가로 제공한다
- 기록 단위 사용자 기본값 설정은 아직 구현하지 않았다. 기본 액션, 위젯, Watch는 기본 1잔을 유지하고, Siri/Shortcuts는 실행 시 선택한 단위를 1회 기록한다
- 기록 후 오늘 목표를 초과하는 단위는 앱과 AppIntent에서 기록하지 않는다
- 앱에서 방금 남긴 기록은 최근 기록 되돌리기로 삭제할 수 있다
- 기록 탭은 HealthKit 샘플 단위 기록을 보여주고, 앱이 생성한 기록만 개별 삭제를 허용한다
- 다음 한 잔 가이드는 목표까지 남은 양, 남은 잔 수, 다음 루틴 문맥을 함께 본다
- 기록 탭의 오늘/주간/월간 요약은 HealthKit 기록을 일별 합산한 표시 모델로 만든다
- 기록 탭의 잔 수와 달성일 계산은 `HydrationServing`과 사용자 목표 수분량을 기준으로 한다
- 앱, 위젯, 워치가 서로 다른 계산 규칙을 만들지 않는다

## Default Recording Amount Policy

현재 기본 기록량 설정 저장/적용 흐름은 없다. #203은 닫혔지만 연결된 종료 PR이 없고, 코드 기준으로 `UserPreferencesUseCase`, `SettingMenu`, App Group 저장 키에 기본 기록량 API가 없다. #195 범위에서 330ml/500ml 프리셋과 직접 입력은 추가됐지만, 사용자가 고른 값을 다음 기본 기록량으로 저장하지는 않는다.

| Entry point | Current amount | Decision point | Notes |
| --- | --- | --- | --- |
| 앱 기본 기록 버튼 | `HydrationServing.defaultGlassVolumeML` = 250ml | `DrinkWaterViewModel.drinkWater()` | 사용자가 별도 프리셋을 눌러도 다음 기본 버튼 값은 바뀌지 않는다. |
| 앱 프리셋 버튼 | 330ml, 500ml | `HydrationServing.additionalPresets`, `recordPresetWater(volumeML:)` | 탭 1회에만 적용된다. 사용자 기본값으로 저장하지 않는다. |
| 앱 직접 입력 | 사용자가 입력한 ml | `recordCustomAmount(_:)` | 유효성 검사 후 1회 기록한다. 사용자 기본값으로 저장하지 않는다. |
| Widget button | `HydrationServing.defaultGlassVolumeML` = 250ml | `LogWaterAppIntent`의 기본 `amount = .glass` | 목표 초과 시 HealthKit에 쓰지 않고 결과 메시지를 반환한다. |
| Watch | `HydrationServing.defaultGlassVolumeML` = 250ml | `WatchHydrationUseCaseImpl.defaultDrinkVolumeML` | Watch 전용 단위 규칙을 만들지 않는다. |
| Siri/Shortcuts | 250ml, 330ml, 500ml, 직접 입력 ml | `LogWaterAppIntent.amount`, `customAmountML`, `LogWaterAppShortcuts` | App Shortcut phrase로 노출하고, 성공/목표 초과/권한 필요 결과 메시지를 반환한다. |

기본 기록량 개인화가 필요하면 #203 범위를 기능 이슈로 복원하고, App Group에서 앱/Widget/AppIntent/Watch가 함께 읽을 수 있는 사용자 설정으로 설계한다.

## Siri And Shortcuts Policy

- Shortcuts, Siri, Spotlight에는 `LogWaterAppShortcuts`로 기본 물 기록 App Shortcut을 노출한다.
- Shortcut phrase는 앱 이름 토큰을 포함해 물 기록 의도가 드러나야 한다.
- `LogWaterAppIntent.amount`는 250ml, 330ml, 500ml, 직접 입력을 제공한다.
- 직접 입력은 `customAmountML`로 받고, 1~4000ml 사이만 허용한다.
- 실행 결과는 아래처럼 안내한다.
  - 성공: 선택한 수분량이 HealthKit에 기록됐음을 알린다.
  - 목표 초과: 오늘 목표를 넘어서 기록하지 않았음을 알린다.
  - HealthKit 권한 필요: 앱을 foreground로 전환해 권한 흐름을 확인하게 한다.
- HealthKit 저장 실패: 기록되지 않았음을 알리고, 권한 철회가 원인이면 앱을 foreground로 전환해 권한 흐름을 확인하게 한다.
- 기록 성공 시에만 Widget timeline을 갱신한다.
- 기록 성공 시에만 analytics `water_logged.source`는 `app_intent`로 기록한다.
- 권한 부족, 직접 입력 오류, 목표 초과, HealthKit 저장 실패는 analytics `water_log_failed.source`로 기록한다.
- Shortcuts 수분량 선택은 기본 기록량 사용자 설정을 바꾸지 않는다. 기본 기록량 개인화는 #203 범위에서 확장한다.

## AppIntent QA Scenarios

- Shortcuts에서 250ml, 330ml, 500ml를 각각 선택하면 해당 ml가 HealthKit에 기록된다.
- Shortcuts에서 직접 입력을 선택하고 1~4000ml 사이 값을 넣으면 해당 ml가 기록된다.
- 직접 입력이 비어 있거나 범위를 벗어나면 HealthKit에 쓰지 않고 안내 메시지를 반환한다.
- 선택한 수분량이 오늘 목표를 초과하면 HealthKit에 쓰지 않고 목표 초과 메시지를 반환한다.
- HealthKit 권한이 없으면 앱 foreground 전환으로 권한 흐름을 확인하게 한다.
- 기록 차단 결과는 `water_log_failed.failure_reason`으로 구분된다.
- HealthKit 저장 실패 결과는 성공 dialog, Widget timeline 갱신, `water_logged` analytics로 처리하지 않는다.
- 기록 성공 후 Widget timeline이 갱신된다.

## User Expectations

- 빠르게 한 잔을 기록할 수 있다
- 오늘 섭취량과 목표 진행률이 같은 기준으로 보인다
- 기록 탭에서 기간별 총 섭취량, 일평균, 기록 횟수, 목표 달성일을 빠르게 확인할 수 있다
- 잘못 남긴 기록은 전체 초기화 없이 최근 기록 또는 개별 기록 단위로 되돌릴 수 있다
- 목표까지 남은 양과 다음 한 잔 기준을 바로 이해할 수 있다
- 워치/위젯 기록이 앱 기록과 어긋나지 않는다

## Scope

- 메인 화면의 물 마시기 액션
- 오늘 섭취량 집계
- 위젯/AppIntent 기록
- Apple Watch 기록
- 메인 화면/위젯/워치의 다음 한 잔 가이드
- 기록 탭의 오늘/주간/월간 기간 필터와 일별 요약
- 기록 탭의 앱 생성 HealthKit 샘플 개별 삭제

## Constraints

- HealthKit 권한이 없으면 기록/집계 UX가 그 상태를 설명해야 한다
- 외부 앱 또는 건강 앱이 만든 수분 기록은 물리미에서 삭제하지 않는다
- 저장 형식보다 사용자 체감 일관성이 우선이다

## Related Code

- `Project/Domain/SharedInterfaces/Entity/HydrationServing.swift`
- `Project/Domain/SharedInterfaces/Entity/HydrationNextActionGuide.swift`
- `Project/Domain/Sources/UseCase/HydrationNextActionGuideUseCaseImpl.swift`
- `Project/Data/Sources/Repository/HealthKitRepositoryImpl.swift`
- `Project/Widget/Sources/`
- `Project/Domain/WatchSources/`

## Related Docs

- `ARCHITECTURE.md`
- `Docs/reliability-recovery.md`
- `Docs/skills/healthkit-flow.md`
- `Docs/skills/widget-watch-integration.md`

## Related Issues

- #203 기본 수분 기록량 및 즐겨찾는 용량 설정 추가
- #195 다양한 수분 기록 단위 프리셋 추가
- #67 Siri/Shortcuts 물 기록 적용
