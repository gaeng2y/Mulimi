# Graph Report - Mulimi  (2026-10-04)

## Corpus Check
- 407 files · ~205,088 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 22 file(s) not represented in the graph (top: .entitlements 6, .plist 5, (none) 3)

## Summary
- 4107 nodes · 11035 edges · 187 communities (148 shown, 39 thin omitted)
- Extraction: 84% EXTRACTED · 16% INFERRED · 0% AMBIGUOUS · INFERRED: 1762 edges (avg confidence: 0.84)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `5c70c42a`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- HydrationRoutineAdherenceInsight
- SettingsViewModel
- WatchHydrationUndoTests.swift
- HydrationRoutine
- MockDrinkWaterUseCase
- MockHealthKitRepository
- MockUserPreferencesUseCase
- DrinkWaterView
- HealthKitQuantityStore
- .assemble
- Docs Index
- HydrationStarterPlanViewModel
- HydrationReminderLogResult
- DrinkWaterViewModel
- ResetUseCase
- HydrationChallenge
- HealthKitPermissionViewModel
- MockRoutineRepository
- .tr
- .drinkWater
- BodyProfile
- HydrationStarterPlan
- MockDrinkWaterRepository
- .tr
- UUID
- SpyRoutineUseCase
- HydrationRoutineRecommendation
- ContentView
- PostHogAnalyticsRepository
- Localization
- HydrationReminderPermissionViewModel
- SignInUseCaseImpl
- PersonalizedHydrationChallenge
- RecordCalendarView
- AppReviewRequestState
- .loadInsights
- RoutineRepositoryImpl
- StackRouting
- String
- HydrationGoalRecommendationViewModel
- UnavailableHealthStore
- HydrationWriteResult
- MockHydrationReminderRepository
- HydrationPresentation
- RoutineActionIntent
- Equatable
- Foundation
- UserDefaults
- HydrationReminderAuthorizationStatus
- WatchHydrationViewModel
- HydrationReminderRepositoryImpl
- HydrationRecord
- HydrationInsightViewModel
- AnalyticsUseCase
- BodyProfileViewModel
- DrinkWaterHealthKitDataSource
- HealthKitUseCase
- MockHydrationRoutineAdherenceUseCase
- HydrationReminderSlot
- DrinkWaterEntry
- DrinkWaterRepositoryImpl
- MulimiWatchApp
- UserCredential
- LogWaterAppIntent
- ProjectDescription
- Growth Scorecard
- HealthKitSource
- Top 5
- MainIcon
- Test.swift
- #329 빠른 물 기록 가이드 제작·발행
- RoutineNotificationDataSourceImpl
- HydrationRecordListViewModel
- HydrationGoalRecommendationUnavailableReason
- OnboardingViewModel
- HydrationProgressUseCaseImpl
- HydrationStarterPlanViewModelTests
- HydrationGoalRecommendationUseCaseImpl
- HydrationEvent
- .fetchChallenges
- Color
- BodyProfileAvailability
- #336 Watch 최근 기록 한 건 되돌리기
- .loadChallenges
- AppleSignInCredential
- MockAppReviewRequestUseCase
- Mulimi Drop — v3
- LiquidGlassSegmentedControl
- AuthTokens
- AppDelegate
- ReadRecoveryRepository
- HydrationReminderActionResult
- HydrationGoalRecommendationAvailability
- Hashable
- fix-icon-composer-file-types.py
- Security And Privacy Operations
- AccountDomain
- RoutineEditorDraft
- PersonalizedChallengeUseCaseImpl
- LogWaterAmountOption
- AGENTS.md Onboarding Map
- .recordWater
- HealthKitAuthorizationStatus
- Sendable
- Error
- WaterWaveView
- HydrationServingPreset
- Generation prompts
- ConfigurationAppIntent
- MockError
- BundleAppInfoProvider
- AppDelegate.swift
- WatchHydrationEvent
- NavigationPresentationStyle
- AnalyticsRepository
- HydrationRoutineSchedule
- UserPreferencesDataSourceImpl
- TokenProperty
- .makeViewModel
- DIEnvironment
- AuthenticationError
- .handle
- UbiquitousMirroredStore
- ContentState
- 아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법
- .makeModelContainer
- #350 HealthKit 조회 실패 복구
- MockChallengeUseCaseForTesting
- WaterDropShaders.metal
- .resolve
- HydrationNextActionGuide
- #320 — 7일 스타터 플랜 제품 적용
- Mulimi
- RoutineWeekday
- DrinkWaterRepository
- WatchDailyGoalLocalDataSource
- View
- Accessibility and Dynamic Type Audit
- HealthKitRepository
- MockHydrationReminderUseCase
- ci_post_clone.sh
- AnalyticsUseCaseImpl
- .assemble
- HealthKitError
- Test
- check-architecture.sh
- HydrationChallengeBadgeHistory
- lint.sh
- lint-fix.sh
- ProfileRoutineViewModel
- MockAnalyticsUseCase
- HydrationReminderPermissionGateView
- ChallengeViewModel
- Challenge State Model
- Completed Plan Archive
- AuthProvider
- HealthQuantityStoreError
- SystemWidgetTimelineReloader
- Generation — Mulimi Water Glass v2
- HydrationReminderStorageDataSourceImpl
- .progressSnapshot
- HydrationGoalRecommendationCard
- ChallengeStorageDataSourceImpl
- MockUserPreferencesUseCaseForTesting
- #321 수분 알림 바로 기록
- WatchDataConstants.swift
- DataAssembly.swift
- Release And QA Runbook
- TestingAssembly
- AppTab
- HydrationReminderRepository
- HydrationComebackMode
- RoutineError
- HydrationRecordPeriod
- Layer Responsibilities
- MockUserPreferencesRepository
- HealthKitDataSourceImpl
- .guideCombinesRemainingServingAndNextRoutine
- HydrationProgressSnapshot
- AuthenticationRepositoryImpl
- SignInUseCase
- LogWaterAppShortcuts

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
- `추가 검증의 제한` --references--> `DIContainer`  [INFERRED]
  Docs/exec-plans/active/2026-10-03-issue-350-read-recovery.md → Project/App/DependencyInjection/Sources/Core/DIContainer.swift
