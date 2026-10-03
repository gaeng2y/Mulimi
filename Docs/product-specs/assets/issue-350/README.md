# #350 조회 실패 화면

2026-10-03, Xcode 27.0 / iPhone 17e / iOS 26.5 Simulator에서 촬영했다.

| 상태 | 캡처 |
| --- | --- |
| 첫 조회 실패: 합계를 숨기고 다시 불러오기 제공 | [first-read-failure.png](first-read-failure.png) |
| 같은 날 새로고침 실패: 이전 500ml와 안내 유지 | [stale-records.png](stale-records.png) |
| 조회 성공: 정상 합계와 기록 액션 | [recovered.png](recovered.png) |

실제 `DrinkWaterView`에 오류 또는 500ml를 반환하는 UseCase 대역을 주입한 임시 시뮬레이터 호스트를 사용했다. HealthKit의 실제 잠금/권한 실패를 촬영한 것은 아니다. 임시 호스트와 캡처용 테스트 코드는 최종 소스에서 제거했다. 재시도의 읽기 전용 동작은 단위 테스트에서 검증했다.
