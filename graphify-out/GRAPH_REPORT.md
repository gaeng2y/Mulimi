# Graph Report - Mulimi  (2026-10-18)

## Corpus Check
- 420 files · ~210,675 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 22 file(s) not represented in the graph (top: .entitlements 6, .plist 5, (none) 3)

## Summary
- 4245 nodes · 11300 edges · 189 communities (153 shown, 36 thin omitted)
- Extraction: 84% EXTRACTED · 16% INFERRED · 0% AMBIGUOUS · INFERRED: 1824 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a08324b6`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- HydrationRoutineAdherenceInsight
- SettingsViewModel
- WatchHydrationUndoTests.swift
- .assemble
- HydrationRoutine
- MockDrinkWaterUseCase
- HealthKitUseCaseImpl
- MockUserPreferencesUseCase
- .tr
- HealthKitQuantityStore
- .assemble
- Hydration Logging
- HydrationStarterPlanViewModel
- UserPreferencesRepository
- DrinkWaterViewModel
- ResetUseCase
- HydrationChallengeKind
- HealthKitPermissionViewModel
- MockRoutineRepository
- WatchHydrationViewModel
- UndoQuantityStore
- BodyProfile
- HydrationStarterPlan
- MockDrinkWaterRepository
- .tr
- UUID
- SpyRoutineUseCase
- RoutineRecommendationUseCaseImpl
- ContentView
- DrinkWaterWidgetProvider
- SwiftUI
- HydrationReminderPermissionViewModel
- SignInUseCaseImpl
- .makeUseCase
- RecordCalendarView
- AppReviewRequestState
- HydrationProgressSnapshot
- RoutineRepositoryImpl
- SheetRouting
- String
- CalendarDayView
- UnavailableHealthStore
- WatchHydrationEvent
- MockHydrationReminderRepository
- HydrationPresentation
- LiquidGlassSegmentStyle
- MockUserPreferencesRepository
- HydrationDomain
- UserDefaults
- HydrationReminderAuthorizationStatus
- AppReviewRequestUseCaseImpl
- HydrationReminderRepositoryImpl
- HydrationRoutineRecommendation
- HydrationInsightViewModel
- MockAnalyticsUseCase
- BodyProfileViewModel
- HydrationWriteResult
- KeyChainDataSource.swift
- UserPreferencesUseCase
- AppReviewRequestUseCase
- DrinkWaterEntry
- DrinkWaterHealthKitDataSource
- .resolve
- UserCredential
- LogWaterAppIntent
- ProjectDescription
- Growth Scorecard
- HydrationReminderSlot
- Top 5
- MainIcon
- Test.swift
- #329 빠른 물 기록 가이드 제작·발행
- .assemble
- HydrationRecordListViewModel
- LogWaterAmountOption
- OnboardingView
- HydrationProgressUseCaseImpl
- HydrationStarterPlanViewModelTests
- HydrationGoalRecommendationUseCaseImpl
- HydrationEvent
- DrinkWaterLockScreenWidgetEntryView
- Color
- HydrationReminderNotificationDataSourceImpl
- #336 Watch 최근 기록 한 건 되돌리기
- .loadChallenges
- AppleSignInCredential
- MockAppReviewRequestUseCase
- Xcode Cloud Release Build
- StartTimerIntent
- MockHydrationReminderUseCaseForTesting
- AppDelegate
- DrinkWaterUseCase
- Assembly
- HydrationGoalRecommendationAvailability
- Hashable
- check-ui-boundaries.py
- AGENTS.md Onboarding Map
- Foundation
- .resolve
- ChallengeViewModel
- Clean Architecture and MVVM
- DesignTokens
- HealthKitAuthorizationStatus
- Error
- WatchDailyGoalLocalDataSource
- HydrationServingPreset
- Generation prompts
- ConfigurationAppIntent
- MockError
- HydrationRecordPeriod
- MockUserPreferencesUseCase
- WatchHydrationSnapshot
- NavigationPresentationStyle
- .load
- .weeklyInsightCalculatesRoutineRatesAndMissPattern
- UserPreferencesDataSourceImpl
- TokenProperty
- .makeViewModel
- DIEnvironment
- ChallengeCategory
- WaterDropGlareEffectModifier
- WaterDropView
- ContentState
- 아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법
- 프로젝트 전체 구조와 의존성
- Security And Privacy Operations
- MulimiTheme.swift
- WaterDropShaders.metal
- DIContainer
- HydrationNextActionGuide
- #320 — 7일 스타터 플랜 제품 적용
- Docs Index
- RoutineWeekday
- DrinkWaterRepository
- HydrationReadFailureView
- RoutineRecoveryReminderAction
- Accessibility and Dynamic Type Audit
- HealthKitRepository
- MockHydrationReminderUseCase
- ci_post_clone.sh
- MulimiUISystemTests
- #356 디자인 시스템 계층 분리
- DrinkWaterWidget
- check-architecture.sh
- lint.sh
- lint-fix.sh
- ProfileRoutineViewModel
- .makeComebackViewModel
- Challenge State Model
- .recordWater
- AuthProvider
- HydrationInsightView
- AnalyticsUseCase
- Generation — Mulimi Water Glass v2
- .progressSnapshot
- View
- HydrationChallengeBadgeHistory
- MockUserPreferencesUseCaseForTesting
- #321 수분 알림 바로 기록
- WatchDataConstants.swift
- HydrationReminderDomain
- HydrationReminderUseCase
- AppTab
- HydrationReminderRepository
- CircleHighlight
- HydrationStarterPlanRepository
- Equatable
- .assemble
- Layer Responsibilities
- UserPreferencesUseCaseImpl
- HealthKitDataSourceImpl
- Mulimi Pull Request Template
- #360 Tuist Previews 적용
- HydrationProgressSnapshot
- Test
- KeychainStoring
- Tuist Previews
- AuthenticationRepositoryImpl
- SettingMenu
- LogWaterAppShortcuts
- StaticAppInfoProvider
- Sendable
- HydrationReminderStorageDataSourceImpl
- Personalized Challenge Strategy

## God Nodes (most connected - your core abstractions)
1. `HydrationDomain` - 118 edges
2. `HydrationInsightViewModel` - 102 edges
3. `AccountDomain` - 100 edges
4. `HydrationRoutine` - 96 edges
5. `DrinkWaterViewModel` - 85 edges
6. `RoutineDomain` - 75 edges
7. `HydrationEvent` - 75 edges
8. `ProfileRoutineViewModel` - 75 edges
9. `MulimiAnalytics` - 73 edges
10. `MockUserPreferencesUseCase` - 70 edges

## Surprising Connections (you probably didn't know these)
- `4. 제어 센터·액션 버튼 기록` --references--> `LogWaterAppIntent`  [INFERRED]
  Docs/feature-discovery.md → Project/App/Sources/AppIntents/LogWaterAppIntent.swift
- `Engineer` --references--> `LogWaterAppIntent`  [INFERRED]
  Docs/feature-discovery.md → Project/App/Sources/AppIntents/LogWaterAppIntent.swift
- `Opportunity` --references--> `HydrationServing`  [INFERRED]
  Docs/feature-discovery.md → Project/Features/Hydration/Domain/Sources/Entity/HydrationServing.swift
- `#350 조회 실패 화면` --references--> `DrinkWaterView`  [INFERRED]
  Docs/product-specs/assets/issue-350/README.md → Project/Features/Hydration/Presentation/Sources/View/DrinkWater/DrinkWaterView.swift
