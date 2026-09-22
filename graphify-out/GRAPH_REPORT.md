# Graph Report - Mulimi  (2026-09-22)

## Corpus Check
- 393 files · ~176,279 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 23 file(s) not represented in the graph (top: .entitlements 6, .plist 6, (none) 3)

## Summary
- 3849 nodes · 10161 edges · 179 communities (166 shown, 13 thin omitted)
- Extraction: 85% EXTRACTED · 15% INFERRED · 0% AMBIGUOUS · INFERRED: 1481 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `2a5baf56`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Sendable
- HydrationRecord
- WatchHydrationLocalDataSource.swift
- ProfileRoutineViewModel
- RoutineRepositoryImpl
- Equatable
- MockHealthKitRepository
- MockUserPreferencesUseCase
- .tr
- HydrationChallengeBadgeHistory
- SettingsViewModel
- Hydration Logging
- HydrationPresentation
- AnalyticsUseCase
- DrinkWaterViewModel
- HydrationDomain
- HydrationChallengeKind
- HealthKitPermissionViewModel
- RoutineActionIntent
- MockDrinkWaterUseCase
- HydrationEvent
- BodyProfile
- DrinkWaterRepository
- MockDrinkWaterRepository
- .tr
- AccountDomain
- SpyRoutineUseCase
- MockRoutineRepository
- LiquidGlassSegmentedControl
- PostHogAnalyticsRepository
- Localization
- HydrationReminderPermissionViewModel
- UserCredential
- ChallengeViewModel
- RecordCalendarView
- HealthKitSource
- .loadInsights
- PersonalizedHydrationChallenge
- AnyObject
- String
- HydrationGoalRecommendationViewModel
- RoutineRecommendationUseCaseImpl
- HealthKitDataSourceImpl
- MockHydrationReminderRepository
- RoutineUseCase
- MockChallengeUseCaseForTesting
- ProfileRoutineView
- DIContainer
- UserDefaults
- HydrationReminderAuthorizationStatus
- SpyDrinkWaterUseCase
- HydrationReminderRepositoryImpl
- HydrationInsightView
- HydrationInsightViewModel
- StartTimerIntent
- BodyProfileViewModel
- DrinkWaterHealthKitDataSource
- DrinkWaterUseCase
- ChallengeUseCaseImpl
- HydrationReminderSlot
- DrinkWaterEntry
- .makeUseCase
- 실행·공유 경계
- AppReviewRequestUseCaseImpl
- LogWaterAppIntent
- ProjectDescription
- HydrationStarterPlanViewModel
- ContentView
- Top 5
- MainIcon
- Test.swift
- ChallengeStorageDataSourceImpl
- HydrationRoutine
- HydrationRecordListViewModel
- Hashable
- OnboardingView
- View
- .assemble
- HydrationGoalRecommendationUseCaseImpl
- AppReviewRequestState
- UUID
- UserPreferencesUseCaseImpl
- WatchHydrationSnapshot
- OnboardingViewModel
- .loadChallenges
- Color
- AppReviewRequestUseCase
- Mulimi Drop — v3
- Growth Scorecard
- AppleSignInCredential
- AppDelegate
- MockUserPreferencesUseCase
- 프로젝트 전체 구조와 의존성
- HydrationGoalRecommendationAvailability
- HydrationProgressUseCaseImpl
- AuthTokens
- Security And Privacy Operations
- Foundation
- FoundationModelsHydrationGoalRecommendationDataSource
- PersonalizedChallengeUseCaseImpl
- LogWaterAmountOption
- AGENTS.md Onboarding Map
- .assemble
- HealthKitAuthorizationStatus
- HydrationProgressSnapshot
- HydrationReminderPermissionGateView
- WaterDropView
- HydrationServingPreset
- Generation prompts
- ConfigurationAppIntent
- SettingsViewModelTests
- DrinkWaterRepositoryImpl
- HydrationRoutineSchedule
- WatchHydrationUseCaseImpl
- AppRoute
- MockUserPreferencesRepository
- AI PR Review Workflow
- UserPreferencesDataSourceImpl
- TokenProperty
- .makeViewModel
- DIEnvironment
- MockHydrationReminderUseCase
- .handle
- KeychainStoring
- ContentState
- HealthKitUseCase
- Error
- HydrationWriteResult
- LogWaterAppShortcuts
- WaterDropShaders.metal
- .resolve
- HydrationNextActionGuide
- #320 — 7일 스타터 플랜 제품 적용
- Docs Index
- RoutineWeekday
- UserPreferencesRepositoryImpl
- WatchDailyGoalLocalDataSource
- HealthKitDataSource
- Accessibility and Dynamic Type Audit
- WatchHydrationMutationResult
- RoutineNotificationDataSourceImpl
- ci_post_clone.sh
- pre-commit
- Test
- DrinkWaterLockScreenWidgetEntryView
- WatchRootView.swift
- ProfileView
- check-architecture.sh
- MockAppReviewRequestUseCase
- lint.sh
- lint-fix.sh
- .progressSnapshot
- .makeComebackViewModel
- L10n
- LogWaterControl
- Challenge State Model
- BundleAppInfoProvider
- AuthProvider
- Mulimi Pull Request Template
- Personalized Challenge Strategy
- Generation — Mulimi Water Glass v2
- .hasCompletedOnboarding
- RoutineRecoveryReminderAction
- .setDailyWaterLimit
- WatchHydrationViewModel
- #321 수분 알림 바로 기록
- WatchDataConstants.swift
- MockUserPreferencesUseCaseForTesting
- UserPreferencesRepository
- Reliability Recovery
- HydrationReminderNotification
- WaterWaveView
- HydrationInsightCategory
- Layer Responsibilities
- SettingMenu
- .drinkWater
- HydrationReminderActionResult
- BodyProfileAvailability
- .deleteHydrationEvent

## God Nodes (most connected - your core abstractions)
1. `HydrationDomain` - 118 edges
2. `AccountDomain` - 100 edges
3. `HydrationRoutine` - 96 edges
4. `HydrationInsightViewModel` - 95 edges
5. `DrinkWaterViewModel` - 85 edges
6. `RoutineDomain` - 75 edges
7. `ProfileRoutineViewModel` - 74 edges
8. `MulimiAnalytics` - 73 edges
9. `HydrationEvent` - 73 edges
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

