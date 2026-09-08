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
