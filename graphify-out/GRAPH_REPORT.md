# Graph Report - Mulimi  (2026-09-22)

## Corpus Check
- 385 files · ~172,160 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 22 file(s) not represented in the graph (top: .entitlements 6, .plist 6, (none) 3)

## Summary
- 3818 nodes · 10133 edges · 189 communities (176 shown, 13 thin omitted)
- Extraction: 85% EXTRACTED · 15% INFERRED · 0% AMBIGUOUS · INFERRED: 1481 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `1637f636`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- HydrationRoutineAdherenceInsight
- HydrationRecord
- WatchHydrationLocalDataSource.swift
- ProfileRoutineViewModel
- RoutineRepositoryImpl
- String
- MockHealthKitRepository
- MockUserPreferencesUseCase
- .tr
- HydrationRecordListViewModel
- .assemble
- Docs Index
- HydrationDomain
- AnalyticsUseCase
- DrinkWaterViewModel
- Foundation
- HydrationChallengeKind
- HealthKitPermissionViewModel
- RoutineActionIntent
- MockDrinkWaterUseCase
- HydrationEvent
- BodyProfile
- .guideCombinesRemainingServingAndNextRoutine
- MockDrinkWaterRepository
- .tr
- AccountDomain
- SpyRoutineUseCase
- MockRoutineRepository
- LiquidGlassSegmentedControl
- PostHogAnalyticsRepository
- Localization
- HydrationReminderPermissionViewModel
- SignInUseCaseImpl
- HydrationChallenge
- RecordCalendarView
- HealthKitSource
- HydrationProgressSnapshot
- ChallengeViewModel
- AnyObject
- ProductAnalyticsEvent
- HydrationGoalRecommendationViewModel
- RoutineRecommendationUseCaseImpl
- HKQuantityTypeIdentifier
- MockHydrationReminderRepository
- HydrationStarterPlanViewModelTests
- .assemble
- ProfileRoutineView
- DIContainer
- UserDefaults
- HydrationReminderAuthorizationStatus
- HealthKitDataSourceImpl
- HydrationReminderRepositoryImpl
- View
- HydrationInsightViewModel
- StartTimerIntent
- BodyProfileViewModel
- DrinkWaterHealthKitDataSource
- DataAssembly.swift
- HydrationChallengeBadgeHistory
- HydrationReminderSlot
- DrinkWaterEntry
- .makeUseCase
- .makeRootView
- AppReviewRequestUseCaseImpl
- LogWaterAppIntent
- ProjectDescription
- HydrationStarterPlan
- ContentView
- Top 5
- MainIcon
- Test.swift
- HydrationStarterPlanViewModel
- HydrationRoutine
- HydrationRecordDaySummary
- Hashable
- OnboardingView
- HydrationGoalRecommendationCard
- .assemble
- HydrationGoalRecommendationUseCaseImpl
- AppReviewRequestState
- SharedHydrationStoreError
- UserPreferencesUseCaseImpl
- WatchHydrationSnapshot
- OnboardingViewModel
- .loadChallenges
- Color
- MockAppReviewRequestUseCase
- Clean Architecture and MVVM
- Growth Scorecard
- AppleSignInCredential
- AppDelegate
- GlareCircleView
- 프로젝트 전체 구조와 의존성
- HydrationGoalRecommendationAvailability
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
- CaseIterable
- WatchHydrationEvent
- ConfigurationAppIntent
- SettingsViewModelTests
- DrinkWaterRepositoryImpl
- HydrationRoutineSchedule
- WatchHydrationUseCaseImpl
- AppRoute
- MockUserPreferencesRepository
- AI PR Review Workflow
- UserPreferencesDataSourceImpl
- AuthenticationRepositoryImpl
- .makeViewModel
- DIEnvironment
- WatchHydrationHealthKitDataSource
- .handle
- DrinkWaterWidgetProvider
- ContentState
- MockHealthKitUseCaseForTesting
- Error
- HydrationWriteResult
- LogWaterAppShortcuts
- WaterDropShaders.metal
- .resolve
- HydrationNextActionGuide
- #320 — 7일 스타터 플랜 제품 적용
- Mulimi
- RoutineWeekday
- UserPreferencesRepositoryImpl
- WatchDailyGoalLocalDataSource
- HealthKitDataSource
- Accessibility and Dynamic Type Audit
- HydrationStarterPlanView
- RoutineNotificationDataSourceImpl
- ci_post_clone.sh
- pre-commit
- UserCredential
- HydrationStarterPlanRepositoryImpl
- AppTab
- ProfileView
- check-architecture.sh
- HealthQuantityStoreError
- lint.sh
- lint-fix.sh
- .progressSnapshot
- .makeComebackViewModel
- HealthKitError
- Test
- Challenge State Model
- DrinkWaterRepository
- AuthProvider
- Mulimi Pull Request Template
- Completed Plan Archive
- BundleAppInfoProvider
- .hasCompletedOnboarding
- RoutineRecoveryReminderAction
- .setHydrationEvents
- WatchHydrationViewModel
- HydrationRecordPeriod
- #321 수분 알림 바로 기록
- WatchDataConstants.swift
- MockUserPreferencesUseCaseForTesting
- TokenProperty
- UserPreferencesRepository
- .init
- Reliability Recovery
- HydrationReminderNotification
- WaterWaveView
- HydrationInsightCategory
- MockHealthKitUseCase
- CI Lint and Architecture Gate
- SettingMenu
- .drinkWater
- HydrationReminderActionResult
- AuthenticationRepository
- ChallengeCategory
- State
- .dayNumber
- SystemWidgetTimelineReloader
- .hydrationEvents
- .deleteHydrationEvent
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

## Communities (189 total, 13 thin omitted)

### Community 0 - "HydrationRoutineAdherenceInsight"
Cohesion: 0.12
Nodes (29): CandidateMatch, Constants, HydrationRoutineAdherenceEvent, HydrationRoutineAdherenceInsight, .adherenceRate, .bestRoutine, .bestTimeSlot, .hasDueOccurrences (+21 more)