## Communities (179 total, 13 thin omitted)

### Community 0 - "Sendable"
Cohesion: 0.09
Nodes (37): MockHydrationRoutineAdherenceUseCase, Calendar, Date, MockHydrationRoutineAdherenceUseCaseForTesting, Calendar, Date, CandidateMatch, Constants (+29 more)

### Community 1 - "HydrationRecord"
Cohesion: 0.09
Nodes (12): Date, MockHealthKitUseCaseForTesting, Bool, Date, HydrationRecord, Date, Double, Date (+4 more)

### Community 2 - "WatchHydrationLocalDataSource.swift"
Cohesion: 0.16
Nodes (6): HealthKit, MulimiHealthKit, OSLog, WatchHydrationData, WatchHydrationDomain, WatchHydrationPresentation

### Community 3 - "ProfileRoutineViewModel"
Cohesion: 0.07
Nodes (30): RoutineRecommendationUseCase, Calendar, Date, .body, .weekdayGrid, ProfileRoutineViewModel, .activeRoutineCount, .canSaveDraft (+22 more)

### Community 4 - "RoutineRepositoryImpl"
Cohesion: 0.20
Nodes (9): RoutineNotificationDataSource, RoutineStorageDataSource, RoutineRepositoryImpl, Bool, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource, SpyRoutineStorageDataSource, Result (+1 more)

### Community 5 - "Equatable"
Cohesion: 0.13
Nodes (26): Equatable, Identifiable, HydrationServingOptionModel, .volumeText, HydrationInsightEmptyCTAModel, HydrationInsightMetric, HydrationWeeklyReportMetric, RoutineAdherenceInsightMetric (+18 more)

### Community 6 - "MockHealthKitRepository"
Cohesion: 0.13
Nodes (6): HealthKitUseCaseImpl, .authorisationStatus, Date, HealthKitUseCaseTests, MockHealthKitRepository, .authorisationStatus

### Community 7 - "MockUserPreferencesUseCase"
Cohesion: 0.17
Nodes (8): NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, Bool, MockUserPreferencesUseCase, Bool, Double

### Community 8 - ".tr"
Cohesion: 0.08
Nodes (34): .drinkWaterView, .body, .body, HealthKitPermissionGateView, .accessCard, .descriptionText, .footnoteText, .headerColor (+26 more)

### Community 9 - "HydrationChallengeBadgeHistory"
Cohesion: 0.17
Nodes (9): MockChallengeUseCase, Calendar, Date, HydrationChallengeBadgeHistory, Date, ChallengeUseCaseTests, Calendar, Int (+1 more)

### Community 10 - "SettingsViewModel"
Cohesion: 0.06
Nodes (33): Container, Container, AppInfoProviding, StaticAppInfoProvider, SignInUseCase, AppSession, Bool, SignInView (+25 more)

### Community 11 - "Hydration Logging"
Cohesion: 0.12
Nodes (32): PostHog Analytics Consolidation, Analytics Architecture Boundary, Analytics Events, Analytics Event Catalog, Product Analytics Event Contract, PostHog Activity QA, Analytics Operations, PostHog Core Product Funnel (+24 more)

### Community 12 - "HydrationPresentation"
Cohesion: 0.19
Nodes (9): AccountPresentation, ChallengePresentation, DependencyInjection, HydrationPresentation, HydrationReminderPresentation, MulimiNavigation, MulimiPlatform, RoutinePresentation (+1 more)

### Community 13 - "AnalyticsUseCase"
Cohesion: 0.10
Nodes (14): AnalyticsUseCase, NoOpAnalyticsUseCase, SystemWidgetTimelineReloader, WidgetTimelineReloading, Double, UserPreferencesUseCase, HydrationReminderActionHandler, Bool (+6 more)

### Community 14 - "DrinkWaterViewModel"
Cohesion: 0.07
Nodes (29): HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, .body, .overflowMenu, CustomHydrationAmountValidation, empty (+21 more)

### Community 15 - "HydrationDomain"
Cohesion: 0.09
Nodes (6): ChallengeDomain, CoreGraphics, HydrationDomain, MulimiAnalytics, Observation, RoutineDomain

### Community 16 - "HydrationChallengeKind"
Cohesion: 0.09
Nodes (35): Codable, HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType, streak7, weeklyAchievement80 (+27 more)

### Community 17 - "HealthKitPermissionViewModel"
Cohesion: 0.13
Nodes (11): ProductAnalyticsEvent, .body, HealthKitPermissionViewModel, .defaultErrorMessage, .deniedMessage, Bool, HealthKitPermissionViewModelTests, MockHealthKitUseCase (+3 more)

### Community 18 - "RoutineActionIntent"
Cohesion: 0.12
Nodes (19): .id, ChallengeSectionHeader, .body, ChallengeView, .body, .challengeContent, .completedCategorySection, .emptyCardBackground (+11 more)

### Community 19 - "MockDrinkWaterUseCase"
Cohesion: 0.10
Nodes (14): Never, HydrationRecordListViewModelTests, RecordSpyWidgetTimelineReloader, MockDrinkWaterUseCase, .currentWaterIntakeML, .hasPendingDrinkWater, Bool, CheckedContinuation (+6 more)

### Community 20 - "HydrationEvent"
Cohesion: 0.09
Nodes (16): MockDrinkWaterUseCase, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int, HydrationEvent (+8 more)

### Community 21 - "BodyProfile"
Cohesion: 0.12
Nodes (12): MockHealthKitUseCase, BodyProfile, .isComplete, .isEmpty, BodyProfileSource, healthKit, manual, BodyProfileValue (+4 more)

### Community 22 - "DrinkWaterRepository"
Cohesion: 0.11
Nodes (8): DrinkWaterRepository, Bool, Double, HydrationNextActionGuideUseCaseImpl, Calendar, Date, HydrationNextActionGuideUseCaseTests, Calendar

### Community 23 - "MockDrinkWaterRepository"
Cohesion: 0.14
Nodes (10): DrinkWaterUseCaseImpl, .currentWaterIntakeML, Double, DrinkWaterUseCaseTests, ReminderLoggingTests, MockDrinkWaterRepository, .currentWaterIntakeML, Double (+2 more)

### Community 24 - ".tr"
Cohesion: 0.17
Nodes (12): CVarArg, WatchL10n, Int, WatchRootView, .backgroundGradient, .body, .heroCard, .nextActionText (+4 more)

