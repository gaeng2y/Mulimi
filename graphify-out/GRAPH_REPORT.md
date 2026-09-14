# Graph Report - Mulimi  (2026-09-14)

## Corpus Check
- 378 files · ~168,585 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 22 file(s) not represented in the graph (top: .entitlements 6, .plist 6, (none) 3)

## Summary
- 3529 nodes · 9660 edges · 173 communities (159 shown, 14 thin omitted)
- Extraction: 85% EXTRACTED · 15% INFERRED · 0% AMBIGUOUS · INFERRED: 1439 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `d187daca`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- HydrationRoutineAdherenceInsight
- HydrationRecord
- WatchHydrationLocalDataSource.swift
- ProfileRoutineViewModel
- HydrationRoutine
- Equatable
- MockHealthKitRepository
- MockUserPreferencesUseCase
- .tr
- HydrationRecordListViewModel
- .assemble
- Product Specs Index
- HydrationRecordEventRow
- RoutineWeekday
- DrinkWaterViewModel
- Foundation
- HydrationChallengeKind
- AnalyticsUseCase
- ChallengeView
- .drinkWater
- HydrationEvent
- BodyProfile
- RoutineUseCase
- MockDrinkWaterRepository
- WatchHydrationViewModel
- AccountDomain
- SpyRoutineUseCase
- RoutineUseCaseImpl
- LiquidGlassSegmentedControl
- .assemble
- SwiftUI
- HydrationReminderPermissionViewModel
- UserCredential
- ChallengeViewModel
- RecordCalendarView
- HealthKitDataSource
- .loadInsights
- PersonalizedHydrationChallenge
- AnyObject
- String
- HydrationGoalRecommendationViewModel
- RoutineRecommendationUseCaseImpl
- HealthKitQuantityStore
- MockHydrationReminderRepository
- MockAnalyticsUseCase
- .assemble
- ProfileRoutineView
- DIContainer
- UserDefaults
- HydrationReminderAuthorizationStatus
- HealthQuantityStoring
- HydrationReminderRepositoryImpl
- View
- HydrationInsightViewModel
- StartTimerIntent
- BodyProfileViewModel
- MockHydrationNextActionGuideUseCase
- DataAssembly.swift
- HydrationChallengeBadgeHistory
- HydrationReminderSlot
- DrinkWaterEntry
- HealthKitPermissionGateView
- .makeRootView
- BodyProfileAvailability
- LogWaterAppIntent
- ProjectDescription
- HydrationStarterPlan
- ContentView
- Top 5
- MainIcon
- Test.swift
- HydrationStarterPlanViewModel
- RoutineNotificationAuthorizationStatus
- HydrationRecordDaySummary
- HydrationGoalRecommendation
- OnboardingView
- HydrationGoalRecommendationCard
- BodyProfileUseCaseImpl
- HydrationGoalRecommendationUseCaseImpl
- AppReviewRequestState
- SharedHydrationStoreError
- UserPreferencesUseCaseImpl
- WatchHydrationSnapshot
- UserPreferencesUseCase
- .loadChallenges
- Color
- .shouldRequestAfterSuccessfulHydrationRecord
- Clean Architecture and MVVM
- Growth Scorecard
- HydrationRoutineAdherenceUseCase
- AppDelegate
- WaterWaveView
- 프로젝트 전체 구조와 의존성
- MockHydrationReminderUseCase
- HydrationProgressUseCaseImpl
- AuthTokens
- Security And Privacy Operations
- HydrationReminderDomain
- FoundationModelsHydrationGoalRecommendationDataSource
- PersonalizedChallengeUseCaseImpl
- LogWaterAmountOption
- AGENTS.md Onboarding Map
- SettingsViewModel
- HealthKitAuthorizationStatus
- Sendable
- HydrationReminderPermissionGateView
- WaterDropView
- HydrationInsightCategory
- WatchHydrationRepositoryImpl
- ConfigurationAppIntent
- SettingsViewModelTests
- DrinkWaterRepositoryImpl
- HydrationRoutineSchedule
- WatchHydrationUseCaseImpl
- AppRoute
- MockUserPreferencesRepository
- Layer Responsibilities
- UserPreferencesDataSourceImpl
- MockUserPreferencesUseCase
- HydrationComebackRepositoryImpl
- DIEnvironment
- WatchHydrationHealthKitDataSource
- MockUserPreferencesUseCaseForTesting
- DrinkWaterWidgetProvider
- ContentState
- MockHealthKitUseCaseForTesting
- Error
- HydrationRecordListView
- LogWaterAppShortcuts
- float2
- .resolve
- HydrationNextActionGuide
- #320 — 7일 스타터 플랜 제품 적용
- Docs Index
- HydrationRoutineRecommendation
- UserPreferencesRepositoryImpl
- WatchDailyGoalUserDefaultsDataSource
- StackRouting
- Accessibility and Dynamic Type Audit
- HydrationStarterPlanView
- UUID
- ci_post_clone.sh
- pre-commit
- MockAppReviewRequestUseCase
- HydrationStarterPlanRepositoryImpl
- AppTab
- AnalyticsUseCaseImpl
- check-architecture.sh
- HealthQuantityStoreError
- lint.sh
- lint-fix.sh
- .progressSnapshot
- .makeComebackViewModel
- HealthKitError
- Test
- Challenge State Model
- MockHydrationNextActionGuideUseCaseForTesting
- AuthProvider
- Mulimi Pull Request Template
- Completed Plan Archive
- BundleAppInfoProvider
- .hasCompletedOnboarding
- RoutineActionIntent
- HydrationReminderStorageDataSourceImpl
- Personalized Challenge Strategy
- HydrationRecordPeriod
- HealthQuantitySample
- WatchDataConstants.swift
- RoutineError
- .hydrationEvents
- .hasSeenPermissionPriming
- .setDailyWaterLimit
- .isHealthDataAvailable

## God Nodes (most connected - your core abstractions)
1. `HydrationDomain` - 114 edges
2. `DrinkWaterViewModel` - 112 edges
3. `HydrationRoutine` - 105 edges
4. `AccountDomain` - 97 edges
5. `HydrationInsightViewModel` - 95 edges
6. `RoutineDomain` - 75 edges
7. `ProfileRoutineViewModel` - 74 edges
8. `HydrationEvent` - 73 edges
9. `MulimiAnalytics` - 71 edges
10. `MockUserPreferencesUseCase` - 63 edges

