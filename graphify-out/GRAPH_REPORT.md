# Graph Report - mulimi-321  (2026-09-19)

## Corpus Check
- 376 files · ~168,915 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 23 file(s) not represented in the graph (top: .entitlements 6, .plist 6, (none) 4)

## Summary
- 3532 nodes · 9506 edges · 181 communities (165 shown, 16 thin omitted)
- Extraction: 85% EXTRACTED · 15% INFERRED · 0% AMBIGUOUS · INFERRED: 1433 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `d187daca`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- HydrationRoutineAdherenceInsight
- HydrationRecord
- WidgetKit
- ProfileRoutineViewModel
- RoutineRepositoryImpl
- HydrationServingPreset
- MockHealthKitRepository
- MockUserPreferencesUseCase
- .tr
- HydrationChallengeBadgeHistory
- SettingsViewModel
- Docs Index
- HydrationEvent
- Layer Responsibilities
- DrinkWaterViewModel
- Foundation
- HydrationChallengeKind
- HealthKitPermissionViewModel
- Color
- MockDrinkWaterUseCase
- HydrationWriteResult
- AppTab
- RoutineUseCase
- MockDrinkWaterRepository
- .tr
- AccountDomain
- SpyRoutineUseCase
- MockRoutineRepository
- LiquidGlassSegmentedControl
- .assemble
- Localization
- AnalyticsUseCase
- SignInUseCaseImpl
- HydrationChallenge
- RecordCalendarView
- DrinkWaterHealthKitDataSource
- HydrationProgressSnapshot
- ChallengeViewModel
- Hashable
- String
- HydrationGoalRecommendationViewModel
- HydrationRoutineRecommendation
- HealthKitQuantityStore
- MockHydrationReminderRepository
- DrinkWaterRepository
- MockChallengeUseCaseForTesting
- ProfileRoutineView
- WatchHydrationViewModel
- UserDefaults
- HydrationReminderAuthorizationStatus
- Equatable
- HydrationReminderRepositoryImpl
- HealthKitDataSourceImpl
- HydrationInsightViewModel
- StartTimerIntent
- BodyProfileViewModel
- RoutineWeekday
- DataAssembly.swift
- ChallengeUseCaseImpl
- HydrationReminderSlot
- UserPreferencesUseCase
- .loadInsights
- MulimiWatchApp
- MainIcon
- LogWaterAppIntent
- ProjectDescription
- RoutineActionIntent
- ContentView
- Top 5
- HydrationRecordDaySummary
- Test.swift
- UUID
- HydrationRoutine
- HydrationRecordListViewModel
- HydrationGoalRecommendationAvailability
- OnboardingView
- AppleSignInDelegate
- BodyProfileUseCaseImpl
- HydrationGoalRecommendationUseCaseImpl
- AppReviewRequestStorageDataSourceImpl
- WatchHydrationHealthKitDataSource
- .makeViewModel
- WatchHydrationSnapshot
- OnboardingViewModel
- .loadChallenges
- State
- .shouldRequestAfterSuccessfulHydrationRecord
- AGENTS.md Onboarding Map
- Growth Scorecard
- Sendable
- AppDelegate
- GlareCircleView
- AI PR Review Workflow
- .makeModelContainer
- .fetchPersonalizedChallenges
- AuthTokens
- Security And Privacy Operations
- HydrationReminderDomain
- FoundationModelsHydrationGoalRecommendationDataSource
- PersonalizedChallengeUseCaseImpl
- LogWaterAmountOption
- Reliability Recovery
- BundleAppInfoProvider
- HealthKitAuthorizationStatus
- .init
- UbiquitousMirroredStore
- WaterDropView
- TokenProperty
- AppDelegate.swift
- ConfigurationAppIntent
- SettingsViewModelTests
- BodyProfileAvailability
- .weeklyInsightCalculatesRoutineRatesAndMissPattern
- WatchHydrationUseCaseImpl
- HydrationReminderNotification
- #321 수분 알림 바로 기록
- Mulimi
- UserPreferencesDataSourceImpl
- 프로젝트 전체 구조와 의존성
- HydrationComebackRepositoryImpl
- DIEnvironment
- .setHydrationEvents
- HydrationReminderActionResult
- RoutineEditorDraft
- ContentState
- WaterWaveView
- Error
- AnyObject
- LogWaterAppShortcuts
- WaterDropShaders.metal
- .resolve
- HydrationRoutineSchedule
- BodyProfile
- Challenge State Model
- AppCoordinator
- UserPreferencesRepositoryImpl
- WatchDailyGoalUserDefaultsDataSource
- StackRouting
- Accessibility and Dynamic Type Audit
- HydrationWeeklyReportTimeSlot
- RoutineNotificationDataSourceImpl
- ci_post_clone.sh
- pre-commit
- BodyProfileSettingView
- ChallengeStorageDataSourceImpl
- HydrationInsightCategory
- HydrationGoalRecommendationRepositoryImpl
- check-architecture.sh
- Profile Information Architecture
- lint.sh
- lint-fix.sh
- .progressSnapshot
- .makeComebackViewModel
- ProfileRoutineViewModel.swift
- TestLiveActivity
- 전체 타깃 직접 의존 목록
- HydrationGoalRecommendationUnavailableReason
- AuthProvider
- Mulimi Pull Request Template
- PostHogAnalyticsRepository
- MockHydrationReminderUseCaseForTesting
- .guideCombinesRemainingServingAndNextRoutine
- View
- ChallengeCategory
- HydrationGoalRecommendationInput
- Completed Plan Archive
- SheetRouting
- WatchDataConstants.swift
- HydrationRoutineRecommendationKind
- WatchHydrationRepositoryImpl
- Personalized Challenge Strategy
- AuthenticationError
- MockAppReviewRequestUseCase
- AnalyticsUseCaseImpl
- .deleteEvent
- HydrationRoutineAdherenceStatus
- MockHydrationProgressUseCase
- .drinkWater
- MockHydrationProgressUseCaseForTesting
- MockRoutineRecommendationUseCaseForTesting
- .hasSeenPermissionPriming