### Community 25 - "AccountDomain"
Cohesion: 0.07
Nodes (3): AccountDomain, MulimiKeychain, Testing

### Community 26 - "SpyRoutineUseCase"
Cohesion: 0.22
Nodes (7): ProfileRoutineViewModelTests, SpyRoutineRecommendationUseCase, SpyRoutineUseCase, Calendar, Date, Error, Result

### Community 27 - "MockRoutineRepository"
Cohesion: 0.13
Nodes (9): RoutineUseCaseImpl, RoutineRecommendationUseCaseTests, Calendar, Date, Int, RoutineUseCaseTests, MockRoutineRepository, Error (+1 more)

### Community 28 - "LiquidGlassSegmentedControl"
Cohesion: 0.11
Nodes (22): Binding, Value, ChallengeCategory, completed, .id, inProgress, recommended, .systemImage (+14 more)

### Community 30 - "Localization"
Cohesion: 0.10
Nodes (12): ActivityKit, AlarmKit, AppIntents, Charts, CryptoKit, DesignSystem, Localization, HydrationPresentationShaderBundleToken (+4 more)

### Community 31 - "HydrationReminderPermissionViewModel"
Cohesion: 0.10
Nodes (11): HydrationReminderUseCase, Bool, .primingView, Constant, HydrationReminderPermissionViewModel, Bool, HydrationReminderPermissionViewModelTests, MockHydrationReminderUseCase (+3 more)

### Community 32 - "UserCredential"
Cohesion: 0.07
Nodes (12): MockSignInUseCase, Bool, UserCredential, AuthenticationRepository, SignInUseCaseImpl, .isAuthenticated, Bool, SignInUseCaseTests (+4 more)

### Community 33 - "ChallengeViewModel"
Cohesion: 0.12
Nodes (14): HydrationChallenge, .id, ChallengeUseCase, Calendar, Date, ChallengeCardModel, ChallengeHistoryCardModel, ChallengeViewModel (+6 more)

### Community 34 - "RecordCalendarView"
Cohesion: 0.06
Nodes (45): GridItem, CalendarDayView, .accessibilityLabel, .backgroundColor, .body, .borderColor, .dayNumber, .progressPercentage (+37 more)

### Community 35 - "HealthKitSource"
Cohesion: 0.15
Nodes (7): HealthKitSource, ReminderHealthKitWriteTests, Bool, Date, Double, Error, Int

### Community 36 - ".loadInsights"
Cohesion: 0.24
Nodes (9): HydrationInsightViewModelTests, SpyRoutineUseCase, Calendar, Date, Int, MockDrinkWaterUseCase, MockHydrationRoutineAdherenceUseCase, Calendar (+1 more)

### Community 37 - "PersonalizedHydrationChallenge"
Cohesion: 0.08
Nodes (21): MockPersonalizedChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCaseForTesting, Calendar, Date, HydrationChallengeRecommendationSource, recentRecords (+13 more)

### Community 38 - "AnyObject"
Cohesion: 0.13
Nodes (7): AnyObject, FullScreenRoute, DeepLinkHandling, URL, FullScreenRouting, SheetRouting, SheetRoute

### Community 39 - "String"
Cohesion: 0.13
Nodes (14): .postHogValue, Any, AnalyticsParameterName, AnalyticsParameterValue, bool, double, int, string (+6 more)

### Community 40 - "HydrationGoalRecommendationViewModel"
Cohesion: 0.11
Nodes (17): DailyLimitSettingView, .body, HydrationGoalRecommendationUseCase, Date, EntryDestination, bodyProfileSetting, dailyLimitSetting, GoalAlignment (+9 more)

### Community 41 - "RoutineRecommendationUseCaseImpl"
Cohesion: 0.27
Nodes (8): DaySummary, RoutineRecommendationUseCaseImpl, Bool, Calendar, Date, DateInterval, Double, Int

### Community 42 - "HealthKitDataSourceImpl"
Cohesion: 0.06
Nodes (34): HKAuthorizationStatus, HKHealthStore, HKQuantityType, HKQuantityTypeIdentifier, HKUnit, HealthKitQuantityStore, .isHealthDataAvailable, HealthQuantitySample (+26 more)

### Community 43 - "MockHydrationReminderRepository"
Cohesion: 0.10
Nodes (9): HydrationReminderRepository, Bool, HydrationReminderUseCaseImpl, Bool, HydrationReminderUseCaseTests, MockHydrationReminderRepository, Bool, Error (+1 more)

### Community 44 - "RoutineUseCase"
Cohesion: 0.15
Nodes (3): RoutineUseCase, RoutineEditorView, .body

### Community 45 - "MockChallengeUseCaseForTesting"
Cohesion: 0.33
Nodes (3): MockChallengeUseCaseForTesting, Calendar, Date

### Community 46 - "ProfileRoutineView"
Cohesion: 0.27
Nodes (3): ProfileRoutineView, .guidanceCard, .permissionSection

### Community 47 - "DIContainer"
Cohesion: 0.12
Nodes (11): Assembler, Assembly, DIContainer, .resolver, Assembly, PreviewAssembly, DomainAssembly, PresentationAssembly (+3 more)

### Community 48 - "UserDefaults"
Cohesion: 0.10
Nodes (15): HydrationComebackRepositoryImpl, Date, HydrationComebackRepositoryTests, RoutineStorageDataSourceImpl, Bool, Double, Int, UserDefaults (+7 more)

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.08
Nodes (9): MockHydrationReminderUseCaseForTesting, Bool, HydrationReminderNotificationDataSource, HydrationReminderAuthorizationStatus, authorized, denied, notDetermined, .analyticsValue (+1 more)

### Community 50 - "SpyDrinkWaterUseCase"
Cohesion: 0.13
Nodes (7): SpyDrinkWaterUseCase, .currentWaterIntakeML, SpyUserPreferencesUseCase, Bool, DateInterval, Double, Int

### Community 51 - "HydrationReminderRepositoryImpl"
Cohesion: 0.14
Nodes (10): HydrationReminderStorageDataSource, HydrationReminderStorageDataSourceImpl, Bool, HydrationReminderRepositoryImpl, Bool, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource (+2 more)