## Surprising Connections (you probably didn't know these)
- `Modular Clean Architecture` --semantically_similar_to--> `Clean Architecture and MVVM`  [INFERRED] [semantically similar]
  README.md → Docs/skills/architecture-boundary.md
- `AI Review Automation Contract` --semantically_similar_to--> `Git Flow PR Filter`  [INFERRED] [semantically similar]
  Docs/delivery-workflow.md → .github/workflows/ai-pr-review.yml
- `Data Sources of Truth` --semantically_similar_to--> `Hydration Source of Truth`  [INFERRED] [semantically similar]
  ARCHITECTURE.md → AGENTS.md
- `Default Validation Sequence` --semantically_similar_to--> `CI Lint and Architecture Gate`  [INFERRED] [semantically similar]
  AGENTS.md → .github/workflows/lint.yml
- `Default Validation Sequence` --semantically_similar_to--> `Domain Data Presentation Test Matrix`  [INFERRED] [semantically similar]
  AGENTS.md → .github/workflows/pr-unit-tests.yml

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

## Communities (173 total, 14 thin omitted)

### Community 0 - "HydrationRoutineAdherenceInsight"
Cohesion: 0.13
Nodes (29): CandidateMatch, Constants, HydrationRoutineAdherenceEvent, HydrationRoutineAdherenceInsight, .adherenceRate, .bestRoutine, .bestTimeSlot, .hasDueOccurrences (+21 more)

### Community 1 - "HydrationRecord"
Cohesion: 0.18
Nodes (8): HydrationRecord, Date, Double, Date, HydrationRecordRow, .body, .dateString, Date

### Community 2 - "WatchHydrationLocalDataSource.swift"
Cohesion: 0.18
Nodes (6): HealthKit, MulimiHealthKit, OSLog, WatchHydrationData, WatchHydrationDomain, WatchHydrationPresentation

### Community 3 - "ProfileRoutineViewModel"
Cohesion: 0.07
Nodes (28): .body, RoutineEditorView, .body, .weekdayGrid, ProfileRoutineViewModel, .activeRoutineCount, .canSaveDraft, .displayedRoutines (+20 more)

### Community 4 - "HydrationRoutine"
Cohesion: 0.15
Nodes (12): RoutineNotificationDataSource, RoutineStorageDataSource, RoutineStorageDataSourceImpl, RoutineRepositoryImpl, Bool, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource, SpyRoutineStorageDataSource (+4 more)

### Community 5 - "Equatable"
Cohesion: 0.14
Nodes (23): Equatable, Identifiable, PersonalizedChallengeCardModel, HydrationServingOptionModel, .volumeText, HydrationInsightEmptyCTAModel, HydrationInsightMetric, HydrationWeeklyReportMetric (+15 more)

### Community 6 - "MockHealthKitRepository"
Cohesion: 0.14
Nodes (6): HealthKitUseCaseImpl, .authorisationStatus, BodyProfileUseCaseTests, HealthKitUseCaseTests, MockHealthKitRepository, .authorisationStatus

### Community 7 - "MockUserPreferencesUseCase"
Cohesion: 0.21
Nodes (8): NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, MockDrinkWaterUseCase, MockUserPreferencesUseCase, Bool, Double

### Community 8 - ".tr"
Cohesion: 0.07
Nodes (31): Bundle, HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, AppReviewRequestTaskID, DrinkWaterView, .actionButtons (+23 more)

### Community 9 - "HydrationRecordListViewModel"
Cohesion: 0.14
Nodes (14): Never, HydrationRecordListViewModel, .showsEmptyStateRecordCTA, Calendar, Sendable, HydrationRecordListViewModelTests, RecordSpyWidgetTimelineReloader, MockDrinkWaterUseCase (+6 more)

### Community 10 - ".assemble"
Cohesion: 0.11
Nodes (19): Container, Container, RootView, .body, Content, SignInUseCase, AppSession, Bool (+11 more)

### Community 11 - "Product Specs Index"
Cohesion: 0.12
Nodes (32): PostHog Analytics Consolidation, Analytics Architecture Boundary, Analytics Events, Analytics Event Catalog, Product Analytics Event Contract, PostHog Activity QA, Analytics Operations, PostHog Core Product Funnel (+24 more)

### Community 12 - "HydrationRecordEventRow"
Cohesion: 0.14
Nodes (15): HydrationRecordDaySummaryRow, .body, .progressPercent, HydrationRecordEventRow, .sourceText, .timeText, .volumeText, .recordListSection (+7 more)

### Community 13 - "RoutineWeekday"
Cohesion: 0.10
Nodes (20): Int, .localeWeekday, Locale, .nextActionSchedule, RoutineWeekday, .displayOrder, friday, .id (+12 more)

### Community 14 - "DrinkWaterViewModel"
Cohesion: 0.08
Nodes (25): AppReviewRequestUseCase, .body, CustomHydrationAmountValidation, empty, invalid, overLimit, valid, DrinkWaterViewModel (+17 more)

### Community 15 - "Foundation"
Cohesion: 0.09
Nodes (9): ChallengeDomain, CoreGraphics, Foundation, FoundationModels, HydrationDomain, MulimiAnalytics, Observation, PostHog (+1 more)

### Community 16 - "HydrationChallengeKind"
Cohesion: 0.09
Nodes (35): Codable, HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType, streak7, weeklyAchievement80 (+27 more)

### Community 17 - "AnalyticsUseCase"
Cohesion: 0.10
Nodes (14): AnalyticsUseCase, NoOpAnalyticsUseCase, ProductAnalyticsEvent, HealthKitUseCase, .body, HealthKitPermissionViewModel, .defaultErrorMessage, .deniedMessage (+6 more)

### Community 18 - "ChallengeView"
Cohesion: 0.10
Nodes (23): ChallengeCard, .accentColor, .cardBackground, ChallengeCategory, completed, .id, inProgress, recommended (+15 more)

### Community 19 - ".drinkWater"
Cohesion: 0.43
Nodes (3): Date, DateInterval, Int

### Community 20 - "HydrationEvent"
Cohesion: 0.07
Nodes (27): MockDrinkWaterUseCase, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int, MockDrinkWaterUseCaseForTesting (+19 more)