- `4. 제어 센터·액션 버튼 기록` --references--> `LogWaterAppIntent`  [INFERRED]
  Docs/feature-discovery.md → Project/App/Sources/AppIntents/LogWaterAppIntent.swift
- `Engineer` --references--> `LogWaterAppIntent`  [INFERRED]
  Docs/feature-discovery.md → Project/App/Sources/AppIntents/LogWaterAppIntent.swift
- `Opportunity` --references--> `HydrationServing`  [INFERRED]
  Docs/feature-discovery.md → Project/Features/Hydration/Domain/Sources/Entity/HydrationServing.swift
- `#350 조회 실패 화면` --references--> `DrinkWaterView`  [INFERRED]
  Docs/product-specs/assets/issue-350/README.md → Project/Features/Hydration/Presentation/Sources/View/DrinkWater/DrinkWaterView.swift

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

## Communities (187 total, 39 thin omitted)

### Community 0 - "HydrationRoutineAdherenceInsight"
Cohesion: 0.12
Nodes (21): CandidateMatch, Constants, HydrationRoutineAdherenceEvent, HydrationRoutineAdherenceInsight, .adherenceRate, .bestRoutine, .bestTimeSlot, .hasDueOccurrences (+13 more)

### Community 1 - "SettingsViewModel"
Cohesion: 0.08
Nodes (17): StaticAppInfoProvider, SettingMenu, bodyProfile, dailyLimit, .id, mainIcon, withdrawal, MainIconSettingView (+9 more)

### Community 2 - "WatchHydrationUndoTests.swift"
Cohesion: 0.12
Nodes (9): HealthKit, MulimiHealthKit, WatchDailyGoalRepository, UndoDailyGoalRepository, UndoHealthStore, Synchronization, WatchHydrationData, WatchHydrationDomain (+1 more)

### Community 4 - "HydrationRoutine"
Cohesion: 0.06
Nodes (11): MockRoutineUseCase, MockRoutineUseCaseForTesting, StarterPlanRoutineStub, RoutineStorageDataSourceImpl, HydrationRoutine, RoutineNotificationAuthorizationStatus, authorized, denied (+3 more)

### Community 5 - "MockDrinkWaterUseCase"
Cohesion: 0.10
Nodes (6): HydrationRecordListViewModelTests, RecordRecoveryClock, RecordSpyWidgetTimelineReloader, MockDrinkWaterUseCase, .currentWaterIntakeML, .hasPendingDrinkWater

### Community 6 - "MockHealthKitRepository"
Cohesion: 0.14
Nodes (5): HealthKitUseCaseImpl, .authorisationStatus, HealthKitUseCaseTests, MockHealthKitRepository, .authorisationStatus

### Community 7 - "MockUserPreferencesUseCase"
Cohesion: 0.17
Nodes (5): NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, MockUserPreferencesUseCase

### Community 8 - "DrinkWaterView"
Cohesion: 0.09
Nodes (20): AppReviewRequestTaskID, DrinkWaterView, .actionButtons, .appReviewRequestTaskID, .completionText, .defaultDrinkButton, .defaultDrinkButtonAccessibilityLabel, .defaultDrinkButtonBackground (+12 more)

### Community 9 - "HealthKitQuantityStore"
Cohesion: 0.18
Nodes (4): HealthKitQuantityStore, .isHealthDataAvailable, HealthQuantitySample, HealthQuantityStoring

### Community 10 - ".assemble"
Cohesion: 0.10
Nodes (9): RootView, AppSession, SignInView, .body, AuthenticationViewModel, .isAuthenticated, AuthenticationViewModelTests, MockSignInUseCase (+1 more)

### Community 11 - "Docs Index"
Cohesion: 0.09
Nodes (33): PostHog Analytics Consolidation, Documentation SSOT Map, Docs Index, Personalized Challenge Strategy, Personalized Challenge Recommendation Candidates, Challenge Recommendation Tier Rules, Analytics Events, Analytics Event Catalog (+25 more)

### Community 12 - "HydrationStarterPlanViewModel"
Cohesion: 0.09
Nodes (15): HydrationStarterPlanRepository, HydrationStarterPlanView, .body, .checklist, HydrationReadFailureView, .body, HydrationStarterPlanViewModel, .completedStepCount (+7 more)

### Community 13 - "HydrationReminderLogResult"
Cohesion: 0.29
Nodes (4): HydrationReminderLogResult, failed, goalExceeded, saved

### Community 14 - "DrinkWaterViewModel"
Cohesion: 0.08
Nodes (19): .body, .overflowMenu, CustomHydrationAmountValidation, empty, invalid, overLimit, valid, DrinkWaterViewModel (+11 more)

### Community 15 - "ResetUseCase"
Cohesion: 0.14
Nodes (10): .body, Action, drink, load, reset, ResetClock, .date, ResetUseCase (+2 more)

### Community 16 - "HydrationChallenge"
Cohesion: 0.08
Nodes (32): MockChallengeUseCase, HydrationChallenge, .id, HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType (+24 more)

### Community 17 - "HealthKitPermissionViewModel"
Cohesion: 0.12
Nodes (9): .body, .body, .permissionView, HealthKitPermissionViewModel, .defaultErrorMessage, .deniedMessage, HealthKitPermissionViewModelTests, MockHealthKitUseCase (+1 more)

### Community 18 - "MockRoutineRepository"
Cohesion: 0.15
Nodes (4): RoutineUseCaseImpl, RoutineRecommendationUseCaseTests, RoutineUseCaseTests, MockRoutineRepository