### Community 1 - "HydrationRecord"
Cohesion: 0.18
Nodes (8): HydrationRecord, Date, Double, Date, HydrationRecordRow, .body, .dateString, Date

### Community 2 - "WatchHydrationLocalDataSource.swift"
Cohesion: 0.18
Nodes (6): HealthKit, MulimiHealthKit, OSLog, WatchHydrationData, WatchHydrationDomain, WatchHydrationPresentation

### Community 3 - "ProfileRoutineViewModel"
Cohesion: 0.07
Nodes (29): .body, RoutineEditorView, .body, .weekdayGrid, ProfileRoutineViewModel, .activeRoutineCount, .canSaveDraft, .displayedRoutines (+21 more)

### Community 4 - "RoutineRepositoryImpl"
Cohesion: 0.20
Nodes (9): RoutineNotificationDataSource, RoutineStorageDataSource, RoutineRepositoryImpl, Bool, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource, SpyRoutineStorageDataSource, Result (+1 more)

### Community 5 - "String"
Cohesion: 0.07
Nodes (33): Equatable, Identifiable, KeychainStore, KeychainStoring, ChallengeHistoryCardModel, PersonalizedChallengeCardModel, .overviewCard, OverviewMetricTile (+25 more)

### Community 6 - "MockHealthKitRepository"
Cohesion: 0.15
Nodes (5): HealthKitUseCaseImpl, .authorisationStatus, HealthKitUseCaseTests, MockHealthKitRepository, .authorisationStatus

### Community 7 - "MockUserPreferencesUseCase"
Cohesion: 0.18
Nodes (7): NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, MockUserPreferencesUseCase, Bool, Double

### Community 8 - ".tr"
Cohesion: 0.07
Nodes (38): Bundle, HealthKitPermissionGateView, .accessCard, .descriptionText, .footnoteText, .headerColor, .headerSection, .headerSystemImage (+30 more)

### Community 9 - "HydrationRecordListViewModel"
Cohesion: 0.11
Nodes (13): HydrationRecordListView, .body, RowListView, .body, Void, .body, .recordListSection, HydrationRecordListViewModel (+5 more)

### Community 10 - ".assemble"
Cohesion: 0.09
Nodes (18): Container, Container, RootView, Content, SignInUseCase, AppSession, Bool, AuthenticationViewModel (+10 more)

### Community 11 - "Docs Index"
Cohesion: 0.10
Nodes (40): PostHog Analytics Consolidation, Documentation SSOT Map, Docs Index, Document Maintenance Rule, Personalized Challenge Strategy, Personalized Challenge Recommendation Candidates, Challenge Recommendation Tier Rules, Analytics Architecture Boundary (+32 more)

### Community 12 - "HydrationDomain"
Cohesion: 0.08
Nodes (4): FoundationModels, HydrationData, HydrationDomain, Testing

### Community 13 - "AnalyticsUseCase"
Cohesion: 0.10
Nodes (17): AnalyticsUseCase, NoOpAnalyticsUseCase, WidgetTimelineReloading, Double, UserPreferencesUseCase, completed, DrinkWaterUseCase, HydrationReminderLogResult (+9 more)

### Community 14 - "DrinkWaterViewModel"
Cohesion: 0.06
Nodes (31): HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, .body, CustomHydrationAmountValidation, empty, invalid (+23 more)

### Community 15 - "Foundation"
Cohesion: 0.10
Nodes (7): ChallengeDomain, CoreGraphics, Foundation, MulimiAnalytics, Observation, PostHog, RoutineDomain

### Community 16 - "HydrationChallengeKind"
Cohesion: 0.08
Nodes (38): Codable, HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType, streak7, weeklyAchievement80 (+30 more)

### Community 17 - "HealthKitPermissionViewModel"
Cohesion: 0.17
Nodes (8): ProductAnalyticsEvent, .body, .permissionView, HealthKitPermissionViewModel, .defaultErrorMessage, .deniedMessage, Bool, HealthKitPermissionViewModelTests

### Community 18 - "RoutineActionIntent"
Cohesion: 0.13
Nodes (18): .id, ChallengeSectionHeader, .body, ChallengeView, .body, .challengeContent, .completedCategorySection, .emptyCardBackground (+10 more)

### Community 19 - "MockDrinkWaterUseCase"
Cohesion: 0.13
Nodes (12): Never, MockDrinkWaterUseCase, .currentWaterIntakeML, .hasPendingDrinkWater, Bool, CheckedContinuation, Date, DateInterval (+4 more)

### Community 20 - "HydrationEvent"
Cohesion: 0.08
Nodes (18): MockDrinkWaterUseCase, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int, MockDrinkWaterUseCaseForTesting (+10 more)

### Community 21 - "BodyProfile"
Cohesion: 0.11
Nodes (11): MockHealthKitUseCase, Date, BodyProfile, .isComplete, .isEmpty, BodyProfileSource, healthKit, manual (+3 more)

### Community 22 - ".guideCombinesRemainingServingAndNextRoutine"
Cohesion: 0.21
Nodes (5): HydrationNextActionGuideUseCaseImpl, Calendar, Date, HydrationNextActionGuideUseCaseTests, Calendar

### Community 23 - "MockDrinkWaterRepository"
Cohesion: 0.13
Nodes (12): DrinkWaterUseCaseImpl, .currentWaterIntakeML, Date, DateInterval, Double, DrinkWaterUseCaseTests, ReminderLoggingTests, MockDrinkWaterRepository (+4 more)

### Community 24 - ".tr"
Cohesion: 0.14
Nodes (19): CVarArg, WatchL10n, Double, Int, WatchMetricRow, .body, WatchNavigationCard, .body (+11 more)

### Community 25 - "AccountDomain"
Cohesion: 0.09
Nodes (5): AccountDomain, HydrationPresentation, MulimiKeychain, MulimiPlatform, RoutinePresentation

### Community 26 - "SpyRoutineUseCase"
Cohesion: 0.10
Nodes (14): ProfileRoutineViewModelTests, SpyDrinkWaterUseCase, .currentWaterIntakeML, SpyRoutineRecommendationUseCase, SpyRoutineUseCase, SpyUserPreferencesUseCase, Bool, Calendar (+6 more)

