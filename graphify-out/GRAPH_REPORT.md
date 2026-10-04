# Graph Report - Mulimi  (2026-10-04)

## Corpus Check
- 404 files · ~203,526 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 22 file(s) not represented in the graph (top: .entitlements 6, .plist 5, (none) 3)

## Summary
- 4062 nodes · 10887 edges · 191 communities (151 shown, 40 thin omitted)
- Extraction: 84% EXTRACTED · 16% INFERRED · 0% AMBIGUOUS · INFERRED: 1730 edges (avg confidence: 0.84)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `2b39e7df`
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
- Hydration Logging
- HydrationStarterPlanViewModel
- DrinkWaterUseCase
- DrinkWaterViewModel
- MulimiAnalytics
- HydrationChallengeKind
- HealthKitPermissionViewModel
- MockRoutineRepository
- HealthKitPermissionGateView
- UndoQuantityStore
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
- HydrationProgressSnapshot
- RoutineRepositoryImpl
- SheetRouting
- String
- HydrationGoalRecommendationViewModel
- UnavailableHealthStore
- WatchHydrationEvent
- MockHydrationReminderRepository
- HydrationReminderDomain
- AppReviewRequestUseCaseImpl
- Equatable
- Foundation
- UserDefaults
- HydrationReminderAuthorizationStatus
- LiquidGlassSegmentedControl
- HydrationReminderRepositoryImpl
- HydrationRecord
- .tr
- UserPreferencesUseCase
- BodyProfileViewModel
- DrinkWaterHealthKitDataSource
- AnalyticsUseCase
- .weeklyInsight
- HydrationReminderSlot
- DrinkWaterEntry
- .makeUseCase
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
- RoutineNotificationAuthorizationStatus
- HydrationRecordListViewModel
- HydrationGoalRecommendationUnavailableReason
- OnboardingView
- HydrationProgressUseCaseImpl
- HydrationStarterPlanViewModelTests
- HydrationGoalRecommendationUseCaseImpl
- HydrationEvent
- ProfileRoutineView
- RoutineActionIntent
- HydrationRecordEventRow
- #336 Watch 최근 기록 한 건 되돌리기
- .loadChallenges
- AppleSignInCredential
- MockAppReviewRequestUseCase
- Xcode Cloud Release Build
- Value
- .make
- AppDelegate
- WatchHydrationViewModel
- 프로젝트 전체 구조와 의존성
- HydrationGoalRecommendationAvailability
- HydrationGoalRecommendation
- fix-icon-composer-file-types.py
- Security And Privacy Operations
- AccountDomain
- Sendable
- PersonalizedChallengeUseCaseImpl
- LogWaterAmountOption
- AGENTS.md Onboarding Map
- .recordWater
- HealthKitAuthorizationStatus
- .assemble
- MockHealthKitUseCaseForTesting
- WaterWaveView
- CaseIterable
- Generation prompts
- ConfigurationAppIntent
- MockUserPreferencesUseCase
- StaticAppInfoProvider
- MockUserPreferencesRepository
- WatchHydrationSnapshot
- Hashable
- AnalyticsRepository
- .weeklyInsightCalculatesRoutineRatesAndMissPattern
- UserPreferencesDataSourceImpl
- TokenProperty
- .makeViewModel
- DIEnvironment
- AI PR Review Workflow
- HydrationReminderActionResult
- UbiquitousMirroredStore
- ContentState
- 아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법
- Error
- HydrationWriteResult
- DrinkWaterWidgetProvider
- WaterDropShaders.metal
- DIContainer
- HydrationNextActionGuide
- #320 — 7일 스타터 플랜 제품 적용
- Docs Index
- RoutineWeekday
- DrinkWaterRepository
- WatchDailyGoalLocalDataSource
- HydrationInsightView
- Accessibility and Dynamic Type Audit
- HealthKitRepository
- MockHydrationReminderUseCase
- ci_post_clone.sh
- FoundationModelsHydrationGoalRecommendationDataSource
- .assemble
- StackRouting
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
- .monthPickerRoutingActions
- AuthProvider
- Mulimi Pull Request Template
- HydrationRoutineRecommendationKind
- Generation — Mulimi Water Glass v2
- HydrationReminderStorageDataSourceImpl
- .progressSnapshot
- View
- ChallengeStorageDataSourceImpl
- MockUserPreferencesUseCaseForTesting
- #321 수분 알림 바로 기록
- WatchDataConstants.swift
- DataAssembly.swift
- Reliability Recovery
- HydrationInsightCategory
- AppTab
- HydrationReminderRepository
- Clean Architecture and MVVM
- HydrationRecordPeriod
- L10n
- Layer Responsibilities
- UserPreferencesUseCaseImpl
- HealthKitDataSourceImpl
- MockHydrationNextActionGuideUseCase
- HydrationStarterPlanCard
- GoalAlignment
- NextStep
- .resolve
- .guideCombinesRemainingServingAndNextRoutine
- MockHydrationProgressUseCase
- AuthenticationRepositoryImpl
- CustomHydrationAmountValidation
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
- `4. 제어 센터·액션 버튼 기록` --references--> `LogWaterAppIntent`  [INFERRED]
  Docs/feature-discovery.md → Project/App/Sources/AppIntents/LogWaterAppIntent.swift
- `Engineer` --references--> `LogWaterAppIntent`  [INFERRED]
  Docs/feature-discovery.md → Project/App/Sources/AppIntents/LogWaterAppIntent.swift
- `Release Filter` --references--> `NoOpAnalyticsRepository`  [INFERRED]
  Docs/product-specs/growth-scorecard.md → Project/Core/Analytics/Domain/Sources/Repository/AnalyticsRepository.swift
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

## Communities (191 total, 40 thin omitted)