- `접근성과 검증` --references--> `MulimiUISystemTests`  [INFERRED]
  Docs/design-system.md → Project/Shared/MulimiUISystem/Tests/MulimiUISystemTests.swift

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Delivery and Review Contract** — docs_delivery_workflow_git_flow_delivery, _github_pull_request_template_pull_request_template, _github_workflows_ai_pr_review_git_flow_pr_filter [EXTRACTED 1.00]
- **Exec Plan Lifecycle** — docs_exec_plans_active_readme_active_exec_plans, docs_exec_plans_active_readme_active_plan_lifecycle, docs_exec_plans_completed_readme_completion_archive [EXTRACTED 1.00]
- **Hydration Logging Reminder Routine and Challenge Habit Loop** — docs_product_specs_hydration_logging_multi_surface_consistency, docs_product_specs_hydration_reminder_priming_daily_nudge_schedule, docs_product_specs_routine_notifications_transactional_schedule_commit, docs_personalized_challenge_strategy_recommendation_candidates, docs_product_specs_challenge_insight_routine_adherence_insight [INFERRED 0.85]
- **Repository Validation Pipeline** — docs_quality_gates_validation_baseline, docs_skills_lint_fix_loop_automated_lint_fix_loop, docs_skills_xcode_build_test_validation_order, docs_xcode_cloud_release_build_release_build_workflow [INFERRED 0.85]
- **Analytics Contract Measurement and Experiment Lifecycle** — docs_product_specs_analytics_events_event_contract, docs_product_specs_analytics_operations_core_funnel, docs_product_specs_onboarding_healthkit_conversion_experiments_baseline_conversion_funnel, docs_product_specs_sign_in_onboarding_healthkit_permission_recovery [INFERRED 0.95]
- **Architecture Guardrail Pipeline** — agents_default_validation, _github_workflows_lint_ci_architecture_gate, _swiftlint_swiftlint_configuration, architecture_dependency_direction [INFERRED 0.95]
- **Canonical Health Data Boundary** — docs_reliability_recovery_healthkit_source_of_truth, docs_security_privacy_health_data_minimization, docs_skills_healthkit_flow_healthkit_data_flow, readme_current_storage_strategy [INFERRED 0.95]
- **Cross-Target Hydration Policy** — docs_reliability_recovery_shared_hydration_rules, docs_skills_widget_watch_integration_cross_target_hydration_consistency, docs_skills_healthkit_flow_storage_policy, readme_current_storage_strategy [INFERRED 0.95]
- **Documentation Harness and Execution Lifecycle** — docs_harness_engineering_documentation_ssot_map, docs_index_document_maintenance_rule, docs_product_specs_index_spec_update_rule, docs_exec_plans_template_exec_plan_lifecycle, docs_exec_plans_tech_debt_tracker_documentation_role_debt [INFERRED 0.95]

## Communities (189 total, 36 thin omitted)

### Community 0 - "HydrationRoutineAdherenceInsight"
Cohesion: 0.12
Nodes (21): CandidateMatch, Constants, HydrationRoutineAdherenceEvent, HydrationRoutineAdherenceInsight, .adherenceRate, .bestRoutine, .bestTimeSlot, .hasDueOccurrences (+13 more)

### Community 1 - "SettingsViewModel"
Cohesion: 0.07
Nodes (25): .body, DailyLimitSettingView, .body, MainIconSettingView, .body, SettingDetailView, .body, WithdrawalSettingView (+17 more)

### Community 2 - "WatchHydrationUndoTests.swift"
Cohesion: 0.23
Nodes (7): HealthKit, MulimiHealthKit, OSLog, Synchronization, WatchHydrationData, WatchHydrationDomain, WatchHydrationPresentation

### Community 3 - ".assemble"
Cohesion: 0.11
Nodes (11): SystemWidgetTimelineReloader, WidgetTimelineReloading, HydrationReminderActionHandler, HydrationReminderActionResult, duplicate, failed, goalExceeded, permissionRequired (+3 more)

### Community 4 - "HydrationRoutine"
Cohesion: 0.06
Nodes (10): MockRoutineUseCase, MockRoutineUseCaseForTesting, StarterPlanRoutineStub, HydrationRoutine, RoutineNotificationAuthorizationStatus, authorized, denied, notDetermined (+2 more)

### Community 5 - "MockDrinkWaterUseCase"
Cohesion: 0.13
Nodes (5): HydrationRecordListViewModelTests, RecordSpyWidgetTimelineReloader, MockDrinkWaterUseCase, .currentWaterIntakeML, .hasPendingDrinkWater

### Community 6 - "HealthKitUseCaseImpl"
Cohesion: 0.10
Nodes (9): HydrationRecord, HealthKitUseCaseImpl, .authorisationStatus, HealthKitUseCaseTests, HydrationRecordRow, .body, .dateString, MockHealthKitRepository (+1 more)

### Community 7 - "MockUserPreferencesUseCase"
Cohesion: 0.17
Nodes (5): NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, MockUserPreferencesUseCase

### Community 8 - ".tr"
Cohesion: 0.05
Nodes (41): .body, HealthKitPermissionGateView, .accessCard, .descriptionText, .footnoteText, .headerColor, .headerSection, .headerSystemImage (+33 more)

### Community 9 - "HealthKitQuantityStore"
Cohesion: 0.21
Nodes (4): HealthKitQuantityStore, .isHealthDataAvailable, HealthQuantitySample, HealthQuantityStoring

