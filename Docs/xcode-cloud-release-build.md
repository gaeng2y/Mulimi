# Xcode Cloud: Release Build Only Setup

이 문서는 `#15` 이슈 범위를 "Release Build"로 한정해서 설정하는 절차입니다.
`PR-UnitTests` 워크플로는 만들지 않습니다.

## 1) 저장소 준비
- 커스텀 스크립트 경로를 Xcode Cloud 표준인 `ci_scripts/`로 사용
- 현재 스크립트: `ci_scripts/ci_post_clone.sh`
- 스크립트에서 수행:
  - `mise` 설치/활성화
  - `tuist install`
  - `tuist generate`

## 2) Xcode Cloud 워크플로 생성
Xcode > Report navigator > Cloud 또는 App Store Connect > Xcode Cloud에서 워크플로 생성:

1. Workflow name: `Release-Build`
2. Start Condition (권장):
   - `Tag changes` with pattern: `v*`
3. Action:
   - `Archive`
4. Scheme:
   - `Mulimi`
5. Configuration:
   - `Release`
6. Destination:
   - iOS

참고: 태그 기반으로 두면 의도된 릴리즈 시점에만 아카이브가 실행됩니다.

## 3) (선택) 배포 연동
필요하면 같은 워크플로에 배포 단계를 추가:
- TestFlight distribute
- 또는 아카이브 산출물만 유지

## 4) 운영 방식
- 릴리즈 빌드 트리거:
  - `git tag v1.0.0`
  - `git push origin v1.0.0`
- 빌드 결과는 Xcode Cloud 대시보드에서 확인

## 5) 현재 범위
- 포함: Release Archive 자동화
- 제외: PR 생성 시 유닛 테스트 게이팅
