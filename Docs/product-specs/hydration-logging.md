# Hydration Logging

## Goal

사용자가 앱, 위젯, 워치 어디서 기록하더라도 같은 수분 기록과 같은 단위 규칙을 보게 한다.

## Product Rules

- 수분 기록의 원본 저장소는 `HealthKit`
- 로컬에 별도 hydration 원장을 다시 두지 않는다
- `250ml = 1잔` 규칙은 `HydrationServing`으로만 다룬다
- 메인 화면은 Metal shader 기반 `WaterDrop`, 오늘 섭취 잔 수/용량 요약, 다음 한 잔 안내, 기본 1잔 기록, 되돌리기/초기화를 담은 더보기(ellipsis) 메뉴만 노출한다
- 다음 한 잔 안내는 화면 상단, `WaterDrop`과 오늘 섭취 요약은 화면 중앙, 기본 기록 CTA는 하단에 둔다. `WaterDrop`은 고정 시각 anchor로, 되돌리기나 기록 성공 피드백 상태 변화로 밀리지 않는다
- 되돌리기(최근 앱 생성 기록 1건)와 초기화는 기본 기록 CTA 옆 더보기 메뉴에서 Label 형태로 제공한다. 되돌리기는 최근 기록이 있을 때만 메뉴에 나타나고, 초기화는 destructive action으로 구분한다
- 기본 1잔 기록은 HealthKit 쓰기 중 중복 탭을 막고, 성공 후 사용자가 즉시 인지할 수 있는 짧은 완료 피드백을 primary CTA 상태 변화로 제공한다
- 메인 화면은 Metal shader 기반 `WaterDrop`, 오늘 섭취 잔 수/용량 요약, 다음 한 잔 안내, 기본 1잔 기록, 최근 앱 생성 기록 1건 되돌리기, 오늘 물리미 기록 초기화만 노출한다
- 기본 1잔 기록은 HealthKit 쓰기 중 중복 탭을 막고, 성공 후 사용자가 즉시 인지할 수 있는 짧은 완료 피드백을 제공한다
- 오늘 기록이 0이고 다음 한 잔 안내가 기본 상태(`readyToDrink`)면, 같은 안내 카드의 문구를 첫 기록 유도로 바꿔 기본 1잔 기록 CTA와 건강 앱 저장을 안내한다. 별도 배너나 레이아웃 요소를 추가하지 않으며, 루틴 임박/목표 미설정 안내가 우선한다. 온보딩 전환 실험 H4 기준(`Docs/product-specs/onboarding-healthkit-conversion-experiments.md`)과 정렬된다
- 기록 단위 사용자 기본값 설정은 아직 구현하지 않았다. 기본 액션, 위젯, Watch는 기본 1잔을 유지하고, Siri/Shortcuts는 실행 시 선택한 단위를 1회 기록한다
- 기록 후 오늘 목표를 초과하는 단위는 앱과 AppIntent에서 기록하지 않는다
- 메인 화면의 오늘 기록 초기화는 확인 후 물리미가 오늘 만든 HealthKit 샘플만 삭제한다
- 메인 기록 화면의 WaterDrop, 오늘 섭취 요약, 기본 기록 CTA, 더보기 메뉴는 작은 화면과 Accessibility Dynamic Type에서도 스크롤로 접근 가능해야 한다
- 기록 탭은 HealthKit 샘플 단위 기록을 보여주고, 앱이 생성한 기록만 개별 삭제를 허용한다
- 기록 탭의 오늘/주간/월간 요약은 HealthKit 기록을 일별 합산한 표시 모델로 만든다
- 기록 탭은 기간별로 시각화를 분리한다. 오늘은 당일 이벤트 타임라인, 주간은 7일 달성 스트립과 일별 요약 리스트, 월간은 달력 grid와 일별 요약 리스트를 쓴다. 기간 요약 카드는 세 기간 모두 유지하고, 개별 이벤트 삭제 정책은 기간과 무관하게 같다
- 기록 탭 empty state는 기간별 문구를 쓴다. 오늘/주간과 현재 달 조회에서는 메인 기록 탭 전환 CTA를 노출하고, 지난달 조회에서는 CTA를 노출하지 않는다
- 기록 탭의 잔 수와 달성일 계산은 `HydrationServing`과 사용자 목표 수분량을 기준으로 한다
- 앱, 위젯, 워치가 서로 다른 계산 규칙을 만들지 않는다