### Community 19 - ".tr"
Cohesion: 0.05
Nodes (32): HealthKitPermissionGateView, .accessCard, .descriptionText, .footnoteText, .headerColor, .headerSection, .headerSystemImage, .primaryButtonHint (+24 more)

### Community 20 - ".drinkWater"
Cohesion: 0.12
Nodes (5): State, UndoGate, .isWaiting, UndoQuantityStore, WatchHydrationUndoTests

### Community 21 - "BodyProfile"
Cohesion: 0.10
Nodes (10): MockHealthKitUseCase, BodyProfile, .isComplete, .isEmpty, BodyProfileSource, healthKit, manual, BodyProfileValue (+2 more)

### Community 22 - "HydrationStarterPlan"
Cohesion: 0.10
Nodes (10): PreviewStarterPlanRepository, HydrationStarterPlanRepositoryImpl, HydrationStarterPlanRepositoryTests, HydrationQuickRecordingMethod, shortcuts, watch, widget, HydrationStarterPlan (+2 more)

### Community 23 - "MockDrinkWaterRepository"
Cohesion: 0.13
Nodes (6): DrinkWaterUseCaseImpl, .currentWaterIntakeML, DrinkWaterUseCaseTests, ReminderLoggingTests, MockDrinkWaterRepository, .currentWaterIntakeML

### Community 24 - ".tr"
Cohesion: 0.14
Nodes (18): WatchL10n, WatchMetricRow, .body, WatchNavigationCard, .body, WatchProgressBar, .body, WatchReadFailureView (+10 more)

### Community 26 - "SpyRoutineUseCase"
Cohesion: 0.09
Nodes (6): ProfileRoutineViewModelTests, SpyDrinkWaterUseCase, .currentWaterIntakeML, SpyRoutineRecommendationUseCase, SpyRoutineUseCase, SpyUserPreferencesUseCase

### Community 27 - "HydrationRoutineRecommendation"
Cohesion: 0.13
Nodes (6): MockRoutineRecommendationUseCase, HydrationRoutineRecommendation, DaySummary, RoutineRecommendationUseCaseImpl, .timeText, .weekdayText

### Community 28 - "ContentView"
Cohesion: 0.13
Nodes (15): AppCoordinator, AppRoute, hydrationLogging, hydrationStarterPlan, .id, .presentationStyle, profileRoutineAction, NavigationRoute (+7 more)

### Community 30 - "Localization"
Cohesion: 0.09
Nodes (12): ActivityKit, AlarmKit, AppIntents, Charts, CryptoKit, DesignSystem, Localization, HydrationPresentationShaderBundleToken (+4 more)

### Community 31 - "HydrationReminderPermissionViewModel"
Cohesion: 0.09
Nodes (6): HydrationReminderUseCase, .primingView, Constant, HydrationReminderPermissionViewModel, HydrationReminderPermissionViewModelTests, MockHydrationReminderUseCase

### Community 32 - "SignInUseCaseImpl"
Cohesion: 0.16
Nodes (5): SignInUseCaseImpl, .isAuthenticated, SignInUseCaseTests, MockAuthenticationRepository, .isAuthenticated

### Community 33 - "PersonalizedHydrationChallenge"
Cohesion: 0.08
Nodes (14): MockPersonalizedChallengeUseCase, MockPersonalizedChallengeUseCaseForTesting, HydrationChallengeRecommendationSource, recentRecords, routine, PersonalizedHydrationChallenge, .id, PersonalizedHydrationChallengeKind (+6 more)

### Community 34 - "RecordCalendarView"
Cohesion: 0.07
Nodes (33): CalendarDayView, .accessibilityLabel, .backgroundColor, .body, .borderColor, .dayNumber, .progressPercentage, HydrationProgressBar (+25 more)

### Community 35 - "AppReviewRequestState"
Cohesion: 0.06
Nodes (14): AppReviewRequestStorageDataSource, AppReviewRequestStorageDataSourceImpl, AppReviewRequestRepositoryImpl, AppReviewRequestStorageDataSourceTests, AppReviewRequestState, AppReviewRequestRepository, AppReviewRequestUseCase, NoOpAppReviewRequestUseCase (+6 more)

### Community 36 - ".loadInsights"
Cohesion: 0.23
Nodes (4): HydrationInsightViewModelTests, InsightRecoveryClock, SpyRoutineUseCase, MockHydrationRoutineAdherenceUseCase

### Community 37 - "RoutineRepositoryImpl"
Cohesion: 0.14
Nodes (7): RoutineNotificationDataSource, RoutineStorageDataSource, RoutineRepositoryImpl, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource, SpyRoutineStorageDataSource, RoutineRepository

### Community 38 - "StackRouting"
Cohesion: 0.09
Nodes (5): DeepLinkHandling, FullScreenRouting, SheetRouting, StackRouting, .hasPath

### Community 39 - "String"
Cohesion: 0.07
Nodes (15): .postHogValue, AnalyticsParameterName, AnalyticsParameterValue, bool, double, int, string, ProductAnalyticsEvent (+7 more)

### Community 40 - "HydrationGoalRecommendationViewModel"
Cohesion: 0.08
Nodes (17): DailyLimitSettingView, .body, HydrationGoalRecommendationUseCase, HydrationProgressUseCase, EntryDestination, bodyProfileSetting, dailyLimitSetting, GoalAlignment (+9 more)

### Community 42 - "HydrationWriteResult"
Cohesion: 0.07
Nodes (14): .analyticsFailureReason, HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, HydrationWriteResult, failure, .failureReason (+6 more)

### Community 43 - "MockHydrationReminderRepository"
Cohesion: 0.15
Nodes (3): HydrationReminderUseCaseImpl, HydrationReminderUseCaseTests, MockHydrationReminderRepository

### Community 44 - "HydrationPresentation"
Cohesion: 0.09
Nodes (10): AccountPresentation, ChallengePresentation, DependencyInjection, HydrationPresentation, HydrationReminderDomain, HydrationReminderPresentation, MulimiNavigation, HydrationReminderAnalyticsParameterName (+2 more)