### Community 27 - "MockRoutineRepository"
Cohesion: 0.11
Nodes (6): RoutineRepository, RoutineUseCaseImpl, RoutineUseCaseTests, MockRoutineRepository, Error, Result

### Community 28 - "LiquidGlassSegmentedControl"
Cohesion: 0.18
Nodes (14): Binding, Value, .categoryPicker, .categoryPicker, LiquidGlassSegment, .id, LiquidGlassSegmentedControl, .activeSegmentBackground (+6 more)

### Community 30 - "Localization"
Cohesion: 0.10
Nodes (12): ActivityKit, AlarmKit, AppIntents, Charts, CryptoKit, DesignSystem, Localization, HydrationPresentationShaderBundleToken (+4 more)

### Community 31 - "HydrationReminderPermissionViewModel"
Cohesion: 0.10
Nodes (11): HydrationReminderUseCase, Bool, .primingView, Constant, HydrationReminderPermissionViewModel, Bool, HydrationReminderPermissionViewModelTests, MockHydrationReminderUseCase (+3 more)

### Community 32 - "SignInUseCaseImpl"
Cohesion: 0.16
Nodes (8): SignInUseCaseImpl, .isAuthenticated, Bool, SignInUseCaseTests, MockAuthenticationRepository, .isAuthenticated, Bool, Error

### Community 33 - "HydrationChallenge"
Cohesion: 0.19
Nodes (6): HydrationChallenge, .id, ChallengeCardModel, Bool, Double, Int

### Community 34 - "RecordCalendarView"
Cohesion: 0.06
Nodes (45): GridItem, CalendarDayView, .accessibilityLabel, .backgroundColor, .body, .borderColor, .dayNumber, .progressPercentage (+37 more)

### Community 35 - "HealthKitSource"
Cohesion: 0.15
Nodes (7): HealthKitSource, ReminderHealthKitWriteTests, Bool, Date, Double, Error, Int

### Community 36 - "HydrationProgressSnapshot"
Cohesion: 0.22
Nodes (10): HydrationProgressSnapshot, HydrationInsightViewModelTests, SpyRoutineUseCase, Calendar, Date, Int, MockDrinkWaterUseCase, MockHydrationRoutineAdherenceUseCase (+2 more)

### Community 37 - "ChallengeViewModel"
Cohesion: 0.07
Nodes (26): MockPersonalizedChallengeUseCase, Calendar, Date, HydrationChallengeTier, beginner, steady, stretch, PersonalizedHydrationChallenge (+18 more)

### Community 38 - "AnyObject"
Cohesion: 0.13
Nodes (7): AnyObject, FullScreenRoute, DeepLinkHandling, URL, FullScreenRouting, SheetRouting, SheetRoute

### Community 39 - "ProductAnalyticsEvent"
Cohesion: 0.13
Nodes (12): .postHogValue, Any, AnalyticsParameterName, AnalyticsParameterValue, bool, double, int, string (+4 more)

### Community 40 - "HydrationGoalRecommendationViewModel"
Cohesion: 0.10
Nodes (17): DailyLimitSettingView, .body, HydrationGoalRecommendationUseCase, Date, EntryDestination, bodyProfileSetting, dailyLimitSetting, GoalAlignment (+9 more)

### Community 41 - "RoutineRecommendationUseCaseImpl"
Cohesion: 0.18
Nodes (12): DaySummary, RoutineRecommendationUseCaseImpl, Bool, Calendar, Date, DateInterval, Double, Int (+4 more)

### Community 42 - "HKQuantityTypeIdentifier"
Cohesion: 0.18
Nodes (12): HKAuthorizationStatus, HKHealthStore, HKQuantityType, HKQuantityTypeIdentifier, HKUnit, HealthKitQuantityStore, .isHealthDataAvailable, HealthQuantitySample (+4 more)

### Community 43 - "MockHydrationReminderRepository"
Cohesion: 0.10
Nodes (9): HydrationReminderRepository, Bool, HydrationReminderUseCaseImpl, Bool, HydrationReminderUseCaseTests, MockHydrationReminderRepository, Bool, Error (+1 more)

### Community 44 - "HydrationStarterPlanViewModelTests"
Cohesion: 0.27
Nodes (4): HydrationStarterPlanViewModelTests, Bool, Date, Int

### Community 45 - ".assemble"
Cohesion: 0.15
Nodes (7): MockChallengeUseCaseForTesting, Calendar, Date, MockPersonalizedChallengeUseCaseForTesting, Calendar, Date, Container

### Community 46 - "ProfileRoutineView"
Cohesion: 0.19
Nodes (7): ProfileRoutineView, .guidanceCard, .permissionSection, RoutineGuidanceSlotStatus, elapsed, next, upcoming

### Community 47 - "DIContainer"
Cohesion: 0.12
Nodes (11): Assembler, Assembly, DIContainer, .resolver, Assembly, PreviewAssembly, DomainAssembly, PresentationAssembly (+3 more)

### Community 48 - "UserDefaults"
Cohesion: 0.08
Nodes (19): DataAssembly, Container, HydrationComebackRepositoryImpl, Date, HydrationComebackRepositoryTests, HydrationReminderStorageDataSourceImpl, Bool, RoutineStorageDataSourceImpl (+11 more)

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.08
Nodes (12): MockHydrationReminderUseCase, Bool, Error, Result, MockHydrationReminderUseCaseForTesting, Bool, HydrationReminderAuthorizationStatus, authorized (+4 more)

### Community 50 - "HealthKitDataSourceImpl"
Cohesion: 0.15
Nodes (8): HealthKitDataSourceImpl, .healthKitAuthorizationStatus, .isWaterSharingAuthorized, Bool, Date, Double, Error, .isWaterSharingAuthorized

### Community 51 - "HydrationReminderRepositoryImpl"
Cohesion: 0.13
Nodes (9): HydrationReminderNotificationDataSource, HydrationReminderStorageDataSource, HydrationReminderRepositoryImpl, Bool, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource, Bool (+1 more)

