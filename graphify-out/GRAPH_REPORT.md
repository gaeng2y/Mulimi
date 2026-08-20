# Graph Report - Mulimi  (2026-08-18)

## Corpus Check
- 352 files · ~96,811 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 3295 nodes · 8652 edges · 153 communities (139 shown, 14 thin omitted)
- Extraction: 83% EXTRACTED · 17% INFERRED · 0% AMBIGUOUS · INFERRED: 1432 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Sendable
- MockHealthKitRepository
- Foundation
- HydrationInsightViewModel
- HydrationEvent
- UserCredential
- DrinkWaterViewModel
- MockUserPreferencesUseCase
- .tr
- RecordCalendarView
- View
- Product Specs Index
- HydrationWriteResult
- Agent Onboarding Guide
- String
- WatchHydrationViewModel
- HydrationChallengeKind
- HealthKitDataSource
- RoutineActionIntent
- SettingsViewModel
- Error
- Hashable
- BodyProfileViewModel
- MockSignInUseCase
- MockUserPreferencesRepository
- Testing
- HealthKitPermissionViewModel
- SpyRoutineUseCase
- LiquidGlassSegmentedControl
- MainIcon
- SwiftUI
- HydrationReminderPermissionViewModel
- MockDrinkWaterRepository
- ChallengeViewModel
- DrinkWaterRepository
- MockRoutineRepository
- MockHydrationReminderRepository
- PersonalizedHydrationChallenge
- AppCoordinator
- HydrationChallengeBadgeHistory
- ProfileRoutineViewModel
- HydrationRoutine
- AnalyticsRepository
- HydrationReminderRepositoryImpl
- RoutineRepositoryImpl
- ProfileRoutineView
- ChallengeUseCaseImpl
- DIContainer
- UserDefaults
- HydrationReminderAuthorizationStatus
- AppRoute
- HydrationReminderSlot
- HydrationGoalRecommendationCard
- RoutineRecoveryReminderAction
- HealthKitDataSourceImpl
- HydrationGoalRecommendationViewModel
- RoutineRecommendationUseCaseImpl
- WidgetKit
- OnboardingView
- .body
- DrinkWaterEntry
- HydrationGoalRecommendationUseCaseImpl
- HydrationNextActionGuide
- .makeUseCase
- LogWaterAppIntent
- ProjectDescription
- Test
- RoutineWeekday
- RoutineNotificationAuthorizationStatus
- PersonalizedChallengeUseCaseImpl
- Test.swift
- BodyProfile
- RoutineNotificationDataSourceImpl
- HydrationServingPreset
- FoundationModelsHydrationGoalRecommendationDataSource
- UserPreferencesDataSourceImpl
- WatchHydrationSnapshot
- HydrationRoutineRecommendation
- AppReviewRequestUseCaseImpl
- HydrationProgressUseCaseImpl
- .loadChallenges
- .makeViewModel
- AppReviewRequestState
- BodyProfileAvailability
- OnboardingViewModel
- MockUserPreferencesUseCaseForTesting
- .makeRootView
- AGENTS.md Onboarding Map
- TokenProperty
- .make
- AppDelegate
- UserPreferencesRepositoryImpl
- WatchHydrationHealthKitDataSource
- HydrationRoutineRecommendationKind
- WatchHydrationUseCaseImpl
- .assemble
- Data Boundary
- AnalyticsUseCase
- .routineAnchorRecommendation
- SpyUserPreferencesUseCase
- LogWaterAmountOption
- Reliability Recovery
- WatchDailyGoalUserDefaultsDataSource
- WaterDropView
- RoutineEditorDraft
- MockHydrationReminderUseCase
- WaterWaveView
- Observation
- DrinkWaterHealthKitDataSource.swift
- ConfigurationAppIntent
- MockError
- AuthTokens
- SettingMenu
- .shouldRequestAfterSuccessfulHydrationRecord
- HydrationInsightCategory
- Security And Privacy Operations
- Mulimi
- AppReviewRequestStorageDataSourceImpl
- ChallengeStorageDataSourceImpl
- WatchHydrationRepositoryImpl
- BodyProfileValue
- .progressSnapshot
- ChallengeCategory
- .resolve
- ContentState
- HydrationReminderPermissionGateView
- MockAppReviewRequestUseCase
- .dayKey
- LogWaterAppShortcuts
- float2
- AppTab
- .guide
- DIEnvironment
- Challenge State Model
- ChallengeRepositoryImpl
- AuthProvider
- WatchHydrationEvent
- BundleAppInfoProvider
- Accessibility and Dynamic Type Audit
- Profile Information Architecture
- HydrationEventModel
- ci_post_clone.sh
- pre-commit
- .hydrationEvents
- Bool
- .fetchChallenges
- .guide
- check-architecture.sh
- WatchDataConstants.swift
- lint.sh
- lint-fix.sh

## God Nodes (most connected - your core abstractions)
1. `DomainLayerInterface` - 153 edges
2. `DrinkWaterViewModel` - 102 edges
3. `HydrationRoutine` - 96 edges
4. `HydrationInsightViewModel` - 95 edges
5. `ProfileRoutineViewModel` - 74 edges
6. `HydrationEvent` - 69 edges
7. `MockUserPreferencesUseCase` - 65 edges
8. `MockDrinkWaterUseCase` - 63 edges
9. `HydrationRecordListViewModel` - 60 edges
10. `BodyProfile` - 54 edges

## Surprising Connections (you probably didn't know these)
- `Modular Clean Architecture` --semantically_similar_to--> `Clean Architecture and MVVM`  [INFERRED] [semantically similar]
  README.md → Docs/skills/architecture-boundary.md