### Community 45 - "RoutineActionIntent"
Cohesion: 0.11
Nodes (16): .id, HydrationInsightEmptyAction, dailyGoal, record, routine, HydrationWeeklyCoachingAction, dailyGoal, none (+8 more)

### Community 46 - "Equatable"
Cohesion: 0.08
Nodes (29): PersonalizedChallengeCardModel, .servingOptions, HydrationServingOptionModel, .volumeText, HydrationInsightEmptyCTAModel, HydrationRecordWeekDayItem, .hasRecord, .id (+21 more)

### Community 47 - "Foundation"
Cohesion: 0.08
Nodes (9): ChallengeDomain, CoreGraphics, Foundation, FoundationModels, HydrationDomain, MulimiAnalytics, Observation, PostHog (+1 more)

### Community 48 - "UserDefaults"
Cohesion: 0.13
Nodes (10): HydrationComebackRepositoryImpl, HydrationComebackRepositoryTests, UserDefaults, .appGroup, .dailyLimit, .glassesOfToday, .hasCompletedOnboarding, .mainIcon (+2 more)

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.08
Nodes (7): MockHydrationReminderUseCaseForTesting, HydrationReminderAuthorizationStatus, authorized, denied, notDetermined, .analyticsValue, ProductAnalyticsEvent

### Community 50 - "WatchHydrationViewModel"
Cohesion: 0.09
Nodes (13): 실행·공유 경계, WatchDIContainer, WatchHydrationResetConfirmation, WatchResetConfirmationView, .dateText, MutationAction, record, reset (+5 more)

### Community 51 - "HydrationReminderRepositoryImpl"
Cohesion: 0.25
Nodes (6): HydrationReminderNotificationDataSource, HydrationReminderStorageDataSource, HydrationReminderRepositoryImpl, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource

### Community 52 - "HydrationRecord"
Cohesion: 0.09
Nodes (5): MockHealthKitUseCaseForTesting, HydrationRecord, HydrationRecordRow, .body, .dateString

### Community 53 - "HydrationInsightViewModel"
Cohesion: 0.09
Nodes (25): HydrationInsightViewModel, .canRecordRecoveryDrink, .chartUpperBound, .emptyStateCTAs, .hasLoadedInsights, .routineAdherenceInsightText, .routineAdherenceMetrics, .routineAdherenceRows (+17 more)

### Community 54 - "AnalyticsUseCase"
Cohesion: 0.17
Nodes (6): AnalyticsUseCase, NoOpAnalyticsUseCase, WidgetTimelineReloading, UserPreferencesUseCase, DrinkWaterUseCase, HydrationReminderActionHandler

### Community 55 - "BodyProfileViewModel"
Cohesion: 0.10
Nodes (12): MockBodyProfileUseCase, BodyProfileSnapshot, BodyProfileUseCase, MockBodyProfileUseCaseForDomain, BodyProfileViewModel, .availabilityState, .heightSourceText, .helperText (+4 more)

### Community 59 - "HydrationReminderSlot"
Cohesion: 0.17
Nodes (6): HydrationReminderSlot, afternoon, evening, .hour, .minute, morning

### Community 60 - "DrinkWaterEntry"
Cohesion: 0.09
Nodes (19): DrinkWaterLockScreenWidgetEntryView, .accentColor, .body, .circularView, .hydrationContent, .inlineView, .rectangularView, DrinkWaterWidgetEntryView (+11 more)

### Community 61 - "DrinkWaterRepositoryImpl"
Cohesion: 0.13
Nodes (3): DrinkWaterDataSource, DrinkWaterRepositoryImpl, .currentWaterIntakeML

### Community 62 - "MulimiWatchApp"
Cohesion: 0.22
Nodes (5): DrinkWaterApp, .body, MulimiWatchApp, .body, WatchDependencyInjection

### Community 64 - "LogWaterAppIntent"
Cohesion: 0.16
Nodes (4): Constant, FailureReason, LogWaterAppIntent, .resolvedVolumeML

### Community 65 - "ProjectDescription"
Cohesion: 0.12
Nodes (4): PackageDescription, ProjectDescription, ProjectDescriptionHelpers, AppVersion

### Community 66 - "Growth Scorecard"
Cohesion: 0.17
Nodes (12): Cadence And Ownership, Decision Rule, Deferred Scope, Experiment Record, Goal, Growth Scorecard, Input And Health Metrics, Measurement Boundary (+4 more)

### Community 68 - "Top 5"
Cohesion: 0.14
Nodes (13): 1. 로그인 없이 시작, 2. 7일 스타터 플랜, 3. 알림 바로 기록, 4. 제어 센터·액션 버튼 기록, 5. 컴백 모드, Candidate Ideas, Decision, Engineer (+5 more)

### Community 69 - "MainIcon"
Cohesion: 0.06
Nodes (13): MockUserPreferencesUseCase, MainIcon, cloud, .`default`, drop, heart, .id, .description (+5 more)

### Community 70 - "Test.swift"
Cohesion: 0.18
Nodes (8): ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, .body, TestEntryView, .body

### Community 71 - "#329 빠른 물 기록 가이드 제작·발행"
Cohesion: 0.11
Nodes (18): #329 빠른 물 기록 가이드 제작·발행, Capture Assets, Community Draft, Completion Notes, Constraints, Context, Device Verification, First-Use Check (+10 more)

### Community 72 - "RoutineNotificationDataSourceImpl"
Cohesion: 0.16
Nodes (3): Constant, RoutineAlarmMetadata, RoutineNotificationDataSourceImpl

### Community 73 - "HydrationRecordListViewModel"
Cohesion: 0.09
Nodes (19): HydrationRecordListView, .body, RowListView, .body, .body, .recordListSection, .yearMonthPickerSheet, HydrationRecordDaySummary (+11 more)

