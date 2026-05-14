# Reliability Recovery

Mulimi의 HealthKit, 알림, Widget, Watch 실패 상황을 같은 기준으로 처리하기 위한 운영 문서다. 제품별 세부 요구는 `Docs/product-specs/`가 맡고, 이 문서는 복구 판단 기준과 source of truth를 정한다.

## Goals

- 권한 거부, 기록 실패, timeline 지연, 앱/워치 데이터 불일치 상황에서 사용자 안내 기준을 통일한다.
- HealthKit 문제를 로컬 hydration 원장으로 덮지 않는다.
- Widget/Watch가 앱과 다른 수분 계산 규칙을 만들지 않게 한다.
- 구현에서 즉시 메워야 할 누락은 후속 GitHub issue로 분리한다.

## Non-Goals

- HealthKit source of truth 변경
- Widget/Watch 전용 수분 단위 규칙 추가
- 복구 로직 대규모 재구현
- 사용자 문구의 최종 카피 관리

## Source Of Truth

| Concern | Source of truth | Recovery rule |
| --- | --- | --- |
| 수분 섭취 기록 | `HealthKit` | 실패해도 SwiftData/UserDefaults hydration 원장을 만들지 않는다. 다시 읽기 또는 다시 기록으로 복구한다. |
| 신체 정보 | `HealthKit` | 권한이 없거나 읽기 실패 시 직접 입력 플로우로 대체하지 않는다. 권한 복구를 안내한다. |
| 목표 수분량 | `iCloud KVS + App Group UserDefaults mirror` | KVS에 양수 값이 있으면 mirror를 갱신하고, KVS가 비어 있으면 local mirror의 양수 값을 KVS로 올린다. 둘 다 없으면 기본 목표를 사용한다. |
| `mainIcon` | App Group `UserDefaults` | 앱과 위젯이 같은 설정을 본다. `mainAppearance`를 복구 경로로 되살리지 않는다. |
| 수분 단위와 다음 액션 | `HydrationServing`, `HydrationNextActionGuide` | 앱, Widget, Watch가 같은 Domain 규칙을 재사용한다. |
| 루틴 알림 | 저장된 루틴 + AlarmKit 권한/스케줄 | 활성 루틴은 알림 권한과 스케줄 상태를 함께 봐야 한다. |

## Recovery Principles

- 사용자에게는 원인보다 다음 행동을 먼저 보여준다: 권한 요청, 설정 이동, 다시 시도, 앱 열기, 입력값 조정.
- 시스템 오류는 Data layer에서 기록하고, View/ViewModel은 사용자에게 필요한 상태와 CTA만 노출한다.
- 목표 초과 차단은 오류가 아니다. 기록 전에 막고, 남은 용량 또는 목표 조정을 안내한다.
- Widget timeline reload는 best-effort다. Widget이 늦게 갱신돼도 앱/HealthKit 기준을 바꾸지 않는다.
- Watch는 자체 계산 규칙을 만들지 않는다. HealthKit 기록과 목표 mirror를 다시 읽어 앱과 수렴시킨다.
- 전역 push 복구는 `ContentView + AppCoordinator` 흐름을 사용한다.

## Failure Matrix