### Community 10 - ".assemble"
Cohesion: 0.11
Nodes (11): RootView, .body, SignInUseCase, AppSession, SignInView, .body, AuthenticationViewModel, .isAuthenticated (+3 more)

### Community 11 - "Hydration Logging"
Cohesion: 0.10
Nodes (27): PostHog Analytics Consolidation, Analytics Events, Analytics Event Catalog, Product Analytics Event Contract, PostHog Activity QA, Analytics Operations, PostHog Core Product Funnel, #350 조회 실패 화면 (+19 more)

### Community 12 - "HydrationStarterPlanViewModel"
Cohesion: 0.19
Nodes (7): HydrationStarterPlanView, .body, .checklist, HydrationStarterPlanViewModel, .completedStepCount, .isAvailable, .nextStep

### Community 14 - "DrinkWaterViewModel"
Cohesion: 0.08
Nodes (19): HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, .body, DrinkWaterViewModel, .dailyLimit, .hasCurrentIntake (+11 more)

### Community 15 - "ResetUseCase"
Cohesion: 0.13
Nodes (10): .body, Action, drink, load, reset, ResetClock, .date, ResetUseCase (+2 more)

### Community 16 - "HydrationChallengeKind"
Cohesion: 0.10
Nodes (29): HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType, streak7, weeklyAchievement80, HydrationChallengeResetPolicy (+21 more)

### Community 17 - "HealthKitPermissionViewModel"
Cohesion: 0.13
Nodes (8): .body, .permissionView, HealthKitPermissionViewModel, .defaultErrorMessage, .deniedMessage, HealthKitPermissionViewModelTests, MockHealthKitUseCase, .authorisationStatus

### Community 18 - "MockRoutineRepository"
Cohesion: 0.12
Nodes (5): PersonalizedChallengeUseCaseTests, RoutineUseCaseImpl, RoutineRecommendationUseCaseTests, RoutineUseCaseTests, MockRoutineRepository

### Community 19 - "WatchHydrationViewModel"
Cohesion: 0.11
Nodes (11): WatchHydrationResetConfirmation, WatchResetConfirmationView, .dateText, MutationAction, record, reset, undo, WatchHydrationViewModel (+3 more)

### Community 20 - "UndoQuantityStore"
Cohesion: 0.13
Nodes (4): UndoGate, .isWaiting, UndoQuantityStore, WatchHydrationUndoTests

### Community 21 - "BodyProfile"
Cohesion: 0.06
Nodes (10): MockHealthKitUseCase, MockHealthKitUseCaseForTesting, BodyProfile, .isComplete, .isEmpty, BodyProfileSource, healthKit, manual (+2 more)

### Community 22 - "HydrationStarterPlan"
Cohesion: 0.11
Nodes (10): PreviewStarterPlanRepository, HydrationStarterPlanRepositoryImpl, HydrationStarterPlanRepositoryTests, HydrationQuickRecordingMethod, shortcuts, watch, widget, HydrationStarterPlan (+2 more)

### Community 23 - "MockDrinkWaterRepository"
Cohesion: 0.13
Nodes (6): DrinkWaterUseCaseImpl, .currentWaterIntakeML, DrinkWaterUseCaseTests, ReminderLoggingTests, MockDrinkWaterRepository, .currentWaterIntakeML

### Community 24 - ".tr"
Cohesion: 0.13
Nodes (18): WatchL10n, WatchMetricRow, .body, WatchNavigationCard, .body, WatchProgressBar, .body, WatchReadFailureView (+10 more)

### Community 25 - "UUID"
Cohesion: 0.13
Nodes (3): UUID, State, HydrationEventModel

### Community 26 - "SpyRoutineUseCase"
Cohesion: 0.10
Nodes (6): ProfileRoutineViewModelTests, SpyDrinkWaterUseCase, .currentWaterIntakeML, SpyRoutineRecommendationUseCase, SpyRoutineUseCase, SpyUserPreferencesUseCase

### Community 28 - "ContentView"
Cohesion: 0.13
Nodes (15): AppCoordinator, AppRoute, hydrationLogging, hydrationStarterPlan, .id, .presentationStyle, profileRoutineAction, NavigationRoute (+7 more)

### Community 30 - "SwiftUI"
Cohesion: 0.07
Nodes (15): ActivityKit, AlarmKit, AppIntents, Charts, CoreGraphics, CryptoKit, DesignSystemFoundation, Localization (+7 more)

### Community 31 - "HydrationReminderPermissionViewModel"
Cohesion: 0.12
Nodes (9): HydrationReminderPermissionGateView, .allowButtonLabel, .body, .headerSection, .primingView, Constant, HydrationReminderPermissionViewModel, HydrationReminderPermissionViewModelTests (+1 more)

### Community 32 - "SignInUseCaseImpl"
Cohesion: 0.12
Nodes (5): SignInUseCaseImpl, .isAuthenticated, SignInUseCaseTests, MockAuthenticationRepository, .isAuthenticated

### Community 33 - ".makeUseCase"
Cohesion: 0.24
Nodes (3): AppReviewRequestUseCaseTests, .calendar, .referenceDate

### Community 34 - "RecordCalendarView"
Cohesion: 0.10
Nodes (20): HydrationProgressBar, .body, HydrationRecordDaySummaryRow, .body, .progressPercent, HydrationRecordEventRow, .sourceText, .timeText (+12 more)

### Community 35 - "AppReviewRequestState"
Cohesion: 0.14
Nodes (6): AppReviewRequestStorageDataSource, AppReviewRequestStorageDataSourceImpl, AppReviewRequestRepositoryImpl, AppReviewRequestStorageDataSourceTests, AppReviewRequestState, MockAppReviewRequestRepository

### Community 36 - "HydrationProgressSnapshot"
Cohesion: 0.21
Nodes (3): HydrationInsightViewModelTests, SpyRoutineUseCase, MockHydrationRoutineAdherenceUseCase

### Community 37 - "RoutineRepositoryImpl"
Cohesion: 0.11
Nodes (8): RoutineNotificationDataSource, RoutineStorageDataSource, RoutineStorageDataSourceImpl, RoutineRepositoryImpl, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource, SpyRoutineStorageDataSource, RoutineRepository

### Community 38 - "SheetRouting"
Cohesion: 0.09
Nodes (5): DeepLinkHandling, FullScreenRouting, SheetRouting, StackRouting, .hasPath

### Community 39 - "String"
Cohesion: 0.09
Nodes (13): .postHogValue, AnalyticsParameterName, AnalyticsParameterValue, bool, double, int, string, ProductAnalyticsEvent (+5 more)