### Community 74 - "HydrationGoalRecommendationUnavailableReason"
Cohesion: 0.19
Nodes (8): HydrationGoalRecommendationDataSource, HydrationGoalRecommendationRepositoryImpl, HydrationGoalRecommendationUnavailableReason, appleIntelligenceNotEnabled, deviceNotEligible, modelNotReady, unknown, unsupportedLocale

### Community 75 - "OnboardingViewModel"
Cohesion: 0.10
Nodes (14): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+6 more)

### Community 78 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.17
Nodes (5): HydrationGoalRecommendationRepository, Constants, HydrationGoalRecommendationUseCaseImpl, HydrationGoalRecommendationUseCaseTests, MockHydrationGoalRecommendationRepository

### Community 79 - "HydrationEvent"
Cohesion: 0.07
Nodes (5): MockDrinkWaterUseCase, .currentWaterIntakeML, MockDrinkWaterUseCaseForTesting, .currentWaterIntakeML, HydrationEvent

### Community 81 - "Color"
Cohesion: 0.06
Nodes (35): ChallengeBadge, .body, ChallengeCard, .accentColor, .body, .cardBackground, ChallengeCategory, .id (+27 more)

### Community 82 - "BodyProfileAvailability"
Cohesion: 0.12
Nodes (12): BodyProfileAvailability, incomplete, needsPermission, noData, permissionDenied, ready, State, bodyProfileRequired (+4 more)

### Community 83 - "#336 Watch 최근 기록 한 건 되돌리기"
Cohesion: 0.20
Nodes (10): #336 Watch 최근 기록 한 건 되돌리기, Completion Notes, Constraints, Context, Goal, Non-Goals, Open Questions, Plan (+2 more)

### Community 84 - ".loadChallenges"
Cohesion: 0.28
Nodes (3): ChallengeViewModelTests, MockChallengeUseCase, MockPersonalizedChallengeUseCase

### Community 85 - "AppleSignInCredential"
Cohesion: 0.17
Nodes (4): AuthenticationServices, AppleSignInCredential, AppleSignInDataSourceImpl, AppleSignInDelegate

### Community 87 - "Mulimi Drop — v3"
Cohesion: 0.17
Nodes (10): Generation and editing — Mulimi Drop v3, Original body layer prompt, Original face layer prompt, Original master prompt, Mulimi Drop — v3, 레이어, 배경과 외관, 앱 적용 (+2 more)

### Community 88 - "LiquidGlassSegmentedControl"
Cohesion: 0.07
Nodes (22): Provider, StartTimerIntent, TestControl, .body, TimerConfiguration, Value, .categoryPicker, HydrationInsightCategory (+14 more)

### Community 89 - "AuthTokens"
Cohesion: 0.29
Nodes (3): AuthenticationNetworkDataSource, AuthenticationNetworkDataSourceImpl, AuthTokens

### Community 90 - "AppDelegate"
Cohesion: 0.09
Nodes (14): App · 조립 루트 — 8개, Core — 6개, Features — 18개, Shared — 5개, Tests — 16개, 검증과 갱신, 기능 간 직접 의존에서 주의할 점, 디렉터리와 소유권 (+6 more)

### Community 91 - "ReadRecoveryRepository"
Cohesion: 0.24
Nodes (4): ReadRecoveryGoal, ReadRecoveryRepository, WatchHydrationReadRecoveryTests, WatchReadRecoveryClock

### Community 92 - "HydrationReminderActionResult"
Cohesion: 0.17
Nodes (9): completed, HydrationReminderActionResult, duplicate, failed, goalExceeded, permissionRequired, protectedDataUnavailable, saved (+1 more)

### Community 93 - "HydrationGoalRecommendationAvailability"
Cohesion: 0.17
Nodes (6): MockHydrationGoalRecommendationUseCase, HydrationGoalRecommendationAvailability, bodyProfileRequired, modelUnavailable, ready, MockHydrationGoalRecommendationUseCase

### Community 94 - "Hashable"
Cohesion: 0.15
Nodes (8): Constants, FoundationModelsHydrationGoalRecommendationDataSource, GeneratedHydrationGoalRecommendation, HydrationGoalRecommendation, HydrationGoalRecommendationError, bodyProfileRequired, modelUnavailable, HydrationGoalRecommendationInput

### Community 96 - "Security And Privacy Operations"
Cohesion: 0.08
Nodes (19): HealthKit Source of Truth, Reliability Recovery, Shared Hydration Rules, Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling (+11 more)

### Community 97 - "AccountDomain"
Cohesion: 0.07
Nodes (5): AccountDomain, HydrationData, MulimiKeychain, MulimiPlatform, Testing

### Community 98 - "RoutineEditorDraft"
Cohesion: 0.31
Nodes (4): .weekdayGrid, RoutineEditorDraft, .canSave, .isEditing

### Community 99 - "PersonalizedChallengeUseCaseImpl"
Cohesion: 0.15
Nodes (7): HydrationChallengeTier, beginner, steady, stretch, Constants, PersonalizedChallengeUseCaseImpl, PersonalizedChallengeUseCaseTests

### Community 100 - "LogWaterAmountOption"
Cohesion: 0.18
Nodes (8): LogWaterAmountOption, bottle, custom, glass, .presetID, .servingType, tumbler, .volumeML

### Community 101 - "AGENTS.md Onboarding Map"
Cohesion: 0.10
Nodes (19): Profile Information Architecture, Profile Root, Settings Screen, Quality Gates, Validation Baseline, Validation Matrix, architecture-boundary, Clean Architecture and MVVM (+11 more)

### Community 102 - ".recordWater"
Cohesion: 0.19
Nodes (3): HydrationReminderNotification, .category, HydrationReminderNotificationTests

### Community 103 - "HealthKitAuthorizationStatus"
Cohesion: 0.26
Nodes (6): HealthKitAuthorizationStatus, notDetermined, sharingAuthorized, sharingDenied, .analyticsValue, ProductAnalyticsEvent

