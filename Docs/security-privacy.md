# Security And Privacy Operations

Mulimi의 보안/개인정보 운영 기준이다. 이 문서는 법률 검토 완료 문서가 아니라 코드 변경과 App Store 제출 전에 확인할 내부 체크리스트다. 최종 개인정보 처리방침, App Store privacy label, 광고/IAP 약관 문구는 별도 법률 검토를 거친다.

## Goals

- HealthKit, Apple Sign In, Firebase, App Group, iCloud KVS의 데이터 경계를 한 곳에서 확인한다.
- 이벤트 파라미터와 로컬 저장소에 넣으면 안 되는 데이터를 명확히 한다.
- AdMob, IAP, 서버 연동을 추가하기 전에 개인정보 영향 검토를 먼저 수행한다.

## Non-Goals

- 개인정보 처리방침 최종 문구 작성
- 서버 보안 아키텍처 설계
- 법률 자문 또는 App Review 통과 보장
- HealthKit 원장을 로컬 저장소로 복원하는 설계

## Data Boundary

| Area | Current Data | Current Store | Rule |
| --- | --- | --- | --- |
| Hydration records | `dietaryWater` 샘플의 날짜/수분량 | HealthKit | 수분 기록의 source of truth다. App Group, SwiftData, Firebase에 원장 형태로 복제하지 않는다. |
| Body profile | HealthKit 키/몸무게 최신값 | HealthKit read-only | 목표 추천과 프로필 표시용으로만 읽는다. 직접 입력 신체 정보 플로우를 되살리지 않는다. |
| Daily goal | `dailyWaterLimit` | iCloud KVS + App Group UserDefaults mirror | 앱/위젯/워치가 같은 목표량을 보기 위한 설정값이다. 인증 정보나 HealthKit 원본을 섞지 않는다. |
| Main icon | `mainIcon` | App Group UserDefaults | 앱/위젯 표시 설정이다. `mainAppearance`는 legacy migration 용도만 유지한다. |
| Onboarding state | `hasCompletedOnboarding` | App Group UserDefaults | 로컬 플로우 상태다. 사용자 식별자와 결합하지 않는다. |
| Routine schedules | `hydrationRoutines` JSON | App Group UserDefaults | 로컬 알림/루틴 표시용이다. Analytics에는 루틴 제목이나 UUID를 보내지 않는다. |
| Challenge badge history | `hydrationChallengeBadgeHistories` JSON | App Group UserDefaults | 로컬 표시용 완료 이력이다. 서버 동기화 대상이 아니다. |
| Apple account credential | Apple user identifier, optional email/name | Keychain | 로그인 상태 판단용이다. identity token, authorization code는 현재 저장하지 않는다. |
| Firebase Analytics | allowlist 이벤트와 파라미터 | Firebase/Google Analytics | 제품 행동 측정만 허용한다. 개인정보, 건강 원본 값, 자유 입력 텍스트는 금지한다. |
| Crashlytics | SDK dependency only | Firebase Crashlytics | 커스텀 key/log를 추가할 때 HealthKit 값, 계정 식별자, 이메일, 루틴 제목을 넣지 않는다. |

## HealthKit

- 앱은 `dietaryWater`를 읽고 쓴다.
- 앱은 `height`, `bodyMass`를 읽는다.
- 수분 기록 삭제는 현재 앱이 만든 HealthKit 샘플만 대상으로 한다.
- HealthKit 권한이 없거나 내부 오류가 있더라도 로컬 수분 원장을 다시 만들지 않는다.
- Widget/AppIntent/Watch도 HealthKit 수분 기록과 `HydrationServing` 규칙을 공유한다.

HealthKit 변경 전 체크:

- 새 HealthKit type을 추가하면 목적, read/write 범위, 권한 문구, App Store privacy label 영향도를 문서화한다.
- HealthKit 값은 Firebase 이벤트 파라미터에 원장, 시계열, 개별 샘플 UUID 형태로 보내지 않는다.
- 신체 정보는 HealthKit 기준이며 App Group/iCloud KVS에 새로 저장하지 않는다.

## Apple Sign In And Account Deletion

현재 Apple Sign In은 `email`, `fullName` scope를 요청하고, 로그인 후 아래 값을 Keychain에 저장한다.

| Keychain Account | Purpose |
| --- | --- |
| `USER-IDENTIFIER` | Apple user identifier |
| `ACCESS-TOKEN` | 현재는 서버 토큰이 없어 Apple user identifier를 임시 로그인 상태 값으로 사용 |
| `REFRESH-TOKEN` | 향후 서버 연동 대비 key, 현재 저장 흐름 없음 |
| `EMAIL` | Apple이 최초 제공한 email이 있을 때 저장 |
| `NICKNAME` | Apple이 최초 제공한 name이 있을 때 저장 |