### Community 40 - "CalendarDayView"
Cohesion: 0.12
Nodes (17): CalendarDayView, .accessibilityLabel, .backgroundColor, .body, .borderColor, .dayNumber, .progressPercentage, .body (+9 more)

### Community 42 - "WatchHydrationEvent"
Cohesion: 0.09
Nodes (5): WatchHydrationHealthKitDataSource, WatchHydrationLocalDataSource, WatchHydrationRepositoryImpl, WatchHydrationEvent, WatchHydrationRepository

### Community 43 - "MockHydrationReminderRepository"
Cohesion: 0.15
Nodes (3): HydrationReminderUseCaseImpl, HydrationReminderUseCaseTests, MockHydrationReminderRepository

### Community 44 - "HydrationPresentation"
Cohesion: 0.17
Nodes (9): AccountPresentation, ChallengePresentation, DependencyInjection, HydrationPresentation, HydrationReminderPresentation, MulimiNavigation, MulimiPlatform, RoutinePresentation (+1 more)

### Community 45 - "LiquidGlassSegmentStyle"
Cohesion: 0.08
Nodes (16): LiquidGlassSegmentStyle, .activeBackground, .activeBorder, .activeShadow, .animation, .borderWidth, .containerBackground, .containerBorder (+8 more)

### Community 47 - "HydrationDomain"
Cohesion: 0.10
Nodes (4): AccountDomain, ChallengeDomain, MulimiAnalytics, RoutineDomain

### Community 48 - "UserDefaults"
Cohesion: 0.12
Nodes (10): HydrationComebackRepositoryImpl, HydrationComebackRepositoryTests, UserDefaults, .appGroup, .dailyLimit, .glassesOfToday, .hasCompletedOnboarding, .mainIcon (+2 more)

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.11
Nodes (6): HydrationReminderAuthorizationStatus, authorized, denied, notDetermined, .analyticsValue, ProductAnalyticsEvent

### Community 50 - "AppReviewRequestUseCaseImpl"
Cohesion: 0.23
Nodes (3): AppReviewRequestRepository, AppReviewRequestUseCaseImpl, Policy

### Community 51 - "HydrationReminderRepositoryImpl"
Cohesion: 0.20
Nodes (8): HydrationReminderNotificationDataSource, HydrationReminderStorageDataSource, HydrationReminderRepositoryImpl, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource, TestError, scheduleFailed

### Community 52 - "HydrationRoutineRecommendation"
Cohesion: 0.17
Nodes (9): MockRoutineRecommendationUseCase, HydrationRoutineRecommendation, HydrationRoutineRecommendationKind, afternoonGap, frequentHydrationWindow, morningStart, .timeText, .weekdayText (+1 more)

### Community 53 - "HydrationInsightViewModel"
Cohesion: 0.09
Nodes (23): HydrationInsightViewModel, .canRecordRecoveryDrink, .chartUpperBound, .dailyGoalText, .emptyStateCTAs, .hasLoadedInsights, .monthlyAverageText, .routineAdherenceInsightText (+15 more)

### Community 54 - "MockAnalyticsUseCase"
Cohesion: 0.18
Nodes (3): HydrationReminderActionHandlerTests, WidgetReloader, MockAnalyticsUseCase

### Community 55 - "BodyProfileViewModel"
Cohesion: 0.10
Nodes (14): MockBodyProfileUseCase, BodyProfileSnapshot, BodyProfileUseCase, MockBodyProfileUseCaseForDomain, BodyProfileViewModel, .availabilityState, .heightSourceText, .helperText (+6 more)

### Community 56 - "HydrationWriteResult"
Cohesion: 0.08
Nodes (7): .analyticsFailureReason, HydrationWriteResult, failure, .failureReason, .isSuccess, success, .analyticsFailureReason

### Community 58 - "UserPreferencesUseCase"
Cohesion: 0.13
Nodes (5): UserPreferencesUseCase, OnboardingViewModel, .canGoBack, .isLastPage, OnboardingViewModelTests

### Community 60 - "DrinkWaterEntry"
Cohesion: 0.16
Nodes (11): DrinkWaterWidgetEntryView, .accentColor, .body, .hydrationContent, DrinkWaterEntry, .dailyLimitText, .isLimitReached, .mililiters (+3 more)

### Community 61 - "DrinkWaterHealthKitDataSource"
Cohesion: 0.08
Nodes (7): DrinkWaterDataSource, DrinkWaterHealthKitDataSource, .currentWaterIntakeML, DrinkWaterRepositoryImpl, .currentWaterIntakeML, HealthKitSource, ReminderHealthKitWriteTests

### Community 62 - ".resolve"
Cohesion: 0.17
Nodes (7): 실행·공유 경계, WatchDIContainer, DrinkWaterApp, .body, MulimiWatchApp, .body, WatchDependencyInjection

### Community 64 - "LogWaterAppIntent"
Cohesion: 0.16
Nodes (4): Constant, FailureReason, LogWaterAppIntent, .resolvedVolumeML

### Community 65 - "ProjectDescription"
Cohesion: 0.12
Nodes (4): PackageDescription, ProjectDescription, ProjectDescriptionHelpers, AppVersion

### Community 66 - "Growth Scorecard"
Cohesion: 0.08
Nodes (20): 72-Hour Audit, Before Release, Cadence And Ownership, Decision Rule, Deferred Scope, Experiment Record, Goal, Growth Scorecard (+12 more)

### Community 67 - "HydrationReminderSlot"
Cohesion: 0.18
Nodes (6): HydrationReminderSlot, afternoon, evening, .hour, .minute, morning

### Community 68 - "Top 5"
Cohesion: 0.14
Nodes (13): 1. 로그인 없이 시작, 2. 7일 스타터 플랜, 3. 알림 바로 기록, 4. 제어 센터·액션 버튼 기록, 5. 컴백 모드, Candidate Ideas, Decision, Engineer (+5 more)

### Community 69 - "MainIcon"
Cohesion: 0.10
Nodes (12): MainIcon, cloud, .`default`, drop, heart, .id, .description, .displayName (+4 more)

### Community 70 - "Test.swift"
Cohesion: 0.18
Nodes (8): ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, .body, TestEntryView, .body

### Community 71 - "#329 빠른 물 기록 가이드 제작·발행"
Cohesion: 0.11
Nodes (18): #329 빠른 물 기록 가이드 제작·발행, Capture Assets, Community Draft, Completion Notes, Constraints, Context, Device Verification, First-Use Check (+10 more)