### Community 52 - "HydrationInsightView"
Cohesion: 0.08
Nodes (23): BadgeView, .body, HydrationInsightView, .emptyState, .emptyStateCTAButtons, .insightContent, .overviewCard, .routineAdherenceCard (+15 more)

### Community 53 - "HydrationInsightViewModel"
Cohesion: 0.08
Nodes (36): .body, HydrationInsightViewModel, .canRecordRecoveryDrink, .chartUpperBound, .dailyGoalText, .emptyStateCTAs, .metrics, .routineAdherenceInsightText (+28 more)

### Community 54 - "StartTimerIntent"
Cohesion: 0.15
Nodes (12): AppIntentControlValueProvider, ControlConfigurationIntent, Provider, StartTimerIntent, Bool, ControlWidgetConfiguration, IntentResult, LocalizedStringResource (+4 more)

### Community 55 - "BodyProfileViewModel"
Cohesion: 0.10
Nodes (14): MockBodyProfileUseCase, BodyProfileSnapshot, Bool, BodyProfileUseCase, MockBodyProfileUseCaseForDomain, BodyProfileViewModel, .availabilityState, .heightSourceText (+6 more)

### Community 56 - "DrinkWaterHealthKitDataSource"
Cohesion: 0.18
Nodes (7): DrinkWaterDataSource, DrinkWaterHealthKitDataSource, .currentWaterIntakeML, Calendar, Date, DateInterval, Double

### Community 57 - "DrinkWaterUseCase"
Cohesion: 0.14
Nodes (10): DrinkWaterUseCase, HydrationReminderLogResult, failed, goalExceeded, saved, Bool, Date, DateInterval (+2 more)

### Community 58 - "ChallengeUseCaseImpl"
Cohesion: 0.19
Nodes (9): ChallengeRepository, ChallengeEvaluation, ChallengeMergeResult, ChallengeUseCaseImpl, Bool, Calendar, Date, Double (+1 more)

### Community 59 - "HydrationReminderSlot"
Cohesion: 0.11
Nodes (14): Constant, HydrationReminderNotificationDataSourceImpl, .notificationCenter, Int, Set, UNUserNotificationCenter, HydrationReminderSlot, afternoon (+6 more)

### Community 60 - "DrinkWaterEntry"
Cohesion: 0.14
Nodes (16): .body, DrinkWaterWidgetEntryView, .accentColor, .body, DrinkWaterEntry, .dailyLimitText, .isLimitReached, .mililiters (+8 more)

### Community 61 - ".makeUseCase"
Cohesion: 0.24
Nodes (8): AppReviewRequestUseCaseTests, .calendar, .referenceDate, Bool, Calendar, Date, Double, Int

### Community 62 - "실행·공유 경계"
Cohesion: 0.17
Nodes (10): App, 실행·공유 경계, WatchDIContainer, DrinkWaterApp, .body, Scene, MulimiWatchApp, .body (+2 more)

### Community 63 - "AppReviewRequestUseCaseImpl"
Cohesion: 0.22
Nodes (9): AppReviewRequestRepository, AppReviewRequestUseCaseImpl, Policy, Bool, Calendar, Date, DateInterval, Double (+1 more)

### Community 64 - "LogWaterAppIntent"
Cohesion: 0.16
Nodes (13): AppIntent, IntentDialog, IntentModes, Constant, FailureReason, LogWaterAppIntent, .resolvedVolumeML, Bool (+5 more)

### Community 65 - "ProjectDescription"
Cohesion: 0.12
Nodes (5): PackageDescription, Plist, ProjectDescription, ProjectDescriptionHelpers, AppVersion

### Community 66 - "HydrationStarterPlanViewModel"
Cohesion: 0.05
Nodes (35): CaseIterable, PreviewStarterPlanRepository, HydrationStarterPlanRepositoryImpl, HydrationStarterPlanRepositoryTests, Bool, HydrationQuickRecordingMethod, shortcuts, watch (+27 more)

### Community 67 - "ContentView"
Cohesion: 0.11
Nodes (15): AppCoordinator, URL, StackRouting, .hasPath, Bool, Hashable, AppCoordinatorTests, AppTab (+7 more)

### Community 68 - "Top 5"
Cohesion: 0.14
Nodes (13): 1. 로그인 없이 시작, 2. 7일 스타터 플랜, 3. 알림 바로 기록, 4. 제어 센터·액션 버튼 기록, 5. 컴백 모드, Candidate Ideas, Decision, Engineer (+5 more)

### Community 69 - "MainIcon"
Cohesion: 0.10
Nodes (13): MainIcon, cloud, .`default`, drop, heart, .id, Self, .description (+5 more)

### Community 70 - "Test.swift"
Cohesion: 0.19
Nodes (13): AppIntentTimelineProvider, ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, ConfigurationAppIntent, Context (+5 more)

### Community 71 - "ChallengeStorageDataSourceImpl"
Cohesion: 0.24
Nodes (4): ChallengeStorageDataSource, ChallengeStorageDataSourceImpl, ChallengeRepositoryImpl, ChallengeStorageDataSourceTests

### Community 72 - "HydrationRoutine"
Cohesion: 0.05
Nodes (15): Int, MockRoutineUseCase, Error, Result, MockRoutineUseCaseForTesting, StarterPlanRoutineStub, HydrationRoutine, Bool (+7 more)

### Community 73 - "HydrationRecordListViewModel"
Cohesion: 0.09
Nodes (31): HydrationRecordListView, .body, RowListView, .body, Void, HydrationRecordDaySummary, .glassCount, .id (+23 more)

### Community 74 - "Hashable"
Cohesion: 0.10
Nodes (18): Hashable, HydrationGoalRecommendationDataSource, HydrationGoalRecommendationRepositoryImpl, HydrationGoalRecommendation, HydrationGoalRecommendationError, bodyProfileRequired, modelUnavailable, HydrationGoalRecommendationInput (+10 more)

### Community 75 - "OnboardingView"
Cohesion: 0.14
Nodes (15): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+7 more)

### Community 76 - "View"
Cohesion: 0.12
Nodes (15): CGPoint, BodyProfileSettingView, .healthSyncCard, .summaryCard, HydrationGoalRecommendationCard, .content, Bool, Void (+7 more)

### Community 77 - ".assemble"
Cohesion: 0.14
Nodes (5): Container, HealthKitRepository, BodyProfileUseCaseImpl, Bool, BodyProfileUseCaseTests