- `AI Review Automation Contract` --semantically_similar_to--> `Git Flow PR Filter`  [INFERRED] [semantically similar]
  Docs/delivery-workflow.md → .github/workflows/ai-pr-review.yml
- `Default Validation Sequence` --semantically_similar_to--> `CI Lint and Architecture Gate`  [INFERRED] [semantically similar]
  AGENTS.md → .github/workflows/lint.yml
- `Default Validation Sequence` --semantically_similar_to--> `Domain Data Presentation Test Matrix`  [INFERRED] [semantically similar]
  AGENTS.md → .github/workflows/pr-unit-tests.yml
- `Data Sources of Truth` --semantically_similar_to--> `Hydration Source of Truth`  [INFERRED] [semantically similar]
  ARCHITECTURE.md → AGENTS.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Architecture Guardrail Pipeline** — agents_default_validation, _github_workflows_lint_ci_architecture_gate, _swiftlint_swiftlint_configuration, architecture_dependency_direction [INFERRED 0.95]
- **Delivery and Review Contract** — docs_delivery_workflow_git_flow_delivery, _github_pull_request_template_pull_request_template, _github_workflows_ai_pr_review_git_flow_pr_filter [EXTRACTED 1.00]
- **Exec Plan Lifecycle** — docs_exec_plans_active_readme_active_exec_plans, docs_exec_plans_active_readme_active_plan_lifecycle, docs_exec_plans_completed_readme_completion_archive [EXTRACTED 1.00]
- **Analytics Contract Measurement and Experiment Lifecycle** — docs_product_specs_analytics_events_event_contract, docs_product_specs_analytics_operations_core_funnel, docs_product_specs_onboarding_healthkit_conversion_experiments_baseline_conversion_funnel, docs_product_specs_sign_in_onboarding_healthkit_permission_recovery [INFERRED 0.95]
- **Hydration Logging Reminder Routine and Challenge Habit Loop** — docs_product_specs_hydration_logging_multi_surface_consistency, docs_product_specs_hydration_reminder_priming_daily_nudge_schedule, docs_product_specs_routine_notifications_transactional_schedule_commit, docs_personalized_challenge_strategy_recommendation_candidates, docs_product_specs_challenge_insight_routine_adherence_insight [INFERRED 0.85]
- **Documentation Harness and Execution Lifecycle** — docs_harness_engineering_documentation_ssot_map, docs_index_document_maintenance_rule, docs_product_specs_index_spec_update_rule, docs_exec_plans_template_exec_plan_lifecycle, docs_exec_plans_tech_debt_tracker_documentation_role_debt [INFERRED 0.95]
- **Canonical Health Data Boundary** — docs_reliability_recovery_healthkit_source_of_truth, docs_security_privacy_health_data_minimization, docs_skills_healthkit_flow_healthkit_data_flow, readme_current_storage_strategy [INFERRED 0.95]
- **Cross-Target Hydration Policy** — docs_reliability_recovery_shared_hydration_rules, docs_skills_widget_watch_integration_cross_target_hydration_consistency, docs_skills_healthkit_flow_storage_policy, readme_current_storage_strategy [INFERRED 0.95]
- **Repository Validation Pipeline** — docs_quality_gates_validation_baseline, docs_skills_lint_fix_loop_automated_lint_fix_loop, docs_skills_xcode_build_test_validation_order, docs_xcode_cloud_release_build_release_build_workflow [INFERRED 0.85]

## Communities (153 total, 14 thin omitted)

### Community 0 - "Sendable"
Cohesion: 0.05
Nodes (67): MockDrinkWaterUseCase, HydrationProgressSnapshot, Bool, Date, Double, Int, HydrationRoutineAdherenceUseCase, HydrationRoutineSchedule (+59 more)

### Community 1 - "MockHealthKitRepository"
Cohesion: 0.06
Nodes (21): HydrationRecord, Date, Double, HealthKitRepository, BodyProfileUseCaseImpl, Bool, HealthKitUseCaseImpl, .authorisationStatus (+13 more)

### Community 2 - "Foundation"
Cohesion: 0.05
Nodes (4): DomainLayerInterface, Foundation, FoundationModels, Utils

### Community 3 - "HydrationInsightViewModel"
Cohesion: 0.08
Nodes (39): Equatable, Identifiable, HydrationInsightEmptyCTAModel, HydrationInsightMetric, HydrationInsightViewModel, .canRecordRecoveryDrink, .chartUpperBound, .dailyGoalText (+31 more)

### Community 4 - "HydrationEvent"
Cohesion: 0.07
Nodes (36): HydrationEvent, Bool, Date, Int, DrinkWaterUseCase, HydrationRecordListView, .body, RowListView (+28 more)

### Community 5 - "UserCredential"
Cohesion: 0.05
Nodes (27): ASAuthorization, ASAuthorizationController, ASAuthorizationControllerDelegate, AuthenticationServices, NSObject, AppleSignInCredential, AppleSignInDataSource, AppleSignInDataSourceImpl (+19 more)

### Community 6 - "DrinkWaterViewModel"
Cohesion: 0.07
Nodes (26): ContentView, AppReviewRequestUseCase, UserPreferencesUseCase, .body, CustomHydrationAmountValidation, empty, invalid, overLimit (+18 more)

### Community 7 - "MockUserPreferencesUseCase"
Cohesion: 0.15
Nodes (15): Never, NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, MockDrinkWaterUseCase, .currentWaterIntakeML, .hasPendingDrinkWater (+7 more)

### Community 8 - ".tr"
Cohesion: 0.06
Nodes (44): Binding, Bundle, .body, HealthKitPermissionGateView, .accessCard, .descriptionText, .footnoteText, .headerColor (+36 more)