### Community 52 - "View"
Cohesion: 0.12
Nodes (19): BadgeView, .body, HydrationInsightView, .emptyStateCTAButtons, .insightContent, .routineAdherenceCard, .selectedCategoryContent, .weekdayPatternCard (+11 more)

### Community 53 - "HydrationInsightViewModel"
Cohesion: 0.09
Nodes (30): .body, HydrationInsightViewModel, .canRecordRecoveryDrink, .chartUpperBound, .dailyGoalText, .emptyStateCTAs, .routineAdherenceInsightText, .routineAdherenceMetrics (+22 more)

### Community 54 - "StartTimerIntent"
Cohesion: 0.15
Nodes (12): AppIntentControlValueProvider, ControlConfigurationIntent, Provider, StartTimerIntent, Bool, ControlWidgetConfiguration, IntentResult, LocalizedStringResource (+4 more)

### Community 55 - "BodyProfileViewModel"
Cohesion: 0.08
Nodes (22): MockBodyProfileUseCase, BodyProfileAvailability, incomplete, needsPermission, noData, permissionDenied, ready, BodyProfileSnapshot (+14 more)

### Community 56 - "DrinkWaterHealthKitDataSource"
Cohesion: 0.14
Nodes (8): DrinkWaterDataSource, DrinkWaterHealthKitDataSource, .currentWaterIntakeML, Bool, Calendar, Date, DateInterval, Double

### Community 57 - "DataAssembly.swift"
Cohesion: 0.17
Nodes (5): AccountData, ChallengeData, MulimiAnalyticsData, RoutineData, Utils

### Community 58 - "HydrationChallengeBadgeHistory"
Cohesion: 0.08
Nodes (22): MockChallengeUseCase, Calendar, Date, ChallengeStorageDataSource, ChallengeStorageDataSourceImpl, ChallengeRepositoryImpl, ChallengeStorageDataSourceTests, HydrationChallengeBadgeHistory (+14 more)

### Community 59 - "HydrationReminderSlot"
Cohesion: 0.11
Nodes (14): Constant, HydrationReminderNotificationDataSourceImpl, .notificationCenter, Int, Set, UNUserNotificationCenter, HydrationReminderSlot, afternoon (+6 more)

### Community 60 - "DrinkWaterEntry"
Cohesion: 0.11
Nodes (21): DrinkWaterLockScreenWidgetEntryView, .accentColor, .body, .circularView, .inlineView, .rectangularView, .body, DrinkWaterWidgetEntryView (+13 more)

### Community 61 - ".makeUseCase"
Cohesion: 0.24
Nodes (8): AppReviewRequestUseCaseTests, .calendar, .referenceDate, Bool, Calendar, Date, Double, Int

### Community 62 - ".makeRootView"
Cohesion: 0.14
Nodes (11): AnyView, App, 실행·공유 경계, WatchDIContainer, DrinkWaterApp, .body, Scene, MulimiWatchApp (+3 more)

### Community 63 - "AppReviewRequestUseCaseImpl"
Cohesion: 0.22
Nodes (9): AppReviewRequestRepository, AppReviewRequestUseCaseImpl, Policy, Bool, Calendar, Date, DateInterval, Double (+1 more)

### Community 64 - "LogWaterAppIntent"
Cohesion: 0.16
Nodes (13): AppIntent, IntentDialog, IntentModes, Constant, FailureReason, LogWaterAppIntent, .resolvedVolumeML, Bool (+5 more)

### Community 65 - "ProjectDescription"
Cohesion: 0.12
Nodes (5): PackageDescription, Plist, ProjectDescription, ProjectDescriptionHelpers, AppVersion

### Community 66 - "HydrationStarterPlan"
Cohesion: 0.18
Nodes (10): PreviewStarterPlanRepository, HydrationQuickRecordingMethod, shortcuts, watch, widget, HydrationStarterPlan, Bool, Date (+2 more)

### Community 67 - "ContentView"
Cohesion: 0.16
Nodes (9): AppCoordinator, URL, StackRouting, .hasPath, Bool, Hashable, AppCoordinatorTests, ContentView (+1 more)

### Community 68 - "Top 5"
Cohesion: 0.14
Nodes (13): 1. 로그인 없이 시작, 2. 7일 스타터 플랜, 3. 알림 바로 기록, 4. 제어 센터·액션 버튼 기록, 5. 컴백 모드, Candidate Ideas, Decision, Engineer (+5 more)

### Community 69 - "MainIcon"
Cohesion: 0.07
Nodes (16): MockUserPreferencesUseCase, Bool, Double, MainIcon, cloud, .`default`, drop, heart (+8 more)

### Community 70 - "Test.swift"
Cohesion: 0.18
Nodes (14): AppIntentTimelineProvider, ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, ConfigurationAppIntent, Context (+6 more)

### Community 71 - "HydrationStarterPlanViewModel"
Cohesion: 0.20
Nodes (10): .drinkWaterView, .checklist, HydrationStarterPlanViewModel, .completedStepCount, .isAvailable, Bool, Calendar, Date (+2 more)

### Community 72 - "HydrationRoutine"
Cohesion: 0.05
Nodes (19): Int, MockRoutineUseCase, Error, Result, MockRoutineUseCaseForTesting, StarterPlanRoutineStub, UUID, HydrationRoutine (+11 more)

### Community 73 - "HydrationRecordDaySummary"
Cohesion: 0.13
Nodes (13): Date, DateInterval, .yearMonthPickerSheet, HydrationRecordDaySummary, .glassCount, .id, .todaySummary, .weekDayItems (+5 more)

### Community 74 - "Hashable"
Cohesion: 0.10
Nodes (18): Hashable, HydrationGoalRecommendationDataSource, HydrationGoalRecommendationRepositoryImpl, HydrationGoalRecommendation, HydrationGoalRecommendationError, bodyProfileRequired, modelUnavailable, HydrationGoalRecommendationInput (+10 more)

### Community 75 - "OnboardingView"
Cohesion: 0.14
Nodes (15): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+7 more)

### Community 76 - "HydrationGoalRecommendationCard"
Cohesion: 0.18
Nodes (9): BodyProfileSettingView, .body, .healthSyncCard, .summaryCard, HydrationGoalRecommendationCard, .body, .content, Bool (+1 more)