### Community 21 - "BodyProfile"
Cohesion: 0.11
Nodes (12): Hashable, MockHealthKitUseCase, Date, BodyProfile, .isComplete, .isEmpty, BodyProfileSource, healthKit (+4 more)

### Community 22 - "RoutineUseCase"
Cohesion: 0.10
Nodes (13): Container, UserPreferencesRepository, DrinkWaterRepository, HydrationNextActionGuideUseCaseImpl, Calendar, Date, HydrationRoutineAdherenceUseCaseImpl, Calendar (+5 more)

### Community 23 - "MockDrinkWaterRepository"
Cohesion: 0.14
Nodes (12): DrinkWaterUseCaseImpl, .currentWaterIntakeML, Bool, Double, DrinkWaterUseCaseTests, MockDrinkWaterRepository, .currentWaterIntakeML, Bool (+4 more)

### Community 24 - "WatchHydrationViewModel"
Cohesion: 0.09
Nodes (28): WatchHydrationUseCase, CVarArg, WatchL10n, Double, Int, WatchMetricRow, .body, WatchNavigationCard (+20 more)

### Community 25 - "AccountDomain"
Cohesion: 0.07
Nodes (6): AccountDomain, HydrationData, HydrationPresentation, MulimiKeychain, MulimiPlatform, Testing

### Community 26 - "SpyRoutineUseCase"
Cohesion: 0.11
Nodes (12): ProfileRoutineViewModelTests, SpyDrinkWaterUseCase, .currentWaterIntakeML, SpyRoutineUseCase, SpyUserPreferencesUseCase, Bool, Date, DateInterval (+4 more)

### Community 27 - "RoutineUseCaseImpl"
Cohesion: 0.22
Nodes (6): RoutineRepository, RoutineUseCaseImpl, RoutineRecommendationUseCaseTests, Calendar, Date, Int

### Community 28 - "LiquidGlassSegmentedControl"
Cohesion: 0.22
Nodes (13): Value, .categoryPicker, .categoryPicker, LiquidGlassSegment, .id, LiquidGlassSegmentedControl, .activeSegmentBackground, .activeSegmentBorder (+5 more)

### Community 29 - ".assemble"
Cohesion: 0.14
Nodes (7): DataAssembly, Container, PostHogAnalyticsRepository, ProductAnalyticsEvent, AnalyticsRepository, NoOpAnalyticsRepository, ProductAnalyticsEvent

### Community 30 - "SwiftUI"
Cohesion: 0.09
Nodes (12): ActivityKit, AlarmKit, Charts, CryptoKit, DesignSystem, Localization, HydrationPresentationShaderBundleToken, StoreKit (+4 more)

### Community 31 - "HydrationReminderPermissionViewModel"
Cohesion: 0.14
Nodes (10): HydrationReminderUseCase, .primingView, Constant, HydrationReminderPermissionViewModel, Bool, HydrationReminderPermissionViewModelTests, MockHydrationReminderUseCase, Bool (+2 more)

### Community 32 - "UserCredential"
Cohesion: 0.05
Nodes (26): ASAuthorization, ASAuthorizationController, ASAuthorizationControllerDelegate, AuthenticationServices, MockSignInUseCase, Bool, AppleSignInCredential, AppleSignInDataSource (+18 more)

### Community 33 - "ChallengeViewModel"
Cohesion: 0.13
Nodes (13): HydrationChallenge, .id, ChallengeUseCase, PersonalizedChallengeUseCase, ChallengeCardModel, ChallengeHistoryCardModel, ChallengeViewModel, Bool (+5 more)

### Community 34 - "RecordCalendarView"
Cohesion: 0.09
Nodes (29): Binding, CalendarDayView, .accessibilityLabel, .backgroundColor, .body, .borderColor, .dayNumber, .progressPercentage (+21 more)

### Community 35 - "HealthKitDataSource"
Cohesion: 0.13
Nodes (13): DrinkWaterHealthKitDataSource, .currentWaterIntakeML, Bool, Calendar, Date, DateInterval, Double, Error (+5 more)

### Community 36 - ".loadInsights"
Cohesion: 0.28
Nodes (9): HydrationInsightViewModelTests, SpyRoutineUseCase, Calendar, Date, Int, MockDrinkWaterUseCase, MockHydrationRoutineAdherenceUseCase, Calendar (+1 more)

### Community 37 - "PersonalizedHydrationChallenge"
Cohesion: 0.08
Nodes (22): MockPersonalizedChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCaseForTesting, Calendar, Date, HydrationChallengeRecommendationSource, recentRecords (+14 more)

### Community 38 - "AnyObject"
Cohesion: 0.15
Nodes (6): AnyObject, FullScreenRoute, DeepLinkHandling, FullScreenRouting, SheetRouting, SheetRoute

### Community 39 - "String"
Cohesion: 0.14
Nodes (14): .postHogValue, Any, AnalyticsParameterName, AnalyticsParameterValue, bool, double, int, string (+6 more)

### Community 40 - "HydrationGoalRecommendationViewModel"
Cohesion: 0.05
Nodes (39): MockHydrationGoalRecommendationUseCase, MockHydrationProgressUseCase, AccountRoute, profileRoutine, setting, SettingMenu, bodyProfile, dailyLimit (+31 more)

### Community 41 - "RoutineRecommendationUseCaseImpl"
Cohesion: 0.27
Nodes (8): DaySummary, RoutineRecommendationUseCaseImpl, Bool, Calendar, Date, DateInterval, Double, Int

### Community 42 - "HealthKitQuantityStore"
Cohesion: 0.32
Nodes (7): HKAuthorizationStatus, HKHealthStore, HKQuantityType, HKQuantityTypeIdentifier, HKUnit, HealthKitQuantityStore, Date

### Community 43 - "MockHydrationReminderRepository"
Cohesion: 0.14
Nodes (8): HydrationReminderRepository, HydrationReminderUseCaseImpl, Bool, HydrationReminderUseCaseTests, MockHydrationReminderRepository, Bool, Error, Result

### Community 44 - "MockAnalyticsUseCase"
Cohesion: 0.18
Nodes (6): HydrationStarterPlanViewModelTests, Bool, Date, Int, MockAnalyticsUseCase, ProductAnalyticsEvent