### Community 0 - "HydrationRoutineAdherenceInsight"
Cohesion: 0.14
Nodes (19): CandidateMatch, Constants, HydrationRoutineAdherenceInsight, .adherenceRate, .bestRoutine, .bestTimeSlot, .hasDueOccurrences, .mostMissedTimeSlot (+11 more)

### Community 1 - "SettingsViewModel"
Cohesion: 0.09
Nodes (15): SettingMenu, bodyProfile, dailyLimit, .id, mainIcon, withdrawal, MainIconSettingView, .body (+7 more)

### Community 2 - "WatchHydrationUndoTests.swift"
Cohesion: 0.12
Nodes (11): 실행·공유 경계, HealthKit, MulimiHealthKit, WatchDIContainer, WatchReadRecoveryClock, UndoDailyGoalRepository, UndoHealthStore, Synchronization (+3 more)

### Community 4 - "HydrationRoutine"
Cohesion: 0.07
Nodes (7): MockRoutineUseCase, MockRoutineUseCaseForTesting, StarterPlanRoutineStub, HydrationRoutine, RoutineUseCase, .timeText, .weekdayText

### Community 5 - "MockDrinkWaterUseCase"
Cohesion: 0.10
Nodes (6): HydrationRecordListViewModelTests, RecordRecoveryClock, RecordSpyWidgetTimelineReloader, MockDrinkWaterUseCase, .currentWaterIntakeML, .hasPendingDrinkWater

### Community 6 - "MockHealthKitRepository"
Cohesion: 0.15
Nodes (5): HealthKitUseCaseImpl, .authorisationStatus, HealthKitUseCaseTests, MockHealthKitRepository, .authorisationStatus

### Community 7 - "MockUserPreferencesUseCase"
Cohesion: 0.17
Nodes (5): NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, MockUserPreferencesUseCase

### Community 8 - "DrinkWaterView"
Cohesion: 0.08
Nodes (21): AppReviewRequestTaskID, DrinkWaterView, .actionButtons, .appReviewRequestTaskID, .completionText, .defaultDrinkButton, .defaultDrinkButtonAccessibilityLabel, .defaultDrinkButtonBackground (+13 more)

### Community 9 - "HealthKitQuantityStore"
Cohesion: 0.19
Nodes (4): HealthKitQuantityStore, .isHealthDataAvailable, HealthQuantitySample, HealthQuantityStoring

### Community 10 - ".assemble"
Cohesion: 0.09
Nodes (11): RootView, .body, SignInUseCase, AppSession, SignInView, .body, AuthenticationViewModel, .isAuthenticated (+3 more)

### Community 11 - "Hydration Logging"
Cohesion: 0.10
Nodes (29): PostHog Analytics Consolidation, Personalized Challenge Strategy, Personalized Challenge Recommendation Candidates, Challenge Recommendation Tier Rules, Analytics Events, Analytics Event Catalog, Product Analytics Event Contract, PostHog Activity QA (+21 more)

### Community 12 - "HydrationStarterPlanViewModel"
Cohesion: 0.11
Nodes (10): HydrationStarterPlanRepository, HydrationStarterPlanView, .body, .checklist, HydrationReadFailureView, .body, HydrationStarterPlanViewModel, .completedStepCount (+2 more)

### Community 13 - "DrinkWaterUseCase"
Cohesion: 0.09
Nodes (8): SystemWidgetTimelineReloader, WidgetTimelineReloading, DrinkWaterUseCase, HydrationReminderLogResult, failed, goalExceeded, saved, HydrationReminderActionHandler

### Community 14 - "DrinkWaterViewModel"
Cohesion: 0.07
Nodes (19): .body, DrinkWaterViewModel, .dailyLimit, .hasCurrentIntake, .isComebackCardVisible, .isFirstRecordGuideActive, .isLimitReached, .mililiters (+11 more)

### Community 15 - "MulimiAnalytics"
Cohesion: 0.17
Nodes (5): CoreGraphics, MulimiAnalytics, Observation, PostHog, RoutinePresentation

### Community 16 - "HydrationChallengeKind"
Cohesion: 0.09
Nodes (29): HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType, streak7, weeklyAchievement80, HydrationChallengeResetPolicy (+21 more)

### Community 17 - "HealthKitPermissionViewModel"
Cohesion: 0.13
Nodes (8): .body, .permissionView, HealthKitPermissionViewModel, .defaultErrorMessage, .deniedMessage, HealthKitPermissionViewModelTests, MockHealthKitUseCase, .authorisationStatus

### Community 18 - "MockRoutineRepository"
Cohesion: 0.13
Nodes (5): RoutineRepository, RoutineUseCaseImpl, RoutineRecommendationUseCaseTests, RoutineUseCaseTests, MockRoutineRepository

### Community 19 - "HealthKitPermissionGateView"
Cohesion: 0.08
Nodes (28): ChallengeBadge, .body, ChallengeCard, .accentColor, .body, .cardBackground, ChallengeHistoryCard, .accentColor (+20 more)

### Community 20 - "UndoQuantityStore"
Cohesion: 0.15
Nodes (4): State, UndoGate, .isWaiting, UndoQuantityStore

### Community 21 - "BodyProfile"
Cohesion: 0.08
Nodes (9): MockHealthKitUseCase, BodyProfile, .isComplete, .isEmpty, BodyProfileSource, healthKit, manual, BodyProfileValue (+1 more)

### Community 22 - "HydrationStarterPlan"
Cohesion: 0.11
Nodes (10): PreviewStarterPlanRepository, HydrationStarterPlanRepositoryImpl, HydrationStarterPlanRepositoryTests, HydrationQuickRecordingMethod, shortcuts, watch, widget, HydrationStarterPlan (+2 more)

### Community 23 - "MockDrinkWaterRepository"
Cohesion: 0.13
Nodes (6): DrinkWaterUseCaseImpl, .currentWaterIntakeML, DrinkWaterUseCaseTests, ReminderLoggingTests, MockDrinkWaterRepository, .currentWaterIntakeML