## Default Recording Amount Policy

현재 기본 기록량 설정 저장/적용 흐름은 없다. #203은 닫혔지만 연결된 종료 PR이 없고, 코드 기준으로 `UserPreferencesUseCase`, `SettingMenu`, App Group 저장 키에 기본 기록량 API가 없다. #195 범위의 330ml/500ml 프리셋과 직접 입력은 현재 메인 화면에 노출하지 않으며, 사용자가 고른 값을 다음 기본 기록량으로 저장하는 흐름도 없다.

| Entry point | Current amount | Decision point | Notes |
| --- | --- | --- | --- |
| 앱 기본 기록 버튼 | `HydrationServing.defaultGlassVolumeML` = 250ml | `DrinkWaterViewModel.drinkWater()` | 메인 화면 기본 버튼은 항상 1잔을 기록한다. |
| 앱 프리셋 버튼 | 없음 | - | 메인 화면에는 노출하지 않는다. 사용자 기본값으로 저장하지 않는다. |
| 앱 직접 입력 | 없음 | - | 메인 화면에는 노출하지 않는다. 사용자 기본값으로 저장하지 않는다. |
| Widget button | `HydrationServing.defaultGlassVolumeML` = 250ml | `LogWaterAppIntent`의 기본 `amount = .glass` | 목표 초과 시 HealthKit에 쓰지 않고 결과 메시지를 반환한다. |
| Control Widget 실험 (#322) | `HydrationServing.defaultGlassVolumeML` | 같은 `LogWaterAppIntent()` | 실험 빌드에서만 제어 센터·잠금 화면·액션 버튼에 노출한다. |
| Watch | `HydrationServing.defaultGlassVolumeML` = 250ml | `WatchHydrationUseCaseImpl.defaultDrinkVolumeML` | Watch 전용 단위 규칙을 만들지 않는다. |
| Siri/Shortcuts | 250ml, 330ml, 500ml, 직접 입력 ml | `LogWaterAppIntent.amount`, `customAmountML`, `LogWaterAppShortcuts` | App Shortcut phrase로 노출하고, 성공/목표 초과/권한 필요 결과 메시지를 반환한다. |

기본 기록량 개인화가 필요하면 #203 범위를 기능 이슈로 복원하고, App Group에서 앱/Widget/AppIntent/Watch가 함께 읽을 수 있는 사용자 설정으로 설계한다.

## App Store Review Request Policy

- 메인 화면의 성공한 수분 기록으로 오늘 목표를 처음 달성한 순간만 리뷰 요청 후보로 본다.
- 최근 30일에 물리미 소유 HealthKit 기록일이 3일 이상이고, 가장 이른 소유 기록일이 7일 이상 지난 사용자만 후보가 된다.
- 수분 기록과 기록일의 원본은 계속 HealthKit으로 유지한다. 로컬에는 요청을 시도한 marketing version과 최근 요청 시각만 저장한다.
- 같은 marketing version에서는 한 번만 시도하고, 마지막 시도 후 120일이 지나야 하며, 최근 365일 요청 시도는 3회 미만이어야 한다.
- 기존 기록 성공 피드백이 사라진 뒤 2초를 더 기다리고, 앱이 inactive가 되거나 alert가 나타나거나 사용자가 화면을 벗어나면 후보를 취소한다.
- StoreKit의 시스템 `RequestReviewAction`만 사용하며 커스텀 사전 리뷰 팝업은 만들지 않는다.
- 요청 API는 실제 프롬프트 표시나 리뷰 작성 결과를 알려주지 않는다. 개발 빌드에서는 흐름을 확인할 수 있지만 TestFlight에서는 프롬프트가 표시되지 않는다.
- 로그아웃이나 회원 탈퇴로 리뷰 요청 이력을 초기화하지 않는다.

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

## Control Widget Experiment (#322)

상태: 로컬 구현·검증 완료. TestFlight 배포, 실기기 QA, 참여자 모집과 지표 수집은 아직 수행하지 않았다. 실제 결과가 나오기 전에는 #322를 닫거나 정식 출시 이슈를 만들지 않는다.

### Build And Installation

- 기존 Widget 번들에 `LogWaterControl` 하나를 조건부 등록한다. `LogWaterAppIntent()`의 기본 한 잔, 권한·목표 초과·실패 처리, 저장 성공 후 timeline 갱신을 그대로 사용한다.
- `MULIMI_CONTROL_WIDGET_EXPERIMENT` 컴파일 조건을 켠 내부 실험 빌드에만 Control을 포함한다. 기본 Debug/Release 빌드에는 포함하지 않는다. 새 AppIntent, 용량 설정, 저장소는 추가하지 않는다.
- 검증 범위는 iOS 26.0 이상 iPhone의 제어 센터와 잠금 화면, 액션 버튼이 있는 iPhone의 액션 버튼이다. 실제 지원 판정은 아래 실기기 QA를 통과한 모델·OS 조합별로 남긴다.
- 앱에서 온보딩, HealthKit 권한, 일일 목표 설정을 먼저 완료한다. 제어 센터의 제어 항목 추가에서 물리미의 `물 한 잔 기록`을 선택한다. 잠금 화면은 사용자화의 하단 제어 항목, 액션 버튼은 설정의 제어 항목에서 같은 Control을 선택한다.
- 아래 컴파일 조건은 실험 archive에만 적용한다. 이 archive는 TestFlight 내부 테스트용으로 배포하고 App Store 출시 빌드로 승격하지 않는다. 정식 출시 archive는 조건을 제거하고 새로 만든다.

```bash
tuist generate --no-open
xcodebuild archive -workspace Mulimi.xcworkspace -scheme Mulimi \
  -configuration Release -destination 'generic/platform=iOS' \
  -archivePath /tmp/Mulimi-Control-322.xcarchive \
  SWIFT_ACTIVE_COMPILATION_CONDITIONS='$(inherited) MULIMI_CONTROL_WIDGET_EXPERIMENT'
```

Archive에는 기존 서명·배포 설정이 필요하다. 로컬 컴파일 검증은 같은 조건으로 `build`와 `CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO`를 사용한다. 조건을 끈 기본 빌드도 함께 검증한다.

### Measurement Protocol

현재 Widget extension의 `Info.plist`에는 PostHog 설정이 없어 `NoOpAnalyticsRepository`를 사용한다. 앱 프로세스에서 실행되더라도 기존 이벤트의 `source = app_intent`만으로는 Control과 Widget/Shortcuts를 구분할 수 없으며, Watch 기록까지 같은 사용자로 집계할 수도 없다. 따라서 이 실험은 참여자 기록표와 기기 내 HealthKit 확인으로 측정한다. `app_intent` 이벤트 수를 Control 사용 횟수로 해석하지 않는다.

1. 지원 기기와 실험 빌드 설치를 확인한 참여자에게 같은 설치 안내를 제공하고 안내 인원 `N`을 기록한다. Control 설치를 직접 확인한 인원 `I`와 설치일 `D0`를 별도로 기록한다. 첫 실행은 설치의 대용 지표가 아니다.
2. 기준선은 설치 전 14개의 완전한 KST 날짜(`D-14`~`D-1`)다. HealthKit에서 물리미 앱·Widget·Watch로 남긴 기록이 있는 날짜 수를 세고 2로 나눠 주간 활성일로 환산한다. 다른 앱이 만든 기록은 제외한다.
3. 설치일의 안내·연습 기록은 반복 사용 집계에서 제외한다. 설치 다음 날부터 7개의 완전한 KST 날짜(`D1`~`D7`) 동안 기존 기록 경로도 계속 사용할 수 있게 한다.
4. 매일 참여자가 Control 시도 횟수, HealthKit에서 확인한 성공 횟수, 차단/실패 횟수, 사용한 위치를 기록한다. 시도 직후 저장을 확인해 다른 경로의 기록과 구분하며, 피드백 표시만으로 성공을 세지 않는다. 첫 성공일과 두 번째 성공일도 남긴다.
5. 같은 7일 동안 HealthKit의 물리미 기록 활성일을 전체 경로에 걸쳐 센다. 같은 날 여러 경로로 기록해도 활성일은 1일이다. 확인되지 않은 날은 0으로 치환하지 않고 측정 공백으로 남긴다.
6. 참여자 코드는 연구 기록표 안에서만 사용한다. Apple ID, PostHog ID, HealthKit 샘플 ID나 건강 원본을 기록표에 복사하거나 외부 서비스와 사용자 단위로 결합하지 않는다. 연구 결과에는 집계값만 남긴다.

| Metric | Calculation |
| --- | --- |
| 설치율 | `I / N`. 안내 후 미설치 이유도 별도로 기록한다. |
| 첫 사용률 | 첫 성공을 확인한 설치자 / `I` |
| 반복 사용률 | D1~D7에 2회 이상 성공한 설치자 / 관찰을 완료한 설치자 |
| 주간 Control 기록 횟수 | D1~D7 성공 횟수의 사용자별 중앙값. 설치 후 0회 사용자도 포함한다. |
| 기록 활성일 변화 | 사용자별 `D1~D7 활성일 - (D-14~D-1 활성일 / 2)`의 중앙값과 증가 사용자 비율 |
| 실패·차단 | 시도 수와 성공 수, 권한 필요/목표 초과/저장 실패/결과 미확인 수를 각각 기록한다. |
| 중복 저장 | 사용자가 의도한 성공 1회에 HealthKit 샘플이 여러 개 추가된 사례 수 |

참여자별 기록표는 아래 열을 사용한다. 매일 기록표의 Control 횟수는 날짜별 7개 값을 유지하고, 연구 종료 시에만 합산한다.

```text
참여자 코드 | 기기·OS | 빌드 | 안내일 | 설치 확인일·위치 | 첫 성공일 | 두 번째 성공일
기준선 14일 활성일 | D1~D7 전체 활성일 | 날짜별 Control 시도·성공·차단·실패·미확인
중복 사례 수 | 설치 실패·제거 이유 | 측정 공백·확인 근거
```

자기 보고의 누락 가능성이 있으므로 매일 기기 내 기록을 대조한다. 관찰 기간 중 Control을 제거한 참여자도 제외하지 않고 제거 사유와 이후 0회/미확인을 구분한다. 설치 표본 또는 완전한 전후 관찰 표본이 30명 미만이거나 측정 공백이 남으면 판정을 보류한다.

### Device QA Gate

각 행에 기기 모델, OS, 빌드, 제어 센터/잠금 화면/액션 버튼 위치, 결과와 확인일을 기록한다. 시뮬레이터 컴파일·단위 테스트 통과는 실기기 저장·피드백 통과를 뜻하지 않는다.

| Scenario | Required observation |
| --- | --- |
| 권한 허용, 목표 여유 | Control 한 번 실행에 기본 한 잔 샘플이 정확히 1개 추가되고 앱·Widget·Watch에 같은 합계가 보인다. |
| 앱 종료 상태 | 앱을 종료한 뒤 각 위치에서 실행해 같은 저장과 피드백을 확인한다. |
| 잠긴 기기 / 재부팅 후 첫 잠금 해제 전 | HealthKit 접근과 시스템 인증/foreground 전환 동작을 확인한다. 저장되지 않은 경우를 성공으로 세지 않는다. |
| 권한 미설정 / 거부 / 실행 중 철회 | 저장되지 않으며 앱의 권한 확인으로 이어지는지 확인한다. 복귀만으로 추가 기록되지 않아야 한다. |
| 목표 도달 / 한 잔보다 적게 남음 | 샘플이 추가되지 않아야 한다. Control 위치에서 반환 dialog가 실제로 전달되는지도 확인한다. |
| 저장 실패 | 샘플과 성공 피드백이 생기지 않아야 한다. Control이 오류 대신 완료로 보이면 관찰을 중단하고 원인을 기록한다. |
| 연속 탭 / 앱·Widget·Watch와 교차 사용 | 각 의도된 실행당 저장 1회, 재개·화면 갱신만으로 추가 저장 0회. 목표 직전 동시 실행도 확인한다. |
| 비행기 모드 | 기존 로컬 HealthKit 저장과 동일하게 동작하는지 확인한다. 네트워크 복귀로 추가 저장되지 않아야 한다. |
| 접근성 | VoiceOver가 `물 한 잔 기록`으로 읽으며 제어 크기별로 시스템 레이블이 식별 가능해야 한다. |
| 실험 조건을 끈 빌드 | Control이 갤러리에 노출되지 않고 기존 Widget·Shortcuts가 그대로 동작한다. |

`ProvidesDialog`가 모든 Control 위치에 같은 방식으로 표시된다고 가정하지 않는다. 저장 실패·목표 차단을 사용자가 구분하지 못하거나 중복 저장/데이터 손실이 발견되면 모집을 진행하지 않는다. 기존 Intent의 목표 확인과 쓰기는 원자적 연산이 아니므로 동시 실행에 대한 중복·초과 방지를 보장했다고 보고하지 않는다.

### Result And Decision

| Item | Current result |
| --- | --- |
| 로컬 환경 (2026-09-08) | Xcode 26.6 (17F113), Tuist 4.205.0, iPhone 17 Pro / iOS 26.5 Simulator |
| 로컬 검증 | lint·architecture 검사, 기본 앱 Debug 빌드, Control 활성화 WidgetExtension Release 빌드 통과. HydrationDomain 59개 테스트 통과. |
| 실기기 모델·OS / TestFlight 빌드 | 미검증 / 미배포 |
| 안내·설치·완전 관찰 표본 | 미모집 / 미수집 |
| 설치율·첫 사용률·반복 사용률 | 미측정 |
| 주간 성공 횟수 중앙값·활성일 변화 | 미측정 |
| 중복·실패·피드백 가드레일 | 실기기 확인 대기 |
| 판정 | 보류 — 실험 데이터 없음 |

- 성공: 완전 관찰 설치자 30명 이상, 주간 성공 횟수 중앙값 3회 이상, 사용자별 활성일 변화 중앙값이 0보다 크고 가드레일을 통과한다. 이 경우에만 정식 Widget 번들 포함 이슈를 생성한다.
- 개선 후 재실험: 설치율은 낮지만 설치자의 반복 사용이 높다. 설치 실패 이유를 바탕으로 안내를 한 번 수정한다.
- 중단: 충분한 설치 표본에서도 반복 사용과 활성일 증가가 없거나 중복·실패 가드레일을 위반한다.
- 보류: 표본 30명 미만, 관찰 미완료 또는 측정 공백이 있다. 미측정값을 0이나 성공으로 보고하지 않는다.

근거: [Apple Control 구성](https://developer.apple.com/documentation/widgetkit/creating-controls-to-perform-actions-across-the-system), [#322](https://github.com/gaeng2y/Mulimi/issues/322). 기본 기록량 개인화는 #315 범위로 유지한다.

## User Expectations

- 빠르게 한 잔을 기록할 수 있다
- 기록 중인지와 기록이 완료됐는지 메인 CTA에서 바로 알 수 있다
- 오늘 섭취 진행률이 WaterDrop으로 보이고, 몇 잔/몇 ml를 마셨는지 바로 확인할 수 있다
- 목표까지 남은 양과 다음 루틴이 가까운지 메인 화면에서 바로 확인할 수 있다
- 기록 탭에서 기간별 총 섭취량, 일평균, 기록 횟수, 목표 달성일을 빠르게 확인할 수 있다
- 잘못 남긴 최근 기록은 메인 화면에서 바로 되돌리고, 과거 기록은 기록 탭의 개별 기록 단위로 삭제하거나 메인 화면에서 오늘 물리미 기록을 초기화할 수 있다
- 워치/위젯 기록이 앱 기록과 어긋나지 않는다

## Scope

- 메인 화면의 물 마시기 액션
- 오늘 섭취량 집계
- 위젯/AppIntent 기록
- Apple Watch 기록
- 기록 탭의 오늘/주간/월간 기간 필터와 일별 요약
- 기록 탭의 앱 생성 HealthKit 샘플 개별 삭제

## Constraints

- HealthKit 권한이 없으면 기록/집계 UX가 그 상태를 설명해야 한다
- 외부 앱 또는 건강 앱이 만든 수분 기록은 물리미에서 삭제하지 않는다
- 저장 형식보다 사용자 체감 일관성이 우선이다

## Related Code

- `Project/Features/Hydration/Domain/Sources/Entity/HydrationServing.swift`
- `Project/Features/Hydration/Domain/Sources/Entity/HydrationNextActionGuide.swift`
- `Project/Features/Routine/Domain/Sources/UseCase/HydrationNextActionGuideUseCaseImpl.swift`
- `Project/Features/Hydration/Data/Sources/Repository/HealthKitRepositoryImpl.swift`
- `Project/Widget/Sources/`
- `Project/Features/WatchHydration/Domain/Sources/`

## Related Docs

- `ARCHITECTURE.md`
- `Docs/reliability-recovery.md`
- `Docs/product-specs/onboarding-healthkit-conversion-experiments.md`
- `Docs/skills/healthkit-flow.md`
- `Docs/skills/widget-watch-integration.md`

## Related Issues

- #203 기본 수분 기록량 및 즐겨찾는 용량 설정 추가
- #195 다양한 수분 기록 단위 프리셋 추가
- #67 Siri/Shortcuts 물 기록 적용
- #322 제어 센터·액션 버튼 수분 기록 사용성 검증