### Community 77 - ".assemble"
Cohesion: 0.13
Nodes (6): Container, HealthKitRepository, Date, BodyProfileUseCaseImpl, Bool, BodyProfileUseCaseTests

### Community 78 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.23
Nodes (7): Constants, HydrationGoalRecommendationUseCaseImpl, Calendar, Date, DateInterval, Int, HydrationGoalRecommendationUseCaseTests

### Community 79 - "AppReviewRequestState"
Cohesion: 0.14
Nodes (8): AppReviewRequestStorageDataSource, AppReviewRequestStorageDataSourceImpl, AppReviewRequestRepositoryImpl, AppReviewRequestStorageDataSourceTests, AppReviewRequestState, Date, Set, MockAppReviewRequestRepository

### Community 80 - "SharedHydrationStoreError"
Cohesion: 0.19
Nodes (10): ModelConfiguration, ModelContainer, SharedHydrationStore, .isICloudAccountAvailable, SharedHydrationStoreError, .errorDescription, failedToCreateContainer, missingAppGroupContainer (+2 more)

### Community 81 - "UserPreferencesUseCaseImpl"
Cohesion: 0.32
Nodes (3): Double, UserPreferencesUseCaseImpl, UserPreferencesUseCaseTests

### Community 82 - "WatchHydrationSnapshot"
Cohesion: 0.11
Nodes (14): WatchHydrationMutationResult, Bool, Date, Double, Int, Self, WatchHydrationSnapshot, .eventCount (+6 more)

### Community 83 - "OnboardingViewModel"
Cohesion: 0.21
Nodes (6): Bool, OnboardingViewModel, .canGoBack, .isLastPage, Bool, OnboardingViewModelTests

### Community 84 - ".loadChallenges"
Cohesion: 0.26
Nodes (8): ChallengeViewModelTests, Calendar, MockChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCase, Calendar, Date

### Community 85 - "Color"
Cohesion: 0.15
Nodes (16): ChallengeBadge, .body, ChallengeCard, .accentColor, .body, .cardBackground, ChallengeHistoryCard, .accentColor (+8 more)

### Community 86 - "MockAppReviewRequestUseCase"
Cohesion: 0.18
Nodes (11): AppReviewRequestUseCase, NoOpAppReviewRequestUseCase, Bool, Calendar, Date, Double, MockAppReviewRequestUseCase, Bool (+3 more)

### Community 87 - "Clean Architecture and MVVM"
Cohesion: 0.29
Nodes (7): Clean Architecture and MVVM, Domain Purity, ViewModel Side Effect Boundary, navigation-coordinator, Root Navigation, Modular Clean Architecture, Root App Flow

### Community 88 - "Growth Scorecard"
Cohesion: 0.07
Nodes (22): 72-Hour Audit, Before Release, Cadence And Ownership, Decision Rule, Deferred Scope, Experiment Record, Goal, Growth Scorecard (+14 more)

### Community 89 - "AppleSignInCredential"
Cohesion: 0.17
Nodes (10): ASAuthorization, ASAuthorizationController, ASAuthorizationControllerDelegate, AuthenticationServices, NSObject, AppleSignInCredential, AppleSignInDataSourceImpl, AppleSignInDelegate (+2 more)

### Community 90 - "AppDelegate"
Cohesion: 0.18
Nodes (10): AppDelegate, Any, Bool, UNUserNotificationCenter, UIApplication, UIApplicationDelegate, UNNotification, UNNotificationPresentationOptions (+2 more)

### Community 91 - "GlareCircleView"
Cohesion: 0.17
Nodes (7): CGPoint, GlareCircleView, .body, CGFloat, Content, WaterDropGlareEffectModifier, ViewModifier

### Community 92 - "프로젝트 전체 구조와 의존성"
Cohesion: 0.15
Nodes (13): App · 조립 루트 — 9개, Core — 6개, Features — 18개, Shared — 5개, Tests — 15개, 검증과 갱신, 기능 간 직접 의존에서 주의할 점, 디렉터리와 소유권 (+5 more)

### Community 93 - "HydrationGoalRecommendationAvailability"
Cohesion: 0.16
Nodes (10): MockHydrationGoalRecommendationUseCase, Date, Error, HydrationGoalRecommendationAvailability, bodyProfileRequired, modelUnavailable, ready, MockHydrationGoalRecommendationUseCase (+2 more)

### Community 94 - "HydrationProgressUseCaseImpl"
Cohesion: 0.39
Nodes (7): HydrationProgressUseCaseImpl, StreakProgress, Calendar, Date, DateInterval, Double, Int

### Community 95 - "AuthTokens"
Cohesion: 0.26
Nodes (4): AuthenticationNetworkDataSource, AuthenticationNetworkDataSourceImpl, AuthTokens, Int

### Community 96 - "Security And Privacy Operations"
Cohesion: 0.15
Nodes (13): Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling, Data Boundary, Health Data Minimization, PostHog Privacy Controls (+5 more)

### Community 97 - "HydrationReminderDomain"
Cohesion: 0.08
Nodes (10): AccountPresentation, ChallengePresentation, DependencyInjection, HydrationReminderData, HydrationReminderDomain, HydrationReminderPresentation, MulimiNavigation, HydrationReminderAnalyticsParameterName (+2 more)

### Community 98 - "FoundationModelsHydrationGoalRecommendationDataSource"
Cohesion: 0.24
Nodes (6): Constants, FoundationModelsHydrationGoalRecommendationDataSource, GeneratedHydrationGoalRecommendation, Int, Locale, SystemLanguageModel

### Community 99 - "PersonalizedChallengeUseCaseImpl"
Cohesion: 0.30
Nodes (5): Constants, PersonalizedChallengeUseCaseImpl, Calendar, Date, Int

### Community 100 - "LogWaterAmountOption"
Cohesion: 0.18
Nodes (11): AppEnum, DisplayRepresentation, LogWaterAmountOption, bottle, custom, glass, .presetID, .servingType (+3 more)