### Community 24 - ".tr"
Cohesion: 0.14
Nodes (18): WatchL10n, WatchMetricRow, .body, WatchNavigationCard, .body, WatchProgressBar, .body, WatchReadFailureView (+10 more)

### Community 26 - "SpyRoutineUseCase"
Cohesion: 0.10
Nodes (6): ProfileRoutineViewModelTests, SpyDrinkWaterUseCase, .currentWaterIntakeML, SpyRoutineRecommendationUseCase, SpyRoutineUseCase, SpyUserPreferencesUseCase

### Community 27 - "HydrationRoutineRecommendation"
Cohesion: 0.11
Nodes (9): MockRoutineRecommendationUseCase, MockRoutineRecommendationUseCaseForTesting, HydrationRoutineRecommendation, .id, RoutineRecommendationUseCase, DaySummary, RoutineRecommendationUseCaseImpl, .timeText (+1 more)

### Community 28 - "ContentView"
Cohesion: 0.13
Nodes (15): AppCoordinator, AppRoute, hydrationLogging, hydrationStarterPlan, .id, .presentationStyle, profileRoutineAction, NavigationRoute (+7 more)

### Community 30 - "Localization"
Cohesion: 0.09
Nodes (12): ActivityKit, AlarmKit, AppIntents, Charts, CryptoKit, DesignSystem, Localization, HydrationPresentationShaderBundleToken (+4 more)

### Community 31 - "HydrationReminderPermissionViewModel"
Cohesion: 0.11
Nodes (6): HydrationReminderUseCase, .primingView, Constant, HydrationReminderPermissionViewModel, HydrationReminderPermissionViewModelTests, MockHydrationReminderUseCase

### Community 32 - "SignInUseCaseImpl"
Cohesion: 0.16
Nodes (5): SignInUseCaseImpl, .isAuthenticated, SignInUseCaseTests, MockAuthenticationRepository, .isAuthenticated

### Community 33 - "PersonalizedHydrationChallenge"
Cohesion: 0.08
Nodes (14): MockPersonalizedChallengeUseCase, MockPersonalizedChallengeUseCaseForTesting, HydrationChallengeRecommendationSource, recentRecords, routine, PersonalizedHydrationChallenge, .id, PersonalizedHydrationChallengeKind (+6 more)

### Community 34 - "RecordCalendarView"
Cohesion: 0.09
Nodes (24): CalendarDayView, .accessibilityLabel, .backgroundColor, .body, .borderColor, .dayNumber, .progressPercentage, HydrationProgressBar (+16 more)

### Community 35 - "AppReviewRequestState"
Cohesion: 0.14
Nodes (6): AppReviewRequestStorageDataSource, AppReviewRequestStorageDataSourceImpl, AppReviewRequestRepositoryImpl, AppReviewRequestStorageDataSourceTests, AppReviewRequestState, MockAppReviewRequestRepository

### Community 36 - "HydrationProgressSnapshot"
Cohesion: 0.11
Nodes (6): MockHydrationProgressUseCase, MockHydrationProgressUseCaseForTesting, HydrationProgressSnapshot, HydrationInsightViewModelTests, SpyRoutineUseCase, MockHydrationRoutineAdherenceUseCase

### Community 37 - "RoutineRepositoryImpl"
Cohesion: 0.17
Nodes (7): RoutineNotificationDataSource, RoutineStorageDataSource, RoutineStorageDataSourceImpl, RoutineRepositoryImpl, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource, SpyRoutineStorageDataSource

### Community 38 - "SheetRouting"
Cohesion: 0.13
Nodes (3): DeepLinkHandling, FullScreenRouting, SheetRouting

### Community 39 - "String"
Cohesion: 0.08
Nodes (15): .postHogValue, AnalyticsParameterName, AnalyticsParameterValue, bool, double, int, string, ProductAnalyticsEvent (+7 more)

### Community 40 - "HydrationGoalRecommendationViewModel"
Cohesion: 0.11
Nodes (15): DailyLimitSettingView, .body, EntryDestination, bodyProfileSetting, dailyLimitSetting, GoalAlignmentThreshold, HydrationGoalRecommendationViewModel, .entryDescription (+7 more)

### Community 42 - "WatchHydrationEvent"
Cohesion: 0.08
Nodes (5): WatchHydrationHealthKitDataSource, WatchHydrationLocalDataSource, WatchHydrationRepositoryImpl, WatchHydrationEvent, WatchHydrationRepository

### Community 43 - "MockHydrationReminderRepository"
Cohesion: 0.16
Nodes (3): HydrationReminderUseCaseImpl, HydrationReminderUseCaseTests, MockHydrationReminderRepository

### Community 44 - "HydrationReminderDomain"
Cohesion: 0.08
Nodes (11): AccountPresentation, ChallengePresentation, DependencyInjection, HydrationReminderData, HydrationReminderDomain, HydrationReminderPresentation, MulimiNavigation, OSLog (+3 more)

### Community 45 - "AppReviewRequestUseCaseImpl"
Cohesion: 0.23
Nodes (3): AppReviewRequestRepository, AppReviewRequestUseCaseImpl, Policy

### Community 46 - "Equatable"
Cohesion: 0.16
Nodes (18): PersonalizedChallengeCardModel, HydrationInsightEmptyCTAModel, RoutineAdherenceDisplayRow, RoutineAdherenceInsightMetric, RoutineGuidanceMetric, RoutineGuidanceSlot, RoutineGuidanceSummary, RoutineGuidanceTone (+10 more)

### Community 47 - "Foundation"
Cohesion: 0.09
Nodes (5): ChallengeDomain, Foundation, FoundationModels, HydrationDomain, RoutineDomain