## God Nodes (most connected - your core abstractions)
1. `HydrationDomain` - 112 edges
2. `AccountDomain` - 100 edges
3. `HydrationInsightViewModel` - 95 edges
4. `DrinkWaterViewModel` - 85 edges
5. `HydrationRoutine` - 85 edges
6. `ProfileRoutineViewModel` - 74 edges
7. `RoutineDomain` - 73 edges
8. `MulimiAnalytics` - 71 edges
9. `HydrationEvent` - 68 edges
10. `MockUserPreferencesUseCase` - 64 edges

## Surprising Connections (you probably didn't know these)
- `4. 제어 센터·액션 버튼 기록` --references--> `LogWaterAppIntent`  [INFERRED]
  Docs/feature-discovery.md → Project/App/Sources/AppIntents/LogWaterAppIntent.swift
- `Engineer` --references--> `LogWaterAppIntent`  [INFERRED]
  Docs/feature-discovery.md → Project/App/Sources/AppIntents/LogWaterAppIntent.swift
- `Opportunity` --references--> `HydrationServing`  [INFERRED]
  Docs/feature-discovery.md → Project/Features/Hydration/Domain/Sources/Entity/HydrationServing.swift
- `디렉터리와 소유권` --references--> `AppCoordinator`  [INFERRED]
  Docs/project-architecture-and-dependencies.md → Project/App/Navigation/Sources/AppCoordinator.swift
- `Release Filter` --references--> `NoOpAnalyticsRepository`  [INFERRED]
  Docs/product-specs/growth-scorecard.md → Project/Core/Analytics/Domain/Sources/Repository/AnalyticsRepository.swift

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

## Communities (181 total, 16 thin omitted)

### Community 0 - "HydrationRoutineAdherenceInsight"
Cohesion: 0.15
Nodes (23): CandidateMatch, Constants, HydrationRoutineAdherenceEvent, HydrationRoutineAdherenceInsight, .adherenceRate, .bestRoutine, .bestTimeSlot, .hasDueOccurrences (+15 more)

### Community 1 - "HydrationRecord"
Cohesion: 0.12
Nodes (10): MockHealthKitUseCaseForTesting, Bool, Date, HydrationRecord, Date, Double, HydrationRecordRow, .body (+2 more)

### Community 2 - "WidgetKit"
Cohesion: 0.14
Nodes (4): ActivityKit, AppIntents, Utils, WidgetKit

### Community 3 - "ProfileRoutineViewModel"
Cohesion: 0.10
Nodes (23): ProfileRoutineViewModel, .activeRoutineCount, .canSaveDraft, .displayedRoutines, .editorPermissionGuidance, .guidanceSummary, .hasConfiguredRoutine, .isEditingDraft (+15 more)

### Community 4 - "RoutineRepositoryImpl"
Cohesion: 0.21
Nodes (9): RoutineNotificationDataSource, RoutineStorageDataSource, RoutineRepositoryImpl, Bool, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource, SpyRoutineStorageDataSource, Result (+1 more)

### Community 5 - "HydrationServingPreset"
Cohesion: 0.16
Nodes (13): CaseIterable, HydrationServing, .additionalPresets, HydrationServingPreset, bottle, .id, tumbler, .volumeML (+5 more)

### Community 6 - "MockHealthKitRepository"
Cohesion: 0.14
Nodes (6): HealthKitUseCaseImpl, .authorisationStatus, Date, HealthKitUseCaseTests, MockHealthKitRepository, .authorisationStatus

### Community 7 - "MockUserPreferencesUseCase"
Cohesion: 0.18
Nodes (7): NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, MockUserPreferencesUseCase, Bool, Double

### Community 8 - ".tr"
Cohesion: 0.07
Nodes (38): Bundle, AppReviewRequestTaskID, DrinkWaterView, .actionButtons, .appReviewRequestTaskID, .completionText, .defaultDrinkButton, .defaultDrinkButtonAccessibilityLabel (+30 more)

### Community 9 - "HydrationChallengeBadgeHistory"
Cohesion: 0.23
Nodes (7): HydrationChallengeBadgeHistory, Date, Bool, ChallengeUseCaseTests, Calendar, Int, MockChallengeRepository

### Community 10 - "SettingsViewModel"
Cohesion: 0.06
Nodes (32): Container, Container, AppInfoProviding, StaticAppInfoProvider, SignInUseCase, AppSession, Bool, MainIconSettingView (+24 more)

### Community 11 - "Docs Index"
Cohesion: 0.11
Nodes (36): PostHog Analytics Consolidation, Documentation SSOT Map, Docs Index, Document Maintenance Rule, Analytics Architecture Boundary, Analytics Events, Analytics Event Catalog, Product Analytics Event Contract (+28 more)

### Community 12 - "HydrationEvent"
Cohesion: 0.08
Nodes (18): Bool, Date, DateInterval, MockDrinkWaterUseCaseForTesting, .currentWaterIntakeML, Bool, Date, DateInterval (+10 more)

### Community 13 - "Layer Responsibilities"
Cohesion: 0.18
Nodes (11): CI Lint and Architecture Gate, Lint Workflow, Domain Data Presentation Test Matrix, PR Unit Tests Workflow, SwiftPM Cache Retry, Selected SwiftLint Rule Set, SwiftLint Configuration, Default Validation Sequence (+3 more)

### Community 14 - "DrinkWaterViewModel"
Cohesion: 0.06
Nodes (30): HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, AppReviewRequestUseCase, .body, CustomHydrationAmountValidation, empty (+22 more)

### Community 15 - "Foundation"
Cohesion: 0.09
Nodes (7): ChallengeDomain, Foundation, FoundationModels, HydrationDomain, MulimiAnalytics, PostHog, RoutineDomain

### Community 16 - "HydrationChallengeKind"
Cohesion: 0.09
Nodes (34): Codable, HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType, streak7, weeklyAchievement80 (+26 more)

### Community 17 - "HealthKitPermissionViewModel"
Cohesion: 0.08
Nodes (25): HealthKitUseCase, HealthKitPermissionGateView, .accessCard, .body, .descriptionText, .footnoteText, .headerColor, .headerSection (+17 more)

### Community 18 - "Color"
Cohesion: 0.11
Nodes (21): ChallengeBadge, .body, ChallengeCard, .accentColor, .body, .cardBackground, ChallengeHistoryCard, .accentColor (+13 more)

