# Hydration Reminder Priming and Daily Nudges

## Goal

온보딩 직후 알림 권한을 맥락과 함께 요청하고, 허용한 사용자에게 하루 세 번 수분 입력을 유도하는 로컬 알림을 보낸다. 기존 루틴(AlarmKit) 알림과는 완전히 분리된 스택이다.

## Current Flow

```text
Onboarding 완료
  -> HydrationReminderPermissionGate (1회 노출, 스킵 가능)
  -> HealthKitPermissionGate
  -> ContentView
```

## Product Rules

- 프라이밍 화면은 시스템 권한 팝업 전에 어떤 알림을 왜 보내는지 설명한다.
- 시스템 권한 요청은 `알림 허용하기` CTA 탭에서만 실행한다. 자동 요청은 금지한다.
- `나중에 할게요`로 언제든 건너뛸 수 있고, 거부해도 앱 진입을 막지 않는다.
- 프라이밍은 기기당 1회만 노출한다. 허용/거부/스킵 어느 쪽이든 다시 보여주지 않는다.
- 이미 온보딩을 마친 기존 사용자도 다음 실행 시 1회 프라이밍을 본다.
- 권한이 허용된 상태에서는 앱 실행 시 리마인더 스케줄을 재동기화한다(문구 갱신 대응).
- 사용자가 iOS 설정에서 권한을 회수하면 다음 실행 시 남은 리마인더를 정리한다.
- 프라이밍 노출 전에 시스템 권한 상태를 먼저 확인한다. 확인이 끝나기 전에는 빈 화면을 유지해, 이미 권한이 결정된 사용자에게 프라이밍이 잠깐이라도 보이지 않게 한다.
- 로그아웃해도 이미 스케줄된 리마인더는 유지한다. 재방문을 유도하는 의도된 동작이며, 알림을 탭하면 로그인 화면으로 진입한다.
- 회원 탈퇴가 성공하면 `hydrationReminder.*`로 스케줄된 리마인더를 정리한다.
- 앱이 포그라운드일 때도 수분 리마인더 배너와 소리를 표시한다.
- 수분 리마인더를 탭하면 `mulimi://hydration/record`를 `AppCoordinator`에 전달해 메인 기록 화면으로 이동한다.

## Reminder Schedule

- 슬롯 정책은 `HydrationReminderSlot`(Domain)이 SSOT다: 아침 9:00, 오후 14:00, 저녁 20:00.
- 슬롯 3개 × 요일 7개 = 21개의 반복 `UNCalendarNotificationTrigger`로 스케줄한다.
- 문구는 슬롯별 제목 + 요일에 따라 로테이션되는 본문 3종(듀오링고식 톤)이다. 토→일 주 경계를 포함해 같은 슬롯에서 같은 본문이 이틀 연속 반복되지 않는다.
- 알림 식별자는 `hydrationReminder.<slot>.<weekday>`로 고정하고, 취소는 이 프리픽스만 대상으로 한다.
- 재스케줄은 같은 식별자 `add()` 교체 방식으로 수행하고, 스케줄 성공 후에만 잔여 식별자를 정리한다. 중간 실패가 기존 스케줄을 지우지 않게 하기 위함이다.
- `removeAllPendingNotificationRequests()`는 사용하지 않는다.

## Routine Notifications와의 관계

- 루틴 알림은 AlarmKit(`AlarmManager`) 기반이고 이 기능은 `UNUserNotificationCenter` 기반이다.
- 두 권한은 서로 다른 시스템 권한이며 한쪽 허용이 다른 쪽에 영향을 주지 않는다.
- 루틴 저장/삭제 시 AlarmKit 알람을 전체 리셋하는 기존 동작은 이 기능과 무관하다.

## State Expectations

- `프라이밍 미노출 + 권한 notDetermined`: 프라이밍 화면 노출
- `허용`: 리마인더 21개 스케줄 후 다음 단계 진입
- `거부 / 스킵`: 스케줄 없이 다음 단계 진입
- `권한이 이미 결정된 상태(재설치 등)`: 프라이밍 없이 통과, 허용 상태면 재동기화

## Measurement Plan

이벤트 정의는 [Analytics Events](analytics-events.md)를 기준으로 한다.

- `hydration_reminder_priming_viewed`: 프라이밍 화면 노출
- `hydration_reminder_request_tapped`: 알림 허용 CTA 탭
- `hydration_reminder_permission_authorized`: 권한 허용
- `hydration_reminder_permission_denied`: 권한 거부
- `hydration_reminder_priming_skipped`: 나중에 할게요 탭