### Community 48 - "UserDefaults"
Cohesion: 0.13
Nodes (10): HydrationComebackRepositoryImpl, HydrationComebackRepositoryTests, UserDefaults, .appGroup, .dailyLimit, .glassesOfToday, .hasCompletedOnboarding, .mainIcon (+2 more)

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.09
Nodes (7): MockHydrationReminderUseCaseForTesting, HydrationReminderAuthorizationStatus, authorized, denied, notDetermined, .analyticsValue, ProductAnalyticsEvent

### Community 50 - "LiquidGlassSegmentedControl"
Cohesion: 0.17
Nodes (9): .categoryPicker, LiquidGlassSegment, .id, LiquidGlassSegmentedControl, .activeSegmentBackground, .activeSegmentBorder, .body, .containerBackground (+1 more)

### Community 51 - "HydrationReminderRepositoryImpl"
Cohesion: 0.22
Nodes (5): HydrationReminderStorageDataSource, HydrationReminderRepositoryImpl, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource

### Community 52 - "HydrationRecord"
Cohesion: 0.13
Nodes (4): HydrationRecord, HydrationRecordRow, .body, .dateString

### Community 53 - ".tr"
Cohesion: 0.08
Nodes (28): .body, HydrationInsightViewModel, .canRecordRecoveryDrink, .chartUpperBound, .dailyGoalText, .emptyStateCTAs, .hasLoadedInsights, .monthlyAverageText (+20 more)

### Community 54 - "UserPreferencesUseCase"
Cohesion: 0.18
Nodes (5): UserPreferencesUseCase, OnboardingViewModel, .canGoBack, .isLastPage, OnboardingViewModelTests

### Community 55 - "BodyProfileViewModel"
Cohesion: 0.07
Nodes (20): MockBodyProfileUseCase, BodyProfileAvailability, incomplete, needsPermission, noData, permissionDenied, ready, BodyProfileSnapshot (+12 more)

### Community 56 - "DrinkWaterHealthKitDataSource"
Cohesion: 0.24
Nodes (3): DrinkWaterDataSource, DrinkWaterHealthKitDataSource, .currentWaterIntakeML

### Community 58 - ".weeklyInsight"
Cohesion: 0.15
Nodes (3): MockHydrationRoutineAdherenceUseCase, HydrationRoutineAdherenceUseCase, HydrationRoutineAdherenceUseCaseImpl

### Community 59 - "HydrationReminderSlot"
Cohesion: 0.09
Nodes (10): Constant, HydrationReminderNotificationDataSource, HydrationReminderNotificationDataSourceImpl, .notificationCenter, HydrationReminderSlot, afternoon, evening, .hour (+2 more)

### Community 60 - "DrinkWaterEntry"
Cohesion: 0.11
Nodes (18): DrinkWaterLockScreenWidgetEntryView, .accentColor, .body, .circularView, .hydrationContent, .inlineView, .rectangularView, DrinkWaterWidgetEntryView (+10 more)

### Community 61 - ".makeUseCase"
Cohesion: 0.24
Nodes (3): AppReviewRequestUseCaseTests, .calendar, .referenceDate

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
Cohesion: 0.12
Nodes (17): 72-Hour Audit, Before Release, Cadence And Ownership, Decision Rule, Deferred Scope, Experiment Record, Goal, Growth Scorecard (+9 more)

### Community 67 - "HealthKitSource"
Cohesion: 0.08
Nodes (4): DrinkWaterRepositoryImpl, .currentWaterIntakeML, HealthKitSource, ReminderHealthKitWriteTests

### Community 68 - "Top 5"
Cohesion: 0.14
Nodes (13): 1. 로그인 없이 시작, 2. 7일 스타터 플랜, 3. 알림 바로 기록, 4. 제어 센터·액션 버튼 기록, 5. 컴백 모드, Candidate Ideas, Decision, Engineer (+5 more)

### Community 69 - "MainIcon"
Cohesion: 0.09
Nodes (12): MainIcon, cloud, .`default`, drop, heart, .id, .description, .displayName (+4 more)

### Community 70 - "Test.swift"
Cohesion: 0.19
Nodes (8): ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, .body, TestEntryView, .body

### Community 71 - "#329 빠른 물 기록 가이드 제작·발행"
Cohesion: 0.11
Nodes (18): #329 빠른 물 기록 가이드 제작·발행, Capture Assets, Community Draft, Completion Notes, Constraints, Context, Device Verification, First-Use Check (+10 more)

### Community 72 - "RoutineNotificationAuthorizationStatus"
Cohesion: 0.07
Nodes (7): Constant, RoutineAlarmMetadata, RoutineNotificationDataSourceImpl, RoutineNotificationAuthorizationStatus, authorized, denied, notDetermined

### Community 73 - "HydrationRecordListViewModel"
Cohesion: 0.11
Nodes (19): HydrationRecordListView, .body, RowListView, .body, HydrationRecordDaySummary, .glassCount, .id, HydrationRecordListViewModel (+11 more)

### Community 74 - "HydrationGoalRecommendationUnavailableReason"
Cohesion: 0.19
Nodes (8): HydrationGoalRecommendationDataSource, HydrationGoalRecommendationRepositoryImpl, HydrationGoalRecommendationUnavailableReason, appleIntelligenceNotEnabled, deviceNotEligible, modelNotReady, unknown, unsupportedLocale

### Community 75 - "OnboardingView"
Cohesion: 0.14
Nodes (10): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+2 more)

### Community 78 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.15
Nodes (5): HydrationGoalRecommendationRepository, Constants, HydrationGoalRecommendationUseCaseImpl, HydrationGoalRecommendationUseCaseTests, MockHydrationGoalRecommendationRepository

### Community 79 - "HydrationEvent"
Cohesion: 0.07
Nodes (5): MockDrinkWaterUseCase, .currentWaterIntakeML, MockDrinkWaterUseCaseForTesting, .currentWaterIntakeML, HydrationEvent