### Community 19 - "MockDrinkWaterUseCase"
Cohesion: 0.12
Nodes (13): Never, HydrationRecordListViewModelTests, MockDrinkWaterUseCase, .currentWaterIntakeML, .hasPendingDrinkWater, Bool, CheckedContinuation, Date (+5 more)

### Community 20 - "HydrationWriteResult"
Cohesion: 0.09
Nodes (14): MockDrinkWaterUseCase, .currentWaterIntakeML, Double, Int, .analyticsFailureReason, HydrationWriteResult, failure, .failureReason (+6 more)

### Community 21 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, challenge, drink, history, insight, profile

### Community 22 - "RoutineUseCase"
Cohesion: 0.13
Nodes (5): RoutineRecommendationUseCase, RoutineUseCase, .body, RoutineEditorView, .body

### Community 23 - "MockDrinkWaterRepository"
Cohesion: 0.16
Nodes (9): DrinkWaterUseCaseImpl, .currentWaterIntakeML, Double, DrinkWaterUseCaseTests, ReminderLoggingTests, MockDrinkWaterRepository, .currentWaterIntakeML, Double (+1 more)

### Community 24 - ".tr"
Cohesion: 0.14
Nodes (19): CVarArg, WatchL10n, Double, Int, WatchMetricRow, .body, WatchNavigationCard, .body (+11 more)

### Community 25 - "AccountDomain"
Cohesion: 0.08
Nodes (5): AccountDomain, HydrationPresentation, MulimiKeychain, MulimiPlatform, Testing

### Community 26 - "SpyRoutineUseCase"
Cohesion: 0.10
Nodes (14): ProfileRoutineViewModelTests, SpyDrinkWaterUseCase, .currentWaterIntakeML, SpyRoutineRecommendationUseCase, SpyRoutineUseCase, SpyUserPreferencesUseCase, Bool, Calendar (+6 more)

### Community 27 - "MockRoutineRepository"
Cohesion: 0.13
Nodes (6): RoutineRepository, RoutineUseCaseImpl, RoutineUseCaseTests, MockRoutineRepository, Error, Result

### Community 28 - "LiquidGlassSegmentedControl"
Cohesion: 0.18
Nodes (14): Binding, Value, .categoryPicker, .categoryPicker, LiquidGlassSegment, .id, LiquidGlassSegmentedControl, .activeSegmentBackground (+6 more)

### Community 29 - ".assemble"
Cohesion: 0.18
Nodes (6): Release Filter, DataAssembly, Container, AnalyticsRepository, NoOpAnalyticsRepository, ProductAnalyticsEvent

### Community 30 - "Localization"
Cohesion: 0.15
Nodes (9): AlarmKit, Charts, CryptoKit, DesignSystem, Localization, HydrationPresentationShaderBundleToken, StoreKit, SwiftUI (+1 more)

### Community 31 - "AnalyticsUseCase"
Cohesion: 0.09
Nodes (19): AnalyticsUseCase, NoOpAnalyticsUseCase, ProductAnalyticsEvent, HydrationReminderUseCase, HydrationReminderPermissionGateView, .allowButtonLabel, .benefitCard, .body (+11 more)

### Community 32 - "SignInUseCaseImpl"
Cohesion: 0.07
Nodes (17): MockSignInUseCase, Bool, AppleSignInDataSource, KeyChainDataSource, AuthenticationRepositoryImpl, .isAuthenticated, Bool, UserCredential (+9 more)

### Community 33 - "HydrationChallenge"
Cohesion: 0.16
Nodes (7): MockChallengeUseCase, Calendar, Date, HydrationChallenge, .id, Int, Int

### Community 34 - "RecordCalendarView"
Cohesion: 0.08
Nodes (29): GridItem, CalendarDayView, .backgroundColor, .borderColor, .dayNumber, .progressPercentage, HydrationProgressBar, .body (+21 more)

### Community 35 - "DrinkWaterHealthKitDataSource"
Cohesion: 0.05
Nodes (28): DrinkWaterDataSource, DrinkWaterHealthKitDataSource, .currentWaterIntakeML, Bool, Calendar, Date, DateInterval, Double (+20 more)

### Community 36 - "HydrationProgressSnapshot"
Cohesion: 0.23
Nodes (10): HydrationProgressSnapshot, HydrationInsightViewModelTests, SpyRoutineUseCase, Calendar, Date, Int, MockDrinkWaterUseCase, MockHydrationRoutineAdherenceUseCase (+2 more)

### Community 37 - "ChallengeViewModel"
Cohesion: 0.07
Nodes (29): MockPersonalizedChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCaseForTesting, Calendar, Date, HydrationChallengeRecommendationSource, recentRecords (+21 more)

### Community 38 - "Hashable"
Cohesion: 0.17
Nodes (11): Hashable, AppRoute, hydrationLogging, .id, .presentationStyle, profileRoutineAction, NavigationPresentationStyle, fullScreenCover (+3 more)

### Community 39 - "String"
Cohesion: 0.13
Nodes (14): .postHogValue, Any, AnalyticsParameterName, AnalyticsParameterValue, bool, double, int, string (+6 more)

### Community 40 - "HydrationGoalRecommendationViewModel"
Cohesion: 0.08
Nodes (24): DailyLimitSettingView, .body, HydrationGoalRecommendationCard, .body, .content, Bool, HydrationGoalRecommendationUseCase, HydrationProgressUseCase (+16 more)

### Community 41 - "HydrationRoutineRecommendation"
Cohesion: 0.18
Nodes (14): MockRoutineRecommendationUseCase, Calendar, Date, HydrationRoutineRecommendation, DaySummary, RoutineRecommendationUseCaseImpl, Bool, Calendar (+6 more)

### Community 42 - "HealthKitQuantityStore"
Cohesion: 0.23
Nodes (11): HKAuthorizationStatus, HKHealthStore, HKQuantityType, HKQuantityTypeIdentifier, HKUnit, HealthKitQuantityStore, .isHealthDataAvailable, HealthQuantitySample (+3 more)

### Community 43 - "MockHydrationReminderRepository"
Cohesion: 0.14
Nodes (8): HydrationReminderRepository, HydrationReminderUseCaseImpl, Bool, HydrationReminderUseCaseTests, MockHydrationReminderRepository, Bool, Error, Result