### Community 78 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.24
Nodes (7): Constants, HydrationGoalRecommendationUseCaseImpl, Calendar, Date, DateInterval, Int, HydrationGoalRecommendationUseCaseTests

### Community 79 - "AppReviewRequestState"
Cohesion: 0.21
Nodes (6): AppReviewRequestStorageDataSourceImpl, AppReviewRequestStorageDataSourceTests, AppReviewRequestState, Date, Set, MockAppReviewRequestRepository

### Community 80 - "UUID"
Cohesion: 0.20
Nodes (7): AlarmMetadata, Bool, RoutineAlarmMetadata, UUID, HydrationEventModel, Date, Int

### Community 82 - "WatchHydrationSnapshot"
Cohesion: 0.16
Nodes (11): Bool, Date, Double, Int, Self, WatchHydrationSnapshot, .eventCount, .isGoalReached (+3 more)

### Community 83 - "OnboardingViewModel"
Cohesion: 0.17
Nodes (9): RootView, .body, Content, Bool, OnboardingViewModel, .canGoBack, .isLastPage, Bool (+1 more)

### Community 84 - ".loadChallenges"
Cohesion: 0.28
Nodes (8): ChallengeViewModelTests, Calendar, MockChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCase, Calendar, Date

### Community 85 - "Color"
Cohesion: 0.15
Nodes (16): ChallengeBadge, .body, ChallengeCard, .accentColor, .body, .cardBackground, ChallengeHistoryCard, .accentColor (+8 more)

### Community 86 - "AppReviewRequestUseCase"
Cohesion: 0.30
Nodes (6): AppReviewRequestUseCase, NoOpAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 87 - "Mulimi Drop — v3"
Cohesion: 0.17
Nodes (10): Generation and editing — Mulimi Drop v3, Original body layer prompt, Original face layer prompt, Original master prompt, Mulimi Drop — v3, 레이어, 배경과 외관, 앱 적용 (+2 more)

### Community 88 - "Growth Scorecard"
Cohesion: 0.07
Nodes (22): 72-Hour Audit, Before Release, Cadence And Ownership, Decision Rule, Deferred Scope, Experiment Record, Goal, Growth Scorecard (+14 more)

### Community 89 - "AppleSignInCredential"
Cohesion: 0.18
Nodes (10): ASAuthorization, ASAuthorizationController, ASAuthorizationControllerDelegate, AuthenticationServices, NSObject, AppleSignInCredential, AppleSignInDataSourceImpl, AppleSignInDelegate (+2 more)

### Community 90 - "AppDelegate"
Cohesion: 0.20
Nodes (10): AppDelegate, Any, Bool, UNUserNotificationCenter, UIApplication, UIApplicationDelegate, UNNotification, UNNotificationPresentationOptions (+2 more)

### Community 91 - "MockUserPreferencesUseCase"
Cohesion: 0.21
Nodes (3): MockUserPreferencesUseCase, Bool, Double

### Community 92 - "프로젝트 전체 구조와 의존성"
Cohesion: 0.15
Nodes (13): App · 조립 루트 — 9개, Core — 6개, Features — 18개, Shared — 5개, Tests — 15개, 검증과 갱신, 기능 간 직접 의존에서 주의할 점, 디렉터리와 소유권 (+5 more)

### Community 93 - "HydrationGoalRecommendationAvailability"
Cohesion: 0.16
Nodes (10): MockHydrationGoalRecommendationUseCase, Date, Error, HydrationGoalRecommendationAvailability, bodyProfileRequired, modelUnavailable, ready, MockHydrationGoalRecommendationUseCase (+2 more)

### Community 94 - "HydrationProgressUseCaseImpl"
Cohesion: 0.30
Nodes (9): Date, DateInterval, HydrationProgressUseCaseImpl, StreakProgress, Calendar, Date, DateInterval, Double (+1 more)

### Community 95 - "AuthTokens"
Cohesion: 0.26
Nodes (4): AuthenticationNetworkDataSource, AuthenticationNetworkDataSourceImpl, AuthTokens, Int

### Community 96 - "Security And Privacy Operations"
Cohesion: 0.12
Nodes (17): Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling, Data Boundary, Health Data Minimization, PostHog Privacy Controls (+9 more)

### Community 97 - "Foundation"
Cohesion: 0.06
Nodes (13): AccountData, ChallengeData, Foundation, FoundationModels, HydrationData, HydrationReminderData, HydrationReminderDomain, MulimiAnalyticsData (+5 more)

### Community 98 - "FoundationModelsHydrationGoalRecommendationDataSource"
Cohesion: 0.27
Nodes (6): Constants, FoundationModelsHydrationGoalRecommendationDataSource, GeneratedHydrationGoalRecommendation, Int, Locale, SystemLanguageModel

### Community 99 - "PersonalizedChallengeUseCaseImpl"
Cohesion: 0.15
Nodes (14): HydrationChallengeTier, beginner, steady, stretch, Constants, PersonalizedChallengeUseCaseImpl, Calendar, Date (+6 more)

### Community 100 - "LogWaterAmountOption"
Cohesion: 0.18
Nodes (11): AppEnum, DisplayRepresentation, LogWaterAmountOption, bottle, custom, glass, .presetID, .servingType (+3 more)

### Community 101 - "AGENTS.md Onboarding Map"
Cohesion: 0.10
Nodes (27): Goal Recommendation Entry Rules, Profile Information Architecture, Profile Root, Settings Screen, Quality Gates, Truthful Validation Reporting, Validation Baseline, Validation Matrix (+19 more)

### Community 102 - ".assemble"
Cohesion: 0.20
Nodes (4): DataAssembly, Container, AppReviewRequestStorageDataSource, AppReviewRequestRepositoryImpl

### Community 103 - "HealthKitAuthorizationStatus"
Cohesion: 0.26
Nodes (6): HealthKitAuthorizationStatus, notDetermined, sharingAuthorized, sharingDenied, .analyticsValue, ProductAnalyticsEvent

### Community 104 - "HydrationProgressSnapshot"
Cohesion: 0.09
Nodes (21): MockHydrationProgressUseCase, Calendar, Date, MockHydrationProgressUseCaseForTesting, Calendar, Date, HydrationProgressSnapshot, Bool (+13 more)