### Community 104 - "Sendable"
Cohesion: 0.10
Nodes (8): MockHydrationNextActionGuideUseCase, MockHydrationNextActionGuideUseCaseForTesting, MockHydrationRoutineAdherenceUseCaseForTesting, MockRoutineRecommendationUseCaseForTesting, ReadRecoveryClock, HydrationNextActionGuideUseCase, HydrationRoutineAdherenceUseCase, RoutineRecommendationUseCase

### Community 105 - "Error"
Cohesion: 0.20
Nodes (9): MockSignInError, deleteAccountFailed, signInFailed, TestError, scheduleFailed, MockError, failed, TestError (+1 more)

### Community 107 - "HydrationServingPreset"
Cohesion: 0.17
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

### Community 111 - "BundleAppInfoProvider"
Cohesion: 0.43
Nodes (4): AppInfoProviding, BundleAppInfoProvider, .appBuildNumber, .appVersion

### Community 112 - "AppDelegate.swift"
Cohesion: 0.25
Nodes (3): HydrationReminderData, OSLog, UserNotifications

### Community 113 - "WatchHydrationEvent"
Cohesion: 0.06
Nodes (11): WatchHydrationEvent, WatchHydrationMutationResult, WatchHydrationSnapshot, .eventCount, .isGoalReached, .lastDrinkDate, .progress, .remainingML (+3 more)

### Community 114 - "NavigationPresentationStyle"
Cohesion: 0.40
Nodes (4): NavigationPresentationStyle, fullScreenCover, push, sheet

### Community 115 - "AnalyticsRepository"
Cohesion: 0.22
Nodes (3): Release Filter, AnalyticsRepository, NoOpAnalyticsRepository

### Community 117 - "UserPreferencesDataSourceImpl"
Cohesion: 0.13
Nodes (4): Constants, UserPreferencesDataSource, UserPreferencesDataSourceImpl, UserPreferencesRepositoryImpl

### Community 118 - "TokenProperty"
Cohesion: 0.18
Nodes (7): KeyChainDataSourceImpl, TokenProperty, accessToken, email, nickname, refreshToken, userIdentifier

### Community 120 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 121 - "AuthenticationError"
Cohesion: 0.29
Nodes (6): AuthenticationError, cancelled, invalidCredential, networkFailed, serverError, unknown

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (6): ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 125 - "아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법"
Cohesion: 0.20
Nodes (10): Apple Watch에서 기록하기, Siri·단축어로 기록하기, Siri에게 말하기, 기록이 저장됐는지 확인하기, 내게 맞는 방법 고르기, 단축어 앱에서 실행, 설정하거나 기록하다 막혔다면, 아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법 (+2 more)

### Community 126 - ".makeModelContainer"
Cohesion: 0.19
Nodes (7): SharedHydrationStore, .isICloudAccountAvailable, SharedHydrationStoreError, .errorDescription, failedToCreateContainer, missingAppGroupContainer, SwiftData

### Community 127 - "#350 HealthKit 조회 실패 복구"
Cohesion: 0.33
Nodes (6): #350 HealthKit 조회 실패 복구, 검증 기록, 경계, 목적, 작업 순서, 추가 검증의 제한

### Community 129 - "WaterDropShaders.metal"
Cohesion: 0.43
Nodes (3): mulimiWaterDistortion(), mulimiWaterLighting(), mulimiWaveNoise()

### Community 130 - ".resolve"
Cohesion: 0.16
Nodes (7): DIContainer, .resolver, PreviewViews, .challenge, .drinkWater, .hydrationList, .profile

### Community 131 - "HydrationNextActionGuide"
Cohesion: 0.14
Nodes (10): Constants, HydrationNextActionGuide, .progress, HydrationNextActionGuideState, approachingRoutine, goalReached, needsGoal, readyToDrink (+2 more)

### Community 132 - "#320 — 7일 스타터 플랜 제품 적용"
Cohesion: 0.20
Nodes (9): #320 — 7일 스타터 플랜 제품 적용, Constraints And Decisions, Context, Goal, Implementation Notes (2026-09-14), Non-Goals, Plan, Rollback (+1 more)

### Community 133 - "Mulimi"
Cohesion: 0.11
Nodes (21): Local Validation Reporting, Mulimi Pull Request Template, PR Review Checklist, Agent Onboarding Guide, Graphify-Assisted Code Navigation, Hydration Source of Truth, Mulimi Architecture SSOT, Core User Flow (+13 more)

### Community 134 - "RoutineWeekday"
Cohesion: 0.10
Nodes (15): .localeWeekday, .nextActionSchedule, RoutineWeekday, .displayOrder, friday, .id, monday, saturday (+7 more)

### Community 135 - "DrinkWaterRepository"
Cohesion: 0.09
Nodes (5): UserPreferencesRepository, DrinkWaterRepository, HydrationNextActionGuideUseCaseImpl, HydrationRoutineAdherenceUseCaseImpl, RoutineUseCase

### Community 136 - "WatchDailyGoalLocalDataSource"
Cohesion: 0.20
Nodes (4): MulimiCloudKit, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, WatchDailyGoalRepositoryImpl

### Community 137 - "View"
Cohesion: 0.06
Nodes (28): ProfileView, .body, .goalRecommendationCard, .goalRecommendationRoute, .routineCard, BadgeView, .body, HydrationInsightView (+20 more)

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "HealthKitRepository"
Cohesion: 0.18
Nodes (3): HealthKitRepository, BodyProfileUseCaseImpl, BodyProfileUseCaseTests

### Community 144 - ".assemble"
Cohesion: 0.24
Nodes (4): PreviewAssembly, DataAssembly, DomainAssembly, PresentationAssembly

### Community 145 - "HealthKitError"
Cohesion: 0.33
Nodes (5): HealthKitError, healthKitInternalError, incompleteExecuteQuery, invalidObjectType, permissionDenied