### Community 72 - ".assemble"
Cohesion: 0.16
Nodes (3): Constant, RoutineAlarmMetadata, RoutineNotificationDataSourceImpl

### Community 73 - "HydrationRecordListViewModel"
Cohesion: 0.10
Nodes (18): HydrationRecordListView, .body, RowListView, .body, .body, .yearMonthPickerSheet, HydrationRecordDaySummary, .glassCount (+10 more)

### Community 74 - "LogWaterAmountOption"
Cohesion: 0.20
Nodes (8): LogWaterAmountOption, bottle, custom, glass, .presetID, .servingType, tumbler, .volumeML

### Community 75 - "OnboardingView"
Cohesion: 0.14
Nodes (10): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+2 more)

### Community 78 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.18
Nodes (5): HydrationGoalRecommendationRepository, Constants, HydrationGoalRecommendationUseCaseImpl, HydrationGoalRecommendationUseCaseTests, MockHydrationGoalRecommendationRepository

### Community 79 - "HydrationEvent"
Cohesion: 0.08
Nodes (5): MockDrinkWaterUseCase, .currentWaterIntakeML, MockDrinkWaterUseCaseForTesting, .currentWaterIntakeML, HydrationEvent

### Community 80 - "DrinkWaterLockScreenWidgetEntryView"
Cohesion: 0.20
Nodes (9): DrinkWaterLockScreenWidget, .body, DrinkWaterLockScreenWidgetEntryView, .accentColor, .body, .circularView, .hydrationContent, .inlineView (+1 more)

### Community 81 - "Color"
Cohesion: 0.07
Nodes (31): .id, ChallengeBadge, .body, ChallengeCard, .accentColor, .body, .cardBackground, ChallengeHistoryCard (+23 more)

### Community 82 - "HydrationReminderNotificationDataSourceImpl"
Cohesion: 0.22
Nodes (3): Constant, HydrationReminderNotificationDataSourceImpl, .notificationCenter

### Community 83 - "#336 Watch 최근 기록 한 건 되돌리기"
Cohesion: 0.18
Nodes (10): #336 Watch 최근 기록 한 건 되돌리기, Completion Notes, Constraints, Context, Goal, Non-Goals, Open Questions, Plan (+2 more)

### Community 84 - ".loadChallenges"
Cohesion: 0.25
Nodes (3): ChallengeViewModelTests, MockChallengeUseCase, MockPersonalizedChallengeUseCase

### Community 85 - "AppleSignInCredential"
Cohesion: 0.17
Nodes (4): AuthenticationServices, AppleSignInCredential, AppleSignInDataSourceImpl, AppleSignInDelegate

### Community 87 - "Xcode Cloud Release Build"
Cohesion: 0.17
Nodes (10): Generation and editing — Mulimi Drop v3, Original body layer prompt, Original face layer prompt, Original master prompt, Mulimi Drop — v3, 레이어, 배경과 외관, 앱 적용 (+2 more)

### Community 88 - "StartTimerIntent"
Cohesion: 0.16
Nodes (6): Provider, StartTimerIntent, TestControl, .body, TimerConfiguration, Value

### Community 91 - "DrinkWaterUseCase"
Cohesion: 0.12
Nodes (5): DrinkWaterUseCase, HydrationReminderLogResult, failed, goalExceeded, saved

### Community 92 - "Assembly"
Cohesion: 0.32
Nodes (4): PreviewAssembly, DataAssembly, DomainAssembly, PresentationAssembly

### Community 93 - "HydrationGoalRecommendationAvailability"
Cohesion: 0.07
Nodes (19): MockHydrationGoalRecommendationUseCase, BodyProfileAvailability, incomplete, needsPermission, noData, permissionDenied, ready, HydrationGoalRecommendationAvailability (+11 more)

### Community 94 - "Hashable"
Cohesion: 0.09
Nodes (16): Constants, FoundationModelsHydrationGoalRecommendationDataSource, GeneratedHydrationGoalRecommendation, HydrationGoalRecommendationDataSource, HydrationGoalRecommendationRepositoryImpl, HydrationGoalRecommendation, HydrationGoalRecommendationError, bodyProfileRequired (+8 more)

### Community 95 - "check-ui-boundaries.py"
Cohesion: 0.05
Nodes (16): calls(), check(), fields(), target_declarations(), tokens(), fix_icon_file_types(), UIBoundaryTests, PreviewTests (+8 more)

### Community 96 - "AGENTS.md Onboarding Map"
Cohesion: 0.11
Nodes (15): Profile Information Architecture, Profile Root, Settings Screen, HealthKit Source of Truth, Reliability Recovery, Shared Hydration Rules, HealthKit Data Flow, healthkit-flow (+7 more)

### Community 97 - "Foundation"
Cohesion: 0.08
Nodes (6): Foundation, FoundationModels, HydrationData, HydrationDomain, PostHog, Testing

### Community 98 - ".resolve"
Cohesion: 0.43
Nodes (5): PreviewViews, .challenge, .drinkWater, .hydrationList, .profile

### Community 100 - "ChallengeViewModel"
Cohesion: 0.05
Nodes (26): MockPersonalizedChallengeUseCase, MockPersonalizedChallengeUseCaseForTesting, HydrationChallenge, .id, HydrationChallengeRecommendationSource, recentRecords, routine, HydrationChallengeTier (+18 more)

### Community 101 - "Clean Architecture and MVVM"
Cohesion: 0.13
Nodes (10): Validation Baseline, architecture-boundary, Clean Architecture and MVVM, navigation-coordinator, Root Navigation, Lightweight Gate, Validation Order, Release-Build Workflow (+2 more)

### Community 102 - "DesignTokens"
Cohesion: 0.31
Nodes (7): DesignSystemFoundation — UISystem에서 사용, Control, DesignTokens, Motion, Palette, Spacing, Typography

### Community 103 - "HealthKitAuthorizationStatus"
Cohesion: 0.26
Nodes (6): HealthKitAuthorizationStatus, notDetermined, sharingAuthorized, sharingDenied, .analyticsValue, ProductAnalyticsEvent

### Community 105 - "Error"
Cohesion: 0.05
Nodes (33): HealthQuantityStoreError, incompleteQuery, internalError, invalidObjectType, permissionDenied, AuthenticationError, cancelled, invalidCredential (+25 more)

### Community 106 - "WatchDailyGoalLocalDataSource"
Cohesion: 0.13
Nodes (6): MulimiCloudKit, SyncedValueStoring, UbiquitousMirroredStore, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, WatchDailyGoalRepositoryImpl