### Community 105 - "HydrationReminderPermissionGateView"
Cohesion: 0.32
Nodes (6): HydrationReminderPermissionGateView, .allowButtonLabel, .benefitCard, .body, .headerSection, Content

### Community 106 - "WaterDropView"
Cohesion: 0.25
Nodes (8): CGFloat, CGSize, TimeInterval, WaterDropView, .body, .dropBackground, .dropHighlights, .dropSymbol

### Community 107 - "HydrationServingPreset"
Cohesion: 0.16
Nodes (13): HydrationServing, .additionalPresets, HydrationServingPreset, bottle, .id, tumbler, .volumeML, Double (+5 more)

### Community 108 - "Generation prompts"
Cohesion: 0.18
Nodes (9): body, cheeks, face, Generation prompts, Master, Mulimi Liquid Glass 아이콘 — #339, v1, 미리보기와 확인, 사용 (+1 more)

### Community 109 - "ConfigurationAppIntent"
Cohesion: 0.18
Nodes (9): IntentDescription, ConfigurationAppIntent, .description, .title, LocalizedStringResource, ConfigurationAppIntent, IntentResult, LocalizedStringResource (+1 more)

### Community 110 - "SettingsViewModelTests"
Cohesion: 0.20
Nodes (10): LocalizedError, MockError, .errorDescription, signInFailed, MockError, deleteFailed, .errorDescription, MockError (+2 more)

### Community 111 - "DrinkWaterRepositoryImpl"
Cohesion: 0.17
Nodes (7): DrinkWaterRepositoryImpl, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int

### Community 112 - "HydrationRoutineSchedule"
Cohesion: 0.18
Nodes (11): HydrationRoutineSchedule, Bool, Set, HydrationRoutineAdherenceUseCaseImpl, Calendar, Date, DateInterval, HydrationRoutineAdherenceUseCaseTests (+3 more)

### Community 113 - "WatchHydrationUseCaseImpl"
Cohesion: 0.16
Nodes (9): Int, WatchDailyGoalRepository, Date, Int, WatchHydrationRepository, Date, Double, Int (+1 more)

### Community 114 - "AppRoute"
Cohesion: 0.15
Nodes (11): AppRoute, hydrationLogging, hydrationStarterPlan, .id, .presentationStyle, profileRoutineAction, NavigationPresentationStyle, fullScreenCover (+3 more)

### Community 115 - "MockUserPreferencesRepository"
Cohesion: 0.23
Nodes (3): MockUserPreferencesRepository, Bool, Double

### Community 116 - "AI PR Review Workflow"
Cohesion: 0.18
Nodes (12): AI PR Review Workflow, Architecture Review Policy, Bounded AI Review Diff, Git Flow PR Filter, Textual Diff Selection, Clean Architecture and MVVM Discipline, Domain Purity, Hydration Source of Truth (+4 more)

### Community 117 - "UserPreferencesDataSourceImpl"
Cohesion: 0.10
Nodes (10): Double, NSUbiquitousKeyValueStore, SyncedValueStoring, UbiquitousMirroredStore, Constants, Bool, Double, NSUbiquitousKeyValueStore (+2 more)

### Community 118 - "TokenProperty"
Cohesion: 0.11
Nodes (13): AppleSignInDataSource, KeyChainDataSource, KeyChainDataSourceImpl, Bool, AuthenticationRepositoryImpl, .isAuthenticated, Bool, TokenProperty (+5 more)

### Community 119 - ".makeViewModel"
Cohesion: 0.23
Nodes (5): MockHydrationGoalRecommendationUseCase, MockHydrationProgressUseCase, HydrationGoalRecommendationViewModelTests, Double, Int

### Community 120 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 121 - "MockHydrationReminderUseCase"
Cohesion: 0.22
Nodes (4): MockHydrationReminderUseCase, Bool, Error, Result

### Community 122 - ".handle"
Cohesion: 0.29
Nodes (6): HydrationReminderActionHandlerTests, Bool, Date, Double, MockDrinkWaterUseCase, WidgetReloader

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (7): ActivityAttributes, ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 126 - "Error"
Cohesion: 0.05
Nodes (39): Error, ModelConfiguration, ModelContainer, HealthQuantityStoreError, incompleteQuery, internalError, invalidObjectType, permissionDenied (+31 more)

### Community 127 - "HydrationWriteResult"
Cohesion: 0.08
Nodes (17): MockDrinkWaterUseCaseForTesting, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int, .analyticsFailureReason (+9 more)

### Community 128 - "LogWaterAppShortcuts"
Cohesion: 0.29
Nodes (6): AppShortcut, AppShortcutsProvider, LogWaterAppShortcuts, .appShortcuts, .shortcutTileColor, ShortcutTileColor

### Community 129 - "WaterDropShaders.metal"
Cohesion: 0.43
Nodes (6): float2, half4, metal_stdlib, mulimiWaterDistortion(), mulimiWaterLighting(), mulimiWaveNoise()

### Community 130 - ".resolve"
Cohesion: 0.36
Nodes (6): PreviewViews, .challenge, .drinkWater, .hydrationList, .profile, Service

### Community 131 - "HydrationNextActionGuide"
Cohesion: 0.09
Nodes (24): MockHydrationNextActionGuideUseCase, Calendar, Date, MockHydrationNextActionGuideUseCaseForTesting, Calendar, Date, Constants, HydrationNextActionGuide (+16 more)

### Community 132 - "#320 — 7일 스타터 플랜 제품 적용"
Cohesion: 0.20
Nodes (9): #320 — 7일 스타터 플랜 제품 적용, Constraints And Decisions, Context, Goal, Implementation Notes (2026-09-14), Non-Goals, Plan, Rollback (+1 more)

### Community 133 - "Docs Index"
Cohesion: 0.12
Nodes (29): Agent Onboarding Guide, Graphify-Assisted Code Navigation, Mulimi Architecture SSOT, Core User Flow, Claude Agent Entrypoint, Delivery Workflow, Git Flow Delivery Strategy, Issue Closure Policy (+21 more)

### Community 134 - "RoutineWeekday"
Cohesion: 0.06
Nodes (32): MockRoutineRecommendationUseCase, Calendar, Date, MockRoutineRecommendationUseCaseForTesting, Calendar, Date, Container, .localeWeekday (+24 more)

### Community 135 - "UserPreferencesRepositoryImpl"
Cohesion: 0.28
Nodes (3): Bool, Double, UserPreferencesRepositoryImpl