### Community 45 - ".assemble"
Cohesion: 0.17
Nodes (6): Assembly, MockChallengeUseCaseForTesting, Calendar, Date, Container, TestingAssembly

### Community 46 - "ProfileRoutineView"
Cohesion: 0.20
Nodes (7): ProfileRoutineView, .guidanceCard, .permissionSection, RoutineGuidanceSlotStatus, elapsed, next, upcoming

### Community 47 - "DIContainer"
Cohesion: 0.16
Nodes (9): Assembler, Assembly, DIContainer, .resolver, Assembly, PreviewAssembly, DomainAssembly, PresentationAssembly (+1 more)

### Community 48 - "UserDefaults"
Cohesion: 0.11
Nodes (16): Double, NSUbiquitousKeyValueStore, UbiquitousMirroredStore, NSUbiquitousKeyValueStore, NSUbiquitousKeyValueStore, Bool, Double, Int (+8 more)

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.09
Nodes (9): MockHydrationReminderUseCaseForTesting, Bool, HydrationReminderAuthorizationStatus, authorized, denied, notDetermined, .analyticsValue, ProductAnalyticsEvent (+1 more)

### Community 50 - "HealthQuantityStoring"
Cohesion: 0.20
Nodes (9): HealthQuantityStoring, HealthKitDataSourceImpl, .healthKitAuthorizationStatus, .isWaterSharingAuthorized, Bool, Date, Double, Error (+1 more)

### Community 51 - "HydrationReminderRepositoryImpl"
Cohesion: 0.21
Nodes (10): HydrationReminderNotificationDataSource, HydrationReminderStorageDataSource, HydrationReminderRepositoryImpl, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource, Bool, Result (+2 more)

### Community 52 - "View"
Cohesion: 0.11
Nodes (25): GridItem, BadgeView, .body, HydrationInsightView, .body, .emptyState, .emptyStateCTAButtons, .insightContent (+17 more)

### Community 53 - "HydrationInsightViewModel"
Cohesion: 0.08
Nodes (33): HydrationInsightViewModel, .canRecordRecoveryDrink, .chartUpperBound, .dailyGoalText, .emptyStateCTAs, .metrics, .routineAdherenceInsightText, .routineAdherenceMetrics (+25 more)

### Community 54 - "StartTimerIntent"
Cohesion: 0.15
Nodes (12): AppIntentControlValueProvider, ControlConfigurationIntent, Provider, StartTimerIntent, Bool, ControlWidgetConfiguration, IntentResult, LocalizedStringResource (+4 more)

### Community 55 - "BodyProfileViewModel"
Cohesion: 0.11
Nodes (14): MockBodyProfileUseCase, BodyProfileSnapshot, MockBodyProfileUseCaseForDomain, BodyProfileViewModel, .availabilityState, .heightSourceText, .helperText, .resolvedHeightText (+6 more)

### Community 56 - "MockHydrationNextActionGuideUseCase"
Cohesion: 0.40
Nodes (3): MockHydrationNextActionGuideUseCase, Calendar, Date

### Community 57 - "DataAssembly.swift"
Cohesion: 0.22
Nodes (5): AccountData, ChallengeData, HydrationReminderData, MulimiAnalyticsData, RoutineData

### Community 58 - "HydrationChallengeBadgeHistory"
Cohesion: 0.09
Nodes (22): MockChallengeUseCase, Calendar, Date, ChallengeStorageDataSource, ChallengeStorageDataSourceImpl, ChallengeRepositoryImpl, ChallengeStorageDataSourceTests, HydrationChallengeBadgeHistory (+14 more)

### Community 59 - "HydrationReminderSlot"
Cohesion: 0.12
Nodes (13): Constant, HydrationReminderNotificationDataSourceImpl, .notificationCenter, Int, Set, UNUserNotificationCenter, HydrationReminderSlot, afternoon (+5 more)

### Community 60 - "DrinkWaterEntry"
Cohesion: 0.12
Nodes (20): DrinkWaterLockScreenWidgetEntryView, .accentColor, .body, .circularView, .inlineView, .rectangularView, DrinkWaterWidgetEntryView, .accentColor (+12 more)

### Community 61 - "HealthKitPermissionGateView"
Cohesion: 0.15
Nodes (14): HealthKitPermissionGateView, .accessCard, .descriptionText, .footnoteText, .headerColor, .headerSection, .headerSystemImage, .permissionView (+6 more)

### Community 62 - ".makeRootView"
Cohesion: 0.15
Nodes (10): AnyView, App, WatchDIContainer, DrinkWaterApp, .body, Scene, MulimiWatchApp, .body (+2 more)

### Community 63 - "BodyProfileAvailability"
Cohesion: 0.20
Nodes (7): BodyProfileAvailability, incomplete, needsPermission, noData, permissionDenied, ready, Bool

### Community 64 - "LogWaterAppIntent"
Cohesion: 0.17
Nodes (13): AppIntent, IntentDialog, IntentModes, Constant, FailureReason, LogWaterAppIntent, .resolvedVolumeML, Bool (+5 more)

### Community 65 - "ProjectDescription"
Cohesion: 0.12
Nodes (5): PackageDescription, Plist, ProjectDescription, ProjectDescriptionHelpers, AppVersion

### Community 66 - "HydrationStarterPlan"
Cohesion: 0.14
Nodes (13): PreviewStarterPlanRepository, HydrationQuickRecordingMethod, shortcuts, watch, widget, HydrationStarterPlan, Bool, Calendar (+5 more)

### Community 67 - "ContentView"
Cohesion: 0.25
Nodes (6): AppCoordinator, AppCoordinatorTests, ContentView, .body, .drinkWaterView, URL

### Community 68 - "Top 5"
Cohesion: 0.14
Nodes (13): 1. 로그인 없이 시작, 2. 7일 스타터 플랜, 3. 알림 바로 기록, 4. 제어 센터·액션 버튼 기록, 5. 컴백 모드, Candidate Ideas, Decision, Engineer (+5 more)

### Community 69 - "MainIcon"
Cohesion: 0.11
Nodes (13): MainIcon, cloud, .`default`, drop, heart, .id, Self, .description (+5 more)

### Community 70 - "Test.swift"
Cohesion: 0.21
Nodes (12): ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, ConfigurationAppIntent, Context, Date (+4 more)