### Community 80 - "ProfileRoutineView"
Cohesion: 0.19
Nodes (7): ProfileRoutineView, .guidanceCard, .permissionSection, RoutineGuidanceSlotStatus, elapsed, next, upcoming

### Community 81 - "RoutineActionIntent"
Cohesion: 0.09
Nodes (24): .id, ChallengeCategory, completed, .id, inProgress, recommended, .systemImage, .title (+16 more)

### Community 82 - "HydrationRecordEventRow"
Cohesion: 0.14
Nodes (13): HydrationRecordDaySummaryRow, .body, .progressPercent, HydrationRecordEventRow, .sourceText, .timeText, .volumeText, .recordListSection (+5 more)

### Community 83 - "#336 Watch 최근 기록 한 건 되돌리기"
Cohesion: 0.13
Nodes (11): #336 Watch 최근 기록 한 건 되돌리기, Completion Notes, Constraints, Context, Goal, Non-Goals, Open Questions, Plan (+3 more)

### Community 84 - ".loadChallenges"
Cohesion: 0.28
Nodes (3): ChallengeViewModelTests, MockChallengeUseCase, MockPersonalizedChallengeUseCase

### Community 85 - "AppleSignInCredential"
Cohesion: 0.17
Nodes (4): AuthenticationServices, AppleSignInCredential, AppleSignInDataSourceImpl, AppleSignInDelegate

### Community 86 - "MockAppReviewRequestUseCase"
Cohesion: 0.17
Nodes (3): AppReviewRequestUseCase, NoOpAppReviewRequestUseCase, MockAppReviewRequestUseCase

### Community 87 - "Xcode Cloud Release Build"
Cohesion: 0.14
Nodes (12): Release-Build Workflow, Xcode Cloud Release Build, Generation and editing — Mulimi Drop v3, Original body layer prompt, Original face layer prompt, Original master prompt, Mulimi Drop — v3, 레이어 (+4 more)

### Community 88 - "Value"
Cohesion: 0.16
Nodes (6): Provider, StartTimerIntent, TestControl, .body, TimerConfiguration, Value

### Community 91 - "WatchHydrationViewModel"
Cohesion: 0.14
Nodes (11): MutationAction, record, reset, undo, WatchHydrationViewModel, .canDrinkWater, .hasCurrentSnapshot, ReadRecoveryGoal (+3 more)

### Community 92 - "프로젝트 전체 구조와 의존성"
Cohesion: 0.17
Nodes (12): App · 조립 루트 — 8개, Core — 6개, Features — 18개, Shared — 5개, Tests — 16개, 검증과 갱신, 기능 간 직접 의존에서 주의할 점, 디렉터리와 소유권 (+4 more)

### Community 93 - "HydrationGoalRecommendationAvailability"
Cohesion: 0.14
Nodes (7): MockHydrationGoalRecommendationUseCase, HydrationGoalRecommendationAvailability, bodyProfileRequired, modelUnavailable, ready, HydrationGoalRecommendationUseCase, MockHydrationGoalRecommendationUseCase

### Community 96 - "Security And Privacy Operations"
Cohesion: 0.17
Nodes (9): Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling, Data Boundary, PostHog Privacy Controls, Security And Privacy Operations (+1 more)

### Community 97 - "AccountDomain"
Cohesion: 0.08
Nodes (5): AccountDomain, HydrationPresentation, MulimiKeychain, MulimiPlatform, Testing

### Community 98 - "Sendable"
Cohesion: 0.22
Nodes (3): ReadRecoveryClock, InsightRecoveryClock, MockHydrationProgressUseCase

### Community 99 - "PersonalizedChallengeUseCaseImpl"
Cohesion: 0.15
Nodes (7): HydrationChallengeTier, beginner, steady, stretch, Constants, PersonalizedChallengeUseCaseImpl, PersonalizedChallengeUseCaseTests

### Community 100 - "LogWaterAmountOption"
Cohesion: 0.18
Nodes (8): LogWaterAmountOption, bottle, custom, glass, .presetID, .servingType, tumbler, .volumeML

### Community 101 - "AGENTS.md Onboarding Map"
Cohesion: 0.11
Nodes (17): Profile Information Architecture, Profile Root, Settings Screen, Quality Gates, Validation Baseline, Validation Matrix, architecture-boundary, lint-fix-loop (+9 more)

### Community 102 - ".recordWater"
Cohesion: 0.19
Nodes (3): HydrationReminderNotification, .category, HydrationReminderNotificationTests

### Community 103 - "HealthKitAuthorizationStatus"
Cohesion: 0.26
Nodes (6): HealthKitAuthorizationStatus, notDetermined, sharingAuthorized, sharingDenied, .analyticsValue, ProductAnalyticsEvent

### Community 104 - ".assemble"
Cohesion: 0.12
Nodes (3): MockHydrationNextActionGuideUseCaseForTesting, MockHydrationRoutineAdherenceUseCaseForTesting, TestingAssembly

### Community 107 - "CaseIterable"
Cohesion: 0.15
Nodes (10): HydrationServing, .additionalPresets, HydrationServingPreset, bottle, .id, tumbler, .volumeML, .progressLevel (+2 more)

### Community 108 - "Generation prompts"
Cohesion: 0.18
Nodes (9): body, cheeks, face, Generation prompts, Master, Mulimi Liquid Glass 아이콘 — #339, v1, 미리보기와 확인, 사용 (+1 more)

### Community 109 - "ConfigurationAppIntent"
Cohesion: 0.18
Nodes (4): ConfigurationAppIntent, .description, .title, ConfigurationAppIntent

### Community 111 - "StaticAppInfoProvider"
Cohesion: 0.24
Nodes (6): AppInfoProviding, BundleAppInfoProvider, .appBuildNumber, .appVersion, StaticAppInfoProvider, SettingsViewModelTests