### Community 9 - "RecordCalendarView"
Cohesion: 0.07
Nodes (42): CalendarDayView, .accessibilityLabel, .backgroundColor, .body, .borderColor, .dayNumber, .progressPercentage, HydrationProgressBar (+34 more)

### Community 10 - "View"
Cohesion: 0.07
Nodes (32): GridItem, BadgeView, .body, HydrationInsightView, .body, .emptyState, .emptyStateCTAButtons, .insightContent (+24 more)

### Community 11 - "Product Specs Index"
Cohesion: 0.08
Nodes (46): Documentation Role Separation Debt, PostHog Analytics Consolidation, Tech Debt Tracker, Exec Plan Lifecycle, Exec Plan Template, Local GitHub Actions and Xcode Cloud Harness, Documentation SSOT Map, Harness Engineering Structure (+38 more)

### Community 12 - "HydrationWriteResult"
Cohesion: 0.05
Nodes (27): .analyticsFailureReason, HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, HydrationWriteResult, failure, .failureReason (+19 more)

### Community 13 - "Agent Onboarding Guide"
Cohesion: 0.06
Nodes (44): Local Validation Reporting, Mulimi Pull Request Template, PR Review Checklist, AI PR Review Workflow, Architecture Review Policy, Bounded AI Review Diff, Git Flow PR Filter, Textual Diff Selection (+36 more)

### Community 14 - "String"
Cohesion: 0.09
Nodes (19): .postHogValue, Any, HealthKitAuthorizationStatus, notDetermined, sharingAuthorized, sharingDenied, AnalyticsParameterName, AnalyticsParameterValue (+11 more)

### Community 15 - "WatchHydrationViewModel"
Cohesion: 0.09
Nodes (28): WatchHydrationUseCase, CVarArg, WatchL10n, Double, Int, WatchMetricRow, .body, WatchNavigationCard (+20 more)

### Community 16 - "HydrationChallengeKind"
Cohesion: 0.09
Nodes (35): Codable, HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType, streak7, weeklyAchievement80 (+27 more)

### Community 17 - "HealthKitDataSource"
Cohesion: 0.07
Nodes (21): DrinkWaterDataSource, DrinkWaterHealthKitDataSource, .currentWaterIntakeML, Bool, Calendar, Date, DateInterval, Double (+13 more)

### Community 18 - "RoutineActionIntent"
Cohesion: 0.07
Nodes (34): .id, RoutineActionIntent, create, edit, ChallengeBadge, .body, ChallengeCard, .accentColor (+26 more)

### Community 19 - "SettingsViewModel"
Cohesion: 0.10
Nodes (18): AppInfoProviding, StaticAppInfoProvider, SystemWidgetTimelineReloader, WidgetTimelineReloading, MainIconSettingView, .body, .body, WithdrawalSettingView (+10 more)

### Community 20 - "Error"
Cohesion: 0.05
Nodes (34): Error, ModelConfiguration, ModelContainer, TestError, scheduleFailed, TestError, scheduleFailed, AuthenticationError (+26 more)

### Community 21 - "Hashable"
Cohesion: 0.09
Nodes (25): Hashable, HydrationGoalRecommendation, HydrationGoalRecommendationAvailability, bodyProfileRequired, modelUnavailable, ready, HydrationGoalRecommendationError, bodyProfileRequired (+17 more)

### Community 22 - "BodyProfileViewModel"
Cohesion: 0.10
Nodes (15): BodyProfileSnapshot, Bool, MockBodyProfileUseCaseForDomain, BodyProfileViewModel, .availabilityState, .heightSourceText, .helperText, .resolvedHeightText (+7 more)

### Community 23 - "MockSignInUseCase"
Cohesion: 0.10
Nodes (18): SignInUseCase, AppSession, Bool, SignInView, .body, RootView, .body, Content (+10 more)

### Community 24 - "MockUserPreferencesRepository"
Cohesion: 0.17
Nodes (6): Bool, Double, UserPreferencesUseCaseImpl, MockUserPreferencesRepository, Double, UserPreferencesUseCaseTests

### Community 25 - "Testing"
Cohesion: 0.10
Nodes (4): DataLayer, DomainLayer, PresentationLayer, Testing

### Community 26 - "HealthKitPermissionViewModel"
Cohesion: 0.12
Nodes (12): HealthKitUseCase, .body, .permissionView, HealthKitPermissionViewModel, .defaultErrorMessage, .deniedMessage, Bool, HealthKitPermissionViewModelTests (+4 more)

### Community 27 - "SpyRoutineUseCase"
Cohesion: 0.15
Nodes (11): ProfileRoutineViewModelTests, SpyDrinkWaterUseCase, .currentWaterIntakeML, SpyRoutineRecommendationUseCase, SpyRoutineUseCase, Calendar, Date, DateInterval (+3 more)

### Community 28 - "LiquidGlassSegmentedControl"
Cohesion: 0.09
Nodes (26): AppIntentControlValueProvider, ControlConfigurationIntent, ControlWidget, ControlWidgetConfiguration, Provider, StartTimerIntent, Bool, IntentResult (+18 more)

### Community 29 - "MainIcon"
Cohesion: 0.07
Nodes (15): MainIcon, cloud, .`default`, drop, heart, .id, Self, .description (+7 more)

### Community 30 - "SwiftUI"
Cohesion: 0.10
Nodes (10): AlarmKit, Charts, CryptoKit, DesignSystem, Localization, PresentationLayerShaderBundleToken, StoreKit, SwiftUI (+2 more)

### Community 31 - "HydrationReminderPermissionViewModel"
Cohesion: 0.14
Nodes (10): HydrationReminderUseCase, .primingView, Constant, HydrationReminderPermissionViewModel, Bool, HydrationReminderPermissionViewModelTests, MockHydrationReminderUseCase, Bool (+2 more)