### Community 71 - "HydrationStarterPlanViewModel"
Cohesion: 0.20
Nodes (11): HydrationStarterPlanRepository, DrinkWaterUseCase, .checklist, HydrationStarterPlanViewModel, .completedStepCount, .isAvailable, Bool, Calendar (+3 more)

### Community 72 - "RoutineNotificationAuthorizationStatus"
Cohesion: 0.06
Nodes (13): MockRoutineUseCase, Error, Result, MockRoutineUseCaseForTesting, StarterPlanRoutineStub, RoutineNotificationAuthorizationStatus, authorized, denied (+5 more)

### Community 73 - "HydrationRecordDaySummary"
Cohesion: 0.14
Nodes (14): .yearMonthPickerSheet, HydrationRecordDaySummary, .glassCount, .id, .todaySummary, .weekDayItems, HydrationRecordPeriodSummary, HydrationRecordWeekDayItem (+6 more)

### Community 74 - "HydrationGoalRecommendation"
Cohesion: 0.07
Nodes (28): MockHydrationGoalRecommendationUseCase, Date, Error, HydrationGoalRecommendation, HydrationGoalRecommendationAvailability, bodyProfileRequired, modelUnavailable, ready (+20 more)

### Community 75 - "OnboardingView"
Cohesion: 0.15
Nodes (15): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+7 more)

### Community 76 - "HydrationGoalRecommendationCard"
Cohesion: 0.17
Nodes (9): BodyProfileSettingView, .body, .healthSyncCard, .summaryCard, HydrationGoalRecommendationCard, .body, .content, Bool (+1 more)

### Community 77 - "BodyProfileUseCaseImpl"
Cohesion: 0.29
Nodes (3): HealthKitRepository, BodyProfileUseCaseImpl, Bool

### Community 78 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.18
Nodes (11): HydrationGoalRecommendationRepository, BodyProfileUseCase, Constants, HydrationGoalRecommendationUseCaseImpl, Calendar, Date, DateInterval, Int (+3 more)

### Community 79 - "AppReviewRequestState"
Cohesion: 0.08
Nodes (25): AppReviewRequestStorageDataSource, AppReviewRequestStorageDataSourceImpl, AppReviewRequestRepositoryImpl, AppReviewRequestStorageDataSourceTests, AppReviewRequestState, Date, Set, AppReviewRequestRepository (+17 more)

### Community 80 - "SharedHydrationStoreError"
Cohesion: 0.21
Nodes (10): ModelConfiguration, ModelContainer, SharedHydrationStore, .isICloudAccountAvailable, SharedHydrationStoreError, .errorDescription, failedToCreateContainer, missingAppGroupContainer (+2 more)

### Community 82 - "WatchHydrationSnapshot"
Cohesion: 0.12
Nodes (15): Date, Int, WatchHydrationEvent, WatchHydrationMutationResult, Bool, Date, Double, Int (+7 more)

### Community 83 - "UserPreferencesUseCase"
Cohesion: 0.20
Nodes (6): UserPreferencesUseCase, OnboardingViewModel, .canGoBack, .isLastPage, Bool, OnboardingViewModelTests

### Community 84 - ".loadChallenges"
Cohesion: 0.26
Nodes (8): ChallengeViewModelTests, Calendar, MockChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCase, Calendar, Date

### Community 85 - "Color"
Cohesion: 0.16
Nodes (15): ChallengeBadge, .body, .body, ChallengeHistoryCard, .accentColor, .body, .cardBackground, ChallengeInfoRow (+7 more)

### Community 86 - ".shouldRequestAfterSuccessfulHydrationRecord"
Cohesion: 0.28
Nodes (5): NoOpAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 87 - "Clean Architecture and MVVM"
Cohesion: 0.29
Nodes (7): Clean Architecture and MVVM, Domain Purity, ViewModel Side Effect Boundary, navigation-coordinator, Root Navigation, Modular Clean Architecture, Root App Flow

### Community 88 - "Growth Scorecard"
Cohesion: 0.12
Nodes (17): 72-Hour Audit, Before Release, Cadence And Ownership, Decision Rule, Deferred Scope, Experiment Record, Goal, Growth Scorecard (+9 more)

### Community 89 - "HydrationRoutineAdherenceUseCase"
Cohesion: 0.17
Nodes (7): MockHydrationRoutineAdherenceUseCase, Calendar, Date, MockHydrationRoutineAdherenceUseCaseForTesting, Calendar, Date, HydrationRoutineAdherenceUseCase

### Community 90 - "AppDelegate"
Cohesion: 0.18
Nodes (11): NSObject, AppDelegate, Any, Bool, UNUserNotificationCenter, UIApplication, UIApplicationDelegate, UNNotification (+3 more)

### Community 91 - "WaterWaveView"
Cohesion: 0.10
Nodes (13): CGPoint, CGRect, Path, CGFloat, WaterWaveView, .animatableData, GlareCircleView, .body (+5 more)

### Community 92 - "프로젝트 전체 구조와 의존성"
Cohesion: 0.14
Nodes (14): App · 조립 루트 — 9개, Core — 6개, Features — 18개, Shared — 5개, Tests — 15개, 검증과 갱신, 기능 간 직접 의존에서 주의할 점, 디렉터리와 소유권 (+6 more)

### Community 93 - "MockHydrationReminderUseCase"
Cohesion: 0.22
Nodes (4): MockHydrationReminderUseCase, Bool, Error, Result

### Community 94 - "HydrationProgressUseCaseImpl"
Cohesion: 0.40
Nodes (7): HydrationProgressUseCaseImpl, StreakProgress, Calendar, Date, DateInterval, Double, Int

### Community 95 - "AuthTokens"
Cohesion: 0.31
Nodes (4): AuthenticationNetworkDataSource, AuthenticationNetworkDataSourceImpl, AuthTokens, Int

### Community 96 - "Security And Privacy Operations"
Cohesion: 0.13
Nodes (15): Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling, Data Boundary, Health Data Minimization, PostHog Privacy Controls (+7 more)

### Community 97 - "HydrationReminderDomain"
Cohesion: 0.09
Nodes (10): AccountPresentation, ChallengePresentation, DependencyInjection, HydrationReminderDomain, HydrationReminderPresentation, MulimiNavigation, HydrationReminderAnalyticsParameterName, RoutinePresentation (+2 more)

