# Challenge and Insight

## Goal

사용자가 기록만 남기고 끝나지 않도록 현재 패턴, 목표 대비 상태, 유지 동기를 함께 제공한다.

## Product Rules

- 챌린지는 장기 달성 레이어와 개인화 추천 레이어를 구분한다
- 챌린지 탭은 `추천`, `진행 중`, `완료` 카테고리로 나누고 Liquid Glass segmented control로 전환한다
- 인사이트는 최근 기록과 목표 흐름을 해석해 보여준다
- 인사이트 탭은 `요약`, `패턴`, `루틴`, `리포트` 카테고리로 나누고 Liquid Glass segmented control로 전환한다
- 인사이트 전체 empty state는 안내와 함께 다음 행동 CTA를 제공한다. 기록 CTA를 우선으로, 루틴 생성 CTA, 목표 미설정 시 목표 설정 CTA 순서로 노출한다
- 주간 리포트는 이번 주 elapsed 구간과 전주 동일 일수 구간을 비교해 평균 섭취량 변화를 보여준다
- 루틴 수행률은 루틴 저장값과 실제 `HealthKit` 기록 시각을 공통 Domain 규칙으로 매칭해 계산한다
- 추천 챌린지는 고정 배지 체계를 대체하지 않고 보조한다
- 추천 챌린지 CTA는 전역 `ContentView + AppCoordinator` push를 통해 루틴 생성/수정 흐름으로 연결한다

## Current Sections

- 챌린지 추천: 루틴과 최근 기록 기반 개인화 CTA
- 챌린지 진행 중: 현재 달성 중인 고정 챌린지
- 챌린지 완료: 획득한 챌린지 기록
- 인사이트 요약: 주간/월간 평균과 목표 기준
- 인사이트 패턴: 요일별 섭취 패턴
- 인사이트 루틴: 루틴 수행률과 놓친 시간대
- 인사이트 루틴 복구 CTA: 놓친 루틴 또는 자주 비는 시간대에서 즉시 기록, 루틴 수정/생성, 알림 권한/설정으로 연결
- 인사이트 리포트: 주간 리포트와 전주 비교, 다음 주 코칭 액션

## Behavior Expectations

- 반복형 챌린지와 누적형 챌린지는 상태 규칙이 다르다
- 추천은 최근 기록과 루틴 상태를 반영한다
- 챌린지 segmented control은 표시 카테고리만 바꾸며 저장 모델이나 진행 규칙을 바꾸지 않는다
- 챌린지 카테고리는 데이터가 없을 때도 카테고리별 empty state를 보여준다
- 인사이트 segmented control은 표시 카테고리만 바꾸며 계산 규칙을 바꾸지 않는다
- 인사이트 전체 empty state CTA는 기록 CTA가 메인 기록 탭 전환으로, 루틴 CTA가 알림 권한 상태에 따라 루틴 생성/권한 요청/설정 이동으로, 목표 CTA가 목표 설정 push로 이어진다
- 인사이트 전체 empty state CTA는 카테고리별 empty card와 역할을 나눈다. 전체 empty state는 시작 행동을, 카테고리 empty card는 해당 카테고리 안내를 담당한다
- 주간 리포트는 평균 섭취량, 목표 달성일, 오전/오후/저녁 중 자주 비는 시간대를 요약한다
- 루틴 수행률은 이번 주에 도래한 활성 루틴만 분모에 넣고, 비활성 루틴과 아직 도래하지 않은 루틴은 구분해 보여준다
- 루틴 기반 추천은 기존 루틴 수정으로, 기록 기반 추천은 새 루틴 생성으로 이어진다
- 루틴 복구 CTA도 같은 정책을 따른다. 놓친 기존 루틴은 수정 흐름으로, 기록 기반 빈 시간대는 새 루틴 생성 흐름으로 이어진다
- 주간 코칭은 놓친 기존 루틴 수정, 빈 시간대 새 루틴 생성, 목표 부족/초과 시 목표 조정, 추천 없음 상태의 유지 안내 중 하나 이상을 보여준다
- 사용자가 성취와 부족분을 모두 읽을 수 있어야 한다

## Comeback Experiment (#323)

### Scope And Eligibility

