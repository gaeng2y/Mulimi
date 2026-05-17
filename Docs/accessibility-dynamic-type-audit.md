# Accessibility And Dynamic Type Audit

Issue: #214

Mulimi 핵심 사용자 흐름의 VoiceOver, Dynamic Type, Reduce Motion 대응 상태를 점검한 기록이다. 접근성 메타데이터는 View 레이어에서만 다루고, 도메인 규칙과 시스템 연동 경계는 바꾸지 않는다.

## Audit Scope

| Flow | Result | Notes |
| --- | --- | --- |
| Home record | Fixed | 목표 진행률을 하나의 의미 있는 접근성 값으로 읽고, 기본 기록/프리셋/직접 입력/되돌리기 버튼에 목적과 결과를 설명하는 label/hint를 추가했다. |
| Onboarding and HealthKit gate | Fixed | 단계 진행 상태, 권한 요청, 설정 이동, 권한 재확인 액션이 VoiceOver에서 구분되도록 보강했다. 장식 아이콘은 숨겼다. |
| History calendar and delete | Fixed | 기간 요약 metric, 캘린더 날짜, 삭제/삭제 불가 상태가 날짜/용량/진행률 또는 출처 맥락을 포함해 읽히도록 정리했다. |
| Insight and challenge CTA | Fixed | 인사이트 카드 CTA, 루틴 복구 액션, 개인화 챌린지 루틴 CTA에 실행 결과를 설명하는 hint를 추가했다. |
| Profile and settings risk action | Fixed | 회원 탈퇴 화면을 ScrollView로 전환해 큰 글자에서 주요 경고와 버튼이 접근 가능하게 하고, 위험 액션 hint를 추가했다. |
| Dynamic Type | Fixed | 접근성 크기에서 홈 주요 버튼, 온보딩 footer, 기록 요약 grid, 루틴 복구 액션을 세로 배치로 전환한다. segmented control은 최소 높이와 2줄 title을 허용한다. |
| Reduce Motion and Transparency | Fixed | 물방울 반복 애니메이션, 온보딩 페이지 전환, segmented control 선택 애니메이션은 Reduce Motion 설정을 따른다. segmented control은 기존 Reduce Transparency 분기를 유지한다. |

## Priority Fixes

### P0

- 홈 핵심 기록 버튼, HealthKit 권한 CTA, 기록 삭제 버튼, 회원 탈퇴 위험 액션에 VoiceOver label/hint를 추가했다.
- 장식용 큰 아이콘과 물방울 시각화는 접근성 트리에서 제외했다.
- 기록 캘린더 날짜와 기록 행은 시각 정보만으로 전달되던 날짜/용량/진행률/삭제 가능 여부를 텍스트로 노출한다.

### P1

- Accessibility Dynamic Type 크기에서 주요 CTA 묶음이 가로 폭을 압박하지 않도록 세로 배치로 전환했다.
- 고정 높이 버튼을 최소 높이로 바꿔 큰 글자에서 잘림 가능성을 낮췄다.
- Reduce Motion 사용자는 반복/전환 애니메이션 없이 같은 기능을 사용할 수 있다.

## Manual QA Checklist

- Accessibility Inspector로 Home, Onboarding, HealthKit gate, History, Insight, Challenge, Settings 흐름의 label/hint 순서를 확인한다.
- VoiceOver를 켠 상태에서 기본 수분 기록, 프리셋 기록, HealthKit 권한 요청, 기록 삭제, 루틴 CTA, 회원 탈퇴 확인 대화상자 진입을 수행한다.
- Dynamic Type `Accessibility 3` 이상에서 홈 CTA, 기록 요약, segmented control, 온보딩 footer, 회원 탈퇴 화면의 잘림 여부를 확인한다.
- Reduce Motion과 Reduce Transparency를 각각 켜고 물방울 애니메이션, 페이지 전환, segmented control 선택 표시가 설정을 따르는지 확인한다.

## Follow-Up Rule

수동 QA에서 새 결함이 발견되면 별도 P0/P1 이슈로 분리한다. 코드 수정이 아닌 운영성 수동 검증만 필요한 항목은 이 문서의 체크리스트를 기준으로 PR 검증 기록에 남긴다.