### Community 98 - "FoundationModelsHydrationGoalRecommendationDataSource"
Cohesion: 0.17
Nodes (8): Constants, FoundationModelsHydrationGoalRecommendationDataSource, GeneratedHydrationGoalRecommendation, HydrationGoalRecommendationDataSource, Int, Locale, HydrationGoalRecommendationRepositoryImpl, SystemLanguageModel

### Community 99 - "PersonalizedChallengeUseCaseImpl"
Cohesion: 0.18
Nodes (10): Constants, PersonalizedChallengeUseCaseImpl, Calendar, Date, Int, PersonalizedChallengeUseCaseTests, Calendar, Date (+2 more)

### Community 100 - "LogWaterAmountOption"
Cohesion: 0.18
Nodes (11): AppEnum, DisplayRepresentation, LogWaterAmountOption, bottle, custom, glass, .presetID, .servingType (+3 more)

### Community 101 - "AGENTS.md Onboarding Map"
Cohesion: 0.11
Nodes (24): Goal Recommendation Entry Rules, Profile Information Architecture, Profile Root, Settings Screen, Goal Mirror Recovery Policy, HealthKit Source of Truth, Recovery Principles, Reliability Recovery (+16 more)

### Community 102 - "SettingsViewModel"
Cohesion: 0.11
Nodes (17): AppInfoProviding, StaticAppInfoProvider, SystemWidgetTimelineReloader, WidgetTimelineReloading, MainIconSettingView, .body, .body, WithdrawalSettingView (+9 more)

### Community 103 - "HealthKitAuthorizationStatus"
Cohesion: 0.26
Nodes (6): HealthKitAuthorizationStatus, notDetermined, sharingAuthorized, sharingDenied, .analyticsValue, ProductAnalyticsEvent

### Community 104 - "Sendable"
Cohesion: 0.12
Nodes (19): MockHydrationProgressUseCase, Calendar, Date, MockHydrationProgressUseCaseForTesting, Calendar, Date, HydrationProgressSnapshot, Bool (+11 more)

### Community 105 - "HydrationReminderPermissionGateView"
Cohesion: 0.32
Nodes (6): HydrationReminderPermissionGateView, .allowButtonLabel, .benefitCard, .body, .headerSection, Content

### Community 106 - "WaterDropView"
Cohesion: 0.29
Nodes (8): CGFloat, CGSize, TimeInterval, WaterDropView, .body, .dropBackground, .dropHighlights, .dropSymbol

### Community 107 - "HydrationInsightCategory"
Cohesion: 0.06
Nodes (32): CaseIterable, KeychainStore, KeychainStoring, KeyChainDataSourceImpl, Bool, TokenProperty, accessToken, email (+24 more)

### Community 108 - "WatchHydrationRepositoryImpl"
Cohesion: 0.46
Nodes (4): WatchHydrationLocalDataSource, Date, Int, WatchHydrationRepositoryImpl

### Community 109 - "ConfigurationAppIntent"
Cohesion: 0.16
Nodes (10): AppIntents, IntentDescription, ConfigurationAppIntent, .description, .title, LocalizedStringResource, ConfigurationAppIntent, IntentResult (+2 more)

### Community 110 - "SettingsViewModelTests"
Cohesion: 0.20
Nodes (10): LocalizedError, MockError, .errorDescription, signInFailed, MockError, deleteFailed, .errorDescription, MockError (+2 more)

### Community 111 - "DrinkWaterRepositoryImpl"
Cohesion: 0.21
Nodes (8): DrinkWaterDataSource, DrinkWaterRepositoryImpl, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int

### Community 112 - "HydrationRoutineSchedule"
Cohesion: 0.30
Nodes (7): HydrationRoutineSchedule, Bool, Set, HydrationRoutineAdherenceUseCaseTests, Calendar, Date, Int

### Community 113 - "WatchHydrationUseCaseImpl"
Cohesion: 0.27
Nodes (6): WatchDailyGoalRepository, WatchHydrationRepository, Date, Double, Int, WatchHydrationUseCaseImpl

### Community 114 - "AppRoute"
Cohesion: 0.15
Nodes (11): AppRoute, hydrationLogging, hydrationStarterPlan, .id, .presentationStyle, profileRoutineAction, NavigationPresentationStyle, fullScreenCover (+3 more)

### Community 115 - "MockUserPreferencesRepository"
Cohesion: 0.23
Nodes (3): MockUserPreferencesRepository, Bool, Double

### Community 116 - "Layer Responsibilities"
Cohesion: 0.09
Nodes (23): AI PR Review Workflow, Architecture Review Policy, Bounded AI Review Diff, Git Flow PR Filter, Textual Diff Selection, CI Lint and Architecture Gate, Lint Workflow, Domain Data Presentation Test Matrix (+15 more)

### Community 117 - "UserPreferencesDataSourceImpl"
Cohesion: 0.24
Nodes (5): SyncedValueStoring, Constants, Bool, Double, UserPreferencesDataSourceImpl

### Community 118 - "MockUserPreferencesUseCase"
Cohesion: 0.21
Nodes (3): MockUserPreferencesUseCase, Bool, Double

### Community 119 - "HydrationComebackRepositoryImpl"
Cohesion: 0.43
Nodes (3): HydrationComebackRepositoryImpl, Date, HydrationComebackRepositoryTests

### Community 120 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 121 - "WatchHydrationHealthKitDataSource"
Cohesion: 0.23
Nodes (8): Bool, Calendar, Date, DateInterval, Error, Int, WatchHydrationHealthKitDataSource, .isWaterSharingAuthorized

### Community 122 - "MockUserPreferencesUseCaseForTesting"
Cohesion: 0.21
Nodes (3): MockUserPreferencesUseCaseForTesting, Bool, Double

### Community 123 - "DrinkWaterWidgetProvider"
Cohesion: 0.27
Nodes (6): AppIntentTimelineProvider, DrinkWaterWidgetProvider, ConfigurationAppIntent, Context, Date, Timeline

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (7): ActivityAttributes, ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 125 - "MockHealthKitUseCaseForTesting"
Cohesion: 0.18
Nodes (3): MockHealthKitUseCaseForTesting, Bool, Date

### Community 126 - "Error"
Cohesion: 0.13
Nodes (14): Error, AuthenticationError, cancelled, invalidCredential, networkFailed, serverError, unknown, MockSignInError (+6 more)

