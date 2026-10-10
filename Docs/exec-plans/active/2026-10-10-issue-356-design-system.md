# #356 디자인 시스템 계층 분리

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
