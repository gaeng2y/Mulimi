# Challenge State Model

## 목적
- 반복형 챌린지와 누적형 챌린지의 상태 규칙을 분리한다.
- 앱 재실행 후에도 챌린지 완료 상태가 같은 기준으로 복원되도록 한다.

## 상태 타입

### 반복형
- 대상: `streak7`, `weeklyAchievement80`
- 저장 모델: `HydrationRecurringChallengeState`
- 특징:
  - 현재 주기 안에서만 완료 상태를 유지한다.
  - 주기가 바뀌면 이전 완료 상태는 이어지지 않는다.
  - `achievedAt`도 같은 주기 안에서만 유지된다.

### 누적형
- 대상: `goalAchievement30`
- 저장 모델: `HydrationCumulativeChallengeState`
- 특징:
  - 누적 진행도를 기준으로 완료 여부를 계산한다.
  - 한 번 완료되면 이후 진행도가 바뀌어도 완료 상태를 유지한다.
  - `achievedAt`은 최초 완료 시점을 유지한다.

## 리셋 정책

### `streak7`
- 상태 타입: 반복형
- 리셋 정책: `streakBreak`
- 주기 식별자:
  - 현재 streak의 시작일 기준으로 계산한다.
  - streak가 끊기거나 새 streak가 시작되면 다른 주기로 취급한다.

### `weeklyAchievement80`
- 상태 타입: 반복형
- 리셋 정책: `weekly`
- 주기 식별자:
  - `Calendar.weekOfYear`의 시작일 기준으로 계산한다.
  - 새로운 주가 시작되면 완료 상태를 초기화한다.

### `goalAchievement30`
- 상태 타입: 누적형
- 리셋 정책: `never`
- 주기 식별자 없음

## 계산 및 갱신 시점
- `ChallengeUseCase.fetchChallenges(referenceDate:calendar:)` 호출 시 매번 재계산한다.
- 계산 순서:
  1. 진행 스냅샷과 누적 달성 횟수를 조회한다.
  2. 챌린지별 현재 진행 상태를 계산한다.
  3. 저장된 상태와 현재 주기를 비교해 merge 한다.
  4. merge 결과를 다시 저장한다.

## 복원 규칙
- 반복형:
  - 저장된 상태의 주기 식별자가 현재 주기와 같을 때만 완료 상태를 복원한다.
  - 주기가 다르면 새 주기의 진행 상태로 덮어쓴다.
- 누적형:
  - 저장된 완료 상태와 `achievedAt`을 우선 복원한다.
  - 현재 계산값이 더 높아져도 최초 완료 시점은 유지한다.

## 레거시 데이터 처리
- 기존 `HydrationChallengeState` 단일 모델은 새 모델로 마이그레이션한다.
- 반복형 레거시 상태는 주기 정보가 없으므로 완료 상태를 보수적으로 초기화한다.
- 누적형 레거시 상태는 완료 상태와 `achievedAt`을 유지한다.