### Community 44 - "DrinkWaterRepository"
Cohesion: 0.06
Nodes (34): Container, UserPreferencesRepository, AppReviewRequestStorageDataSource, AppReviewRequestRepositoryImpl, AppReviewRequestState, Date, Set, AppReviewRequestRepository (+26 more)

### Community 45 - "MockChallengeUseCaseForTesting"
Cohesion: 0.33
Nodes (3): MockChallengeUseCaseForTesting, Calendar, Date

### Community 46 - "ProfileRoutineView"
Cohesion: 0.19
Nodes (7): ProfileRoutineView, .guidanceCard, .permissionSection, RoutineGuidanceSlotStatus, elapsed, next, upcoming

### Community 47 - "WatchHydrationViewModel"
Cohesion: 0.15
Nodes (10): AnyView, WatchHydrationUseCase, MutationAction, record, reset, Bool, Date, Sendable (+2 more)

### Community 48 - "UserDefaults"
Cohesion: 0.10
Nodes (14): HydrationReminderStorageDataSourceImpl, Bool, RoutineStorageDataSourceImpl, Bool, Double, Int, UserDefaults, .appGroup (+6 more)

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.10
Nodes (10): MockHydrationReminderUseCase, Bool, Error, Result, HydrationReminderAuthorizationStatus, authorized, denied, notDetermined (+2 more)

### Community 50 - "Equatable"
Cohesion: 0.10
Nodes (30): Equatable, Identifiable, HydrationInsightEmptyAction, dailyGoal, record, routine, HydrationInsightEmptyCTAModel, HydrationInsightMetric (+22 more)

### Community 51 - "HydrationReminderRepositoryImpl"
Cohesion: 0.21
Nodes (8): HydrationReminderNotificationDataSource, HydrationReminderStorageDataSource, HydrationReminderRepositoryImpl, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource, Bool, Result

### Community 52 - "HealthKitDataSourceImpl"
Cohesion: 0.19
Nodes (9): HealthQuantityStoring, HealthKitDataSourceImpl, .healthKitAuthorizationStatus, .isWaterSharingAuthorized, Bool, Date, Double, Error (+1 more)

### Community 53 - "HydrationInsightViewModel"
Cohesion: 0.14
Nodes (18): HydrationInsightViewModel, .canRecordRecoveryDrink, .dailyGoalText, .emptyStateCTAs, .metrics, .routineAdherenceInsightText, .routineAdherenceMetrics, .routineAdherenceRows (+10 more)

### Community 54 - "StartTimerIntent"
Cohesion: 0.15
Nodes (12): AppIntentControlValueProvider, ControlConfigurationIntent, Provider, StartTimerIntent, Bool, ControlWidgetConfiguration, IntentResult, LocalizedStringResource (+4 more)

### Community 55 - "BodyProfileViewModel"
Cohesion: 0.10
Nodes (15): MockBodyProfileUseCase, BodyProfileSnapshot, Bool, MockBodyProfileUseCaseForDomain, BodyProfileViewModel, .availabilityState, .heightSourceText, .helperText (+7 more)

### Community 56 - "RoutineWeekday"
Cohesion: 0.11
Nodes (17): .localeWeekday, Locale, .nextActionSchedule, RoutineWeekday, .displayOrder, friday, .id, monday (+9 more)

### Community 57 - "DataAssembly.swift"
Cohesion: 0.18
Nodes (5): AccountData, ChallengeData, HydrationData, MulimiAnalyticsData, RoutineData

### Community 58 - "ChallengeUseCaseImpl"
Cohesion: 0.24
Nodes (8): ChallengeRepository, ChallengeEvaluation, ChallengeMergeResult, ChallengeUseCaseImpl, Calendar, Date, Double, Int

### Community 59 - "HydrationReminderSlot"
Cohesion: 0.10
Nodes (14): Constant, HydrationReminderNotificationDataSourceImpl, .notificationCenter, Int, Set, UNUserNotificationCenter, HydrationReminderSlot, afternoon (+6 more)

### Community 60 - "UserPreferencesUseCase"
Cohesion: 0.05
Nodes (45): SystemWidgetTimelineReloader, WidgetTimelineReloading, UserPreferencesUseCase, DrinkWaterUseCase, HydrationReminderLogResult, failed, goalExceeded, saved (+37 more)

### Community 61 - ".loadInsights"
Cohesion: 0.22
Nodes (7): .chartUpperBound, HydrationInsightWeekdayDistribution, .id, Date, DateInterval, Double, Int

### Community 62 - "MulimiWatchApp"
Cohesion: 0.22
Nodes (8): App, DrinkWaterApp, .body, Scene, MulimiWatchApp, .body, Scene, WatchDependencyInjection

### Community 63 - "MainIcon"
Cohesion: 0.05
Nodes (26): MockUserPreferencesUseCase, Bool, Double, MockUserPreferencesUseCaseForTesting, Bool, Double, MainIcon, cloud (+18 more)

### Community 64 - "LogWaterAppIntent"
Cohesion: 0.16
Nodes (13): AppIntent, IntentDialog, IntentModes, Constant, FailureReason, LogWaterAppIntent, .resolvedVolumeML, Bool (+5 more)

### Community 65 - "ProjectDescription"
Cohesion: 0.12
Nodes (5): PackageDescription, Plist, ProjectDescription, ProjectDescriptionHelpers, AppVersion

### Community 66 - "RoutineActionIntent"
Cohesion: 0.15
Nodes (13): .id, ChallengeView, .body, .challengeContent, .emptyCardBackground, .selectedCategoryContent, PersonalizedChallengeCard, .accentColor (+5 more)

### Community 67 - "ContentView"
Cohesion: 0.10
Nodes (18): ContentView, .body, AccountRoute, profileRoutine, setting, SettingMenu, bodyProfile, dailyLimit (+10 more)

### Community 68 - "Top 5"
Cohesion: 0.14
Nodes (13): 1. 로그인 없이 시작, 2. 7일 스타터 플랜, 3. 알림 바로 기록, 4. 제어 센터·액션 버튼 기록, 5. 컴백 모드, Candidate Ideas, Decision, Engineer (+5 more)