## Known Limitations

- 리마인더 시간과 문구는 아직 사용자 설정을 제공하지 않는다.

## Related Code

- `Project/Features/HydrationReminder/Domain/Sources/HydrationReminderSlot.swift`
- `Project/Features/HydrationReminder/Domain/Sources/HydrationReminderUseCase.swift`
- `Project/Features/HydrationReminder/Domain/Sources/HydrationReminderUseCaseImpl.swift`
- `Project/Features/HydrationReminder/Data/Sources/DataSource/HydrationReminderNotificationDataSource.swift`
- `Project/Features/HydrationReminder/Data/Sources/Repository/HydrationReminderRepositoryImpl.swift`
- `Project/Features/HydrationReminder/Presentation/Sources/ViewModel/HydrationReminderPermissionViewModel.swift`
- `Project/Features/HydrationReminder/Presentation/Sources/View/HydrationReminderPermissionGateView.swift`
- `Project/App/Sources/RootView.swift`
- `Project/App/Navigation/Sources/AppCoordinator.swift`
- `Project/App/Sources/AppDelegate.swift`

## Related Docs

- `Docs/product-specs/sign-in-onboarding-healthkit.md`
- `Docs/product-specs/routine-notifications.md`
- `Docs/product-specs/analytics-events.md`

## Notification Quick Logging (#321)

- Debug와 Release 모두 수분 리마인더에 **마셨어요** 액션 하나를 제공한다. 기본 기록량은 `HydrationServing.defaultGlassVolumeML`이다. AlarmKit 루틴, 스누즈, 알림 시간·목표 정책은 변경하지 않는다.
- 액션은 `.authenticationRequired`를 사용한다. 잠금 해제 후 앱 화면을 열지 않고 처리할 수 있다. 잠금 해제가 취소되면 앱에 액션 응답이 전달되지 않으므로 선택 이벤트에도 포함되지 않는다.
- Apple 문서에 따라 잠긴 기기의 HealthKit 읽기는 제한된다. 잠금 상태에서 목표 확인을 우회하지 않고, 보호 데이터 미사용·조회 오류·로그아웃 상태에서는 저장하지 않는다. 읽기 권한 거부와 실제 기록 0은 HealthKit 특성상 구별할 수 없으며 기존 기록 경로와 같은 측정 한계가 있다.
- `DrinkWaterUseCase`가 목표 초과 여부를 확인하고 기존 Repository → HealthKit 경로를 호출한다. 권한 철회·저장 실패를 성공으로 표시하거나 위젯을 갱신하지 않는다. 실패·목표 초과는 추가 로컬 알림으로 안내하며, 이를 탭하면 기존 기록 화면으로 이동한다. 알림 권한이 철회된 상태에서는 이 안내도 보이지 않을 수 있다.
- 중복 키는 **반복 요청 ID + 해당 전달 시각**이다. 처리 중 재진입은 무시하고, 성공한 전달의 영수증만 요청별로 UserDefaults에 저장한다(기본 스케줄 최대 21개). 수분량·HealthKit 원장·재시도 큐는 저장하지 않는다. 저장 직후 앱이 종료되어 영수증이 누락되더라도 동일한 `HKMetadataKeySyncIdentifier`와 버전 1을 재사용해 HealthKit 중복 샘플을 막는다. 다음 주 동일 슬롯은 새 전달 시각으로 기록된다.
- 성공 후에만 위젯 timeline을 갱신한다. 원래 알림 본문 탭은 `AppCoordinator`의 기존 `mulimi://hydration/record` 경로를 유지한다. dismiss·알 수 없는 액션은 기록하거나 이동시키지 않는다.

### Measurement and Decision