### Community 127 - "HydrationRecordListView"
Cohesion: 0.25
Nodes (5): HydrationRecordListView, .body, RowListView, .body, Void

### Community 128 - "LogWaterAppShortcuts"
Cohesion: 0.40
Nodes (6): AppShortcut, AppShortcutsProvider, LogWaterAppShortcuts, .appShortcuts, .shortcutTileColor, ShortcutTileColor

### Community 129 - "float2"
Cohesion: 0.53
Nodes (5): float2, half4, mulimiWaterDistortion(), mulimiWaterLighting(), mulimiWaveNoise()

### Community 130 - ".resolve"
Cohesion: 0.48
Nodes (6): PreviewViews, .challenge, .drinkWater, .hydrationList, .profile, Service

### Community 131 - "HydrationNextActionGuide"
Cohesion: 0.20
Nodes (14): Constants, HydrationNextActionGuide, .progress, HydrationNextActionGuideState, approachingRoutine, goalReached, needsGoal, readyToDrink (+6 more)

### Community 132 - "#320 — 7일 스타터 플랜 제품 적용"
Cohesion: 0.20
Nodes (9): #320 — 7일 스타터 플랜 제품 적용, Completion Notes, Constraints And Decisions, Context, Goal, Non-Goals, Plan, Rollback (+1 more)

### Community 133 - "Docs Index"
Cohesion: 0.11
Nodes (33): Agent Onboarding Guide, Graphify-Assisted Code Navigation, Mulimi Architecture SSOT, Core User Flow, Claude Agent Entrypoint, Delivery Workflow, Git Flow Delivery Strategy, Issue Closure Policy (+25 more)

### Community 134 - "HydrationRoutineRecommendation"
Cohesion: 0.10
Nodes (17): MockRoutineRecommendationUseCase, Calendar, Date, MockRoutineRecommendationUseCaseForTesting, Calendar, Date, HydrationRoutineRecommendation, HydrationRoutineRecommendationKind (+9 more)

### Community 135 - "UserPreferencesRepositoryImpl"
Cohesion: 0.35
Nodes (4): UserPreferencesDataSource, Bool, Double, UserPreferencesRepositoryImpl

### Community 136 - "WatchDailyGoalUserDefaultsDataSource"
Cohesion: 0.29
Nodes (6): MulimiCloudKit, Int, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, Int, WatchDailyGoalRepositoryImpl

### Community 137 - "StackRouting"
Cohesion: 0.25
Nodes (4): StackRouting, .hasPath, Bool, Hashable

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "HydrationStarterPlanView"
Cohesion: 0.36
Nodes (4): HydrationStarterPlanView, .body, Bool, Void

### Community 140 - "UUID"
Cohesion: 0.12
Nodes (12): Alarm, AlarmManager, AlarmMetadata, AlarmPresentation, Constant, RoutineAlarmMetadata, RoutineNotificationDataSourceImpl, LocalizedStringResource (+4 more)

### Community 143 - "MockAppReviewRequestUseCase"
Cohesion: 0.48
Nodes (5): MockAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 144 - "HydrationStarterPlanRepositoryImpl"
Cohesion: 0.38
Nodes (3): HydrationStarterPlanRepositoryImpl, HydrationStarterPlanRepositoryTests, Bool

### Community 145 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, challenge, drink, history, insight, profile

### Community 148 - "HealthQuantityStoreError"
Cohesion: 0.33
Nodes (5): HealthQuantityStoreError, incompleteQuery, internalError, invalidObjectType, permissionDenied

### Community 151 - ".progressSnapshot"
Cohesion: 0.42
Nodes (4): HydrationProgressUseCaseTests, Calendar, Date, Int

### Community 152 - ".makeComebackViewModel"
Cohesion: 0.14
Nodes (10): HydrationComebackRepository, .nextActionSummary, HydrationComebackMode, baseline, card, disabled, StubHydrationComebackRepository, Bool (+2 more)

### Community 153 - "HealthKitError"
Cohesion: 0.33
Nodes (5): HealthKitError, healthKitInternalError, incompleteExecuteQuery, invalidObjectType, permissionDenied

### Community 154 - "Test"
Cohesion: 0.10
Nodes (23): ControlWidget, WidgetConfiguration, Test, Widget, TestBundle, .body, WidgetConfiguration, TestLiveActivity (+15 more)

### Community 155 - "Challenge State Model"
Cohesion: 0.50
Nodes (5): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Legacy Challenge State Migration, Recurring Challenge State

### Community 156 - "MockHydrationNextActionGuideUseCaseForTesting"
Cohesion: 0.40
Nodes (3): MockHydrationNextActionGuideUseCaseForTesting, Calendar, Date

### Community 157 - "AuthProvider"
Cohesion: 0.40
Nodes (4): AuthProvider, apple, google, kakao

### Community 158 - "Mulimi Pull Request Template"
Cohesion: 0.50
Nodes (4): Local Validation Reporting, Mulimi Pull Request Template, PR Review Checklist, Truthful Validation Reporting

### Community 159 - "Completed Plan Archive"
Cohesion: 0.40
Nodes (5): Stale Document Handling, Active Exec Plans, Active Plan Lifecycle, Completed Exec Plans, Completed Plan Archive

### Community 160 - "BundleAppInfoProvider"
Cohesion: 0.60
Nodes (3): BundleAppInfoProvider, .appBuildNumber, .appVersion

### Community 162 - "RoutineActionIntent"
Cohesion: 0.11
Nodes (17): .id, Bool, HydrationInsightEmptyAction, dailyGoal, record, routine, HydrationWeeklyCoachingAction, dailyGoal (+9 more)

### Community 164 - "Personalized Challenge Strategy"
Cohesion: 0.50
Nodes (4): Personalized Challenge Strategy, Personalized Challenge Recommendation Candidates, Challenge Recommendation Tier Rules, Challenge and Insight Information Architecture

### Community 165 - "HydrationRecordPeriod"
Cohesion: 0.29
Nodes (7): .selectedPeriodRangeText, HydrationRecordPeriod, .id, month, .title, today, week

### Community 166 - "HealthQuantitySample"
Cohesion: 0.83
Nodes (3): HealthQuantitySample, Bool, Double

### Community 168 - "RoutineError"
Cohesion: 0.50
Nodes (3): RoutineError, permissionDenied, scheduleFailed

