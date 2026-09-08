# Feature Discovery

- 상태: 발견 단계. 제품 스펙이나 로드맵 확정안이 아니다.
- 검토일: 2026-09-07
- 범위: 기존 Mulimi 기능과 공개 경쟁 제품을 바탕으로 다음 검증 후보를 찾는다.

## Opportunity

Mulimi는 HealthKit을 원본 저장소로 사용하는 iPhone·Apple Watch 수분 습관 앱이다. 핵심 고객은 물 마시기를 자주 잊지만 기록에는 시간을 쓰고 싶지 않고, Apple Health 연동과 기기 중심 개인정보 보호를 선호하는 사용자다.

제품 성과는 기존 Growth Scorecard와 동일하게 `D0-D6 중 3일 이상 기록한 활성 사용자`를 중심으로 판단한다. 새 기능은 다음 경계를 지켜야 한다.

- HealthKit, `HydrationServing`, 기존 Routine·Challenge·Insight·AppIntent를 재사용한다.
- 별도 서버 계정, 새 원장, 새로운 수분 계산 규칙을 만들지 않는다.
- 30명 이상의 유효 표본과 사전 기준선으로 판단하고, 핵심 지표는 상대 10% 이상 개선을 목표로 한다.

WaterMinder와 Waterllama는 이미 음료·컵 커스터마이징, 스마트 알림, 챌린지, 리포트, 공유, Watch·Widget·Siri를 폭넓게 제공하고 Plant Nanny는 캐릭터 성장형 게임화에 집중한다. 따라서 같은 기능 수 경쟁보다 Apple 네이티브 기록 경로와 첫 주 습관 형성에 집중하는 편이 Mulimi에 더 적합하다. ([WaterMinder](https://apps.apple.com/us/app/water-tracker-by-waterminder/id653031147), [Waterllama](https://apps.apple.com/us/app/water-tracker-waterllama/id1454778585), [Plant Nanny](https://apps.apple.com/us/app/plant-nanny-cute-water-tracker/id1424178757))

## Candidate Ideas

### Product Manager

| 아이디어 | 해결하려는 문제 | 가장 작은 형태 |
| --- | --- | --- |
| 로그인 없이 시작 | 서버 계정 가치가 없는 상태에서 Apple 로그인이 첫 기록 전 이탈을 만든다 | 로그인 단계를 건너뛰고 로컬 세션으로 온보딩 시작 |
| 7일 스타터 플랜 | 사용자가 첫 기록 뒤 루틴·Widget·Watch를 발견하지 못한다 | 첫 기록, 루틴 1개, 빠른 기록 경로 1개를 안내하는 체크리스트 |
| 컴백 모드 | 며칠 놓친 사용자가 연속 기록 단절 후 복귀 이유를 잃는다 | 2~6일 공백 후 “오늘 한 번으로 다시 시작” 카드 노출 |
| 횟수 목표 모드 | ml 목표가 행동으로 번역되지 않는 사용자가 있다 | 기존 목표량을 하루 권장 횟수로 함께 표현 |
| 루틴 템플릿 | 빈 화면에서 알림 시간을 직접 설계하는 비용이 크다 | 출근·업무·운동 템플릿을 기존 Routine에 복사 |

### Product Designer

| 아이디어 | 해결하려는 문제 | 가장 작은 형태 |
| --- | --- | --- |
| 알림 바로 기록 | 알림을 눌러 앱으로 이동하는 동안 행동 의도가 사라진다 | “마셨어요”와 “10분 뒤” 액션 제공 |
| 코칭 원탭 적용 | 인사이트를 읽고 루틴 편집 화면에서 다시 설정해야 한다 | 추천 시간을 기존 편집 화면에 미리 채운 CTA |
| 빠른 기록 설정 코치 | Widget·Watch·Shortcut이 있어도 설치·설정 경로를 모른다 | 첫 기록 뒤 사용 기기에 맞는 한 가지 경로만 제안 |
| 하루 마감 카드 | 하루 결과가 숫자만으로 끝나 성취감과 다음 행동이 약하다 | 저녁에 달성 요약과 내일 한 행동만 표시 |
| 주간 초점 고정 | 주간 코칭을 읽어도 다음 주 행동이 홈에서 사라진다 | 선택한 코칭 한 개를 홈 상단에 7일간 고정 |

### Engineer

| 아이디어 | 해결하려는 문제 | 가장 작은 형태 |
| --- | --- | --- |
| 제어 센터·액션 버튼 기록 | 앱이나 Widget을 찾지 않고도 기록하고 싶다 | 기존 `LogWaterAppIntent`를 실행하는 Control Widget |
| Watch 컴플리케이션·Smart Stack | Watch 앱을 직접 열어야 현재량과 기록 버튼을 볼 수 있다 | 현재 진행률과 기본 기록 버튼 하나 제공 |
| 목표 인지형 알림 억제 | 이미 충분히 마셨는데 고정 알림이 와 신뢰가 떨어진다 | 알림 시점에 목표 달성 상태면 해당 알림 건너뛰기 |
| 운동 후 제안 | 운동으로 수분 필요가 커진 순간을 놓친다 | 온디바이스 운동 종료 후 기록 CTA를 선택적으로 노출 |
| 루틴 iCloud 복원 | 기기 교체 시 로컬 루틴이 사라질 수 있다 | 기존 루틴 표현을 iCloud KVS로 백업·복원 |

## Top 5

점수는 5점 만점이며 `핵심 가치 × 2 + 검증 속도 + 차별성`으로 정렬한다.

| 순위 | 아이디어 | 핵심 가치 | 검증 속도 | 차별성 | 가중 점수 |
| ---: | --- | ---: | ---: | ---: | ---: |
| 1 | 로그인 없이 시작 | 5 | 5 | 4 | 19 |
| 2 | 7일 스타터 플랜 | 5 | 5 | 3 | 18 |
| 3 | 알림 바로 기록 | 5 | 4 | 4 | 18 |
| 4 | 제어 센터·액션 버튼 기록 | 4 | 5 | 4 | 17 |
| 5 | 컴백 모드 | 4 | 4 | 4 | 16 |

### 1. 로그인 없이 시작

- 이유: 현재 인증 구현은 Apple 식별자를 로컬 Keychain과 분석 식별에 사용하고 서버 로그인·삭제는 구현하지 않는다. 핵심 데이터는 HealthKit·로컬 저장소·iCloud KVS에 있으므로, 로그인은 가치보다 첫 기록 전 마찰일 가능성이 크다.
- 핵심 가정: Apple 로그인 단계 때문에 유의미한 사용자가 이탈하고, 로그인 제거가 데이터 정합성이나 복원을 해치지 않는다.
- 검증: 먼저 로그인 화면 노출·성공·이탈 이벤트를 추가한다. 이후 TestFlight에서 로그인 생략 흐름을 비교해 온보딩 완료율과 첫 기록률을 본다.
- 통과 기준: 온보딩 완료율 또는 첫 기록률 상대 10% 이상 개선, 인증 관련 데이터 손실·지원 문의 증가 없음.

### 2. 7일 스타터 플랜

- 이유: 현재 온보딩은 제품 설명과 권한 획득에 집중하며, 첫 기록 이후 Routine·Widget·Watch 중 한 가지를 습관 경로로 만드는 단계가 없다.
- 핵심 가정: 기존 기능의 부족보다 발견과 설정 실패가 첫 주 이탈의 주원인이다.
- 검증: 새 엔진 없이 기존 화면으로 연결하는 3단계 체크리스트를 첫 기록 직후 노출한다.
- 통과 기준: D0-D6 3일 기록 활성화율 상대 10% 이상 개선.

### 3. 알림 바로 기록

- 이유: 현재 알림 탭은 앱의 기록 화면으로 이동한다. 알림 액션은 앱을 백그라운드에서 실행해 사용자 응답을 처리할 수 있어 한 단계를 제거할 수 있다. ([Apple: Handling notifications and notification-related actions](https://developer.apple.com/documentation/usernotifications/handling-notifications-and-notification-related-actions))
- 핵심 가정: 앱 진입 단계가 알림 후 기록 전환을 낮추며, 백그라운드 HealthKit 저장이 안정적으로 동작한다.
- 검증: TestFlight에서 “마셨어요” 액션 하나만 제공하고 액션 선택 대비 저장 성공률과 알림 후 기록률을 측정한다.
- 통과 기준: 알림 후 기록률 상대 10% 이상 개선, 저장 실패율이 기존 기록 경로보다 나빠지지 않음.

### 4. 제어 센터·액션 버튼 기록

- 이유: 기존 Widget이 사용하는 `LogWaterAppIntent`를 재사용할 수 있다. WidgetKit Control은 제어 센터·잠금 화면·액션 버튼 등에서 App Intent를 실행할 수 있다. ([Apple: Creating controls](https://developer.apple.com/documentation/widgetkit/creating-controls-to-perform-actions-across-the-system), [Apple: Widget interactivity](https://developer.apple.com/documentation/widgetkit/adding-interactivity-to-widgets-and-live-activities))
- 핵심 가정: 지원 기기 사용자가 이 경로를 주 3회 이상 사용하며 기존 기록 경로를 단순 대체하는 데 그치지 않는다.
- 검증: 기존 AppIntent에 연결한 Control 하나를 TestFlight로 배포해 설치율, 주간 사용 횟수, 전체 기록 일수 변화를 본다.
- 통과 기준: 설치 사용자의 주간 중앙값 3회 이상, 기록 활성일 증가.

### 5. 컴백 모드

- 이유: 현재 연속 기록과 챌린지는 진행을 보여 주지만, 공백 후 다시 시작하는 순간을 위한 별도 경험은 없다.
- 핵심 가정: 공백 사용자는 기존 연속 기록보다 작은 재시작 행동에 더 잘 반응한다.
- 검증: 2~6일 공백 뒤 복귀한 사용자에게 기존 기록 CTA를 담은 카드만 노출한다.
- 통과 기준: 같은 세션 기록률 상대 15% 이상 개선, 이후 7일 재활성화율 악화 없음.

## Decision

상위 후보는 검증 이슈 [#319](https://github.com/gaeng2y/Mulimi/issues/319)~[#323](https://github.com/gaeng2y/Mulimi/issues/323)으로 등록하되, 실험은 우선순위대로 하나씩 실행한다. 각 기능의 구현 이슈는 해당 검증이 성공한 경우에만 연다. 기본 기록량 개인화는 이미 [#315](https://github.com/gaeng2y/Mulimi/issues/315)에서 다루므로 중복 후보에서 제외한다. Watch 컴플리케이션과 운동 후 제안은 사용자 범위와 권한 비용이 더 커서 상위 실험 결과 이후에 검토한다.