[이슈 #323](https://github.com/gaeng2y/Mulimi/issues/323)의 검증용 구현이다. 일반 빌드에는 노출하지 않으며, 실험 성공이나 정식 출시를 뜻하지 않는다.

- 공백은 **마지막 양수 수분 기록일과 복귀일 사이의 완전히 비어 있는 날짜 수**다. 예를 들어 9월 1일 마지막 기록 후 9월 4일 복귀는 2일 공백이다. 목표 미달이나 끊어진 목표 달성 streak로 판정하지 않는다.
- `HydrationProgress`가 HealthKit의 최근 7일과 오늘을 조회한다. 2~6일 공백, 오늘 기록 0, 기본 한 잔을 기록할 목표 여유가 있을 때만 후보가 된다. 월/주 경계도 조회하며, 기록 이력 없음·오늘 기록 있음·1일 이하·7일 이상 공백은 제외한다. 기존 이력 정책대로 다른 앱/건강 앱의 양수 기록도 기록일로 센다.
- 날짜 경계는 기기의 현재 Calendar/시간대다. KST 지표와 비교하는 이번 모집은 `Asia/Seoul` 기기로 한정하고 관찰 중 시간대 변경은 별도 이탈로 남긴다.
- 활성 앱의 루트 진입에서 후보를 확인한다. 두 군 모두 메인 기록 탭으로 이동하되, 이미 열린 전역 push/딥 링크를 닫거나 덮지 않는다. 그 화면에서 루트로 돌아온 경우에 판정한다.
- 실험군은 기존 상단 다음 한 잔 안내를 “오늘 한 번으로 다시 시작” 카드로 바꾼다. 안내가 가리키는 기존 하단 한 잔 버튼이 CTA다. 새 기록 버튼·챌린지·배지·점수·알림 스케줄은 만들지 않는다.
- 화면 노출, 닫기, 앱 백그라운드/화면 이탈 후 같은 공백을 다시 보여주지 않는다. 저장 실패는 기존 오류 안내를 유지하고 같은 화면에서 재시도할 수 있다. 저장 성공 시 기존 안내로 돌아간다.
- 노출 처리 시각 하나만 `HydrationComebackRepository`의 로컬 UserDefaults에 저장한다. 건강 샘플이나 기록 원장은 저장하지 않는다. Domain은 공백 계산, Data는 처리 시각 저장, Presentation은 카드/측정 상태, ContentView는 루트 탭 전환을 맡는다.
- `ponytail:` 재설치·다른 기기·건강 기록의 사후 수정까지 동일 공백을 식별하지는 않는다. 이번 실험은 기기 고정·재설치 제외로 운영한다. 정식 다기기 실험이 필요할 때만 별도 노출 정책을 설계한다.

### Build Variants

같은 커밋으로 아래 두 Release 빌드를 만들고 서로 다른 build number를 부여한다. 프로젝트 설정의 영구 기본값은 바꾸지 않는다. 두 플래그를 동시에 넣으면 컴파일 오류가 난다.

```sh
# 비교군: 기존 안내 유지 + 같은 eligibility 이벤트
xcodebuild build -workspace Mulimi.xcworkspace -scheme Mulimi -configuration Release \
  -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
  SWIFT_ACTIVE_COMPILATION_CONDITIONS='$(inherited) MULIMI_COMEBACK_BASELINE'

# 실험군: 같은 대상 판정 + 컴백 카드
xcodebuild build -workspace Mulimi.xcworkspace -scheme Mulimi -configuration Release \
  -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
  SWIFT_ACTIVE_COMPILATION_CONDITIONS='$(inherited) MULIMI_COMEBACK_EXPERIMENT'
```

서명 없는 로컬 빌드는 컴파일 검증용이다. TestFlight 배포는 운영자가 정상 서명/archive 절차로 별도 진행한다. 어느 플래그도 없으면 기존 동작이며 컴백 이벤트도 없다. PostHog 설정이 없으면 기존 NoOp 분석 구현이므로 측정 빌드로 사용하지 않는다.

### Measurement Protocol

1. 모집 전에 두 군의 빌드 번호, 동시 관찰 기간, 참여 조건을 고정한다. 기존 사용자를 두 빌드에 무작위 배정하고 같은 설치 안내를 제공한다. 다른 전환 실험 플래그는 끈다. 군 변경/재설치는 별도 이탈로 기록한다.
2. 각 군의 첫 `hydration_comeback_eligible`을 코호트 진입으로 삼는다. 사용자별 첫 복귀만 주 분석에 사용한다. 14일 모집 후 유효 표본이 각 군 30명 미만이면 최대 28일까지 연장하고, 마지막 진입자의 D7까지 기다린다.
3. 즉시 기록률은 `eligible` 이후 같은 `distinct_id`와 SDK `$session_id`에서 `water_logged`가 발생한 사용자 / eligible 사용자다. 실험군의 `viewed` 대비 성공률과 CTA 시도 대비 `record_result.success`도 별도로 낸다. raw 이벤트 수를 사용자 전환율로 쓰지 않는다.
4. D0는 복귀일이다. D1~D7의 완전한 KST 날짜에 양수 HealthKit 기록이 있는 고유 날짜 수(0~7), 그중 하루 이상 기록한 비율을 비교한다. 각 군에서 같은 동의·확인 절차로 기기 내 이력을 확인한다. 오늘 기록·목표 달성일을 대신 사용하지 않는다.
5. iPhone `water_logged` 집계는 보조 지표다. Widget/Watch/타 앱 HealthKit 기록을 모두 추적한다고 가정하지 않는다. D7의 기기 내 기록 확인이 없으면 0일이 아니라 결측이며, 성숙·확인 표본과 결측률을 군별로 보고한다.
6. 참여자별 연구 코드는 연구 기록표 안에서만 쓴다. PostHog 사용자 ID/Apple ID/HealthKit 샘플 ID/건강 원본을 기록표로 복사하거나 외부 서비스끼리 사용자 단위 결합하지 않는다. 제품 이벤트 결과와 기기 확인 결과는 각각 집계 수준으로 비교한다.
7. 닫기율(`dismissed / viewed`), 새 공백에서 다시 본 인원/횟수, 같은 공백의 잘못된 재노출 사례, 반복 문구에 대한 불편 응답을 기록한다. 탭 이동이나 백그라운드를 명시적 거절로 세지 않는다.

결과표에는 군별 eligible 사용자 수, 즉시 성공 사용자 수/비율, 상대 상승률, CTA 시도/성공/실패 수, D7 성숙·확인·결측 수, D1~D7 기록일 평균/중앙값, 7일 재활성률, 닫기율, 반복 노출 불편 응답을 남긴다. 상대 상승률은 `(실험군 즉시 기록률 / 비교군 즉시 기록률 - 1)`이며 비교군 기록률이 0이면 산출하지 않는다. 비율·군 차이의 신뢰구간도 함께 보고하고 작은 표본의 점 추정만으로 성공을 단정하지 않는다.

### QA And Decision

- 실기기에서 이력 없음, 1/2/6/7일 공백, 오늘 타 출처 기록, 월 경계, 권한 거부, 목표 미설정을 확인한다. 건강 기록을 조작하는 테스트는 본인 운영 건강 데이터 대신 분리한 QA 기기에서만 수행한다.
- 비교군의 기존 카드, 실험군 문구와 하단 CTA, VoiceOver 닫기 버튼, 큰 글씨/작은 화면의 스크롤, 저장 성공/실패/빠른 중복 탭을 확인한다.
- 닫기 후 재진입, 백그라운드 복귀, 앱 종료 후 재시작에는 같은 공백의 두 번째 `viewed`가 없어야 한다. 새 기록 후 새 공백에서는 다시 후보가 되어야 한다. 다른 탭에서의 복귀와 전역 push 상태도 확인한다.
- 성공 후보: 즉시 기록률 상대 15% 이상 상승, D1~D7 기록일과 재활성률이 모두 악화되지 않으며 거부감/저장 가드레일을 통과한다. 허용 악화폭은 0으로 두고 불확실성이 남으면 비열등성이 확인됐다고 보고하지 않는다. 측정 근거를 리뷰한 뒤에만 후속 구현 이슈를 만든다.
- 개선 후 재실험: 즉시 기록은 늘지만 7일 유지 개선이 없다. 즉시 지표만으로 정식 도입하지 않는다.
- 중단: 충분한 성숙 표본에서도 기록률 개선이 없거나 저장/반복 노출 문제가 확인된다.
- 보류: 군별 유효 표본 30명 미만, D7 미성숙, 결측/군 간 측정 차이, 비교군 기록률 0 또는 불확실한 비열등성.

로컬 검증(2026-09-08): Xcode 26.6 (17F113), Tuist 4.205.0, iPhone 17 Pro / iOS 26.5 Simulator에서 lint·architecture 검사, 프로젝트 생성, Hydration Domain 61개·Data 3개·Presentation 80개 테스트와 기본 앱 및 두 실험군 Release 빌드를 통과했다. Swift Testing 매개변수 실행 수는 이 테스트 선언 수와 별개다.

현재 상태: **실기기 QA·배포·모집·즉시 기록률·7일 재활성·거부감은 미검증/미측정이며 판정은 보류**다. 이슈 완료 조건은 코드 PR만으로 충족되지 않는다.

## Related Docs

- `Docs/challenge-state-model.md`
- `Docs/personalized-challenge-strategy.md`
- `Docs/product-specs/analytics-events.md`
- `Docs/product-specs/growth-scorecard.md`

## Related Code

- `Project/Features/Challenge/Presentation/Sources/View/ChallengeView.swift`
- `Project/Features/Hydration/Presentation/Sources/View/HydrationInsight/HydrationInsightView.swift`
- `Project/Features/Challenge/Presentation/Sources/ViewModel/ChallengeViewModel.swift`
- `Project/Features/Hydration/Presentation/Sources/ViewModel/HydrationInsightViewModel.swift`
- `Project/Features/Hydration/Presentation/Sources/ViewModel/DrinkWaterViewModel.swift`
- `Project/Features/Hydration/Domain/Sources/Entity/HydrationProgressSnapshot.swift`
- `Project/Features/Hydration/Data/Sources/Repository/HydrationComebackRepositoryImpl.swift`
- `Project/App/Navigation/Sources/AppRoute.swift`
- `Project/Features/Routine/Domain/Sources/Entity/RoutineActionIntent.swift`
- `Project/Features/Routine/Domain/Sources/UseCase/HydrationRoutineAdherenceUseCaseImpl.swift`
- `Project/Features/Routine/Domain/Sources/Entity/HydrationRoutineAdherenceInsight.swift`