### Community 32 - "MockDrinkWaterRepository"
Cohesion: 0.14
Nodes (11): DrinkWaterUseCaseImpl, .currentWaterIntakeML, Date, DateInterval, Double, DrinkWaterUseCaseTests, MockDrinkWaterRepository, .currentWaterIntakeML (+3 more)

### Community 33 - "ChallengeViewModel"
Cohesion: 0.14
Nodes (13): HydrationChallenge, .id, ChallengeUseCase, PersonalizedChallengeUseCase, ChallengeCardModel, ChallengeHistoryCardModel, ChallengeViewModel, Bool (+5 more)

### Community 34 - "DrinkWaterRepository"
Cohesion: 0.10
Nodes (13): DrinkWaterRepository, UserPreferencesRepository, RoutineUseCase, HydrationNextActionGuideUseCaseImpl, Calendar, Date, HydrationRoutineAdherenceUseCaseImpl, Calendar (+5 more)

### Community 35 - "MockRoutineRepository"
Cohesion: 0.12
Nodes (10): RoutineRepository, RoutineUseCaseImpl, MockRoutineRepository, Error, Result, RoutineRecommendationUseCaseTests, Calendar, Date (+2 more)

### Community 36 - "MockHydrationReminderRepository"
Cohesion: 0.14
Nodes (8): HydrationReminderRepository, HydrationReminderUseCaseImpl, Bool, HydrationReminderUseCaseTests, MockHydrationReminderRepository, Bool, Error, Result

### Community 37 - "PersonalizedHydrationChallenge"
Cohesion: 0.10
Nodes (16): HydrationChallengeRecommendationSource, recentRecords, routine, PersonalizedHydrationChallenge, .id, PersonalizedHydrationChallengeKind, consistencyDefender, dailyGoalBooster (+8 more)

### Community 38 - "AppCoordinator"
Cohesion: 0.08
Nodes (13): AnyObject, FullScreenRoute, AppCoordinator, DeepLinkHandling, FullScreenRouting, SheetRouting, StackRouting, .hasPath (+5 more)

### Community 39 - "HydrationChallengeBadgeHistory"
Cohesion: 0.16
Nodes (11): HydrationChallengeBadgeHistory, Date, Bool, ChallengeUseCaseTests, Calendar, Int, MockChallengeRepository, MockHydrationProgressUseCase (+3 more)

### Community 40 - "ProfileRoutineViewModel"
Cohesion: 0.13
Nodes (18): ProfileRoutineViewModel, .activeRoutineCount, .canSaveDraft, .displayedRoutines, .editorPermissionGuidance, .guidanceSummary, .hasConfiguredRoutine, .isEditingDraft (+10 more)

### Community 41 - "HydrationRoutine"
Cohesion: 0.10
Nodes (9): Int, UUID, HydrationRoutine, .nextActionSchedule, Bool, Bool, .timeText, .weekdayText (+1 more)

### Community 42 - "AnalyticsRepository"
Cohesion: 0.09
Nodes (10): PostHogAnalyticsRepository, DrinkWaterApp, .body, Scene, AnalyticsRepository, NoOpAnalyticsRepository, AnalyticsUseCaseImpl, AnalyticsRepositoryOverrideAssembly (+2 more)

### Community 43 - "HydrationReminderRepositoryImpl"
Cohesion: 0.14
Nodes (9): HydrationReminderNotificationDataSource, HydrationReminderStorageDataSource, HydrationReminderRepositoryImpl, Bool, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource, Bool (+1 more)

### Community 44 - "RoutineRepositoryImpl"
Cohesion: 0.21
Nodes (9): RoutineNotificationDataSource, RoutineStorageDataSource, RoutineRepositoryImpl, Bool, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource, SpyRoutineStorageDataSource, Result (+1 more)

### Community 45 - "ProfileRoutineView"
Cohesion: 0.13
Nodes (19): ProfileRoutineView, .guidanceCard, RoutineGuidanceMetric, RoutineGuidanceSlot, RoutineGuidanceSlotStatus, elapsed, next, upcoming (+11 more)

### Community 46 - "ChallengeUseCaseImpl"
Cohesion: 0.21
Nodes (9): ChallengeRepository, HydrationProgressUseCase, ChallengeEvaluation, ChallengeMergeResult, ChallengeUseCaseImpl, Calendar, Date, Double (+1 more)

### Community 47 - "DIContainer"
Cohesion: 0.12
Nodes (12): Assembler, Assembly, DIContainer, .resolver, PreviewAssembly, DataAssembly, DomainAssembly, PresentationAssembly (+4 more)

### Community 48 - "UserDefaults"
Cohesion: 0.10
Nodes (15): HydrationReminderStorageDataSourceImpl, Bool, RoutineStorageDataSourceImpl, Container, Bool, Double, Int, UserDefaults (+7 more)

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.10
Nodes (8): HydrationReminderAuthorizationStatus, authorized, denied, notDetermined, .analyticsValue, MockHydrationReminderUseCaseForTesting, Bool, UNAuthorizationStatus

### Community 50 - "AppRoute"
Cohesion: 0.10
Nodes (18): AppRoute, hydrationLogging, .id, .presentationStyle, profileRoutine, profileRoutineAction, setting, NavigationPresentationStyle (+10 more)

### Community 51 - "HydrationReminderSlot"
Cohesion: 0.13
Nodes (13): Constant, HydrationReminderNotificationDataSourceImpl, .notificationCenter, Int, Set, UNUserNotificationCenter, HydrationReminderSlot, afternoon (+5 more)

### Community 52 - "HydrationGoalRecommendationCard"
Cohesion: 0.15
Nodes (10): .body, BodyProfileSettingView, .body, .healthSyncCard, .summaryCard, HydrationGoalRecommendationCard, .body, .content (+2 more)

