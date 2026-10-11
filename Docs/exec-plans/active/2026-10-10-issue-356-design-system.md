# #356 디자인 시스템 계층 분리

상태: 구현·로컬 검증 완료, develop 대상 PR 리뷰 준비. 머지 후 completed로 이동한다.

## Context

- 이슈: https://github.com/gaeng2y/Mulimi/issues/356
- `origin/develop@930e5bc` 기준. 기존 DesignSystem의 네 화면 소비자를 두 UI 계층으로 이관한다.

## Goal

- 소비자는 MulimiUISystem을 사용하고, MulimiUISystem만 DesignSystemFoundation을 의존한다.
- 색상 번들, 선택 상태, 물방울 효과와 접근성 동작을 유지한다.

## Constraints

- 초기 플랫폼은 iOS 26 이상. Watch/Widget 포팅과 기능 로직 변경은 범위 밖이다.
- Foundation은 SwiftUI를 사용해도 되지만 제품/기능/현지화에 의존하지 않는다.
- 기존 그래프 변경 4개는 저장소 밖 임시 디렉터리에 백업하고 최종 공유 그래프를 격리 갱신한다.

## Plan

1. 사용 중인 기본 값과 장식 원시 요소를 Foundation으로 옮긴다.
2. Mulimi 테마·컴포넌트·리소스를 UISystem으로 옮기고 소비자를 전환한다.
3. import/manifest 경계 검사와 회귀 테스트를 추가한다.
4. 관련 테스트, 빌드와 접근성을 확인한다.
5. 구조 문서·구조도·그래프를 갱신하고 gitmoji 커밋과 develop 대상 PR을 만든다.

## Decisions

- 색상 리소스는 framework 번들을 명시해 로드한다. 기존 Color.accent/background API도 유지한다.
- 기존 선택 컴포넌트의 Color.accentColor는 호스트 tint를 계속 따른다.
- `bubble.json`은 전체 저장소의 소스/manifest 조회에서 소비자가 없어 제거한다.
- 실제 사용 값만 토큰으로 제공한다. 현재 모서리는 Capsule이므로 임의의 radius 토큰을 추가하지 않는다.

## Validation

- `git diff --check`, `make lint`, `make arch-check`, 경계 검사 회귀 테스트
- `tuist generate --no-open`, MulimiUISystem 및 Hydration/Challenge 테스트, Mulimi 앱 빌드
- 리소스 light/dark 로드, 큰 글씨·Reduce Motion/Transparency·선택 접근성 검증
- archify showcase validate/deliver/visual-check 및 네 캡처 직접 확인
- 격리 Graphify AST 갱신

## Rollback

- 두 framework와 소비자 의존성, 문서·생성물을 같은 변경 단위로 되돌린다. 저장 데이터 마이그레이션은 없다.

## Completion Notes

- lint 328개 파일 위반 0, arch-check, 경계 검사 fixture 7개, tuist generate 통과.
- iPhone 17e / iOS 26.5: MulimiUISystem 5개 테스트(매개변수 포함 9건), Hydration Domain 67·Data 7·Presentation 104, Challenge Domain 10·Data 3·Presentation 6개 통과.
- Xcode 27.0 (27A266a), Tuist 4.205.0. 워치·위젯을 포함한 Mulimi 서명 없는 iOS Debug 빌드 성공.
- 기존 Foundation Models deprecated API, 테스트 unused result, AppIntents metadata 생략 메시지가 있다. 앱 빌드는 `Could not archive SSU artifacts` 메시지를 출력했지만 종료 코드 0 / BUILD SUCCEEDED다.
- 새 색상 테스트는 UIColor의 색 공간 객체 동일성 대신 RGBA 값으로 비교한다. 접근성 시스템 환경 값은 읽기 전용이므로 테스트에서 강제로 쓰지 않는다.
- 구조도 소스 참조는 실제 코드 커밋이 필요해 코드 커밋 후 생성물을 별도 커밋한다.


## UI 비교 결과

- iPhone 17e / iOS 27.0의 별도 QA 앱에서 기준 커밋 `930e5bc`의 원본 컴포넌트와 새 framework 컴포넌트를 같은 호스트에 렌더링했다.
- XCUITest 2개 통과: 선택 trait의 초기 상태·탭 후 이동과 Binding 값, 네 환경에서의 최소 높이를 검증했다.
- 라이트/다크 × 기본/접근성 최대 크기 네 조건의 **전체 캡처 RGB 픽셀이 동일**했다. 물방울 반사 효과도 같은 캡처에 포함된다.
- 최대 크기에서 세 칸에 긴 라벨을 넣으면 일부 글자가 줄임표로 표시되는 기존 제한이 양쪽에서 동일하다. 이 작업은 기존 표현을 보존하며 레이아웃 변경은 포함하지 않는다. 전체 라벨과 선택 상태의 접근성 정보는 유지된다.
- [기본 라이트: 이전](../../validation/issue-356/before-light.png) / [이후](../../validation/issue-356/after-light.png)
- [기본 다크: 이전](../../validation/issue-356/before-dark.png) / [이후](../../validation/issue-356/after-dark.png)
- [최대 글씨 라이트: 이전](../../validation/issue-356/before-large-light.png) / [이후](../../validation/issue-356/after-large-light.png)
- [최대 글씨 다크: 이전](../../validation/issue-356/before-large-dark.png) / [이후](../../validation/issue-356/after-large-dark.png)
- QA fixture는 저장소 밖 `/private/tmp/mulimi-356-qa`, 결과는 `/private/tmp/mulimi-356-qa-results.xcresult`에 보관했다. 제품 테스트 타깃이나 CI에 QA 앱을 추가하지 않았다.
- 구조도는 코드 커밋 `6fd6b9f` 기준 소스 33개를 검증했다. showcase 9/9, 오류/경고 0, 네 해상도의 넘침 없음, 작은·큰 화면의 라이트/다크 캡처 네 장 직접 확인 완료.

- Graphify는 격리된 출력 경로에서 AST만 갱신했다. 4,204개 노드·11,186개 간선·192개 커뮤니티이며, 생성물 출처 노드와 세션 학습 섹션이 없다. 문서 의미 재분석은 하지 않았다.

- Reduce Motion/Transparency는 시뮬레이터 접근성 설정을 활성화한 뒤 앱의 두 SwiftUI 환경 값이 모두 `true`인 것을 확인했다. 불투명 배경과 선택 변경을 직접 확인했고 같은 XCUITest 선택/Binding 검증 1개도 통과했다. [설정 활성화 캡처](../../validation/issue-356/reduced-motion-transparency.png). 검증 후 설정은 원래 값으로 복구했다.
- 시뮬레이터 Settings의 스위치 탭이 설정을 바꾸지 않아 `simctl spawn ... defaults`로 테스트 설정을 적용하고, 앱에서 읽은 실제 환경 값으로 반영 여부를 확인했다. 실기기 VoiceOver 음성·HealthKit 권한 검증은 이번 UI 모듈 분리 범위에 포함하지 않았다.
