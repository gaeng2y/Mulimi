# architecture-boundary

## When to use

- 레이어 이동
- 새 `UseCase`, `Repository`, `DataSource` 추가
- ViewModel 책임 분리
- 아키텍처 리뷰

## Goal

Mulimi의 `Clean Architecture + MVVM` 경계를 유지한다.

## Rules

- `Domain`은 UI와 로컬라이제이션에 의존하지 않는다.
- `Presentation`은 상태와 화면 조합을 담당한다.
- `Data`는 외부 시스템과 저장소 연동을 담당한다.
- `App`은 루트 조립과 타깃 정의를 담당한다.
- `Widget`과 `Watch`는 앱과 다른 도메인 규칙을 만들지 않는다.
- 기능 수직 모듈은 `Project/Features/<Feature>/{Domain,Data,Presentation}`에 둔다.
- 기능 `Presentation`과 `Data`는 자신의 기능 `Domain`을 향해 안쪽으로 의존하고, 기능 간 의존은 명시적인 Domain 또는 공용 Presentation 타깃으로 연결한다.

## Guardrails

- 디자인 시스템: `App·Presentation -> MulimiUISystem -> DesignSystemFoundation`. 두 UI 모듈의 기능/현지화 역참조와 Domain UI 의존은 금지한다. import와 manifest 선언은 `check-ui-boundaries.py`가 검사한다.
- `Project/Features/*/Domain`에서 `SwiftUI`, `UIKit`, `WidgetKit`, `Localization`, `Data`, `Presentation` import 금지
- `Project/Features/*/Presentation`의 ViewModel에서 시스템 side-effect API 직접 접근 금지
- ViewModel 간 직접 타입 참조 금지
- 전역 push는 `ContentView + AppCoordinator`
- `250ml = 1잔`은 `HydrationServing`

## Checklist

1. 이 변경이 어느 레이어 책임인지 먼저 정한다.
2. 인터페이스는 `Domain`, 구현은 `Data`, 표현은 `Presentation`에 둔다.
3. 루트 상태가 필요하면 `AppSession`, 루트 내비게이션이 필요하면 `AppCoordinator`를 본다.
4. `make arch-check`로 구조 위반 여부를 확인한다.

## Validation

```bash
make arch-check
```

## 변경 영향 분석 (blast-radius)

변경 전과 리뷰에서 사용한다. 조사·리뷰 요청만 받았다면 수정 없이 결과를 보고한다.

1. 요청 범위와 diff에서 바뀌는 동작을 정한다. 실제 호출자, 테스트, fixture, 설정, 공개 API와 `Project.swift`를 확인한다. Graphify 조회는 `AGENTS.md` 절차를 따르고 현재 코드로 대조한다.
2. 심볼 참조 밖의 계약도 추적한다. HealthKit 샘플 소유권·조회/쓰기 순서, App Group 키·iCloud 미러, 저장된 JSON, 날짜 경계, AppIntent, Widget, Watch의 공유 소스·별도 컴파일이 해당한다. 변경과 관련된 항목만 조사한다.
3. 안전하다고 판단하는 핵심 전제와 깨졌을 때의 사용자 영향을 적는다. 예: 되돌리기가 다른 앱의 기록을 지우지 않는다는 전제는 삭제 대상 UUID와 소유권 조건에 달려 있다. 파일 위치만으로 실행 결과를 단정하지 않는다.
4. 전제를 확인할 가장 작은 기존 테스트·실행 경로를 사용한다. 새 결함은 재현 증거와 함께 보고하고, 수정까지 요청된 작업에서만 [버그 재현·수정 검증](../quality-gates.md#버그-재현과-수정-검증)을 진행한다. 실행할 수 없는 항목은 미검증으로 남긴다.
5. 영향받는 소비자·데이터, 확인한 전제와 증거, 확인된 결함, 해소한 우려, 남은 미검증 항목을 보고한다. 추측을 확정된 버그로 보고하거나 검색 결과가 없다는 이유로 안전하다고 판단하지 않는다.

## 구현 전 설계 (architect)

새 인터페이스, 모듈 간 계약, 상태 소유권, 저장·동시성 정책 또는 레이어 경계를 바꿀 때 사용한다. 기존 계약 안의 작은 수정은 기존 구조를 재사용한다. 설계만 요청받았다면 설계 결과까지 수행한다.

1. 관련 제품 스펙, 현재 호출 코드, `Project.swift`, 기존 경계의 이유를 확인한다. 위 변경 영향 분석으로 수정이 닿는 범위를 정한다.
2. 호출자가 사용할 코드와 관찰 가능한 성공·실패 동작부터 적는다. 그에 필요한 최소 타입·함수 시그니처, 상태와 side effect의 소유 레이어, DI 연결을 정한다. `ARCHITECTURE.md`의 경계와 source of truth를 유지한다.
3. 기존 구현을 재사용하는 안을 먼저 검토한다. 실제 선택지가 있으면 가장 유력한 대안과 복잡도·호환성·검증 비용을 비교하고 선택 이유를 남긴다. 후보 수를 채우려고 설계를 늘리지 않는다.
4. 호출자·테스트·fixture·설정·문서의 변경 목록과 검증 방법을 정한다. 스케치만으로 동작이 증명됐다고 보고하지 않고, 검증이 필요한 전제를 표시한다.
5. 구현까지 요청된 작업은 선택한 설계를 최소 변경으로 구현한다. 같은 종류의 우회가 반복되면 경계를 다시 검토한다. 미구현 stub을 완료 결과로 남기지 않으며 오류 처리·검증을 보존한다.

변경 후 [품질 게이트](../quality-gates.md)의 해당 검증을 수행한다. 타깃·의존성·소스 공유가 바뀌면 구조 문서와 구조도를 함께 갱신한다.