### Community 53 - "RoutineRecoveryReminderAction"
Cohesion: 0.13
Nodes (13): Bool, HydrationInsightEmptyAction, dailyGoal, record, routine, HydrationWeeklyCoachingAction, dailyGoal, none (+5 more)

### Community 54 - "HealthKitDataSourceImpl"
Cohesion: 0.11
Nodes (12): HKAuthorizationStatus, HKHealthStore, HKQuantityTypeIdentifier, HKUnit, Constant, HealthKitDataSourceImpl, .authorizationStatus, .healthKitAuthorizationStatus (+4 more)

### Community 55 - "HydrationGoalRecommendationViewModel"
Cohesion: 0.13
Nodes (16): HydrationGoalRecommendationUseCase, DailyLimitSettingView, .body, EntryDestination, bodyProfileSetting, dailyLimitSetting, GoalAlignment, aboveGoal (+8 more)

### Community 56 - "RoutineRecommendationUseCaseImpl"
Cohesion: 0.27
Nodes (8): DaySummary, RoutineRecommendationUseCaseImpl, Bool, Calendar, Date, DateInterval, Double, Int

### Community 57 - "WidgetKit"
Cohesion: 0.11
Nodes (5): ActivityKit, AppIntents, DependencyInjection, PostHog, WidgetKit

### Community 58 - "OnboardingView"
Cohesion: 0.14
Nodes (15): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+7 more)

### Community 59 - ".body"
Cohesion: 0.15
Nodes (4): .body, .permissionSection, RoutineEditorView, .body

### Community 60 - "DrinkWaterEntry"
Cohesion: 0.12
Nodes (20): DrinkWaterLockScreenWidgetEntryView, .accentColor, .body, .circularView, .inlineView, .rectangularView, DrinkWaterWidgetEntryView, .accentColor (+12 more)

### Community 61 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.19
Nodes (9): HydrationGoalRecommendationRepository, BodyProfileUseCase, Constants, HydrationGoalRecommendationUseCaseImpl, Calendar, Date, DateInterval, Int (+1 more)

### Community 62 - "HydrationNextActionGuide"
Cohesion: 0.18
Nodes (14): Constants, HydrationNextActionGuide, .progress, HydrationNextActionGuideState, approachingRoutine, goalReached, needsGoal, readyToDrink (+6 more)

### Community 63 - ".makeUseCase"
Cohesion: 0.24
Nodes (8): AppReviewRequestUseCaseTests, .calendar, .referenceDate, Bool, Calendar, Date, Double, Int

### Community 64 - "LogWaterAppIntent"
Cohesion: 0.17
Nodes (13): AppIntent, IntentDialog, IntentModes, Constant, FailureReason, LogWaterAppIntent, .resolvedVolumeML, Bool (+5 more)

### Community 65 - "ProjectDescription"
Cohesion: 0.15
Nodes (5): PackageDescription, Plist, ProjectDescription, ProjectDescriptionHelpers, AppVersion

### Community 66 - "Test"
Cohesion: 0.12
Nodes (19): WidgetConfiguration, Test, Widget, TestBundle, .body, WidgetConfiguration, TestLiveActivity, .body (+11 more)

### Community 67 - "RoutineWeekday"
Cohesion: 0.11
Nodes (16): .localeWeekday, Locale, RoutineWeekday, .displayOrder, friday, .id, monday, saturday (+8 more)

### Community 68 - "RoutineNotificationAuthorizationStatus"
Cohesion: 0.12
Nodes (7): RoutineNotificationAuthorizationStatus, authorized, denied, notDetermined, MockRoutineUseCase, Error, Result

### Community 69 - "PersonalizedChallengeUseCaseImpl"
Cohesion: 0.22
Nodes (9): HydrationChallengeTier, beginner, steady, stretch, Constants, PersonalizedChallengeUseCaseImpl, Calendar, Date (+1 more)

### Community 70 - "Test.swift"
Cohesion: 0.18
Nodes (14): AppIntentTimelineProvider, ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, ConfigurationAppIntent, Context (+6 more)

### Community 71 - "BodyProfile"
Cohesion: 0.12
Nodes (5): BodyProfile, .isComplete, .isEmpty, Bool, MockHealthKitUseCase

### Community 72 - "RoutineNotificationDataSourceImpl"
Cohesion: 0.18
Nodes (8): Alarm, AlarmManager, AlarmMetadata, AlarmPresentation, Constant, RoutineAlarmMetadata, RoutineNotificationDataSourceImpl, LocalizedStringResource

### Community 73 - "HydrationServingPreset"
Cohesion: 0.16
Nodes (13): CaseIterable, HydrationServing, .additionalPresets, HydrationServingPreset, bottle, .id, tumbler, .volumeML (+5 more)

### Community 74 - "FoundationModelsHydrationGoalRecommendationDataSource"
Cohesion: 0.16
Nodes (8): Constants, FoundationModelsHydrationGoalRecommendationDataSource, GeneratedHydrationGoalRecommendation, HydrationGoalRecommendationDataSource, Int, Locale, HydrationGoalRecommendationRepositoryImpl, SystemLanguageModel

### Community 75 - "UserPreferencesDataSourceImpl"
Cohesion: 0.18
Nodes (5): Constants, Bool, Double, NSUbiquitousKeyValueStore, UserPreferencesDataSourceImpl

### Community 76 - "WatchHydrationSnapshot"
Cohesion: 0.14
Nodes (12): WatchHydrationMutationResult, Bool, Date, Double, Int, Self, WatchHydrationSnapshot, .eventCount (+4 more)