### Community 107 - "HydrationServingPreset"
Cohesion: 0.16
Nodes (10): HydrationServing, .additionalPresets, HydrationServingPreset, bottle, .id, tumbler, .volumeML, .progressLevel (+2 more)

### Community 108 - "Generation prompts"
Cohesion: 0.18
Nodes (9): body, cheeks, face, Generation prompts, Master, Mulimi Liquid Glass 아이콘 — #339, v1, 미리보기와 확인, 사용 (+1 more)

### Community 109 - "ConfigurationAppIntent"
Cohesion: 0.18
Nodes (4): ConfigurationAppIntent, .description, .title, ConfigurationAppIntent

### Community 110 - "MockError"
Cohesion: 0.20
Nodes (9): MockError, .errorDescription, signInFailed, MockError, deleteFailed, .errorDescription, MockError, .errorDescription (+1 more)

### Community 111 - "HydrationRecordPeriod"
Cohesion: 0.33
Nodes (6): HydrationRecordPeriod, .id, month, .title, today, week

### Community 113 - "WatchHydrationSnapshot"
Cohesion: 0.08
Nodes (11): WatchHydrationMutationResult, WatchHydrationSnapshot, .eventCount, .isGoalReached, .lastDrinkDate, .progress, .remainingML, WatchDailyGoalRepository (+3 more)

### Community 114 - "NavigationPresentationStyle"
Cohesion: 0.40
Nodes (4): NavigationPresentationStyle, fullScreenCover, push, sheet

### Community 115 - ".load"
Cohesion: 0.25
Nodes (4): ReadRecoveryGoal, ReadRecoveryRepository, WatchHydrationReadRecoveryTests, WatchReadRecoveryClock

### Community 117 - "UserPreferencesDataSourceImpl"
Cohesion: 0.15
Nodes (4): Constants, UserPreferencesDataSource, UserPreferencesDataSourceImpl, UserPreferencesRepositoryImpl

### Community 118 - "TokenProperty"
Cohesion: 0.18
Nodes (7): KeyChainDataSourceImpl, TokenProperty, accessToken, email, nickname, refreshToken, userIdentifier

### Community 120 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 121 - "ChallengeCategory"
Cohesion: 0.10
Nodes (20): ChallengeCategory, completed, .id, inProgress, recommended, .systemImage, .title, .categoryPicker (+12 more)

### Community 122 - "WaterDropGlareEffectModifier"
Cohesion: 0.20
Nodes (7): MulimiUISystem — 화면에서 사용, 공개 API, 디자인 시스템, 리소스와 플랫폼, 모듈과 의존 방향, 접근성과 검증, WaterDropGlareEffectModifier

### Community 123 - "WaterDropView"
Cohesion: 0.13
Nodes (7): WaterDropView, .body, .dropBackground, .dropHighlights, .dropSymbol, WaterWaveView, .animatableData

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (6): ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 125 - "아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법"
Cohesion: 0.18
Nodes (10): Apple Watch에서 기록하기, Siri·단축어로 기록하기, Siri에게 말하기, 기록이 저장됐는지 확인하기, 내게 맞는 방법 고르기, 단축어 앱에서 실행, 설정하거나 기록하다 막혔다면, 아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법 (+2 more)

### Community 126 - "프로젝트 전체 구조와 의존성"
Cohesion: 0.15
Nodes (13): App · 조립 루트 — 8개, Core — 6개, Features — 18개, Shared — 6개, Tests — 17개, 검증과 갱신, 기능 간 직접 의존에서 주의할 점, 디렉터리와 소유권 (+5 more)

### Community 127 - "Security And Privacy Operations"
Cohesion: 0.18
Nodes (9): Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling, Data Boundary, PostHog Privacy Controls, Security And Privacy Operations (+1 more)

### Community 128 - "MulimiTheme.swift"
Cohesion: 0.33
Nodes (5): BundleToken, MulimiTheme, .accent, .background, MulimiUIResources

### Community 129 - "WaterDropShaders.metal"
Cohesion: 0.43
Nodes (3): mulimiWaterDistortion(), mulimiWaterLighting(), mulimiWaveNoise()

### Community 130 - "DIContainer"
Cohesion: 0.15
Nodes (8): #350 HealthKit 조회 실패 복구, 검증 기록, 경계, 목적, 작업 순서, 추가 검증의 제한, DIContainer, .resolver

### Community 131 - "HydrationNextActionGuide"
Cohesion: 0.08
Nodes (13): MockHydrationNextActionGuideUseCase, MockHydrationNextActionGuideUseCaseForTesting, Constants, HydrationNextActionGuide, .progress, HydrationNextActionGuideState, approachingRoutine, goalReached (+5 more)

### Community 132 - "#320 — 7일 스타터 플랜 제품 적용"
Cohesion: 0.20
Nodes (9): #320 — 7일 스타터 플랜 제품 적용, Constraints And Decisions, Context, Goal, Implementation Notes (2026-09-14), Non-Goals, Plan, Rollback (+1 more)

### Community 133 - "Docs Index"
Cohesion: 0.10
Nodes (27): Agent Onboarding Guide, Graphify-Assisted Code Navigation, Mulimi Architecture SSOT, Core User Flow, Claude Agent Entrypoint, Delivery Workflow, Git Flow Delivery Strategy, Issue Closure Policy (+19 more)

### Community 134 - "RoutineWeekday"
Cohesion: 0.09
Nodes (16): .localeWeekday, .nextActionSchedule, RoutineWeekday, .displayOrder, friday, .id, monday, saturday (+8 more)

### Community 135 - "DrinkWaterRepository"
Cohesion: 0.10
Nodes (6): Constants, PersonalizedChallengeUseCaseImpl, DrinkWaterRepository, HydrationNextActionGuideUseCaseImpl, HydrationRoutineAdherenceUseCaseImpl, RoutineUseCase

### Community 136 - "HydrationReadFailureView"
Cohesion: 0.40
Nodes (3): .body, HydrationReadFailureView, .body

### Community 137 - "RoutineRecoveryReminderAction"
Cohesion: 0.17
Nodes (12): HydrationInsightEmptyAction, dailyGoal, record, routine, HydrationWeeklyCoachingAction, dailyGoal, none, routine (+4 more)

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "HealthKitRepository"
Cohesion: 0.14
Nodes (3): HealthKitRepository, BodyProfileUseCaseImpl, BodyProfileUseCaseTests