| Failure type | User guidance | System handling | Retry / CTA | Data rule |
| --- | --- | --- | --- | --- |
| HealthKit 최초 권한 미결정 | 온보딩 뒤 HealthKit 권한 게이트에서 필요한 접근을 설명한다. | `HealthKitPermissionGateView`가 `notDetermined` 상태에서 권한 요청 CTA를 제공한다. | 권한 요청 | 권한 승인 전에는 HealthKit 기록/집계를 원본처럼 표시하지 않는다. |
| HealthKit 권한 거부 또는 철회 | 물 기록과 신체 정보 동기화가 제한됐음을 설명하고 설정 이동을 제안한다. | 앱 활성화 시 상태를 다시 읽고, `sharingDenied`면 게이트를 유지한다. | 설정 이동, 상태 새로고침 | 로컬 hydration 원장이나 직접 신체 정보 입력으로 대체하지 않는다. |
| HealthKit 읽기 실패 | 가능한 화면에서는 일시적 동기화 실패로 안내한다. | Data layer는 오류를 로그로 남기고 빈 값/이전 화면 상태를 원본으로 저장하지 않는다. | 다시 시도, 앱 재진입, 권한 확인 | 다음 refresh에서 HealthKit을 다시 읽는다. 실패값을 KVS/UserDefaults에 쓰지 않는다. |
| HealthKit 기록 실패 | 기록이 완료되지 않았음을 알리고 다시 시도를 제공한다. 권한 철회가 원인이면 설정 이동을 제공한다. | 기록 결과가 확인되기 전에는 성공 analytics, undo, timeline reload를 성공 처리로 간주하지 않는다. | 다시 시도, 설정 이동 | 실패한 기록을 로컬에 보류 저장하지 않는다. |
| 오늘 목표 초과 기록 | 남은 용량 또는 목표 달성 상태를 안내한다. | 앱/Widget AppIntent/Watch 모두 기록 전에 차단한다. | 입력량 조정, 목표 변경 | 초과 샘플을 HealthKit에 쓰지 않는다. |
| 최근 기록 되돌리기 또는 개별 삭제 실패 | 삭제되지 않았음을 안내하고 다시 시도할 수 있게 한다. | 앱이 생성한 HealthKit 샘플만 삭제 대상이다. 외부 앱/건강 앱 샘플은 삭제하지 않는다. | 다시 시도 | 삭제 실패 시 목록과 오늘 합계는 HealthKit 재조회 결과를 따른다. |
| Widget timeline 갱신 실패 또는 지연 | 별도 오류 화면보다 마지막으로 렌더링 가능한 상태를 유지하고, 사용자는 앱에서 최신 상태를 확인한다. | 앱 기록, 기록 삭제, 목표/아이콘 변경 후 `WidgetCenter.reloadAllTimelines()`를 호출한다. WidgetKit 지연은 OS 정책으로 본다. | 앱 열기 | Widget entry는 HealthKit 기록, 목표 mirror, `HydrationServing` 기준으로 다시 만든다. |
| Watch 기록 실패 | 기록이 반영되지 않으면 Watch snapshot을 다시 읽고 앱 또는 건강 앱 기준과 맞춘다. | Watch는 HealthKit 저장 실패를 별도 로컬 원장으로 보정하지 않는다. | 다시 시도, 앱에서 권한 확인 | Watch 수분 기록 원본도 HealthKit이다. |
| Watch/App Group 목표 불일치 | 앱/Watch가 서로 다른 목표를 보이면 다음 refresh에서 KVS와 App Group mirror를 다시 동기화한다. | KVS 양수 값이 우선이고, 없으면 local mirror 양수 값을 KVS로 올린다. | 앱 재진입, Watch 재진입 | 목표량은 `iCloud KVS + App Group UserDefaults mirror` 정책을 따른다. |
| 알림 권한 미결정 | 루틴 저장 전 권한 요청 필요성을 설명한다. | 활성 루틴 저장 시 권한 상태를 먼저 확인한다. | 권한 요청 | 루틴 저장소는 UserDefaults JSON이고, 알림 스케줄은 활성 루틴에서 재구성한다. |
| 알림 권한 거부 | 루틴을 만들 수는 있지만 활성 알림은 동작하지 않음을 설명하고 설정 이동을 제공한다. | 권한 거부 상태에서 활성 루틴 저장을 시도하면 설정 이동 prompt로 분기한다. | 설정 이동, 알림 없이 저장 | 활성 알림 상태와 루틴 표시가 어긋나지 않아야 한다. |
| 알림 스케줄 실패 | 저장 또는 변경이 완료되지 않았음을 안내한다. | 스케줄 실패가 발생하면 활성 루틴을 예약 완료처럼 보여주지 않는다. | 다시 시도, 알림 없이 저장 | 저장된 루틴과 AlarmKit 스케줄 상태가 일치해야 한다. |

## Current Implementation Notes

- HealthKit 권한 게이트는 거부 상태에서 설정 이동과 상태 새로고침을 제공한다.
- 메인 수분 기록, 기록 삭제, 목표/아이콘 변경 후 Widget timeline reload를 호출한다.
- AppIntent는 선택된 기록량, Watch는 기본 1잔 기준으로 목표 초과를 차단한다.
- Watch 목표량은 KVS를 먼저 보고 App Group mirror를 보정한다.
- 루틴 알림은 권한 상태에 따라 권한 요청, 설정 이동, 알림 없이 저장으로 분기한다.

## Follow-Up Issues

아래 항목은 문서 기준과 현재 구현 사이의 즉시 보강 후보다.

| Area | Follow-up | Gap | Required outcome |
| --- | --- | --- | --- |
| HealthKit write result | [#219](https://github.com/gaeng2y/Mulimi/issues/219) | 수분 기록 저장 실패가 앱/AppIntent/Watch UI까지 성공/실패로 명확히 전달되지 않는다. | 실패 시 성공 analytics, undo, timeline reload를 성공 처리하지 않고 사용자에게 재시도 또는 설정 이동을 안내한다. |
| Routine schedule atomicity | [#220](https://github.com/gaeng2y/Mulimi/issues/220) | 루틴 저장 후 AlarmKit 스케줄 실패가 나면 활성 루틴 표시와 실제 알림 상태가 어긋날 수 있다. | 스케줄 실패 시 활성 루틴을 예약 완료처럼 보여주지 않고, 다시 시도 또는 알림 없이 저장으로 복구한다. |

## QA Scenarios

- HealthKit 권한을 거부한 뒤 앱을 재진입하면 권한 게이트가 유지되고 설정 이동 CTA가 보인다.
- HealthKit 권한을 설정에서 다시 허용한 뒤 앱으로 돌아오면 상태 새로고침 후 메인 화면에 진입한다.
- 목표까지 남은 양보다 큰 커스텀 용량을 입력하면 HealthKit 쓰기 전에 차단된다.
- 앱에서 수분 기록 또는 삭제 후 Widget이 늦게 갱신돼도 앱 화면의 오늘 합계가 HealthKit 기준으로 유지된다.
- Watch에서 기본 1잔을 기록한 뒤 앱이 HealthKit을 다시 읽으면 같은 오늘 합계로 수렴한다.
- 알림 권한이 `notDetermined`이면 활성 루틴 저장 전에 권한 요청 prompt가 나온다.
- 알림 권한이 `denied`이면 설정 이동 또는 알림 없이 저장 흐름으로 분기한다.

## Related Docs

- `ARCHITECTURE.md`
- `Docs/product-specs/hydration-logging.md`
- `Docs/product-specs/routine-notifications.md`
- `Docs/skills/healthkit-flow.md`
- `Docs/skills/widget-watch-integration.md`
- `Docs/exec-plans/tech-debt-tracker.md`