### Community 77 - "HydrationRoutineRecommendation"
Cohesion: 0.16
Nodes (11): HydrationRoutineRecommendation, .id, RoutineRecommendationUseCase, .timeText, .weekdayText, MockRoutineRecommendationUseCase, Calendar, Date (+3 more)

### Community 78 - "AppReviewRequestUseCaseImpl"
Cohesion: 0.25
Nodes (9): AppReviewRequestRepository, AppReviewRequestUseCaseImpl, Policy, Bool, Calendar, Date, DateInterval, Double (+1 more)

### Community 79 - "HydrationProgressUseCaseImpl"
Cohesion: 0.39
Nodes (7): HydrationProgressUseCaseImpl, StreakProgress, Calendar, Date, DateInterval, Double, Int

### Community 80 - ".loadChallenges"
Cohesion: 0.28
Nodes (8): ChallengeViewModelTests, Calendar, MockChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCase, Calendar, Date

### Community 81 - ".makeViewModel"
Cohesion: 0.32
Nodes (5): MockHydrationGoalRecommendationUseCase, MockHydrationProgressUseCase, HydrationGoalRecommendationViewModelTests, Double, Int

### Community 82 - "AppReviewRequestState"
Cohesion: 0.20
Nodes (6): AppReviewRequestStorageDataSource, AppReviewRequestRepositoryImpl, AppReviewRequestState, Date, Set, MockAppReviewRequestRepository

### Community 83 - "BodyProfileAvailability"
Cohesion: 0.13
Nodes (12): BodyProfileAvailability, incomplete, needsPermission, noData, permissionDenied, ready, State, bodyProfileRequired (+4 more)

### Community 84 - "OnboardingViewModel"
Cohesion: 0.23
Nodes (5): OnboardingViewModel, .canGoBack, .isLastPage, Bool, OnboardingViewModelTests

### Community 85 - "MockUserPreferencesUseCaseForTesting"
Cohesion: 0.16
Nodes (3): MockUserPreferencesUseCaseForTesting, Bool, Double

### Community 86 - ".makeRootView"
Cohesion: 0.14
Nodes (10): AnyView, App, MulimiWatchApp, .body, Scene, WatchDIContainer, WatchDataLayer, WatchDependencyInjection (+2 more)

### Community 87 - "AGENTS.md Onboarding Map"
Cohesion: 0.21
Nodes (14): Quality Gates, Truthful Validation Reporting, Validation Baseline, Validation Matrix, architecture-boundary, Automated Lint Fix Loop, lint-fix-loop, Lightweight Gate (+6 more)

### Community 88 - "TokenProperty"
Cohesion: 0.18
Nodes (8): KeyChainDataSourceImpl, Bool, TokenProperty, accessToken, email, nickname, refreshToken, userIdentifier

### Community 89 - ".make"
Cohesion: 0.23
Nodes (7): HydrationNextActionGuideUseCase, MockHydrationNextActionGuideUseCase, MockHydrationNextActionGuideUseCaseForTesting, DrinkWaterWidgetProvider, ConfigurationAppIntent, Context, Timeline

### Community 90 - "AppDelegate"
Cohesion: 0.19
Nodes (10): AppDelegate, Any, Bool, UNUserNotificationCenter, UIApplication, UIApplicationDelegate, UNNotification, UNNotificationPresentationOptions (+2 more)

### Community 91 - "UserPreferencesRepositoryImpl"
Cohesion: 0.19
Nodes (4): UserPreferencesDataSource, Bool, Double, UserPreferencesRepositoryImpl

### Community 92 - "WatchHydrationHealthKitDataSource"
Cohesion: 0.26
Nodes (7): Constants, Calendar, Date, DateInterval, Error, Int, WatchHydrationHealthKitDataSource

### Community 93 - "HydrationRoutineRecommendationKind"
Cohesion: 0.18
Nodes (6): HydrationRoutineRecommendationKind, afternoonGap, frequentHydrationWindow, morningStart, .recommendationCards, RoutineRecommendationCard

### Community 94 - "WatchHydrationUseCaseImpl"
Cohesion: 0.31
Nodes (6): WatchDailyGoalRepository, WatchHydrationRepository, Date, Double, Int, WatchHydrationUseCaseImpl

### Community 95 - ".assemble"
Cohesion: 0.15
Nodes (7): MockChallengeUseCaseForTesting, Calendar, Date, MockPersonalizedChallengeUseCaseForTesting, Calendar, Date, Container

### Community 96 - "Data Boundary"
Cohesion: 0.17
Nodes (12): Data Boundary, Health Data Minimization, CloudKit-Backed Hydration Store, Local-Only Store Fallback, SwiftData and CloudKit Sync Strategy, Idempotent Hydration Migration, Hydration Migration Flow, UserDefaults to SwiftData Migration (+4 more)

### Community 97 - "AnalyticsUseCase"
Cohesion: 0.18
Nodes (3): AnalyticsUseCase, NoOpAnalyticsUseCase, MockAnalyticsUseCase

### Community 98 - ".routineAnchorRecommendation"
Cohesion: 0.38
Nodes (5): PersonalizedChallengeUseCaseTests, Calendar, Date, Double, Int

### Community 99 - "SpyUserPreferencesUseCase"
Cohesion: 0.21
Nodes (3): SpyUserPreferencesUseCase, Bool, Double

### Community 100 - "LogWaterAmountOption"
Cohesion: 0.18
Nodes (11): AppEnum, DisplayRepresentation, LogWaterAmountOption, bottle, custom, glass, .presetID, .servingType (+3 more)

### Community 101 - "Reliability Recovery"
Cohesion: 0.22
Nodes (11): Goal Mirror Recovery Policy, HealthKit Source of Truth, Recovery Principles, Reliability Recovery, Routine Schedule Recovery, Shared Hydration Rules, HealthKit Data Flow, healthkit-flow (+3 more)