### Community 101 - "AGENTS.md Onboarding Map"
Cohesion: 0.11
Nodes (24): Goal Recommendation Entry Rules, Profile Information Architecture, Profile Root, Settings Screen, Quality Gates, Truthful Validation Reporting, Validation Baseline, Validation Matrix (+16 more)

### Community 102 - "SettingsViewModel"
Cohesion: 0.12
Nodes (15): StaticAppInfoProvider, MainIconSettingView, .body, SettingDetailView, .body, WithdrawalSettingView, .body, SettingsViewModel (+7 more)

### Community 103 - "HealthKitAuthorizationStatus"
Cohesion: 0.26
Nodes (6): HealthKitAuthorizationStatus, notDetermined, sharingAuthorized, sharingDenied, .analyticsValue, ProductAnalyticsEvent

### Community 104 - "Sendable"
Cohesion: 0.06
Nodes (24): MockHydrationProgressUseCase, Calendar, Date, MockHydrationRoutineAdherenceUseCase, Calendar, Date, MockHydrationProgressUseCaseForTesting, Calendar (+16 more)

### Community 105 - "HydrationReminderPermissionGateView"
Cohesion: 0.20
Nodes (9): .body, SignInView, .body, HydrationReminderPermissionGateView, .allowButtonLabel, .benefitCard, .body, .headerSection (+1 more)

### Community 106 - "WaterDropView"
Cohesion: 0.25
Nodes (8): CGFloat, CGSize, TimeInterval, WaterDropView, .body, .dropBackground, .dropHighlights, .dropSymbol

### Community 107 - "CaseIterable"
Cohesion: 0.15
Nodes (14): CaseIterable, HydrationServing, .additionalPresets, HydrationServingPreset, bottle, .id, tumbler, .volumeML (+6 more)

### Community 108 - "WatchHydrationEvent"
Cohesion: 0.25
Nodes (6): Date, Int, WatchHydrationRepositoryImpl, Date, Int, WatchHydrationEvent

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
Cohesion: 0.09
Nodes (11): Double, NSUbiquitousKeyValueStore, SyncedValueStoring, UbiquitousMirroredStore, Constants, Bool, Double, NSUbiquitousKeyValueStore (+3 more)

### Community 118 - "AuthenticationRepositoryImpl"
Cohesion: 0.19
Nodes (6): AppleSignInDataSource, KeyChainDataSource, Bool, AuthenticationRepositoryImpl, .isAuthenticated, Bool

### Community 119 - ".makeViewModel"
Cohesion: 0.23
Nodes (5): MockHydrationGoalRecommendationUseCase, MockHydrationProgressUseCase, HydrationGoalRecommendationViewModelTests, Double, Int

### Community 120 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 121 - "WatchHydrationHealthKitDataSource"
Cohesion: 0.20
Nodes (8): Bool, Calendar, Date, DateInterval, Error, Int, WatchHydrationHealthKitDataSource, WatchHydrationLocalDataSource

### Community 122 - ".handle"
Cohesion: 0.29
Nodes (6): HydrationReminderActionHandlerTests, Bool, Date, Double, MockDrinkWaterUseCase, WidgetReloader

### Community 123 - "DrinkWaterWidgetProvider"
Cohesion: 0.36
Nodes (5): HydrationNextActionGuideUseCase, DrinkWaterWidgetProvider, ConfigurationAppIntent, Context, Timeline

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (7): ActivityAttributes, ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 125 - "MockHealthKitUseCaseForTesting"
Cohesion: 0.10
Nodes (5): MockHealthKitUseCaseForTesting, Bool, Date, HealthKitUseCase, Date

### Community 126 - "Error"
Cohesion: 0.10
Nodes (19): Error, AuthenticationError, cancelled, invalidCredential, networkFailed, serverError, unknown, MockSignInError (+11 more)

### Community 127 - "HydrationWriteResult"
Cohesion: 0.13
Nodes (10): .analyticsFailureReason, HydrationWriteResult, failure, .failureReason, .isSuccess, success, Bool, Int (+2 more)

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
Cohesion: 0.11
Nodes (20): MockHydrationNextActionGuideUseCase, Calendar, Date, MockHydrationNextActionGuideUseCaseForTesting, Calendar, Date, Constants, HydrationNextActionGuide (+12 more)

### Community 132 - "#320 — 7일 스타터 플랜 제품 적용"
Cohesion: 0.20
Nodes (9): #320 — 7일 스타터 플랜 제품 적용, Constraints And Decisions, Context, Goal, Implementation Notes (2026-09-14), Non-Goals, Plan, Rollback (+1 more)

### Community 133 - "Mulimi"
Cohesion: 0.14
Nodes (23): Agent Onboarding Guide, Graphify-Assisted Code Navigation, Mulimi Architecture SSOT, Core User Flow, Dependency Direction, Layer Responsibilities, Claude Agent Entrypoint, Accessibility Metadata Stays in View Layer (+15 more)

### Community 134 - "RoutineWeekday"
Cohesion: 0.06
Nodes (34): MockRoutineRecommendationUseCase, Calendar, Date, MockRoutineRecommendationUseCaseForTesting, Calendar, Date, .localeWeekday, Locale (+26 more)

### Community 135 - "UserPreferencesRepositoryImpl"
Cohesion: 0.28
Nodes (3): Bool, Double, UserPreferencesRepositoryImpl

### Community 136 - "WatchDailyGoalLocalDataSource"
Cohesion: 0.25
Nodes (6): MulimiCloudKit, Int, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, Int, WatchDailyGoalRepositoryImpl

### Community 137 - "HealthKitDataSource"
Cohesion: 0.18
Nodes (4): HealthKitDataSource, HealthKitRepositoryImpl, .authorisationStatus, Date

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "HydrationStarterPlanView"
Cohesion: 0.32
Nodes (4): HydrationStarterPlanView, .body, Bool, Void

### Community 140 - "RoutineNotificationDataSourceImpl"
Cohesion: 0.18
Nodes (8): Alarm, AlarmManager, AlarmMetadata, AlarmPresentation, Constant, RoutineAlarmMetadata, RoutineNotificationDataSourceImpl, LocalizedStringResource

