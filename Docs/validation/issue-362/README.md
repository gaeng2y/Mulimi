# #362 회원 탈퇴 삭제·보존 범위 검증

## 환경

- 수정 전: `develop@69c84fc` 빌드에 `qa-harness.patch`만 적용
- 수정 후: `feature/#362-withdrawal-scope`의 수정 작업 트리(수정 커밋과 같은 내용)에 `qa-harness.patch`만 적용
- Xcode 27.1, macOS 27.2, iPhone 17 시뮬레이터 `400304D3-3E0F-4CB6-8F81-2DACD244F4F4` (iOS 27.1)
- Debug 빌드, `-derivedDataPath`는 세션 임시 폴더

## 전제

- 시뮬레이터에서 Sign in with Apple을 쓸 수 없어 `qa-harness.patch`가 `MULIMI_QA_SEED_AUTH=1`일 때 Keychain에 `ACCESS-TOKEN`·`USER-IDENTIFIER` 테스트 값을 넣는다. 탈퇴 처리 코드는 바꾸지 않는다.
- 같은 패치가 임시 UI 테스트 타깃 `MulimiQAUITests`를 추가한다. 커밋하지 않았다.
- 알림·HealthKit·AlarmKit 권한은 테스트가 시스템 화면에서 허용한다.

## 조작 순서

`WithdrawalQA.testWithdrawalScenario`가 실행한다.

1. 온보딩과 권한 게이트를 지나 메인에 진입한다.
2. 프로필 > 루틴에서 알림 권한을 허용하고 `QA 루틴`(활성, 오전 9:00)을 저장한다. 이미 있으면 그대로 둔다.
3. 프로필 > 회원 탈퇴 화면과 확인 대화상자를 캡처하고 `탈퇴`를 누른다.
4. 앱을 종료하고 같은 seed로 다시 로그인한 뒤 프로필 > 루틴을 캡처한다.

재실행:

```sh
git apply Docs/validation/issue-362/qa-harness.patch
tuist generate --no-open
TEST_RUNNER_QA_OUT=<출력 폴더> xcodebuild test -workspace Mulimi.xcworkspace -scheme MulimiQAUITests \
  -destination 'platform=iOS Simulator,id=<SIM_ID>' \
  -only-testing:MulimiQAUITests/WithdrawalQA/testWithdrawalScenario
git apply -R Docs/validation/issue-362/qa-harness.patch
```

## 결과

| 단계 | 기대 | 수정 전 | 수정 후 |
| --- | --- | --- | --- |
| 탈퇴 상세 | 삭제·보존 범위를 실제 처리대로 안내 | "모든 데이터 영구 삭제", "저장된 물 섭취 기록 삭제" 안내 (`before-03`) | 로그인 정보·루틴 삭제, 건강 앱 기록·앱 설정 유지 안내 (`after-03`) |
| 확인 대화상자 | 같은 범위 안내 | "모든 데이터가 영구적으로 삭제됩니다" (`before-04`) | 삭제·보존 범위와 되돌릴 수 없음 안내 (`after-04`) |
| 탈퇴 직후 | 로그인 화면 | 로그인 화면 (`before-05`) | 로그인 화면 (`after-05`) |
| 재로그인 후 루틴 | 루틴 없음, 알람 취소 | `QA 루틴, 활성` 유지 (`before-06`) | "아직 저장된 루틴이 없습니다." (`after-06`) |

`*-01-routine-saved.png`는 각 실행의 시작 조건으로 활성 루틴이 있음을 보여준다.

## 단위 테스트

- `AccountPresentation`: 수정 전 커밋 `✅ 회원 탈퇴 루틴 정리 회귀 테스트 추가`에서 2개 테스트가 실패하고, 수정 후 17개 테스트가 통과한다.

## 미검증

- AlarmKit 알람 취소는 화면 밖 상태다. 시뮬레이터에서는 루틴 저장소가 비는 것만 확인했다. `deleteRoutine`이 남은 루틴만으로 다시 스케줄하는 동작은 `RoutineRepositoryImplTests`가 다루고, 다시 스케줄하기 전 기존 알람을 모두 취소하는 `RoutineNotificationDataSourceImpl.cancelExistingAlarms`는 코드로만 확인했다. 실기기에서 탈퇴 후 알람이 울리지 않는지는 확인하지 않았다.
- iCloud KVS 목표량 보존과 다른 기기 동기화는 확인하지 않았다.
- 루틴 정리 실패 경로는 단위 테스트로만 확인했다.