운영 기준:

- identity token과 authorization code는 현재 저장하지 않는다.
- 서버 인증을 도입하면 Apple identity token은 서버 검증용으로만 전송하고, 클라이언트 장기 저장을 금지한다.
- 로그아웃과 현재 회원 탈퇴 구현은 Keychain 인증 정보를 삭제한다.
- 회원 탈퇴가 서버 계정 삭제를 의미하게 되면 서버 데이터 삭제, Sign in with Apple token revoke, Firebase user association 해제 여부를 함께 설계한다.
- HealthKit 기록 삭제는 Apple account 삭제와 별개의 HealthKit 데이터 작업이다. 제품 문구가 HealthKit 기록 삭제를 약속하면 실제 삭제 범위와 사용자 확인 흐름을 먼저 구현한다.

법률/리뷰 검토 필요:

- 회원 탈퇴 화면 문구가 실제 삭제 범위와 일치하는지
- Apple Sign In token revocation이 필요한 서버 구조인지
- 삭제 요청 후 보관해야 하는 결제/영수증/분쟁 대응 데이터가 있는지

## Firebase Analytics And Crashlytics

Analytics 이벤트 계약은 `Docs/product-specs/analytics-events.md`가 기준이다. Firebase SDK 직접 의존은 앱 초기화와 repository 구현으로 제한한다.

허용:

- `source`, `context`, `status`, `serving_type`, `preset`, `failure_reason`, `action`, `challenge_kind` 같은 enum/string allowlist 값
- `volume_ml`, `daily_goal_ml`, `previous_goal_ml`, `new_goal_ml`, `weekday_count` 같은 제품 행동 이해에 필요한 정수 값
- 실패 사유는 문서화된 enum 값만 사용

금지:

- Apple user identifier, email, name, identity token, authorization code, Keychain 값
- HealthKit 샘플 UUID, 전체 수분 기록 원장, 신체 정보 원본 값, 세부 시계열
- 루틴 제목, 자유 입력 텍스트, 알림 본문, 사용자 메모
- 정확한 위치, 연락처, 사진, 캘린더, 파일 경로
- 기기 식별자, 광고 식별자, fingerprinting 목적 값
- Crashlytics custom key/log에 개인정보나 건강 데이터를 넣는 것

이벤트 추가 전 체크:

1. `Docs/product-specs/analytics-events.md`에 이벤트명과 파라미터를 먼저 추가한다.
2. 새 파라미터가 위 금지 목록에 걸리지 않는지 확인한다.
3. App Store privacy label, Firebase data collection 설정, DebugView QA 항목을 갱신한다.
4. ViewModel 테스트에서는 Firebase SDK가 아니라 `AnalyticsUseCase` mock 호출만 검증한다.

## App Group And iCloud KVS

App Group identifier는 `group.com.gaeng2y.drinkwater`다. iCloud container는 `iCloud.gaeng2y.DrinkWater`이고, KVS key는 현재 `dailyWaterLimit`만 운영 대상으로 본다.

CloudKit-backed SwiftData hydration store 문서는 legacy 참고용이다. 현재 수분 기록 source of truth는 HealthKit이며, 새 기능에서 `HydrationEventModel` 원장을 다시 활성화하지 않는다.

| Storage | Key | Purpose | Shared With | Notes |
| --- | --- | --- | --- | --- |
| App Group UserDefaults | `dailyWaterLimit` | 목표 수분량 mirror | App, Widget, Watch | iCloud KVS와 동기화한다. |
| iCloud KVS | `dailyWaterLimit` | 같은 Apple 계정의 목표량 동기화 | App, Watch | 민감 데이터 확장 금지. |
| App Group UserDefaults | `mainIcon` | 표시 아이콘 설정 | App, Widget | `mainAppearance`는 legacy migration 용도. |
| App Group UserDefaults | `hasCompletedOnboarding` | 로컬 온보딩 상태 | App | 사용자 식별자와 결합하지 않는다. |
| App Group UserDefaults | `hydrationRoutines` | 루틴 JSON | App | 로컬 알림/추천 계산용. |
| App Group UserDefaults | `hydrationChallengeBadgeHistories` | 챌린지 완료 이력 JSON | App | 표시 이력용. |
| App Group UserDefaults | `yyyy-MM-dd` legacy glass count | legacy hydration count | Legacy only | HealthKit source of truth 정책에 따라 새 기능에서 사용하지 않는다. |
| App Group UserDefaults | `manualBodyHeightCM`, `manualBodyWeightKG` | legacy/manual body profile | Legacy only | 신체 정보는 HealthKit 기준이며 새 플로우에서 확장하지 않는다. |