### Community 102 - "WatchDailyGoalUserDefaultsDataSource"
Cohesion: 0.25
Nodes (6): Int, NSUbiquitousKeyValueStore, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, Int, WatchDailyGoalRepositoryImpl

### Community 103 - "WaterDropView"
Cohesion: 0.29
Nodes (8): CGFloat, CGSize, TimeInterval, WaterDropView, .body, .dropBackground, .dropHighlights, .dropSymbol

### Community 104 - "RoutineEditorDraft"
Cohesion: 0.31
Nodes (7): .weekdayGrid, RoutineEditorDraft, .canSave, .isEditing, Bool, Date, Set

### Community 105 - "MockHydrationReminderUseCase"
Cohesion: 0.22
Nodes (4): MockHydrationReminderUseCase, Bool, Error, Result

### Community 106 - "WaterWaveView"
Cohesion: 0.24
Nodes (7): CGPoint, CGRect, Path, CGFloat, WaterWaveView, .animatableData, Shape

### Community 108 - "DrinkWaterHealthKitDataSource.swift"
Cohesion: 0.22
Nodes (3): HealthKit, OSLog, WatchDomainLayerInterface

### Community 109 - "ConfigurationAppIntent"
Cohesion: 0.22
Nodes (9): IntentDescription, ConfigurationAppIntent, .description, .title, LocalizedStringResource, ConfigurationAppIntent, IntentResult, LocalizedStringResource (+1 more)

### Community 110 - "MockError"
Cohesion: 0.20
Nodes (10): LocalizedError, MockError, .errorDescription, signInFailed, MockError, .errorDescription, failed, MockError (+2 more)

### Community 111 - "AuthTokens"
Cohesion: 0.31
Nodes (4): AuthenticationNetworkDataSource, AuthenticationNetworkDataSourceImpl, AuthTokens, Int

### Community 112 - "SettingMenu"
Cohesion: 0.22
Nodes (8): SettingMenu, bodyProfile, dailyLimit, .id, mainIcon, withdrawal, Self, SettingDetailView

### Community 113 - ".shouldRequestAfterSuccessfulHydrationRecord"
Cohesion: 0.28
Nodes (5): NoOpAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 114 - "HydrationInsightCategory"
Cohesion: 0.22
Nodes (9): HydrationInsightCategory, .id, overview, pattern, report, routine, .systemImage, .title (+1 more)

### Community 115 - "Security And Privacy Operations"
Cohesion: 0.25
Nodes (8): Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling, PostHog Privacy Controls, Privacy Impact Review, Security And Privacy Operations

### Community 116 - "Mulimi"
Cohesion: 0.29
Nodes (8): Clean Architecture and MVVM, Domain Purity, ViewModel Side Effect Boundary, navigation-coordinator, Root Navigation, Modular Clean Architecture, Mulimi, Root App Flow

### Community 119 - "WatchHydrationRepositoryImpl"
Cohesion: 0.36
Nodes (4): WatchHydrationLocalDataSource, Date, Int, WatchHydrationRepositoryImpl

### Community 120 - "BodyProfileValue"
Cohesion: 0.36
Nodes (5): BodyProfileSource, healthKit, manual, BodyProfileValue, Double

### Community 121 - ".progressSnapshot"
Cohesion: 0.39
Nodes (4): HydrationProgressUseCaseTests, Calendar, Date, Int

### Community 122 - "ChallengeCategory"
Cohesion: 0.25
Nodes (8): ChallengeCategory, completed, .id, inProgress, recommended, .systemImage, .title, Self

### Community 123 - ".resolve"
Cohesion: 0.36
Nodes (6): PreviewViews, .challenge, .drinkWater, .hydrationList, .profile, Service

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (7): ActivityAttributes, ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 125 - "HydrationReminderPermissionGateView"
Cohesion: 0.38
Nodes (5): HydrationReminderPermissionGateView, .allowButtonLabel, .benefitCard, .headerSection, Content

### Community 126 - "MockAppReviewRequestUseCase"
Cohesion: 0.48
Nodes (5): MockAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 127 - ".dayKey"
Cohesion: 0.38
Nodes (3): Date, DateInterval, Int

### Community 128 - "LogWaterAppShortcuts"
Cohesion: 0.40
Nodes (6): AppShortcut, AppShortcutsProvider, LogWaterAppShortcuts, .appShortcuts, .shortcutTileColor, ShortcutTileColor

### Community 129 - "float2"
Cohesion: 0.53
Nodes (5): float2, half4, mulimiWaterDistortion(), mulimiWaterLighting(), mulimiWaveNoise()

### Community 130 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, challenge, drink, history, insight, profile

### Community 131 - ".guide"
Cohesion: 0.27
Nodes (4): Calendar, Date, Calendar, Date

### Community 132 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 133 - "Challenge State Model"
Cohesion: 0.50
Nodes (5): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Legacy Challenge State Migration, Recurring Challenge State

### Community 135 - "AuthProvider"
Cohesion: 0.40
Nodes (4): AuthProvider, apple, google, kakao

### Community 136 - "WatchHydrationEvent"
Cohesion: 0.60
Nodes (3): Date, Int, WatchHydrationEvent

### Community 137 - "BundleAppInfoProvider"
Cohesion: 0.60
Nodes (3): BundleAppInfoProvider, .appBuildNumber, .appVersion

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "Profile Information Architecture"
Cohesion: 0.67
Nodes (4): Goal Recommendation Entry Rules, Profile Information Architecture, Profile Root, Settings Screen

### Community 140 - "HydrationEventModel"
Cohesion: 0.83
Nodes (3): HydrationEventModel, Date, Int