### Community 69 - "HydrationRecordDaySummary"
Cohesion: 0.17
Nodes (14): HydrationRecordDaySummaryRow, .body, .progressPercent, HydrationRecordDaySummary, .glassCount, .id, .todaySummary, HydrationRecordPeriodSummary (+6 more)

### Community 70 - "Test.swift"
Cohesion: 0.16
Nodes (16): AppIntentTimelineProvider, ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, ConfigurationAppIntent, Context (+8 more)

### Community 71 - "UUID"
Cohesion: 0.16
Nodes (8): AlarmMetadata, Bool, RoutineAlarmMetadata, UUID, Bool, HydrationEventModel, Date, Int

### Community 72 - "HydrationRoutine"
Cohesion: 0.07
Nodes (14): Int, MockRoutineUseCase, Error, Result, MockRoutineUseCaseForTesting, HydrationRoutine, Bool, RoutineNotificationAuthorizationStatus (+6 more)

### Community 73 - "HydrationRecordListViewModel"
Cohesion: 0.10
Nodes (20): HydrationRecordListView, .body, RowListView, .body, Void, HydrationRecordListViewModel, .emptyStateDescription, .emptyStateTitle (+12 more)

### Community 74 - "HydrationGoalRecommendationAvailability"
Cohesion: 0.17
Nodes (10): MockHydrationGoalRecommendationUseCase, Date, Error, HydrationGoalRecommendationAvailability, bodyProfileRequired, modelUnavailable, ready, MockHydrationGoalRecommendationUseCase (+2 more)

### Community 75 - "OnboardingView"
Cohesion: 0.14
Nodes (15): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+7 more)

### Community 76 - "AppleSignInDelegate"
Cohesion: 0.20
Nodes (9): ASAuthorization, ASAuthorizationController, ASAuthorizationControllerDelegate, AuthenticationServices, AppleSignInCredential, AppleSignInDataSourceImpl, AppleSignInDelegate, CheckedContinuation (+1 more)

### Community 77 - "BodyProfileUseCaseImpl"
Cohesion: 0.23
Nodes (4): HealthKitRepository, BodyProfileUseCaseImpl, Bool, BodyProfileUseCaseTests

### Community 78 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.17
Nodes (11): HydrationGoalRecommendationRepository, BodyProfileUseCase, Constants, HydrationGoalRecommendationUseCaseImpl, Calendar, Date, DateInterval, Int (+3 more)

### Community 80 - "WatchHydrationHealthKitDataSource"
Cohesion: 0.23
Nodes (8): Bool, Calendar, Date, DateInterval, Error, Int, WatchHydrationHealthKitDataSource, .isWaterSharingAuthorized

### Community 81 - ".makeViewModel"
Cohesion: 0.23
Nodes (5): MockHydrationGoalRecommendationUseCase, MockHydrationProgressUseCase, HydrationGoalRecommendationViewModelTests, Double, Int

### Community 82 - "WatchHydrationSnapshot"
Cohesion: 0.12
Nodes (15): Date, Int, WatchHydrationEvent, WatchHydrationMutationResult, Bool, Date, Double, Int (+7 more)

### Community 83 - "OnboardingViewModel"
Cohesion: 0.15
Nodes (10): RootView, .body, Content, SignInView, .body, OnboardingViewModel, .canGoBack, .isLastPage (+2 more)

### Community 84 - ".loadChallenges"
Cohesion: 0.26
Nodes (8): ChallengeViewModelTests, Calendar, MockChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCase, Calendar, Date

### Community 85 - "State"
Cohesion: 0.25
Nodes (6): State, bodyProfileRequired, idle, loading, modelUnavailable, ready

### Community 86 - ".shouldRequestAfterSuccessfulHydrationRecord"
Cohesion: 0.28
Nodes (5): NoOpAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 87 - "AGENTS.md Onboarding Map"
Cohesion: 0.13
Nodes (21): Quality Gates, Truthful Validation Reporting, Validation Baseline, Validation Matrix, architecture-boundary, Clean Architecture and MVVM, Domain Purity, ViewModel Side Effect Boundary (+13 more)

### Community 88 - "Growth Scorecard"
Cohesion: 0.12
Nodes (16): 72-Hour Audit, Before Release, Cadence And Ownership, Decision Rule, Deferred Scope, Experiment Record, Goal, Growth Scorecard (+8 more)

### Community 89 - "Sendable"
Cohesion: 0.09
Nodes (15): MockHydrationNextActionGuideUseCase, Calendar, Date, MockHydrationRoutineAdherenceUseCase, Calendar, Date, MockHydrationNextActionGuideUseCaseForTesting, Calendar (+7 more)

### Community 90 - "AppDelegate"
Cohesion: 0.18
Nodes (11): NSObject, AppDelegate, Any, Bool, UNUserNotificationCenter, UIApplication, UIApplicationDelegate, UNNotification (+3 more)

### Community 91 - "GlareCircleView"
Cohesion: 0.17
Nodes (7): CGPoint, GlareCircleView, .body, CGFloat, Content, WaterDropGlareEffectModifier, ViewModifier

### Community 92 - "AI PR Review Workflow"
Cohesion: 0.18
Nodes (12): AI PR Review Workflow, Architecture Review Policy, Bounded AI Review Diff, Git Flow PR Filter, Textual Diff Selection, Clean Architecture and MVVM Discipline, Domain Purity, Hydration Source of Truth (+4 more)

### Community 93 - ".makeModelContainer"
Cohesion: 0.19
Nodes (10): ModelConfiguration, ModelContainer, SharedHydrationStore, .isICloudAccountAvailable, SharedHydrationStoreError, .errorDescription, failedToCreateContainer, missingAppGroupContainer (+2 more)

### Community 94 - ".fetchPersonalizedChallenges"
Cohesion: 0.37
Nodes (5): PersonalizedChallengeUseCaseTests, Calendar, Date, Double, Int

### Community 95 - "AuthTokens"
Cohesion: 0.31
Nodes (4): AuthenticationNetworkDataSource, AuthenticationNetworkDataSourceImpl, AuthTokens, Int

### Community 96 - "Security And Privacy Operations"
Cohesion: 0.11
Nodes (20): HealthKit Source of Truth, Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling, Data Boundary, Health Data Minimization (+12 more)