### Community 113 - "WatchHydrationSnapshot"
Cohesion: 0.09
Nodes (10): WatchHydrationMutationResult, WatchHydrationSnapshot, .eventCount, .isGoalReached, .lastDrinkDate, .progress, .remainingML, WatchDailyGoalRepository (+2 more)

### Community 114 - "Hashable"
Cohesion: 0.22
Nodes (7): NavigationPresentationStyle, fullScreenCover, push, sheet, HydrationGoalRecommendationError, bodyProfileRequired, modelUnavailable

### Community 115 - "AnalyticsRepository"
Cohesion: 0.15
Nodes (3): AnalyticsRepository, NoOpAnalyticsRepository, AnalyticsUseCaseImpl

### Community 117 - "UserPreferencesDataSourceImpl"
Cohesion: 0.20
Nodes (4): Constants, UserPreferencesDataSource, UserPreferencesDataSourceImpl, UserPreferencesRepositoryImpl

### Community 118 - "TokenProperty"
Cohesion: 0.18
Nodes (7): KeyChainDataSourceImpl, TokenProperty, accessToken, email, nickname, refreshToken, userIdentifier

### Community 120 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 121 - "AI PR Review Workflow"
Cohesion: 0.18
Nodes (8): AI PR Review Workflow, Architecture Review Policy, Git Flow PR Filter, Textual Diff Selection, Clean Architecture and MVVM Discipline, Hydration Source of Truth, Data Sources of Truth, AI Review Automation Contract

### Community 122 - "HydrationReminderActionResult"
Cohesion: 0.15
Nodes (10): HydrationReminderActionResult, duplicate, failed, goalExceeded, permissionRequired, protectedDataUnavailable, saved, signInRequired (+2 more)

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (6): ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 125 - "아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법"
Cohesion: 0.17
Nodes (10): Apple Watch에서 기록하기, Siri·단축어로 기록하기, Siri에게 말하기, 기록이 저장됐는지 확인하기, 내게 맞는 방법 고르기, 단축어 앱에서 실행, 설정하거나 기록하다 막혔다면, 아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법 (+2 more)

### Community 126 - "Error"
Cohesion: 0.04
Nodes (39): HealthQuantityStoreError, incompleteQuery, internalError, invalidObjectType, permissionDenied, AuthenticationError, cancelled, invalidCredential (+31 more)

### Community 127 - "HydrationWriteResult"
Cohesion: 0.10
Nodes (11): .analyticsFailureReason, HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, HydrationWriteResult, failure, .failureReason (+3 more)

### Community 129 - "WaterDropShaders.metal"
Cohesion: 0.43
Nodes (3): mulimiWaterDistortion(), mulimiWaterLighting(), mulimiWaveNoise()

### Community 130 - "DIContainer"
Cohesion: 0.14
Nodes (8): #350 HealthKit 조회 실패 복구, 검증 기록, 경계, 목적, 작업 순서, 추가 검증의 제한, DIContainer, .resolver

### Community 131 - "HydrationNextActionGuide"
Cohesion: 0.17
Nodes (11): Constants, HydrationNextActionGuide, .progress, HydrationNextActionGuideState, approachingRoutine, goalReached, needsGoal, readyToDrink (+3 more)

### Community 132 - "#320 — 7일 스타터 플랜 제품 적용"
Cohesion: 0.20
Nodes (9): #320 — 7일 스타터 플랜 제품 적용, Constraints And Decisions, Context, Goal, Implementation Notes (2026-09-14), Non-Goals, Plan, Rollback (+1 more)

### Community 133 - "Docs Index"
Cohesion: 0.12
Nodes (23): Agent Onboarding Guide, Graphify-Assisted Code Navigation, Mulimi Architecture SSOT, Core User Flow, Claude Agent Entrypoint, Delivery Workflow, Git Flow Delivery Strategy, Issue Closure Policy (+15 more)

### Community 134 - "RoutineWeekday"
Cohesion: 0.11
Nodes (14): .localeWeekday, .nextActionSchedule, RoutineWeekday, .displayOrder, friday, .id, monday, saturday (+6 more)

### Community 135 - "DrinkWaterRepository"
Cohesion: 0.08
Nodes (3): UserPreferencesRepository, DrinkWaterRepository, HydrationNextActionGuideUseCaseImpl

### Community 136 - "WatchDailyGoalLocalDataSource"
Cohesion: 0.20
Nodes (4): MulimiCloudKit, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, WatchDailyGoalRepositoryImpl

### Community 137 - "HydrationInsightView"
Cohesion: 0.06
Nodes (30): BadgeView, .body, HydrationInsightView, .emptyState, .emptyStateCTAButtons, .insightContent, .metricColumns, .routineAdherenceCard (+22 more)

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "HealthKitRepository"
Cohesion: 0.18
Nodes (3): HealthKitRepository, BodyProfileUseCaseImpl, BodyProfileUseCaseTests

### Community 143 - "FoundationModelsHydrationGoalRecommendationDataSource"
Cohesion: 0.28
Nodes (3): Constants, FoundationModelsHydrationGoalRecommendationDataSource, GeneratedHydrationGoalRecommendation

### Community 144 - ".assemble"
Cohesion: 0.24
Nodes (4): PreviewAssembly, DataAssembly, DomainAssembly, PresentationAssembly

### Community 146 - "Test"
Cohesion: 0.10
Nodes (13): Test, TestBundle, .body, TestLiveActivity, .body, DrinkWaterLockScreenWidget, .body, DrinkWaterWidget (+5 more)

### Community 148 - "HydrationChallengeBadgeHistory"
Cohesion: 0.08
Nodes (9): MockChallengeUseCase, HydrationChallengeBadgeHistory, ChallengeRepository, ChallengeEvaluation, ChallengeMergeResult, ChallengeUseCaseImpl, ChallengeUseCaseTests, HydrationProgressUseCase (+1 more)