### Community 143 - "UserCredential"
Cohesion: 0.15
Nodes (3): MockSignInUseCase, Bool, UserCredential

### Community 144 - "HydrationStarterPlanRepositoryImpl"
Cohesion: 0.38
Nodes (3): HydrationStarterPlanRepositoryImpl, HydrationStarterPlanRepositoryTests, Bool

### Community 145 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, challenge, drink, history, insight, profile

### Community 146 - "ProfileView"
Cohesion: 0.21
Nodes (9): AccountRoute, profileRoutine, setting, ProfileView, .body, .goalRecommendationCard, .goalRecommendationRoute, .routineCard (+1 more)

### Community 148 - "HealthQuantityStoreError"
Cohesion: 0.40
Nodes (5): HealthQuantityStoreError, incompleteQuery, internalError, invalidObjectType, permissionDenied

### Community 151 - ".progressSnapshot"
Cohesion: 0.40
Nodes (4): HydrationProgressUseCaseTests, Calendar, Date, Int

### Community 152 - ".makeComebackViewModel"
Cohesion: 0.13
Nodes (11): HydrationComebackRepository, Date, HydrationComebackMode, baseline, card, disabled, StubHydrationComebackRepository, Bool (+3 more)

### Community 153 - "HealthKitError"
Cohesion: 0.33
Nodes (5): HealthKitError, healthKitInternalError, incompleteExecuteQuery, invalidObjectType, permissionDenied

### Community 154 - "Test"
Cohesion: 0.10
Nodes (22): ControlWidget, WidgetConfiguration, Test, Widget, TestBundle, .body, WidgetConfiguration, TestLiveActivity (+14 more)

### Community 155 - "Challenge State Model"
Cohesion: 0.50
Nodes (5): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Legacy Challenge State Migration, Recurring Challenge State

### Community 156 - "DrinkWaterRepository"
Cohesion: 0.15
Nodes (5): DrinkWaterRepository, Bool, Date, DateInterval, Double

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
Cohesion: 0.43
Nodes (4): AppInfoProviding, BundleAppInfoProvider, .appBuildNumber, .appVersion

### Community 162 - "RoutineRecoveryReminderAction"
Cohesion: 0.14
Nodes (13): Bool, HydrationInsightEmptyAction, dailyGoal, record, routine, HydrationWeeklyCoachingAction, dailyGoal, none (+5 more)

### Community 163 - ".setHydrationEvents"
Cohesion: 0.37
Nodes (5): PersonalizedChallengeUseCaseTests, Calendar, Date, Double, Int

### Community 164 - "WatchHydrationViewModel"
Cohesion: 0.22
Nodes (8): MutationAction, record, reset, Bool, Date, Sendable, WatchHydrationViewModel, .canDrinkWater

### Community 165 - "HydrationRecordPeriod"
Cohesion: 0.29
Nodes (7): .selectedPeriodRangeText, HydrationRecordPeriod, .id, month, .title, today, week

### Community 166 - "#321 수분 알림 바로 기록"
Cohesion: 0.17
Nodes (11): #321 수분 알림 바로 기록, Completion Notes, Constraints, Context, Goal, Non-Goals, Open Questions, Plan (+3 more)

### Community 168 - "MockUserPreferencesUseCaseForTesting"
Cohesion: 0.21
Nodes (3): MockUserPreferencesUseCaseForTesting, Bool, Double

### Community 169 - "TokenProperty"
Cohesion: 0.21
Nodes (7): KeyChainDataSourceImpl, TokenProperty, accessToken, email, nickname, refreshToken, userIdentifier

### Community 170 - "UserPreferencesRepository"
Cohesion: 0.20
Nodes (3): Bool, Double, UserPreferencesRepository

### Community 171 - ".init"
Cohesion: 0.18
Nodes (8): Bool, Calendar, Date, Double, Int, MockHydrationProgressUseCase, Calendar, Date

### Community 172 - "Reliability Recovery"
Cohesion: 0.22
Nodes (11): Goal Mirror Recovery Policy, HealthKit Source of Truth, Recovery Principles, Reliability Recovery, Routine Schedule Recovery, Shared Hydration Rules, HealthKit Data Flow, healthkit-flow (+3 more)

### Community 173 - "HydrationReminderNotification"
Cohesion: 0.24
Nodes (6): HydrationReminderNotification, .category, Bool, Date, HydrationReminderNotificationTests, UNNotificationCategory

### Community 174 - "WaterWaveView"
Cohesion: 0.28
Nodes (6): CGRect, Path, CGFloat, WaterWaveView, .animatableData, Shape

### Community 175 - "HydrationInsightCategory"
Cohesion: 0.22
Nodes (9): HydrationInsightCategory, .id, overview, pattern, report, routine, .systemImage, .title (+1 more)

### Community 176 - "MockHealthKitUseCase"
Cohesion: 0.25
Nodes (4): MockHealthKitUseCase, .authorisationStatus, Date, Error

### Community 177 - "CI Lint and Architecture Gate"
Cohesion: 0.25
Nodes (8): CI Lint and Architecture Gate, Lint Workflow, Domain Data Presentation Test Matrix, PR Unit Tests Workflow, SwiftPM Cache Retry, Selected SwiftLint Rule Set, SwiftLint Configuration, Default Validation Sequence

### Community 178 - "SettingMenu"
Cohesion: 0.25
Nodes (7): SettingMenu, bodyProfile, dailyLimit, .id, mainIcon, withdrawal, Self

### Community 179 - ".drinkWater"
Cohesion: 0.29
Nodes (3): Error, Int, Int

### Community 180 - "HydrationReminderActionResult"
Cohesion: 0.25
Nodes (8): HydrationReminderActionResult, duplicate, failed, goalExceeded, permissionRequired, protectedDataUnavailable, saved, signInRequired

### Community 182 - "ChallengeCategory"
Cohesion: 0.29
Nodes (7): ChallengeCategory, .id, inProgress, recommended, .systemImage, .title, Self

### Community 183 - "State"
Cohesion: 0.29
Nodes (6): State, bodyProfileRequired, idle, loading, modelUnavailable, ready