### Community 145 - "#356 디자인 시스템 계층 분리"
Cohesion: 0.20
Nodes (10): #356 디자인 시스템 계층 분리, Completion Notes, Constraints, Context, Decisions, Goal, Plan, Rollback (+2 more)

### Community 146 - "DrinkWaterWidget"
Cohesion: 0.20
Nodes (6): DrinkWaterWidget, .body, DrinkWaterWidgetBundle, .body, LogWaterControl, .body

### Community 151 - "ProfileRoutineViewModel"
Cohesion: 0.06
Nodes (23): RoutineRecommendationUseCase, .body, RoutineEditorView, .body, .weekdayGrid, ProfileRoutineViewModel, .activeRoutineCount, .canSaveDraft (+15 more)

### Community 152 - ".makeComebackViewModel"
Cohesion: 0.12
Nodes (7): HydrationComebackRepository, .comebackSummary, HydrationComebackMode, baseline, card, disabled, StubHydrationComebackRepository

### Community 155 - "Challenge State Model"
Cohesion: 0.50
Nodes (4): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Recurring Challenge State

### Community 156 - ".recordWater"
Cohesion: 0.19
Nodes (3): HydrationReminderNotification, .category, HydrationReminderNotificationTests

### Community 157 - "AuthProvider"
Cohesion: 0.40
Nodes (4): AuthProvider, apple, google, kakao

### Community 158 - "HydrationInsightView"
Cohesion: 0.08
Nodes (18): BadgeView, .body, HydrationInsightView, .emptyState, .emptyStateCTAButtons, .insightContent, .metricColumns, .routineAdherenceCard (+10 more)

### Community 159 - "AnalyticsUseCase"
Cohesion: 0.18
Nodes (3): AnalyticsUseCase, NoOpAnalyticsUseCase, AnalyticsUseCaseImpl

### Community 160 - "Generation — Mulimi Water Glass v2"
Cohesion: 0.25
Nodes (6): droplet, Generation — Mulimi Water Glass v2, glass, Master, water, Mulimi — Water Glass v2

### Community 163 - "View"
Cohesion: 0.14
Nodes (11): ProfileView, .body, .goalRecommendationCard, .goalRecommendationRoute, .routineCard, BodyProfileSettingView, .healthSyncCard, .summaryCard (+3 more)

### Community 164 - "HydrationChallengeBadgeHistory"
Cohesion: 0.06
Nodes (14): MockChallengeUseCase, MockChallengeUseCaseForTesting, ChallengeStorageDataSource, ChallengeStorageDataSourceImpl, ChallengeRepositoryImpl, ChallengeStorageDataSourceTests, HydrationChallengeBadgeHistory, ChallengeRepository (+6 more)

### Community 166 - "#321 수분 알림 바로 기록"
Cohesion: 0.18
Nodes (11): #321 수분 알림 바로 기록, Completion Notes, Constraints, Context, Goal, Non-Goals, Open Questions, Plan (+3 more)

### Community 168 - "HydrationReminderDomain"
Cohesion: 0.07
Nodes (9): AccountData, ChallengeData, HydrationReminderData, HydrationReminderDomain, MulimiAnalyticsData, HydrationReminderAnalyticsParameterName, RoutineData, UserNotifications (+1 more)

### Community 171 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, challenge, drink, history, insight, profile

### Community 173 - "CircleHighlight"
Cohesion: 0.20
Nodes (4): CircleHighlight, .body, GlareCircleView, .body

### Community 174 - "HydrationStarterPlanRepository"
Cohesion: 0.18
Nodes (6): HydrationStarterPlanRepository, NextStep, chooseMethod, finish, recordWater, saveRoutine

### Community 175 - "Equatable"
Cohesion: 0.06
Nodes (36): ChallengeHistoryCardModel, CustomHydrationAmountValidation, empty, invalid, overLimit, valid, .servingOptions, HydrationServingOptionModel (+28 more)

### Community 177 - "Layer Responsibilities"
Cohesion: 0.09
Nodes (17): AI PR Review Workflow, Architecture Review Policy, Git Flow PR Filter, Textual Diff Selection, CI Lint and Architecture Gate, Lint Workflow, Domain Data Presentation Test Matrix, PR Unit Tests Workflow (+9 more)

### Community 179 - "HealthKitDataSourceImpl"
Cohesion: 0.09
Nodes (7): HealthKitDataSource, HealthKitDataSourceImpl, .healthKitAuthorizationStatus, .isWaterSharingAuthorized, HealthKitRepositoryImpl, .authorisationStatus, .isWaterSharingAuthorized

### Community 180 - "Mulimi Pull Request Template"
Cohesion: 0.50
Nodes (3): Local Validation Reporting, Mulimi Pull Request Template, PR Review Checklist

### Community 181 - "#360 Tuist Previews 적용"
Cohesion: 0.20
Nodes (9): #360 Tuist Previews 적용, Constraints, Context, Goal, Plan, Progress, Remaining Validation, Rollback (+1 more)

### Community 182 - "HydrationProgressSnapshot"
Cohesion: 0.09
Nodes (6): MockHydrationProgressUseCase, MockHydrationProgressUseCaseForTesting, HydrationProgressSnapshot, HydrationProgressUseCase, MockHydrationProgressUseCase, MockHydrationProgressUseCase

### Community 183 - "Test"
Cohesion: 0.22
Nodes (5): Test, TestBundle, .body, TestLiveActivity, .body

### Community 186 - "Tuist Previews"
Cohesion: 0.22
Nodes (9): GitHub 연결과 CI, Preview 실행, Tuist Previews, 검증과 문제 해결, 로컬 빌드와 공유, 빌드 번호, 설정과 준비, 실행 조건 (+1 more)

### Community 187 - "AuthenticationRepositoryImpl"
Cohesion: 0.15
Nodes (5): AppleSignInDataSource, KeyChainDataSource, AuthenticationRepositoryImpl, .isAuthenticated, AuthenticationRepository

### Community 190 - "SettingMenu"
Cohesion: 0.29
Nodes (6): SettingMenu, bodyProfile, dailyLimit, .id, mainIcon, withdrawal

### Community 192 - "LogWaterAppShortcuts"
Cohesion: 0.29
Nodes (3): LogWaterAppShortcuts, .appShortcuts, .shortcutTileColor

### Community 193 - "StaticAppInfoProvider"
Cohesion: 0.29
Nodes (5): AppInfoProviding, BundleAppInfoProvider, .appBuildNumber, .appVersion, StaticAppInfoProvider