### Community 97 - "HydrationReminderDomain"
Cohesion: 0.06
Nodes (19): AccountPresentation, Assembler, Assembly, ChallengePresentation, DependencyInjection, HydrationReminderDomain, HydrationReminderPresentation, MulimiNavigation (+11 more)

### Community 98 - "FoundationModelsHydrationGoalRecommendationDataSource"
Cohesion: 0.24
Nodes (6): Constants, FoundationModelsHydrationGoalRecommendationDataSource, GeneratedHydrationGoalRecommendation, Int, Locale, SystemLanguageModel

### Community 99 - "PersonalizedChallengeUseCaseImpl"
Cohesion: 0.19
Nodes (9): HydrationChallengeTier, beginner, steady, stretch, Constants, PersonalizedChallengeUseCaseImpl, Calendar, Date (+1 more)

### Community 100 - "LogWaterAmountOption"
Cohesion: 0.18
Nodes (11): AppEnum, DisplayRepresentation, LogWaterAmountOption, bottle, custom, glass, .presetID, .servingType (+3 more)

### Community 101 - "Reliability Recovery"
Cohesion: 0.22
Nodes (10): Goal Mirror Recovery Policy, Recovery Principles, Reliability Recovery, Routine Schedule Recovery, Shared Hydration Rules, HealthKit Data Flow, healthkit-flow, Health Data Storage Policy (+2 more)

### Community 102 - "BundleAppInfoProvider"
Cohesion: 0.47
Nodes (3): BundleAppInfoProvider, .appBuildNumber, .appVersion

### Community 103 - "HealthKitAuthorizationStatus"
Cohesion: 0.26
Nodes (6): HealthKitAuthorizationStatus, notDetermined, sharingAuthorized, sharingDenied, .analyticsValue, ProductAnalyticsEvent

### Community 104 - ".init"
Cohesion: 0.18
Nodes (8): Bool, Calendar, Date, Double, Int, MockHydrationProgressUseCase, Calendar, Date

### Community 105 - "UbiquitousMirroredStore"
Cohesion: 0.22
Nodes (5): Double, NSUbiquitousKeyValueStore, UbiquitousMirroredStore, NSUbiquitousKeyValueStore, NSUbiquitousKeyValueStore

### Community 106 - "WaterDropView"
Cohesion: 0.25
Nodes (8): CGFloat, CGSize, TimeInterval, WaterDropView, .body, .dropBackground, .dropHighlights, .dropSymbol

### Community 107 - "TokenProperty"
Cohesion: 0.12
Nodes (10): KeychainStore, KeychainStoring, KeyChainDataSourceImpl, Bool, TokenProperty, accessToken, email, nickname (+2 more)

### Community 108 - "AppDelegate.swift"
Cohesion: 0.12
Nodes (8): HealthKit, HydrationReminderData, MulimiHealthKit, OSLog, UserNotifications, WatchHydrationData, WatchHydrationDomain, WatchHydrationPresentation

### Community 109 - "ConfigurationAppIntent"
Cohesion: 0.18
Nodes (9): IntentDescription, ConfigurationAppIntent, .description, .title, LocalizedStringResource, ConfigurationAppIntent, IntentResult, LocalizedStringResource (+1 more)

### Community 110 - "SettingsViewModelTests"
Cohesion: 0.20
Nodes (10): LocalizedError, MockError, .errorDescription, signInFailed, MockError, deleteFailed, .errorDescription, MockError (+2 more)

### Community 111 - "BodyProfileAvailability"
Cohesion: 0.18
Nodes (9): BodyProfileAvailability, incomplete, needsPermission, noData, permissionDenied, ready, HydrationGoalRecommendationError, bodyProfileRequired (+1 more)

### Community 112 - ".weeklyInsightCalculatesRoutineRatesAndMissPattern"
Cohesion: 0.23
Nodes (8): HydrationRoutineAdherenceUseCaseImpl, Calendar, Date, DateInterval, HydrationRoutineAdherenceUseCaseTests, Calendar, Date, Int

### Community 113 - "WatchHydrationUseCaseImpl"
Cohesion: 0.27
Nodes (6): WatchDailyGoalRepository, WatchHydrationRepository, Date, Double, Int, WatchHydrationUseCaseImpl

### Community 114 - "HydrationReminderNotification"
Cohesion: 0.22
Nodes (6): HydrationReminderNotification, .category, Bool, Date, HydrationReminderNotificationTests, UNNotificationCategory

### Community 115 - "#321 수분 알림 바로 기록"
Cohesion: 0.20
Nodes (10): #321 수분 알림 바로 기록, Completion Notes, Constraints, Context, Goal, Non-Goals, Open Questions, Plan (+2 more)

### Community 116 - "Mulimi"
Cohesion: 0.16
Nodes (20): Agent Onboarding Guide, Graphify-Assisted Code Navigation, Mulimi Architecture SSOT, Core User Flow, Claude Agent Entrypoint, Delivery Workflow, Git Flow Delivery Strategy, Issue Closure Policy (+12 more)

### Community 117 - "UserPreferencesDataSourceImpl"
Cohesion: 0.24
Nodes (5): SyncedValueStoring, Constants, Bool, Double, UserPreferencesDataSourceImpl

### Community 118 - "프로젝트 전체 구조와 의존성"
Cohesion: 0.20
Nodes (9): 검증과 갱신, 기능 간 직접 의존에서 주의할 점, 디렉터리와 소유권, 생성 검증 결과, 실행·공유 경계, 읽는 방법, 저장·외부 연동, 프로젝트 전체 구조와 의존성 (+1 more)

### Community 119 - "HydrationComebackRepositoryImpl"
Cohesion: 0.43
Nodes (3): HydrationComebackRepositoryImpl, Date, HydrationComebackRepositoryTests

### Community 120 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 121 - ".setHydrationEvents"
Cohesion: 0.40
Nodes (4): RoutineRecommendationUseCaseTests, Calendar, Date, Int

### Community 122 - "HydrationReminderActionResult"
Cohesion: 0.15
Nodes (14): HydrationReminderActionResult, duplicate, failed, goalExceeded, permissionRequired, protectedDataUnavailable, saved, signInRequired (+6 more)