| 항목 | 정의 |
| --- | --- |
| 선택 | 앱 delegate까지 전달되어 중복 필터를 통과한 `hydration_reminder_action_selected`. 사용자의 잠금 해제 전 물리적 탭 수가 아니다. |
| 결과 | 같은 시도의 `hydration_reminder_action_result`: `saved`, `failed`, `permissionRequired`, `goalExceeded`, `protectedDataUnavailable`, `signInRequired`. `saved`는 HealthKit 저장 API 완료이며 별도 실기기 샘플 검증이 필요하다. |
| 기존 성공 이벤트 | 저장 완료 후 `water_logged.source = notification_action`. 앱 본문은 기존 `drink_water_main`을 유지한다. |
| 귀속 시간창 | `UNNotification.date`부터 액션 응답 시각까지 **0~600초(양 끝 포함)**. `within_attribution_window`로 구분한다. 오래된 알림의 명시적 액션은 저장하지만 10분 내 기록 전환에서 제외한다. 날짜 경계를 넘어도 같은 경과 시간 규칙을 쓴다. |
| 본문 열기 | `hydration_reminder_opened`. 열기와 저장은 별개다. 이벤트 자체로 기록 성공이나 노출 수를 추정하지 않는다. |
| 전달·노출 분모 | 예약 요청 21개는 전달 수가 아니다. 배너 표시 요청·본문 열기도 실제 사용자 노출을 보장하지 않는다. 참가자가 확인한 실제 전달/노출과 HealthKit 기록을 별도 관찰표로 수집한다. |
| 저장 가드레일 | 액션 선택 대비 저장 성공·실패/차단 비율과 결과 미수신 수를 보고한다. 미수신을 성공이나 실패로 치환하지 않는다. 기존 경로는 `water_logged`/`water_log_failed`를 같은 빌드·기기 조건으로 비교한다. |

기준선은 KST(Asia/Seoul) 기준 기능 도입 전 7개의 완전한 날짜, 적용 후 관찰도 7개의 완전한 날짜로 정한다. 두 구간 모두 **확인된 알림 전달 뒤 10분 안에 HealthKit 기록 1건 이상이 있는 알림 / 확인된 전달 알림**을 비교한다. 한 기록이 여러 알림의 창에 들어가면 직전 알림 한 건에만 귀속한다. 기록 시각·기기·OS·빌드·잠금/백그라운드 상태·시도·저장/차단·중복을 기기 내에서 확인하고 집계 결과만 남긴다. 자연 발생 기록이 포함될 수 있어 이 전후 비교만으로 인과 효과를 단정하지 않는다.

현재 저장소에는 신뢰할 수 있는 전달 분모와 기존 전환율 관찰값이 없다. **기준선 미측정, 전환 개선 판정 보류**가 시작 상태다. TestFlight에서 유효 분모를 확보하기 전에는 액션 선택 대비 저장 결과만 보조 지표로 사용한다. 재설치·영수증 기록 전 종료·이벤트 업로드 유실로 정확한 시도 결합이 불가능할 수 있으며 알림 ID/전달 시각/HealthKit 샘플 ID를 분석 서버에 보내지 않는다. 상대 10% 개선과 기존 경로 이하의 저장 실패율을 확인해야 성공으로 판단하고, 중복·잘못된 성공 표시가 있으면 먼저 수정한다. #321의 실기기·실험 완료 조건은 PR 구현만으로 닫지 않는다.

### Device QA (pending)

지원하는 실제 iPhone에서 기기·OS·빌드와 HealthKit 샘플 수/용량을 함께 기록한다. 시뮬레이터 단위 테스트는 아래 환경 검증을 대체하지 않는다.

1. 전경/백그라운드/앱 종료 상태의 액션 → 기본 1잔 1건, 액션 처리 완료까지 기다림.
2. 잠금 화면 → 잠금 해제 성공 시 저장, 취소 시 미저장. 처리 도중 재잠금/HealthKit 조회 실패 시 성공 안내 없음.
3. 권한 허용 후 철회, 로그아웃, 목표 도달/남은 용량 부족 → 미저장과 실패 안내 확인.
4. 같은 알림 반복 응답·처리 중 중복·저장 직후 프로세스 종료 후 재처리 → 샘플 최대 1건. 다음 주 동일 요청은 새 기록.
5. 본문/실패 안내 탭 → 기록 화면, dismiss/알 수 없는 액션 → 저장과 이동 없음.
6. PostHog 활성 Release/TestFlight에서 선택·결과·성공 이벤트와 600초 경계 확인. 잠금 해제 전 취소·분석 설정 없음·오프라인 이벤트 유실은 측정 공백으로 기록.

근거: [Apple — actionable notifications](https://developer.apple.com/documentation/usernotifications/declaring-your-actionable-notification-types), [잠금 해제 요구](https://developer.apple.com/documentation/usernotifications/unnotificationactionoptions/authenticationrequired), [HealthKit 개인정보 보호](https://developer.apple.com/documentation/healthkit/protecting-user-privacy), [HealthKit sync identifier](https://developer.apple.com/documentation/healthkit/hkmetadatakeysyncidentifier).