## Ambiguous Edges - Review These
- `HealthKit Source of Truth` → `CloudKit-Backed Hydration Store`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to
- `CloudKit-Backed Hydration Store` → `Current Storage Strategy`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to

## Knowledge Gaps
- **484 isolated node(s):** `.resolver`, `production`, `preview`, `testing`, `.current` (+479 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 886 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **14 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `HealthKit Source of Truth` and `CloudKit-Backed Hydration Store`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `Current Storage Strategy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `String` connect `String` to `HydrationRoutineAdherenceInsight`, `HydrationRecord`, `ProfileRoutineViewModel`, `HydrationRoutine`, `Equatable`, `.tr`, `HydrationRecordListViewModel`, `.assemble`, `HydrationRecordEventRow`, `RoutineWeekday`, `DrinkWaterViewModel`, `HydrationChallengeKind`, `AnalyticsUseCase`, `ChallengeView`, `.drinkWater`, `HydrationEvent`, `BodyProfile`, `WatchHydrationViewModel`, `LiquidGlassSegmentedControl`, `.assemble`, `HydrationReminderPermissionViewModel`, `UserCredential`, `ChallengeViewModel`, `RecordCalendarView`, `PersonalizedHydrationChallenge`, `HydrationGoalRecommendationViewModel`, `HealthKitQuantityStore`, `MockAnalyticsUseCase`, `ProfileRoutineView`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `View`, `HydrationInsightViewModel`, `StartTimerIntent`, `BodyProfileViewModel`, `HydrationChallengeBadgeHistory`, `HydrationReminderSlot`, `DrinkWaterEntry`, `HealthKitPermissionGateView`, `LogWaterAppIntent`, `ProjectDescription`, `HydrationStarterPlan`, `MainIcon`, `HydrationStarterPlanViewModel`, `HydrationRecordDaySummary`, `HydrationGoalRecommendation`, `OnboardingView`, `HydrationGoalRecommendationCard`, `AppReviewRequestState`, `SharedHydrationStoreError`, `Color`, `.shouldRequestAfterSuccessfulHydrationRecord`, `AuthTokens`, `FoundationModelsHydrationGoalRecommendationDataSource`, `LogWaterAmountOption`, `SettingsViewModel`, `HealthKitAuthorizationStatus`, `HydrationReminderPermissionGateView`, `HydrationInsightCategory`, `ConfigurationAppIntent`, `SettingsViewModelTests`, `HydrationRoutineSchedule`, `AppRoute`, `UserPreferencesDataSourceImpl`, `MockUserPreferencesUseCase`, `MockUserPreferencesUseCaseForTesting`, `ContentState`, `Error`, `HydrationNextActionGuide`, `HydrationRoutineRecommendation`, `HydrationStarterPlanView`, `UUID`, `MockAppReviewRequestUseCase`, `AnalyticsUseCaseImpl`, `.progressSnapshot`, `.makeComebackViewModel`, `Test`, `BundleAppInfoProvider`, `RoutineActionIntent`, `HydrationRecordPeriod`?**
  _High betweenness centrality (0.262) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `HydrationRoutineAdherenceInsight`, `HydrationRecord`, `WatchHydrationLocalDataSource.swift`, `HydrationNextActionGuide`, `HydrationRoutineRecommendation`, `.tr`, `WatchDailyGoalUserDefaultsDataSource`, `.assemble`, `HydrationChallengeKind`, `AnalyticsUseCase`, `HealthQuantityStoreError`, `BodyProfile`, `RoutineUseCase`, `HydrationEvent`, `.makeComebackViewModel`, `AccountDomain`, `HealthKitError`, `RoutineUseCaseImpl`, `WatchHydrationViewModel`, `AuthProvider`, `SwiftUI`, `HydrationReminderPermissionViewModel`, `UserCredential`, `ChallengeViewModel`, `RoutineActionIntent`, `AnyObject`, `String`, `HydrationGoalRecommendationViewModel`, `RoutineError`, `MockHydrationReminderRepository`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `BodyProfileViewModel`, `DataAssembly.swift`, `HydrationChallengeBadgeHistory`, `HydrationReminderSlot`, `BodyProfileAvailability`, `HydrationStarterPlan`, `MainIcon`, `HydrationStarterPlanViewModel`, `RoutineNotificationAuthorizationStatus`, `HydrationGoalRecommendation`, `BodyProfileUseCaseImpl`, `HydrationGoalRecommendationUseCaseImpl`, `AppReviewRequestState`, `SharedHydrationStoreError`, `WatchHydrationSnapshot`, `UserPreferencesUseCase`, `.shouldRequestAfterSuccessfulHydrationRecord`, `HydrationRoutineAdherenceUseCase`, `AuthTokens`, `HydrationReminderDomain`, `SettingsViewModel`, `HealthKitAuthorizationStatus`, `Sendable`, `HydrationInsightCategory`, `WatchHydrationUseCaseImpl`, `DIEnvironment`, `Error`?**
  _High betweenness centrality (0.066) - this node is a cross-community bridge._
- **Why does `HydrationEvent` connect `HydrationEvent` to `Equatable`, `HydrationRecordListViewModel`, `UUID`, `HydrationRecordEventRow`, `.drinkWater`, `BodyProfile`, `MockDrinkWaterRepository`, `.progressSnapshot`, `SpyRoutineUseCase`, `RoutineUseCaseImpl`, `HealthKitDataSource`, `.loadInsights`, `.hydrationEvents`, `RoutineRecommendationUseCaseImpl`, `MockAnalyticsUseCase`, `HealthQuantityStoring`, `HydrationInsightViewModel`, `HydrationChallengeBadgeHistory`, `HydrationRecordDaySummary`, `HydrationGoalRecommendationUseCaseImpl`, `AppReviewRequestState`, `HydrationProgressUseCaseImpl`, `PersonalizedChallengeUseCaseImpl`, `Sendable`, `DrinkWaterRepositoryImpl`, `HydrationRoutineSchedule`?**
  _High betweenness centrality (0.044) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `DrinkWaterViewModel` (e.g. with `.assemble()` and `.assemble()`) actually correct?**
  _`DrinkWaterViewModel` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.resolver`, `production`, `preview` to the rest of the system?**
  _484 weakly-connected nodes found - possible documentation gaps or missing edges._