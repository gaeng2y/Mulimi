---
name: mulimi-blast-radius
description: Mulimi 변경의 호출자·데이터 계약·앱·Widget·Watch 영향을 추적하고 핵심 안전 전제를 실행 증거로 확인한다. 변경 전 영향 분석이나 diff 리뷰 시 사용한다.
---

# Mulimi 변경 영향 분석

[AGENTS.md](../../../AGENTS.md)를 먼저 따르고 [변경 영향 분석 절차](../../../Docs/skills/architecture-boundary.md#변경-영향-분석-blast-radius)를 수행한다.

실제 호출자와 `Project.swift`를 확인하고 저장 계약·공유 소스까지 추적한다. 관련 없는 영역으로 조사를 넓히지 않는다. 증거 수준과 미검증 표시는 [품질 게이트](../../../Docs/quality-gates.md#검증-증거)를 따른다.

영향받는 소비자·데이터, 안전성의 핵심 전제와 실행 결과, 확인된 결함과 남은 미검증을 보고한다. 조사·리뷰만 요청받았다면 제품 코드를 변경하지 않는다.