## Ambiguous Edges - Review These
- `HealthKit Source of Truth` → `CloudKit-Backed Hydration Store`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to
- `CloudKit-Backed Hydration Store` → `Current Storage Strategy`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to

## Knowledge Gaps
- **436 isolated node(s):** `.postHogValue`, `glass`, `bottle`, `tumbler`, `custom` (+431 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **14 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `HealthKit Source of Truth` and `CloudKit-Backed Hydration Store`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `Current Storage Strategy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `String` connect `String` to `Sendable`, `MockHealthKitRepository`, `HydrationInsightViewModel`, `HydrationEvent`, `UserCredential`, `DrinkWaterViewModel`, `MockUserPreferencesUseCase`, `.tr`, `BundleAppInfoProvider`, `View`, `RecordCalendarView`, `HydrationWriteResult`, `WatchHydrationViewModel`, `HydrationChallengeKind`, `RoutineActionIntent`, `SettingsViewModel`, `Error`, `Hashable`, `BodyProfileViewModel`, `MockSignInUseCase`, `HealthKitPermissionViewModel`, `LiquidGlassSegmentedControl`, `MainIcon`, `HydrationReminderPermissionViewModel`, `ChallengeViewModel`, `PersonalizedHydrationChallenge`, `HydrationChallengeBadgeHistory`, `ProfileRoutineViewModel`, `HydrationRoutine`, `AnalyticsRepository`, `ProfileRoutineView`, `ChallengeUseCaseImpl`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `AppRoute`, `HydrationReminderSlot`, `HydrationGoalRecommendationCard`, `RoutineRecoveryReminderAction`, `HydrationGoalRecommendationViewModel`, `OnboardingView`, `DrinkWaterEntry`, `HydrationNextActionGuide`, `LogWaterAppIntent`, `ProjectDescription`, `Test`, `RoutineWeekday`, `PersonalizedChallengeUseCaseImpl`, `RoutineNotificationDataSourceImpl`, `HydrationServingPreset`, `FoundationModelsHydrationGoalRecommendationDataSource`, `UserPreferencesDataSourceImpl`, `HydrationRoutineRecommendation`, `AppReviewRequestUseCaseImpl`, `AppReviewRequestState`, `MockUserPreferencesUseCaseForTesting`, `TokenProperty`, `HydrationRoutineRecommendationKind`, `AnalyticsUseCase`, `LogWaterAmountOption`, `RoutineEditorDraft`, `ConfigurationAppIntent`, `MockError`, `AuthTokens`, `SettingMenu`, `.shouldRequestAfterSuccessfulHydrationRecord`, `HydrationInsightCategory`, `AppReviewRequestStorageDataSourceImpl`, `ChallengeStorageDataSourceImpl`, `BodyProfileValue`, `ChallengeCategory`, `ContentState`, `HydrationReminderPermissionGateView`, `MockAppReviewRequestUseCase`, `.dayKey`?**
  _High betweenness centrality (0.249) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `Sendable`, `MockHealthKitRepository`, `HydrationInsightViewModel`, `DIEnvironment`, `UserCredential`, `AuthProvider`, `WatchHydrationEvent`, `.tr`, `HydrationWriteResult`, `String`, `WatchHydrationViewModel`, `HydrationChallengeKind`, `RoutineActionIntent`, `SettingsViewModel`, `Error`, `Hashable`, `BodyProfileViewModel`, `MockSignInUseCase`, `Testing`, `HealthKitPermissionViewModel`, `MainIcon`, `SwiftUI`, `HydrationReminderPermissionViewModel`, `ChallengeViewModel`, `DrinkWaterRepository`, `MockRoutineRepository`, `MockHydrationReminderRepository`, `PersonalizedHydrationChallenge`, `AppCoordinator`, `HydrationChallengeBadgeHistory`, `ProfileRoutineView`, `ChallengeUseCaseImpl`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `HydrationReminderSlot`, `HydrationGoalRecommendationViewModel`, `WidgetKit`, `HydrationGoalRecommendationUseCaseImpl`, `HydrationNextActionGuide`, `RoutineWeekday`, `RoutineNotificationAuthorizationStatus`, `HydrationServingPreset`, `WatchHydrationSnapshot`, `HydrationRoutineRecommendation`, `AppReviewRequestState`, `BodyProfileAvailability`, `TokenProperty`, `HydrationRoutineRecommendationKind`, `WatchHydrationUseCaseImpl`, `WatchDailyGoalUserDefaultsDataSource`, `Observation`, `DrinkWaterHealthKitDataSource.swift`, `AuthTokens`, `.shouldRequestAfterSuccessfulHydrationRecord`, `BodyProfileValue`?**
  _High betweenness centrality (0.095) - this node is a cross-community bridge._
- **Why does `DomainLayerInterface` connect `Foundation` to `MockHealthKitRepository`, `HydrationInsightViewModel`, `UserCredential`, `Hashable`, `BodyProfileViewModel`, `MockUserPreferencesRepository`, `Testing`, `MainIcon`, `SwiftUI`, `AnalyticsRepository`, `ProfileRoutineView`, `DIContainer`, `WidgetKit`, `FoundationModelsHydrationGoalRecommendationDataSource`, `AppReviewRequestState`, `MockUserPreferencesUseCaseForTesting`, `AnalyticsUseCase`, `Observation`, `DrinkWaterHealthKitDataSource.swift`?**
  _High betweenness centrality (0.062) - this node is a cross-community bridge._
- **Are the 31 inferred relationships involving `DrinkWaterViewModel` (e.g. with `.goalText` and `.progressAccessibilityLabel`) actually correct?**
  _`DrinkWaterViewModel` has 31 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.postHogValue`, `glass`, `bottle` to the rest of the system?**
  _436 weakly-connected nodes found - possible documentation gaps or missing edges._