### Community 146 - "Test"
Cohesion: 0.10
Nodes (13): Test, TestBundle, .body, TestLiveActivity, .body, DrinkWaterLockScreenWidget, .body, DrinkWaterWidget (+5 more)

### Community 148 - "HydrationChallengeBadgeHistory"
Cohesion: 0.14
Nodes (5): HydrationChallengeBadgeHistory, ChallengeRepository, ChallengeEvaluation, ChallengeMergeResult, ChallengeUseCaseImpl

### Community 151 - "ProfileRoutineViewModel"
Cohesion: 0.08
Nodes (20): .body, RoutineEditorView, .body, ProfileRoutineViewModel, .activeRoutineCount, .canSaveDraft, .displayedRoutines, .editorPermissionGuidance (+12 more)

### Community 152 - "MockAnalyticsUseCase"
Cohesion: 0.12
Nodes (4): HydrationComebackRepository, .comebackSummary, StubHydrationComebackRepository, MockAnalyticsUseCase

### Community 153 - "HydrationReminderPermissionGateView"
Cohesion: 0.40
Nodes (4): HydrationReminderPermissionGateView, .allowButtonLabel, .body, .headerSection

### Community 154 - "ChallengeViewModel"
Cohesion: 0.12
Nodes (5): ChallengeUseCase, ChallengeCardModel, ChallengeHistoryCardModel, ChallengeViewModel, .hasLoadedChallenges

### Community 155 - "Challenge State Model"
Cohesion: 0.50
Nodes (4): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Recurring Challenge State

### Community 156 - "Completed Plan Archive"
Cohesion: 0.40
Nodes (5): Stale Document Handling, Active Exec Plans, Active Plan Lifecycle, Completed Exec Plans, Completed Plan Archive

### Community 157 - "AuthProvider"
Cohesion: 0.40
Nodes (4): AuthProvider, apple, google, kakao

### Community 158 - "HealthQuantityStoreError"
Cohesion: 0.40
Nodes (5): HealthQuantityStoreError, incompleteQuery, internalError, invalidObjectType, permissionDenied

### Community 160 - "Generation — Mulimi Water Glass v2"
Cohesion: 0.25
Nodes (6): droplet, Generation — Mulimi Water Glass v2, glass, Master, water, Mulimi — Water Glass v2

### Community 163 - "HydrationGoalRecommendationCard"
Cohesion: 0.18
Nodes (7): BodyProfileSettingView, .body, .healthSyncCard, .summaryCard, HydrationGoalRecommendationCard, .body, .content

### Community 164 - "ChallengeStorageDataSourceImpl"
Cohesion: 0.29
Nodes (4): ChallengeStorageDataSource, ChallengeStorageDataSourceImpl, ChallengeRepositoryImpl, ChallengeStorageDataSourceTests

### Community 166 - "#321 수분 알림 바로 기록"
Cohesion: 0.18
Nodes (11): #321 수분 알림 바로 기록, Completion Notes, Constraints, Context, Goal, Non-Goals, Open Questions, Plan (+3 more)

### Community 168 - "DataAssembly.swift"
Cohesion: 0.18
Nodes (5): AccountData, ChallengeData, MulimiAnalyticsData, RoutineData, Utils

### Community 169 - "Release And QA Runbook"
Cohesion: 0.50
Nodes (4): 72-Hour Audit, Before Release, Release Activity Check, Release And QA Runbook

### Community 171 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, challenge, drink, history, insight, profile

### Community 173 - "HydrationComebackMode"
Cohesion: 0.50
Nodes (4): HydrationComebackMode, baseline, card, disabled

### Community 174 - "RoutineError"
Cohesion: 0.50
Nodes (3): RoutineError, permissionDenied, scheduleFailed

### Community 175 - "HydrationRecordPeriod"
Cohesion: 0.33
Nodes (6): HydrationRecordPeriod, .id, month, .title, today, week

### Community 177 - "Layer Responsibilities"
Cohesion: 0.11
Nodes (15): AI PR Review Workflow, Architecture Review Policy, Git Flow PR Filter, Textual Diff Selection, CI Lint and Architecture Gate, Lint Workflow, Domain Data Presentation Test Matrix, PR Unit Tests Workflow (+7 more)

### Community 178 - "MockUserPreferencesRepository"
Cohesion: 0.18
Nodes (3): UserPreferencesUseCaseImpl, UserPreferencesUseCaseTests, MockUserPreferencesRepository

### Community 179 - "HealthKitDataSourceImpl"
Cohesion: 0.09
Nodes (7): HealthKitDataSource, HealthKitDataSourceImpl, .healthKitAuthorizationStatus, .isWaterSharingAuthorized, HealthKitRepositoryImpl, .authorisationStatus, .isWaterSharingAuthorized

### Community 186 - "HydrationProgressSnapshot"
Cohesion: 0.12
Nodes (4): MockHydrationProgressUseCase, MockHydrationProgressUseCaseForTesting, HydrationProgressSnapshot, MockHydrationProgressUseCase

### Community 187 - "AuthenticationRepositoryImpl"
Cohesion: 0.15
Nodes (5): AppleSignInDataSource, KeyChainDataSource, AuthenticationRepositoryImpl, .isAuthenticated, AuthenticationRepository

### Community 192 - "LogWaterAppShortcuts"
Cohesion: 0.33
Nodes (3): LogWaterAppShortcuts, .appShortcuts, .shortcutTileColor

## Ambiguous Edges - Review These
- `CloudKit-Backed Hydration Store` → `HealthKit Source of Truth`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to
- `CloudKit-Backed Hydration Store` → `Current Storage Strategy`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to