### Community 151 - "ProfileRoutineViewModel"
Cohesion: 0.07
Nodes (24): .body, RoutineEditorView, .body, .weekdayGrid, ProfileRoutineViewModel, .activeRoutineCount, .canSaveDraft, .displayedRoutines (+16 more)

### Community 152 - "MockAnalyticsUseCase"
Cohesion: 0.10
Nodes (8): HydrationComebackRepository, .comebackSummary, HydrationComebackMode, baseline, card, disabled, StubHydrationComebackRepository, MockAnalyticsUseCase

### Community 153 - "HydrationReminderPermissionGateView"
Cohesion: 0.32
Nodes (5): HydrationReminderPermissionGateView, .allowButtonLabel, .benefitCard, .body, .headerSection

### Community 154 - "ChallengeViewModel"
Cohesion: 0.09
Nodes (8): MockChallengeUseCaseForTesting, HydrationChallenge, .id, ChallengeUseCase, ChallengeCardModel, ChallengeHistoryCardModel, ChallengeViewModel, .hasLoadedChallenges

### Community 155 - "Challenge State Model"
Cohesion: 0.50
Nodes (4): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Recurring Challenge State

### Community 157 - "AuthProvider"
Cohesion: 0.40
Nodes (4): AuthProvider, apple, google, kakao

### Community 158 - "Mulimi Pull Request Template"
Cohesion: 0.50
Nodes (3): Local Validation Reporting, Mulimi Pull Request Template, PR Review Checklist

### Community 159 - "HydrationRoutineRecommendationKind"
Cohesion: 0.29
Nodes (5): HydrationRoutineRecommendationKind, afternoonGap, frequentHydrationWindow, morningStart, .recommendationCards

### Community 160 - "Generation — Mulimi Water Glass v2"
Cohesion: 0.25
Nodes (6): droplet, Generation — Mulimi Water Glass v2, glass, Master, water, Mulimi — Water Glass v2

### Community 163 - "View"
Cohesion: 0.08
Nodes (16): ProfileView, .body, .goalRecommendationCard, .goalRecommendationRoute, .routineCard, BodyProfileSettingView, .body, .healthSyncCard (+8 more)

### Community 164 - "ChallengeStorageDataSourceImpl"
Cohesion: 0.29
Nodes (4): ChallengeStorageDataSource, ChallengeStorageDataSourceImpl, ChallengeRepositoryImpl, ChallengeStorageDataSourceTests

### Community 166 - "#321 수분 알림 바로 기록"
Cohesion: 0.18
Nodes (11): #321 수분 알림 바로 기록, Completion Notes, Constraints, Context, Goal, Non-Goals, Open Questions, Plan (+3 more)

### Community 168 - "DataAssembly.swift"
Cohesion: 0.12
Nodes (6): AccountData, ChallengeData, HydrationData, MulimiAnalyticsData, RoutineData, Utils

### Community 169 - "Reliability Recovery"
Cohesion: 0.22
Nodes (6): HealthKit Source of Truth, Reliability Recovery, Shared Hydration Rules, HealthKit Data Flow, healthkit-flow, widget-watch-integration

### Community 170 - "HydrationInsightCategory"
Cohesion: 0.29
Nodes (6): HydrationInsightCategory, analysis, .id, routine, .systemImage, .title

### Community 171 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, challenge, drink, history, insight, profile

### Community 174 - "Clean Architecture and MVVM"
Cohesion: 0.29
Nodes (5): Clean Architecture and MVVM, navigation-coordinator, Root Navigation, Modular Clean Architecture, Root App Flow

### Community 175 - "HydrationRecordPeriod"
Cohesion: 0.33
Nodes (6): HydrationRecordPeriod, .id, month, .title, today, week

### Community 177 - "Layer Responsibilities"
Cohesion: 0.18
Nodes (9): CI Lint and Architecture Gate, Lint Workflow, Domain Data Presentation Test Matrix, PR Unit Tests Workflow, Selected SwiftLint Rule Set, SwiftLint Configuration, Default Validation Sequence, Dependency Direction (+1 more)

### Community 179 - "HealthKitDataSourceImpl"
Cohesion: 0.08
Nodes (12): HealthKitDataSource, HealthKitDataSourceImpl, .healthKitAuthorizationStatus, .isWaterSharingAuthorized, HealthKitRepositoryImpl, .authorisationStatus, HealthKitError, healthKitInternalError (+4 more)

### Community 181 - "HydrationStarterPlanCard"
Cohesion: 0.40
Nodes (4): HydrationStarterPlanCard, .body, .nextStepText, .progressText

### Community 182 - "GoalAlignment"
Cohesion: 0.40
Nodes (5): GoalAlignment, aboveGoal, aligned, belowGoal, unknown

### Community 183 - "NextStep"
Cohesion: 0.40
Nodes (5): NextStep, chooseMethod, finish, recordWater, saveRoutine

### Community 184 - ".resolve"
Cohesion: 0.36
Nodes (5): PreviewViews, .challenge, .drinkWater, .hydrationList, .profile

### Community 187 - "AuthenticationRepositoryImpl"
Cohesion: 0.15
Nodes (5): AppleSignInDataSource, KeyChainDataSource, AuthenticationRepositoryImpl, .isAuthenticated, AuthenticationRepository

### Community 188 - "CustomHydrationAmountValidation"
Cohesion: 0.40
Nodes (5): CustomHydrationAmountValidation, empty, invalid, overLimit, valid

### Community 192 - "LogWaterAppShortcuts"
Cohesion: 0.33
Nodes (3): LogWaterAppShortcuts, .appShortcuts, .shortcutTileColor

## Ambiguous Edges - Review These
- `CloudKit-Backed Hydration Store` → `HealthKit Source of Truth`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to
- `CloudKit-Backed Hydration Store` → `Current Storage Strategy`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to