### Community 194 - "Sendable"
Cohesion: 0.07
Nodes (8): MockHydrationRoutineAdherenceUseCase, MockHydrationRoutineAdherenceUseCaseForTesting, HydrationRoutineSchedule, ReadRecoveryClock, InsightRecoveryClock, RecordRecoveryClock, HydrationRoutineAdherenceUseCase, UndoHealthStore

### Community 206 - "Personalized Challenge Strategy"
Cohesion: 0.50
Nodes (4): Personalized Challenge Strategy, Personalized Challenge Recommendation Candidates, Challenge Recommendation Tier Rules, Challenge and Insight Information Architecture

## Ambiguous Edges - Review These
- `Current Storage Strategy` → `CloudKit-Backed Hydration Store`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to
- `HealthKit Source of Truth` → `CloudKit-Backed Hydration Store`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to

## Knowledge Gaps
- **473 isolated node(s):** `.resolver`, `production`, `preview`, `testing`, `.current` (+468 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1117 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **36 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `HydrationRoutineAdherenceInsight`, `SettingsViewModel`, `.assemble`, `HydrationRoutine`, `MockDrinkWaterUseCase`, `HealthKitUseCaseImpl`, `.tr`, `HealthKitQuantityStore`, `.assemble`, `HydrationStarterPlanViewModel`, `DrinkWaterViewModel`, `HydrationChallengeKind`, `HealthKitPermissionViewModel`, `WatchHydrationViewModel`, `UndoQuantityStore`, `BodyProfile`, `HydrationStarterPlan`, `MockDrinkWaterRepository`, `.tr`, `UUID`, `SpyRoutineUseCase`, `ContentView`, `HydrationReminderPermissionViewModel`, `RecordCalendarView`, `AppReviewRequestState`, `CalendarDayView`, `UnavailableHealthStore`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `AppReviewRequestUseCaseImpl`, `HydrationRoutineRecommendation`, `HydrationInsightViewModel`, `MockAnalyticsUseCase`, `BodyProfileViewModel`, `HydrationWriteResult`, `AppReviewRequestUseCase`, `DrinkWaterEntry`, `DrinkWaterHealthKitDataSource`, `UserCredential`, `LogWaterAppIntent`, `ProjectDescription`, `Growth Scorecard`, `HydrationReminderSlot`, `MainIcon`, `.assemble`, `HydrationRecordListViewModel`, `LogWaterAmountOption`, `OnboardingView`, `HydrationEvent`, `Color`, `HydrationReminderNotificationDataSourceImpl`, `AppleSignInCredential`, `MockAppReviewRequestUseCase`, `StartTimerIntent`, `DrinkWaterUseCase`, `Hashable`, `.drinkWater`, `ChallengeViewModel`, `HealthKitAuthorizationStatus`, `Error`, `WatchDailyGoalLocalDataSource`, `HydrationServingPreset`, `ConfigurationAppIntent`, `MockError`, `HydrationRecordPeriod`, `MockUserPreferencesUseCase`, `UserPreferencesDataSourceImpl`, `TokenProperty`, `ChallengeCategory`, `ContentState`, `HydrationNextActionGuide`, `RoutineWeekday`, `RoutineRecoveryReminderAction`, `DrinkWaterWidget`, `ProfileRoutineViewModel`, `.makeComebackViewModel`, `.recordWater`, `HydrationInsightView`, `AnalyticsUseCase`, `.progressSnapshot`, `View`, `HydrationChallengeBadgeHistory`, `MockUserPreferencesUseCaseForTesting`, `Equatable`, `HealthKitDataSourceImpl`, `Test`, `KeychainStoring`, `AuthenticationRepositoryImpl`, `SettingMenu`, `StaticAppInfoProvider`, `Sendable`?**
  _High betweenness centrality (0.321) - this node is a cross-community bridge._
- **Are the 23 inferred relationships involving `HydrationInsightViewModel` (e.g. with `.assemble()` and `.assemble()`) actually correct?**
  _`HydrationInsightViewModel` has 23 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.resolver`, `production`, `preview` to the rest of the system?**
  _473 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `HydrationRoutineAdherenceInsight` be split into smaller, more focused modules?**
  _Cohesion score 0.12403100775193798 - nodes in this community are weakly interconnected._
- **Why does `Foundation` connect `Foundation` to `HydrationRoutineAdherenceInsight`, `MulimiTheme.swift`, `WatchHydrationUndoTests.swift`, `HydrationNextActionGuide`, `HydrationRoutine`, `HealthKitUseCaseImpl`, `DrinkWaterRepository`, `.tr`, `HealthKitQuantityStore`, `.assemble`, `HealthKitRepository`, `UserPreferencesRepository`, `HydrationChallengeKind`, `WatchHydrationViewModel`, `BodyProfile`, `HydrationStarterPlan`, `ProfileRoutineViewModel`, `.makeComebackViewModel`, `.tr`, `AuthProvider`, `SwiftUI`, `SignInUseCaseImpl`, `AppReviewRequestState`, `HydrationChallengeBadgeHistory`, `RoutineRepositoryImpl`, `SheetRouting`, `String`, `HydrationReminderDomain`, `HydrationReminderUseCase`, `WatchHydrationEvent`, `MockHydrationReminderRepository`, `HydrationPresentation`, `HydrationReminderRepository`, `HydrationDomain`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `HydrationRoutineRecommendation`, `HydrationProgressSnapshot`, `BodyProfileViewModel`, `KeychainStoring`, `KeyChainDataSource.swift`, `UserPreferencesUseCase`, `AuthenticationRepositoryImpl`, `HydrationWriteResult`, `AppReviewRequestUseCase`, `UserCredential`, `StaticAppInfoProvider`, `Sendable`, `HydrationReminderSlot`, `MainIcon`, `HydrationGoalRecommendationUseCaseImpl`, `HydrationEvent`, `Color`, `AppleSignInCredential`, `DrinkWaterUseCase`, `HydrationGoalRecommendationAvailability`, `Hashable`, `ChallengeViewModel`, `HealthKitAuthorizationStatus`, `Error`, `WatchDailyGoalLocalDataSource`, `HydrationServingPreset`, `WatchHydrationSnapshot`, `TokenProperty`, `DIEnvironment`?**
  _High betweenness centrality (0.074) - this node is a cross-community bridge._

### Low-confidence Hints
_AMBIGUOUS edges — the extractor was unsure. Verify before acting on these._

- **What is the exact relationship between `Current Storage Strategy` and `CloudKit-Backed Hydration Store`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `HealthKit Source of Truth` and `CloudKit-Backed Hydration Store`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._