금지:

- Keychain 인증 값, Apple user identifier, email/name을 App Group/iCloud KVS에 저장하지 않는다.
- HealthKit 샘플 목록, 샘플 UUID, 신체 정보 원본을 App Group/iCloud KVS에 저장하지 않는다.
- Widget/Watch 편의를 위해 앱과 다른 수분 계산 규칙이나 별도 원장을 만들지 않는다.

## AdMob Introduction Checklist

AdMob 또는 다른 광고 SDK를 추가하기 전에 아래를 PR 본문에 명시한다.

- 광고가 필요한 제품 목적과 노출 위치
- Google Mobile Ads SDK와 UMP SDK 도입 여부
- ATT 요청 여부와 IDFA 사용 여부
- SKAdNetwork 또는 AdAttributionKit 설정 영향
- App Store privacy label에 추가될 data type, linked-to-user 여부, tracking 여부
- Firebase Analytics와 광고 측정 데이터 결합 여부
- 사용자 동의 철회 또는 privacy options 진입점 제공 방식
- Third-party SDK privacy manifest 포함 여부
- 법률 검토 필요 여부

광고 SDK 도입 전에는 기본값을 보수적으로 둔다. 동의가 필요한 지역/상황에서는 광고 요청보다 동의 상태 확인을 먼저 수행한다.

## IAP Introduction Checklist

StoreKit, 구독, 결제 서버, 영수증 검증을 추가하기 전에 아래를 PR 본문에 명시한다.

- 구매 상품 유형: consumable, non-consumable, subscription
- App Store Server API 또는 server notification 사용 여부
- 클라이언트/서버에 저장할 구매 식별자와 보관 기간
- 계정 삭제 시 구매/구독/영수증 데이터 처리 기준
- 복원 구매와 Apple 계정 기반 식별 경계
- Firebase 이벤트에 purchase amount, product id, transaction id를 보낼지 여부
- App Store privacy label의 `Purchases` data type 영향
- 환불, 구독 취소, 분쟁 대응을 위해 보관해야 하는 데이터와 법률 검토 항목

결제 데이터는 사용자 권리, 환불, 세무/회계, App Store 정책과 연결되므로 제품 기능 구현 전에 보관/삭제 기준을 먼저 확정한다.

## Privacy Review Checklist

보안/개인정보 영향이 있는 PR은 아래를 확인한다.

- 새 권한, entitlement, SDK, 외부 전송이 생겼는가?
- App Store privacy label 또는 PrivacyInfo manifest 변경이 필요한가?
- 개인정보 처리방침 또는 앱 내 고지 문구 변경이 필요한가?
- Analytics 이벤트 파라미터가 allowlist 기준을 따르는가?
- App Group/iCloud KVS에 민감 데이터가 추가되지 않았는가?
- 로그, OSLog, Crashlytics custom key에 개인정보/건강 데이터가 들어가지 않는가?
- 회원 탈퇴/로그아웃/동의 철회 시 데이터 삭제 또는 수집 중단 범위가 명확한가?
- 법률 검토가 필요한 항목을 PR과 이슈에 남겼는가?

## Legal Review Required

아래 변경은 코드 리뷰와 별개로 법률/정책 검토가 필요하다.

- 개인정보 처리방침 최종 문구 변경
- App Store privacy label의 data type, linked-to-user, tracking 답변 변경
- 광고 SDK, ATT, IDFA, UMP, SKAdNetwork/AdAttributionKit 도입
- IAP/구독/영수증 서버 검증/구매 이력 보관
- 서버 계정, 원격 사용자 프로필, 데이터 삭제 요청 처리
- HealthKit type 추가 또는 HealthKit 데이터를 외부 서버/SDK로 전송하는 설계

## References

- Apple App Privacy Details: https://developer.apple.com/app-store/app-privacy-details/
- Apple User Privacy And Data Use: https://developer.apple.com/app-store/user-privacy-and-data-use/
- Apple Sign in with Apple account deletion: https://developer.apple.com/support/offering-account-deletion-in-your-app
- Apple privacy manifest files: https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
- Firebase App Store data collection guide: https://firebase.google.com/docs/ios/app-store-data-collection
- Firebase Analytics data collection controls: https://firebase.google.com/docs/analytics/configure-data-collection
- Google Mobile Ads SDK privacy guide: https://developers.google.com/admob/ios/privacy