## Knowledge Gaps
- **572 isolated node(s):** `.resolver`, `production`, `preview`, `testing`, `.current` (+567 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1042 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **40 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `HealthKit Source of Truth`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `Current Storage Strategy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `String` connect `String` to `HydrationRoutineAdherenceInsight`, `SettingsViewModel`, `HydrationRoutine`, `MockDrinkWaterUseCase`, `DrinkWaterView`, `HealthKitQuantityStore`, `.assemble`, `HydrationStarterPlanViewModel`, `DrinkWaterUseCase`, `DrinkWaterViewModel`, `HydrationChallengeKind`, `HealthKitPermissionViewModel`, `HealthKitPermissionGateView`, `UndoQuantityStore`, `BodyProfile`, `HydrationStarterPlan`, `MockDrinkWaterRepository`, `.tr`, `UUID`, `SpyRoutineUseCase`, `HydrationRoutineRecommendation`, `ContentView`, `PostHogAnalyticsRepository`, `HydrationReminderPermissionViewModel`, `PersonalizedHydrationChallenge`, `RecordCalendarView`, `AppReviewRequestState`, `HydrationGoalRecommendationViewModel`, `UnavailableHealthStore`, `AppReviewRequestUseCaseImpl`, `Equatable`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `LiquidGlassSegmentedControl`, `HydrationRecord`, `.tr`, `BodyProfileViewModel`, `HydrationReminderSlot`, `DrinkWaterEntry`, `UserCredential`, `LogWaterAppIntent`, `ProjectDescription`, `HealthKitSource`, `MainIcon`, `RoutineNotificationAuthorizationStatus`, `HydrationRecordListViewModel`, `OnboardingView`, `HydrationEvent`, `ProfileRoutineView`, `RoutineActionIntent`, `HydrationRecordEventRow`, `AppleSignInCredential`, `MockAppReviewRequestUseCase`, `Value`, `.make`, `WatchHydrationViewModel`, `HydrationGoalRecommendation`, `PersonalizedChallengeUseCaseImpl`, `LogWaterAmountOption`, `.recordWater`, `HealthKitAuthorizationStatus`, `CaseIterable`, `ConfigurationAppIntent`, `MockUserPreferencesUseCase`, `StaticAppInfoProvider`, `AnalyticsRepository`, `UserPreferencesDataSourceImpl`, `TokenProperty`, `HydrationReminderActionResult`, `UbiquitousMirroredStore`, `ContentState`, `Error`, `HydrationWriteResult`, `HydrationNextActionGuide`, `RoutineWeekday`, `DrinkWaterRepository`, `HydrationInsightView`, `FoundationModelsHydrationGoalRecommendationDataSource`, `Test`, `HydrationChallengeBadgeHistory`, `ProfileRoutineViewModel`, `MockAnalyticsUseCase`, `HydrationReminderPermissionGateView`, `ChallengeViewModel`, `HydrationRoutineRecommendationKind`, `.progressSnapshot`, `View`, `ChallengeStorageDataSourceImpl`, `MockUserPreferencesUseCaseForTesting`, `HydrationInsightCategory`, `HydrationRecordPeriod`, `L10n`, `HealthKitDataSourceImpl`, `HydrationStarterPlanCard`, `AuthenticationRepositoryImpl`?**
  _High betweenness centrality (0.278) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `HydrationRoutineAdherenceInsight`, `WatchHydrationUndoTests.swift`, `HydrationNextActionGuide`, `HydrationRoutine`, `DrinkWaterRepository`, `WatchDailyGoalLocalDataSource`, `HealthKitQuantityStore`, `.assemble`, `HealthKitRepository`, `DrinkWaterUseCase`, `MulimiAnalytics`, `HydrationChallengeKind`, `MockRoutineRepository`, `HydrationChallengeBadgeHistory`, `BodyProfile`, `HydrationStarterPlan`, `MockAnalyticsUseCase`, `.tr`, `ChallengeViewModel`, `HydrationRoutineRecommendation`, `AuthProvider`, `Localization`, `HydrationReminderPermissionViewModel`, `SignInUseCaseImpl`, `HydrationRoutineRecommendationKind`, `AppReviewRequestState`, `HydrationProgressSnapshot`, `SheetRouting`, `String`, `DataAssembly.swift`, `WatchHydrationEvent`, `MockHydrationReminderRepository`, `HydrationReminderDomain`, `HydrationReminderRepository`, `L10n`, `HydrationReminderAuthorizationStatus`, `UserDefaults`, `HealthKitDataSourceImpl`, `HydrationRecord`, `UserPreferencesUseCase`, `BodyProfileViewModel`, `.weeklyInsight`, `AuthenticationRepositoryImpl`, `HydrationReminderSlot`, `UserCredential`, `MainIcon`, `RoutineNotificationAuthorizationStatus`, `HydrationGoalRecommendationUseCaseImpl`, `HydrationEvent`, `RoutineActionIntent`, `AppleSignInCredential`, `MockAppReviewRequestUseCase`, `HydrationGoalRecommendationAvailability`, `HydrationGoalRecommendation`, `AccountDomain`, `HealthKitAuthorizationStatus`, `CaseIterable`, `StaticAppInfoProvider`, `WatchHydrationSnapshot`, `TokenProperty`, `DIEnvironment`, `UbiquitousMirroredStore`, `Error`, `HydrationWriteResult`?**
  _High betweenness centrality (0.075) - this node is a cross-community bridge._
- **Why does `프로젝트 전체 구조와 의존성` connect `프로젝트 전체 구조와 의존성` to `AppDelegate`, `WatchHydrationUndoTests.swift`, `Docs Index`?**
  _High betweenness centrality (0.055) - this node is a cross-community bridge._
- **Are the 23 inferred relationships involving `HydrationInsightViewModel` (e.g. with `.assemble()` and `.assemble()`) actually correct?**
  _`HydrationInsightViewModel` has 23 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.resolver`, `production`, `preview` to the rest of the system?**
  _572 weakly-connected nodes found - possible documentation gaps or missing edges._