# #350 HealthKit 조회 실패 복구

## 목적

조회 실패를 정상 0ml·기록 없음으로 바꾸지 않고, 저장 후 조회 실패는 조회만 재시도한다.

## 작업 순서

- [x] Data → Domain 조회 계약을 throws로 변경하고 모든 소비자와 테스트 대역을 갱신한다.
- [x] 앱·Watch의 실패 안내, 기간별 이전 상태 보존, 조회 재시도를 연결한다.
- [x] Widget·코칭·챌린지·스타터·리뷰 요청이 실패값으로 결과를 확정하지 않게 한다.
- [x] 오류 주입 테스트, lint·아키텍처 검사, iOS·Watch 빌드를 수행한다.
- [x] 제품 문서·격리 Graphify 산출물과 gitmoji 커밋·develop 대상 PR 본문을 준비한다.

## 경계

- 읽기 권한 거부와 정상 빈 결과는 HealthKit이 구분해 주지 않는다. 실제 API 오류만 전달한다.
- 이전 데이터는 화면 메모리에만 보관한다. 날짜·조회 기간이 달라지면 재사용하지 않는다.
- 원본 작업 폴더의 #349 미커밋 변경은 그대로 두고 별도 worktree에서 작업한다.
- PR #347·#348은 미병합 상태이므로 develop 기준으로 구현하고 겹치는 파일을 PR에 명시한다.

## 검증 기록

검증 환경: Xcode 27.0 (27A266a), Tuist 4.205.0, iPhone 17e / iOS 26.5, Apple Watch SE 3 40mm / watchOS 26.5.

| 검증 | 결과 |
| --- | --- |
| `git diff --check`, `make lint`, `make arch-check` | 통과, lint 317개 파일 위반 0 |
| `tuist generate --no-open` | 통과 |
| Hydration Domain / Data / Presentation | 67 / 7 / 101개 통과 |
| Routine Domain / Presentation | 13 / 18개 통과 |
| Challenge Domain / Presentation | 10 / 6개 통과 |
| WatchHydrationTests | 6개 통과 |
| Mulimi Release, generic/platform=iOS | 서명 없는 전체 앱·Widget·Watch 빌드 통과 |
| MulimiWatch, generic/platform=watchOS Simulator | 서명 없는 빌드 통과 |
| 구조도 | showcase 9/9, 오류·경고 0, 4개 화면 크기의 containment 및 라이트/다크 캡처 4장 직접 확인 |

- 테스트 중 조회 계약 전환으로 드러난 누락된 `try`와 Mock의 `return`을 수정했다. 기간 실패 테스트는 실제 선택 월을 고정한 뒤 재실행해 통과했다.
- 최종 코드에서 캡처용 호스트·테스트를 제거했다. [화면 캡처와 재현 조건](../../product-specs/assets/issue-350/README.md)을 참고한다.
- 빌드에는 AppIntents metadata 대상 제외, AccentColor 미지정, PostHog dSYM 업로드 자격 정보 미설정, SSU artifact archive 진단이 남는다. Xcode 전체 빌드 결과는 성공이다. 실기기 서명·설치·잠금/읽기 권한 동작과 Siri/잠금 화면 Widget 실사용은 미실행했다.
- PR 자동화와 Xcode Cloud 결과는 PR 본문에서 로컬 검증과 분리해 기록한다. 병합 전까지 이 계획을 active에 둔다.

## 추가 검증의 제한

- `DependencyInjectionPreview` 전체 빌드는 기존 `DIContainer`의 Production Assembly 소스 미포함, PreviewAssembly의 MainActor 호출, MockHealthKitUseCase의 오래된 인자명 때문에 실패했다. 해당 파일과 DI manifest는 기준 커밋과 동일하다.
- `DependencyInjectionTesting`은 생성된 워크스페이스에 스킴이 없어 전체 빌드를 실행하지 못했다.
- 값을 반환하는 Preview/Testing Mock은 기존의 nonthrowing 구현으로 throwing 프로토콜을 만족하므로 불필요한 변경을 제거했다. 실제 오류 주입은 Feature TestSupport Mock에서 수행한다.
- Preview 7개·Testing 7개 조회 Mock은 iOS Simulator SDK의 Swift 6 `swiftc -typecheck`로 throwing 프로토콜 호환성 확인을 통과했다.
- 격리된 `GRAPHIFY_OUT`의 AST 갱신 후 공유 그래프에서 `graphify-out/` 출처 노드와 세션 학습 섹션이 없음을 확인했다. 문서 의미 재분석은 수행하지 않았다.
