# Personalized Challenge Strategy

## Goal
- Keep the fixed challenge set as the long-lived achievement layer.
- Add lightweight personalized recommendations that reflect the user's current routine and recent hydration pattern.

## Information Architecture
- `추천 챌린지`
  - non-persistent, recommendation-oriented cards
  - show source, tier, recommendation reason, and next action
- `진행 중 챌린지`
  - fixed achievement challenges with progress tracking
- `획득한 챌린지`
  - completed fixed challenges

## Implemented Recommendation Candidates
1. `routineAnchor`
- Source: enabled routine
- Rule: pick the most frequent enabled routine, then the earliest one
- Purpose: attach hydration to an existing cue

2. `morningKickstart`
- Source: recent records
- Rule: if morning first-drink count in the last 14 days is below 5, recommend improving morning hydration
- Purpose: move the first hydration earlier in the day

3. `dailyGoalBooster`
- Source: recent records
- Rule: if monthly average intake is below the daily goal and morning habit is not the main gap, recommend raising the average by one 250ml step
- Purpose: make daily goal progress feel reachable

4. `consistencyDefender`
- Source: recent records
- Rule: if the user is already close to or above the goal, recommend preserving the current weekly pace
- Purpose: keep momentum instead of only chasing deficit recovery

## Tier Rules
- `beginner`
  - obvious habit gap exists
  - recommendation should be low-friction and easy to start
- `steady`
  - baseline habit exists
  - recommendation should strengthen consistency
- `stretch`
  - current pace is already healthy
  - recommendation should preserve or slightly extend the pace

## Next Expansion
- Add more personalized candidates around time-of-day gaps, weekday gaps, and routine completion history
- Connect personalized recommendations to badge history once `#139` is introduced
- If recommendation quality grows, split the recommendation engine into its own policy/service layer