### Community 123 - "RoutineEditorDraft"
Cohesion: 0.31
Nodes (7): .weekdayGrid, RoutineEditorDraft, .canSave, .isEditing, Bool, Date, Set

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (7): ActivityAttributes, ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 125 - "WaterWaveView"
Cohesion: 0.28
Nodes (6): CGRect, Path, CGFloat, WaterWaveView, .animatableData, Shape

### Community 126 - "Error"
Cohesion: 0.08
Nodes (23): Error, HealthQuantityStoreError, incompleteQuery, internalError, invalidObjectType, permissionDenied, MockSignInError, deleteAccountFailed (+15 more)

### Community 127 - "AnyObject"
Cohesion: 0.25
Nodes (4): AnyObject, FullScreenRoute, DeepLinkHandling, FullScreenRouting

### Community 128 - "LogWaterAppShortcuts"
Cohesion: 0.29
Nodes (6): AppShortcut, AppShortcutsProvider, LogWaterAppShortcuts, .appShortcuts, .shortcutTileColor, ShortcutTileColor

### Community 129 - "WaterDropShaders.metal"
Cohesion: 0.43
Nodes (6): float2, half4, metal_stdlib, mulimiWaterDistortion(), mulimiWaterLighting(), mulimiWaveNoise()

### Community 130 - ".resolve"
Cohesion: 0.36
Nodes (6): PreviewViews, .challenge, .drinkWater, .hydrationList, .profile, Service

### Community 131 - "HydrationRoutineSchedule"
Cohesion: 0.13
Nodes (20): Constants, HydrationNextActionGuide, .progress, HydrationNextActionGuideState, approachingRoutine, goalReached, needsGoal, readyToDrink (+12 more)

### Community 132 - "BodyProfile"
Cohesion: 0.11
Nodes (11): MockHealthKitUseCase, Date, BodyProfile, .isComplete, .isEmpty, BodyProfileSource, healthKit, manual (+3 more)

### Community 133 - "Challenge State Model"
Cohesion: 0.50
Nodes (5): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Legacy Challenge State Migration, Recurring Challenge State

### Community 134 - "AppCoordinator"
Cohesion: 0.39
Nodes (3): AppCoordinator, AppCoordinatorTests, URL

### Community 135 - "UserPreferencesRepositoryImpl"
Cohesion: 0.24
Nodes (4): UserPreferencesDataSource, Bool, Double, UserPreferencesRepositoryImpl

### Community 136 - "WatchDailyGoalUserDefaultsDataSource"
Cohesion: 0.27
Nodes (6): MulimiCloudKit, Int, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, Int, WatchDailyGoalRepositoryImpl

### Community 137 - "StackRouting"
Cohesion: 0.25
Nodes (4): StackRouting, .hasPath, Bool, Hashable

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "HydrationWeeklyReportTimeSlot"
Cohesion: 0.24
Nodes (6): HydrationWeeklyReportTimeSlot, afternoon, evening, morning, .sortOrder, Bool

### Community 140 - "RoutineNotificationDataSourceImpl"
Cohesion: 0.21
Nodes (6): Alarm, AlarmManager, AlarmPresentation, Constant, RoutineNotificationDataSourceImpl, LocalizedStringResource

### Community 143 - "BodyProfileSettingView"
Cohesion: 0.31
Nodes (5): BodyProfileSettingView, .body, .healthSyncCard, .summaryCard, Void

### Community 144 - "ChallengeStorageDataSourceImpl"
Cohesion: 0.29
Nodes (4): ChallengeStorageDataSource, ChallengeStorageDataSourceImpl, ChallengeRepositoryImpl, ChallengeStorageDataSourceTests

### Community 145 - "HydrationInsightCategory"
Cohesion: 0.22
Nodes (9): HydrationInsightCategory, .id, overview, pattern, report, routine, .systemImage, .title (+1 more)

### Community 148 - "Profile Information Architecture"
Cohesion: 0.67
Nodes (4): Goal Recommendation Entry Rules, Profile Information Architecture, Profile Root, Settings Screen

### Community 151 - ".progressSnapshot"
Cohesion: 0.40
Nodes (4): HydrationProgressUseCaseTests, Calendar, Date, Int

### Community 152 - ".makeComebackViewModel"
Cohesion: 0.17
Nodes (9): HydrationComebackRepository, HydrationComebackMode, baseline, card, disabled, StubHydrationComebackRepository, Bool, Date (+1 more)

### Community 153 - "ProfileRoutineViewModel.swift"
Cohesion: 0.28
Nodes (3): CoreGraphics, Observation, RoutinePresentation

### Community 154 - "TestLiveActivity"
Cohesion: 0.14
Nodes (14): ControlWidget, Widget, TestBundle, .body, WidgetConfiguration, TestLiveActivity, .body, DrinkWaterWidgetBundle (+6 more)

### Community 155 - "전체 타깃 직접 의존 목록"
Cohesion: 0.33
Nodes (6): App · 조립 루트 — 9개, Core — 6개, Features — 18개, Shared — 5개, Tests — 15개, 전체 타깃 직접 의존 목록

### Community 156 - "HydrationGoalRecommendationUnavailableReason"
Cohesion: 0.25
Nodes (6): HydrationGoalRecommendationUnavailableReason, appleIntelligenceNotEnabled, deviceNotEligible, modelNotReady, unknown, unsupportedLocale

### Community 157 - "AuthProvider"
Cohesion: 0.40
Nodes (4): AuthProvider, apple, google, kakao

### Community 158 - "Mulimi Pull Request Template"
Cohesion: 0.50
Nodes (4): Local Validation Reporting, Mulimi Pull Request Template, PR Review Checklist, Truthful Validation Reporting

### Community 162 - "View"
Cohesion: 0.10
Nodes (22): BadgeView, .body, HydrationInsightView, .emptyStateCTAButtons, .insightContent, .overviewCard, .routineAdherenceCard, .selectedCategoryContent (+14 more)

### Community 163 - "ChallengeCategory"
Cohesion: 0.25
Nodes (8): ChallengeCategory, completed, .id, inProgress, recommended, .systemImage, .title, Self

### Community 164 - "HydrationGoalRecommendationInput"
Cohesion: 0.50
Nodes (3): HydrationGoalRecommendation, HydrationGoalRecommendationInput, Int