### Community 136 - "WatchDailyGoalLocalDataSource"
Cohesion: 0.21
Nodes (7): MulimiCloudKit, Int, NSUbiquitousKeyValueStore, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, Int, WatchDailyGoalRepositoryImpl

### Community 137 - "HealthKitDataSource"
Cohesion: 0.18
Nodes (4): HealthKitDataSource, HealthKitRepositoryImpl, .authorisationStatus, Date

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "WatchHydrationMutationResult"
Cohesion: 0.27
Nodes (3): WatchHydrationMutationResult, Date, WatchHydrationUseCase

### Community 140 - "RoutineNotificationDataSourceImpl"
Cohesion: 0.21
Nodes (6): Alarm, AlarmManager, AlarmPresentation, Constant, RoutineNotificationDataSourceImpl, LocalizedStringResource

### Community 143 - "Test"
Cohesion: 0.25
Nodes (9): WidgetConfiguration, Test, .body, WidgetConfiguration, TestLiveActivity, .body, DrinkWaterWidget, WidgetConfiguration (+1 more)

### Community 144 - "DrinkWaterLockScreenWidgetEntryView"
Cohesion: 0.22
Nodes (9): DrinkWaterLockScreenWidget, .body, DrinkWaterLockScreenWidgetEntryView, .accentColor, .body, .circularView, .inlineView, .rectangularView (+1 more)

### Community 145 - "WatchRootView.swift"
Cohesion: 0.25
Nodes (7): Double, WatchMetricRow, .body, WatchNavigationCard, .body, WatchProgressBar, .body

### Community 146 - "ProfileView"
Cohesion: 0.19
Nodes (9): AccountRoute, profileRoutine, setting, ProfileView, .body, .goalRecommendationCard, .goalRecommendationRoute, .routineCard (+1 more)

### Community 148 - "MockAppReviewRequestUseCase"
Cohesion: 0.48
Nodes (5): MockAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 151 - ".progressSnapshot"
Cohesion: 0.40
Nodes (4): HydrationProgressUseCaseTests, Calendar, Date, Int

### Community 152 - ".makeComebackViewModel"
Cohesion: 0.15
Nodes (10): HydrationComebackRepository, Date, .nextActionSummary, HydrationComebackMode, baseline, card, disabled, StubHydrationComebackRepository (+2 more)

### Community 153 - "L10n"
Cohesion: 0.40
Nodes (3): Bundle, BundleToken, L10n

### Community 154 - "LogWaterControl"
Cohesion: 0.20
Nodes (10): ControlWidget, Widget, TestBundle, DrinkWaterWidgetBundle, .body, LogWaterControl, .body, ControlWidgetConfiguration (+2 more)

### Community 155 - "Challenge State Model"
Cohesion: 0.50
Nodes (5): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Legacy Challenge State Migration, Recurring Challenge State

### Community 156 - "BundleAppInfoProvider"
Cohesion: 0.60
Nodes (3): BundleAppInfoProvider, .appBuildNumber, .appVersion

### Community 157 - "AuthProvider"
Cohesion: 0.40
Nodes (4): AuthProvider, apple, google, kakao

### Community 158 - "Mulimi Pull Request Template"
Cohesion: 0.50
Nodes (4): Local Validation Reporting, Mulimi Pull Request Template, PR Review Checklist, Truthful Validation Reporting

### Community 159 - "Personalized Challenge Strategy"
Cohesion: 0.50
Nodes (4): Personalized Challenge Strategy, Personalized Challenge Recommendation Candidates, Challenge Recommendation Tier Rules, Challenge and Insight Information Architecture

### Community 160 - "Generation — Mulimi Water Glass v2"
Cohesion: 0.25
Nodes (6): droplet, Generation — Mulimi Water Glass v2, glass, Master, water, Mulimi — Water Glass v2

### Community 162 - "RoutineRecoveryReminderAction"
Cohesion: 0.15
Nodes (12): HydrationInsightEmptyAction, dailyGoal, record, routine, HydrationWeeklyCoachingAction, dailyGoal, none, routine (+4 more)

### Community 164 - "WatchHydrationViewModel"
Cohesion: 0.18
Nodes (9): AnyView, MutationAction, record, reset, Bool, Date, Sendable, WatchHydrationViewModel (+1 more)

### Community 166 - "#321 수분 알림 바로 기록"
Cohesion: 0.18
Nodes (11): #321 수분 알림 바로 기록, Completion Notes, Constraints, Context, Goal, Non-Goals, Open Questions, Plan (+3 more)

### Community 168 - "MockUserPreferencesUseCaseForTesting"
Cohesion: 0.21
Nodes (3): MockUserPreferencesUseCaseForTesting, Bool, Double

### Community 170 - "UserPreferencesRepository"
Cohesion: 0.20
Nodes (3): Bool, Double, UserPreferencesRepository

### Community 172 - "Reliability Recovery"
Cohesion: 0.22
Nodes (11): Goal Mirror Recovery Policy, HealthKit Source of Truth, Recovery Principles, Reliability Recovery, Routine Schedule Recovery, Shared Hydration Rules, HealthKit Data Flow, healthkit-flow (+3 more)

### Community 173 - "HydrationReminderNotification"
Cohesion: 0.22
Nodes (6): HydrationReminderNotification, .category, Bool, Date, HydrationReminderNotificationTests, UNNotificationCategory

### Community 174 - "WaterWaveView"
Cohesion: 0.28
Nodes (6): CGRect, Path, CGFloat, WaterWaveView, .animatableData, Shape

### Community 175 - "HydrationInsightCategory"
Cohesion: 0.22
Nodes (9): HydrationInsightCategory, .id, overview, pattern, report, routine, .systemImage, .title (+1 more)

### Community 177 - "Layer Responsibilities"
Cohesion: 0.18
Nodes (11): CI Lint and Architecture Gate, Lint Workflow, Domain Data Presentation Test Matrix, PR Unit Tests Workflow, SwiftPM Cache Retry, Selected SwiftLint Rule Set, SwiftLint Configuration, Default Validation Sequence (+3 more)

### Community 178 - "SettingMenu"
Cohesion: 0.22
Nodes (8): SettingMenu, bodyProfile, dailyLimit, .id, mainIcon, withdrawal, Self, SettingDetailView