## Knowledge Gaps
- **576 isolated node(s):** `.resolver`, `production`, `preview`, `testing`, `.current` (+571 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1051 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **39 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `HealthKit Source of Truth`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `Current Storage Strategy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `String` connect `String` to `HydrationRoutineAdherenceInsight`, `SettingsViewModel`, `HydrationRoutine`, `MockDrinkWaterUseCase`, `DrinkWaterView`, `HealthKitQuantityStore`, `.assemble`, `HydrationStarterPlanViewModel`, `HydrationReminderLogResult`, `DrinkWaterViewModel`, `HydrationChallenge`, `HealthKitPermissionViewModel`, `.tr`, `.drinkWater`, `BodyProfile`, `HydrationStarterPlan`, `MockDrinkWaterRepository`, `.tr`, `UUID`, `SpyRoutineUseCase`, `HydrationRoutineRecommendation`, `ContentView`, `PostHogAnalyticsRepository`, `HydrationReminderPermissionViewModel`, `PersonalizedHydrationChallenge`, `RecordCalendarView`, `AppReviewRequestState`, `HydrationGoalRecommendationViewModel`, `UnavailableHealthStore`, `HydrationWriteResult`, `RoutineActionIntent`, `Equatable`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `WatchHydrationViewModel`, `HydrationRecord`, `HydrationInsightViewModel`, `AnalyticsUseCase`, `BodyProfileViewModel`, `DrinkWaterHealthKitDataSource`, `HydrationReminderSlot`, `DrinkWaterEntry`, `UserCredential`, `LogWaterAppIntent`, `ProjectDescription`, `HealthKitSource`, `MainIcon`, `RoutineNotificationDataSourceImpl`, `HydrationRecordListViewModel`, `OnboardingViewModel`, `HydrationEvent`, `.fetchChallenges`, `Color`, `AppleSignInCredential`, `MockAppReviewRequestUseCase`, `LiquidGlassSegmentedControl`, `AuthTokens`, `HydrationReminderActionResult`, `Hashable`, `RoutineEditorDraft`, `PersonalizedChallengeUseCaseImpl`, `LogWaterAmountOption`, `.recordWater`, `HealthKitAuthorizationStatus`, `HydrationServingPreset`, `ConfigurationAppIntent`, `MockError`, `BundleAppInfoProvider`, `AnalyticsRepository`, `HydrationRoutineSchedule`, `UserPreferencesDataSourceImpl`, `TokenProperty`, `AuthenticationError`, `UbiquitousMirroredStore`, `ContentState`, `.makeModelContainer`, `HydrationNextActionGuide`, `RoutineWeekday`, `View`, `AnalyticsUseCaseImpl`, `Test`, `HydrationChallengeBadgeHistory`, `ProfileRoutineViewModel`, `MockAnalyticsUseCase`, `ChallengeViewModel`, `.progressSnapshot`, `HydrationGoalRecommendationCard`, `ChallengeStorageDataSourceImpl`, `MockUserPreferencesUseCaseForTesting`, `HydrationComebackMode`, `HydrationRecordPeriod`, `HealthKitDataSourceImpl`, `AuthenticationRepositoryImpl`?**
  _High betweenness centrality (0.337) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `HydrationRoutineAdherenceInsight`, `WatchHydrationUndoTests.swift`, `HydrationNextActionGuide`, `HydrationRoutine`, `DrinkWaterRepository`, `WatchDailyGoalLocalDataSource`, `HealthKitQuantityStore`, `HealthKitRepository`, `HydrationReminderLogResult`, `HydrationChallenge`, `HealthKitError`, `.tr`, `HydrationChallengeBadgeHistory`, `BodyProfile`, `HydrationStarterPlan`, `MockAnalyticsUseCase`, `.tr`, `ChallengeViewModel`, `HydrationRoutineRecommendation`, `AuthProvider`, `Localization`, `HydrationReminderPermissionViewModel`, `SignInUseCaseImpl`, `AppReviewRequestState`, `RoutineRepositoryImpl`, `StackRouting`, `String`, `DataAssembly.swift`, `HydrationGoalRecommendationViewModel`, `HydrationWriteResult`, `MockHydrationReminderRepository`, `HydrationPresentation`, `HydrationReminderRepository`, `RoutineActionIntent`, `RoutineError`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `WatchHydrationViewModel`, `HydrationRecord`, `HydrationInsightViewModel`, `AnalyticsUseCase`, `BodyProfileViewModel`, `HealthKitUseCase`, `HydrationProgressSnapshot`, `AuthenticationRepositoryImpl`, `HydrationReminderSlot`, `SignInUseCase`, `UserCredential`, `MainIcon`, `HydrationGoalRecommendationUseCaseImpl`, `HydrationEvent`, `BodyProfileAvailability`, `AppleSignInCredential`, `AuthTokens`, `ReadRecoveryRepository`, `Hashable`, `AccountDomain`, `HealthKitAuthorizationStatus`, `Sendable`, `HydrationServingPreset`, `BundleAppInfoProvider`, `AppDelegate.swift`, `WatchHydrationEvent`, `TokenProperty`, `DIEnvironment`, `AuthenticationError`, `UbiquitousMirroredStore`, `.makeModelContainer`?**
  _High betweenness centrality (0.074) - this node is a cross-community bridge._
- **Why does `HydrationWriteResult` connect `HydrationWriteResult` to `MockDrinkWaterUseCase`, `String`, `Sendable`, `UnavailableHealthStore`, `Equatable`, `HydrationEvent`, `Foundation`, `WatchHydrationEvent`, `WatchHydrationViewModel`, `.drinkWater`, `HydrationInsightViewModel`, `MockDrinkWaterRepository`, `DrinkWaterHealthKitDataSource`, `UUID`, `SpyRoutineUseCase`, `ReadRecoveryRepository`, `Localization`?**
  _High betweenness centrality (0.048) - this node is a cross-community bridge._
- **Are the 23 inferred relationships involving `HydrationInsightViewModel` (e.g. with `.assemble()` and `.assemble()`) actually correct?**
  _`HydrationInsightViewModel` has 23 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.resolver`, `production`, `preview` to the rest of the system?**
  _576 weakly-connected nodes found - possible documentation gaps or missing edges._