### Community 184 - ".dayNumber"
Cohesion: 0.33
Nodes (4): Calendar, Int, HydrationStarterPlanTests, Int

## Ambiguous Edges - Review These
- `HealthKit Source of Truth` → `CloudKit-Backed Hydration Store`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to
- `CloudKit-Backed Hydration Store` → `Current Storage Strategy`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to

## Knowledge Gaps
- **505 isolated node(s):** `.resolver`, `production`, `preview`, `testing`, `.current` (+500 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 965 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `HealthKit Source of Truth` and `CloudKit-Backed Hydration Store`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `Current Storage Strategy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `String` connect `String` to `HydrationRoutineAdherenceInsight`, `HydrationRecord`, `ProfileRoutineViewModel`, `.tr`, `HydrationRecordListViewModel`, `.assemble`, `AnalyticsUseCase`, `DrinkWaterViewModel`, `HydrationChallengeKind`, `HealthKitPermissionViewModel`, `RoutineActionIntent`, `MockDrinkWaterUseCase`, `HydrationEvent`, `BodyProfile`, `MockDrinkWaterRepository`, `.tr`, `SpyRoutineUseCase`, `LiquidGlassSegmentedControl`, `PostHogAnalyticsRepository`, `HydrationReminderPermissionViewModel`, `HydrationChallenge`, `RecordCalendarView`, `HealthKitSource`, `ChallengeViewModel`, `ProductAnalyticsEvent`, `HydrationGoalRecommendationViewModel`, `HKQuantityTypeIdentifier`, `ProfileRoutineView`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `HealthKitDataSourceImpl`, `View`, `HydrationInsightViewModel`, `StartTimerIntent`, `BodyProfileViewModel`, `HydrationChallengeBadgeHistory`, `HydrationReminderSlot`, `DrinkWaterEntry`, `AppReviewRequestUseCaseImpl`, `LogWaterAppIntent`, `ProjectDescription`, `HydrationStarterPlan`, `MainIcon`, `HydrationStarterPlanViewModel`, `HydrationRoutine`, `HydrationRecordDaySummary`, `Hashable`, `OnboardingView`, `HydrationGoalRecommendationCard`, `AppReviewRequestState`, `SharedHydrationStoreError`, `Color`, `MockAppReviewRequestUseCase`, `Growth Scorecard`, `AppleSignInCredential`, `AppDelegate`, `AuthTokens`, `FoundationModelsHydrationGoalRecommendationDataSource`, `LogWaterAmountOption`, `SettingsViewModel`, `HealthKitAuthorizationStatus`, `HydrationReminderPermissionGateView`, `CaseIterable`, `ConfigurationAppIntent`, `SettingsViewModelTests`, `DrinkWaterRepositoryImpl`, `HydrationRoutineSchedule`, `AppRoute`, `UserPreferencesDataSourceImpl`, `AuthenticationRepositoryImpl`, `ContentState`, `Error`, `HydrationWriteResult`, `HydrationNextActionGuide`, `RoutineWeekday`, `HydrationStarterPlanView`, `RoutineNotificationDataSourceImpl`, `UserCredential`, `ProfileView`, `.progressSnapshot`, `.makeComebackViewModel`, `Test`, `BundleAppInfoProvider`, `RoutineRecoveryReminderAction`, `WatchHydrationViewModel`, `HydrationRecordPeriod`, `MockUserPreferencesUseCaseForTesting`, `TokenProperty`, `HydrationReminderNotification`, `HydrationInsightCategory`, `SettingMenu`, `.drinkWater`, `HydrationReminderActionResult`, `ChallengeCategory`?**
  _High betweenness centrality (0.303) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `HydrationRoutineAdherenceInsight`, `HydrationRecord`, `WatchHydrationLocalDataSource.swift`, `HydrationNextActionGuide`, `String`, `RoutineWeekday`, `WatchDailyGoalLocalDataSource`, `.tr`, `.assemble`, `HydrationDomain`, `AnalyticsUseCase`, `DrinkWaterViewModel`, `UserCredential`, `HydrationChallengeKind`, `RoutineActionIntent`, `HydrationEvent`, `BodyProfile`, `.makeComebackViewModel`, `AccountDomain`, `HealthKitError`, `MockRoutineRepository`, `DrinkWaterRepository`, `AuthProvider`, `Localization`, `HydrationReminderPermissionViewModel`, `BundleAppInfoProvider`, `SignInUseCaseImpl`, `HydrationProgressSnapshot`, `ChallengeViewModel`, `AnyObject`, `ProductAnalyticsEvent`, `HydrationGoalRecommendationViewModel`, `TokenProperty`, `HKQuantityTypeIdentifier`, `UserPreferencesRepository`, `MockHydrationReminderRepository`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `AuthenticationRepository`, `BodyProfileViewModel`, `DataAssembly.swift`, `HydrationChallengeBadgeHistory`, `HydrationReminderSlot`, `HydrationStarterPlan`, `MainIcon`, `HydrationRoutine`, `Hashable`, `.assemble`, `AppReviewRequestState`, `SharedHydrationStoreError`, `WatchHydrationSnapshot`, `MockAppReviewRequestUseCase`, `AppleSignInCredential`, `AuthTokens`, `HydrationReminderDomain`, `HealthKitAuthorizationStatus`, `Sendable`, `CaseIterable`, `WatchHydrationEvent`, `WatchHydrationUseCaseImpl`, `UserPreferencesDataSourceImpl`, `DIEnvironment`, `.tr`, `MockHealthKitUseCaseForTesting`, `Error`?**
  _High betweenness centrality (0.072) - this node is a cross-community bridge._
- **Why does `프로젝트 전체 구조와 의존성` connect `프로젝트 전체 구조와 의존성` to `Mulimi`, `.makeRootView`?**
  _High betweenness centrality (0.066) - this node is a cross-community bridge._
- **What connects `.resolver`, `production`, `preview` to the rest of the system?**
  _505 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `HydrationRoutineAdherenceInsight` be split into smaller, more focused modules?**
  _Cohesion score 0.12403100775193798 - nodes in this community are weakly interconnected._