### Community 179 - ".drinkWater"
Cohesion: 0.29
Nodes (3): Error, Int, Int

### Community 180 - "HydrationReminderActionResult"
Cohesion: 0.25
Nodes (8): HydrationReminderActionResult, duplicate, failed, goalExceeded, permissionRequired, protectedDataUnavailable, saved, signInRequired

### Community 183 - "BodyProfileAvailability"
Cohesion: 0.13
Nodes (12): BodyProfileAvailability, incomplete, needsPermission, noData, permissionDenied, ready, State, bodyProfileRequired (+4 more)

## Ambiguous Edges - Review These
- `HealthKit Source of Truth` → `CloudKit-Backed Hydration Store`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to
- `CloudKit-Backed Hydration Store` → `Current Storage Strategy`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to

## Knowledge Gaps
- **525 isolated node(s):** `.resolver`, `production`, `preview`, `testing`, `.current` (+520 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 985 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `HealthKit Source of Truth` and `CloudKit-Backed Hydration Store`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `Current Storage Strategy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `String` connect `String` to `Sendable`, `HydrationRecord`, `ProfileRoutineViewModel`, `Equatable`, `.tr`, `HydrationChallengeBadgeHistory`, `SettingsViewModel`, `AnalyticsUseCase`, `DrinkWaterViewModel`, `HydrationChallengeKind`, `HealthKitPermissionViewModel`, `RoutineActionIntent`, `MockDrinkWaterUseCase`, `HydrationEvent`, `BodyProfile`, `MockDrinkWaterRepository`, `.tr`, `LiquidGlassSegmentedControl`, `PostHogAnalyticsRepository`, `HydrationReminderPermissionViewModel`, `UserCredential`, `ChallengeViewModel`, `RecordCalendarView`, `HealthKitSource`, `PersonalizedHydrationChallenge`, `HydrationGoalRecommendationViewModel`, `HealthKitDataSourceImpl`, `ProfileRoutineView`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `SpyDrinkWaterUseCase`, `HydrationInsightView`, `HydrationInsightViewModel`, `StartTimerIntent`, `BodyProfileViewModel`, `DrinkWaterUseCase`, `ChallengeUseCaseImpl`, `HydrationReminderSlot`, `DrinkWaterEntry`, `AppReviewRequestUseCaseImpl`, `LogWaterAppIntent`, `ProjectDescription`, `HydrationStarterPlanViewModel`, `MainIcon`, `ChallengeStorageDataSourceImpl`, `HydrationRoutine`, `HydrationRecordListViewModel`, `Hashable`, `OnboardingView`, `View`, `AppReviewRequestState`, `UUID`, `Color`, `AppReviewRequestUseCase`, `Growth Scorecard`, `AppleSignInCredential`, `MockUserPreferencesUseCase`, `AuthTokens`, `FoundationModelsHydrationGoalRecommendationDataSource`, `PersonalizedChallengeUseCaseImpl`, `LogWaterAmountOption`, `HealthKitAuthorizationStatus`, `HydrationReminderPermissionGateView`, `HydrationServingPreset`, `ConfigurationAppIntent`, `SettingsViewModelTests`, `DrinkWaterRepositoryImpl`, `HydrationRoutineSchedule`, `AppRoute`, `UserPreferencesDataSourceImpl`, `TokenProperty`, `KeychainStoring`, `ContentState`, `Error`, `HydrationWriteResult`, `HydrationNextActionGuide`, `RoutineWeekday`, `RoutineNotificationDataSourceImpl`, `Test`, `WatchRootView.swift`, `ProfileView`, `MockAppReviewRequestUseCase`, `.progressSnapshot`, `.makeComebackViewModel`, `L10n`, `BundleAppInfoProvider`, `RoutineRecoveryReminderAction`, `WatchHydrationViewModel`, `MockUserPreferencesUseCaseForTesting`, `HydrationReminderNotification`, `HydrationInsightCategory`, `SettingMenu`, `.drinkWater`, `HydrationReminderActionResult`?**
  _High betweenness centrality (0.301) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `Sendable`, `HydrationRecord`, `WatchHydrationLocalDataSource.swift`, `HydrationNextActionGuide`, `ProfileRoutineViewModel`, `Equatable`, `RoutineWeekday`, `WatchDailyGoalLocalDataSource`, `HydrationChallengeBadgeHistory`, `SettingsViewModel`, `WatchHydrationMutationResult`, `HydrationPresentation`, `AnalyticsUseCase`, `DrinkWaterViewModel`, `HydrationDomain`, `HydrationChallengeKind`, `RoutineActionIntent`, `HydrationEvent`, `BodyProfile`, `DrinkWaterRepository`, `.makeComebackViewModel`, `AccountDomain`, `.tr`, `L10n`, `AuthProvider`, `Localization`, `HydrationReminderPermissionViewModel`, `UserCredential`, `ChallengeViewModel`, `AnyObject`, `String`, `HydrationGoalRecommendationViewModel`, `UserPreferencesRepository`, `MockHydrationReminderRepository`, `RoutineUseCase`, `HealthKitDataSourceImpl`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `BodyProfileAvailability`, `BodyProfileViewModel`, `DrinkWaterUseCase`, `ChallengeUseCaseImpl`, `HydrationReminderSlot`, `HydrationStarterPlanViewModel`, `MainIcon`, `HydrationRoutine`, `Hashable`, `.assemble`, `AppReviewRequestState`, `WatchHydrationSnapshot`, `AppReviewRequestUseCase`, `AppleSignInCredential`, `AuthTokens`, `HealthKitAuthorizationStatus`, `HydrationProgressSnapshot`, `HydrationServingPreset`, `WatchHydrationUseCaseImpl`, `UserPreferencesDataSourceImpl`, `TokenProperty`, `DIEnvironment`, `KeychainStoring`, `HealthKitUseCase`, `Error`?**
  _High betweenness centrality (0.072) - this node is a cross-community bridge._
- **Why does `프로젝트 전체 구조와 의존성` connect `프로젝트 전체 구조와 의존성` to `Docs Index`, `실행·공유 경계`?**
  _High betweenness centrality (0.065) - this node is a cross-community bridge._
- **What connects `.resolver`, `production`, `preview` to the rest of the system?**
  _525 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Sendable` be split into smaller, more focused modules?**
  _Cohesion score 0.08771929824561403 - nodes in this community are weakly interconnected._