### Community 165 - "Completed Plan Archive"
Cohesion: 0.40
Nodes (5): Stale Document Handling, Active Exec Plans, Active Plan Lifecycle, Completed Exec Plans, Completed Plan Archive

### Community 168 - "HydrationRoutineRecommendationKind"
Cohesion: 0.29
Nodes (5): HydrationRoutineRecommendationKind, afternoonGap, frequentHydrationWindow, morningStart, .recommendationCards

### Community 169 - "WatchHydrationRepositoryImpl"
Cohesion: 0.36
Nodes (4): WatchHydrationLocalDataSource, Date, Int, WatchHydrationRepositoryImpl

### Community 170 - "Personalized Challenge Strategy"
Cohesion: 0.50
Nodes (4): Personalized Challenge Strategy, Personalized Challenge Recommendation Candidates, Challenge Recommendation Tier Rules, Challenge and Insight Information Architecture

### Community 171 - "AuthenticationError"
Cohesion: 0.29
Nodes (6): AuthenticationError, cancelled, invalidCredential, networkFailed, serverError, unknown

### Community 172 - "MockAppReviewRequestUseCase"
Cohesion: 0.48
Nodes (5): MockAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 175 - "HydrationRoutineAdherenceStatus"
Cohesion: 0.33
Nodes (6): HydrationRoutineAdherenceStatus, inactive, needsAttention, noDueOccurrences, noRecords, onTrack

### Community 176 - "MockHydrationProgressUseCase"
Cohesion: 0.40
Nodes (3): MockHydrationProgressUseCase, Calendar, Date

### Community 178 - "MockHydrationProgressUseCaseForTesting"
Cohesion: 0.40
Nodes (3): MockHydrationProgressUseCaseForTesting, Calendar, Date

### Community 179 - "MockRoutineRecommendationUseCaseForTesting"
Cohesion: 0.40
Nodes (3): MockRoutineRecommendationUseCaseForTesting, Calendar, Date

## Ambiguous Edges - Review These
- `HealthKit Source of Truth` → `CloudKit-Backed Hydration Store`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to
- `CloudKit-Backed Hydration Store` → `Current Storage Strategy`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to

## Knowledge Gaps
- **491 isolated node(s):** `.resolver`, `production`, `preview`, `testing`, `.current` (+486 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 914 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **16 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `HealthKit Source of Truth` and `CloudKit-Backed Hydration Store`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `Current Storage Strategy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `String` connect `String` to `HydrationRoutineAdherenceInsight`, `HydrationRecord`, `ProfileRoutineViewModel`, `HydrationServingPreset`, `.tr`, `HydrationChallengeBadgeHistory`, `SettingsViewModel`, `HydrationEvent`, `DrinkWaterViewModel`, `HydrationChallengeKind`, `HealthKitPermissionViewModel`, `Color`, `MockDrinkWaterUseCase`, `HydrationWriteResult`, `MockDrinkWaterRepository`, `.tr`, `SpyRoutineUseCase`, `LiquidGlassSegmentedControl`, `.assemble`, `AnalyticsUseCase`, `SignInUseCaseImpl`, `HydrationChallenge`, `RecordCalendarView`, `DrinkWaterHealthKitDataSource`, `ChallengeViewModel`, `Hashable`, `HydrationGoalRecommendationViewModel`, `HydrationRoutineRecommendation`, `HealthKitQuantityStore`, `DrinkWaterRepository`, `ProfileRoutineView`, `WatchHydrationViewModel`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `Equatable`, `HealthKitDataSourceImpl`, `HydrationInsightViewModel`, `StartTimerIntent`, `BodyProfileViewModel`, `RoutineWeekday`, `ChallengeUseCaseImpl`, `HydrationReminderSlot`, `UserPreferencesUseCase`, `.loadInsights`, `MainIcon`, `LogWaterAppIntent`, `ProjectDescription`, `RoutineActionIntent`, `ContentView`, `HydrationRecordDaySummary`, `Test.swift`, `UUID`, `HydrationRoutine`, `HydrationRecordListViewModel`, `OnboardingView`, `AppleSignInDelegate`, `AppReviewRequestStorageDataSourceImpl`, `.shouldRequestAfterSuccessfulHydrationRecord`, `.makeModelContainer`, `AuthTokens`, `FoundationModelsHydrationGoalRecommendationDataSource`, `PersonalizedChallengeUseCaseImpl`, `LogWaterAmountOption`, `BundleAppInfoProvider`, `HealthKitAuthorizationStatus`, `UbiquitousMirroredStore`, `TokenProperty`, `ConfigurationAppIntent`, `SettingsViewModelTests`, `HydrationReminderNotification`, `UserPreferencesDataSourceImpl`, `HydrationReminderActionResult`, `RoutineEditorDraft`, `ContentState`, `HydrationRoutineSchedule`, `BodyProfile`, `HydrationWeeklyReportTimeSlot`, `RoutineNotificationDataSourceImpl`, `BodyProfileSettingView`, `ChallengeStorageDataSourceImpl`, `HydrationInsightCategory`, `.progressSnapshot`, `.makeComebackViewModel`, `HydrationGoalRecommendationUnavailableReason`, `PostHogAnalyticsRepository`, `View`, `ChallengeCategory`, `HydrationGoalRecommendationInput`, `HydrationRoutineRecommendationKind`, `AuthenticationError`, `MockAppReviewRequestUseCase`, `AnalyticsUseCaseImpl`, `HydrationRoutineAdherenceStatus`, `.drinkWater`?**
  _High betweenness centrality (0.305) - this node is a cross-community bridge._
- **Why does `프로젝트 전체 구조와 의존성` connect `프로젝트 전체 구조와 의존성` to `전체 타깃 직접 의존 목록`, `Mulimi`?**
  _High betweenness centrality (0.092) - this node is a cross-community bridge._
- **Why does `실행·공유 경계` connect `프로젝트 전체 구조와 의존성` to `HydrationRoutineSchedule`, `HydrationWriteResult`, `HydrationServingPreset`?**
  _High betweenness centrality (0.074) - this node is a cross-community bridge._
- **What connects `.resolver`, `production`, `preview` to the rest of the system?**
  _491 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `HydrationRecord` be split into smaller, more focused modules?**
  _Cohesion score 0.11688311688311688 - nodes in this community are weakly interconnected._