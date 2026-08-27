# Graph Report - Mulimi  (2026-08-26)

## Corpus Check
- 356 files · ~100,018 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 3333 nodes · 8933 edges · 162 communities (150 shown, 12 thin omitted)
- Extraction: 84% EXTRACTED · 16% INFERRED · 0% AMBIGUOUS · INFERRED: 1397 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `16fd983c`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- HydrationRoutineAdherenceInsight
- HydrationRecord
- HydrationDomain
- ProfileRoutineViewModel
- RoutineRepositoryImpl
- HydrationServingPreset
- MockHealthKitRepository
- MockDrinkWaterUseCase
- .tr
- RecordCalendarView
- MockSignInUseCase
- Product Specs Index
- HydrationEvent
- Agent Onboarding Guide
- DrinkWaterViewModel
- WatchHydrationRepositoryImpl
- HydrationChallengeKind
- HealthKitPermissionViewModel
- Color
- SettingsViewModel
- SharedHydrationStoreError
- Hashable
- .body
- MockDrinkWaterRepository
- .tr
- Foundation
- SpyRoutineUseCase
- RoutineUseCaseImpl
- StartTimerIntent
- MainIcon
- CorePresentation
- HydrationReminderPermissionViewModel
- UserCredential
- HydrationChallenge
- DrinkWaterRepository
- HealthKitDataSourceImpl
- HydrationProgressSnapshot
- ChallengeViewModel
- AppCoordinator
- String
- HydrationGoalRecommendationViewModel
- RoutineWeekday
- AnalyticsRepository
- MockHydrationReminderRepository
- HydrationChallengeBadgeHistory
- Sendable
- ProfileRoutineView
- DIContainer
- UserDefaults
- HydrationReminderAuthorizationStatus
- HydrationGoalRecommendationUnavailableReason
- HydrationReminderRepositoryImpl
- HydrationInsightView
- HydrationInsightViewModel
- LiquidGlassSegmentedControl
- BodyProfileViewModel
- HydrationRoutineRecommendation
- HydrationReminderDomain
- ChallengeUseCaseImpl
- HydrationReminderSlot
- DrinkWaterEntry
- RoutineRecoveryReminderAction
- DrinkWaterApp
- RoutineRecommendationUseCaseImpl
- LogWaterAppIntent
- ProjectDescription
- Test
- RoutineEditorDraft
- RoutineNotificationAuthorizationStatus
- UserPreferencesUseCaseImpl
- Test.swift
- BodyProfile
- RoutineNotificationDataSourceImpl
- HydrationRecordListViewModel
- FoundationModelsHydrationGoalRecommendationDataSource
- OnboardingView
- View
- DrinkWaterWidgetProvider
- HydrationGoalRecommendationUseCaseImpl
- .makeUseCase
- AppRoute
- .makeViewModel
- WatchHydrationSnapshot
- .assemble
- .loadChallenges
- MockUserPreferencesUseCaseForTesting
- .shouldRequestAfterSuccessfulHydrationRecord
- AGENTS.md Onboarding Map
- Growth Scorecard
- MockUserPreferencesUseCase
- AppDelegate
- WaterWaveView
- AppReviewRequestUseCaseImpl
- BodyProfileUseCaseImpl
- HydrationProgressUseCaseImpl
- AuthTokens
- Data Boundary
- ViewPreviews.swift
- HydrationRoutineAdherenceUseCase
- PersonalizedChallengeUseCaseImpl
- LogWaterAmountOption
- Reliability Recovery
- AppReviewRequestState
- HealthKitAuthorizationStatus
- ChallengeCategory
- MockHydrationReminderUseCase
- WaterDropView
- TokenProperty
- DrinkWaterHealthKitDataSource.swift
- ConfigurationAppIntent
- SettingsViewModelTests
- DrinkWaterRepositoryImpl
- HydrationRoutineSchedule
- WatchHydrationUseCaseImpl
- WatchHydrationViewModel
- Security And Privacy Operations
- Mulimi
- UserPreferencesDataSourceImpl
- SettingMenu
- MockHealthKitUseCase
- MockUserPreferencesRepository
- WatchHydrationHealthKitDataSource
- HydrationReminderPermissionGateView
- .resolve
- ContentState
- AnalyticsUseCaseImpl
- Error
- BundleAppInfoProvider
- LogWaterAppShortcuts
- float2
- AppTab
- HydrationNextActionGuide
- DIEnvironment
- Challenge State Model
- Q: 지금 layer 로 모듈 나눠져있는거 feature 별로 나눌 수 있나 feature 별로 data/domain/presentation 모듈이 나눠지는거지
- UserPreferencesRepositoryImpl
- WatchDailyGoalUserDefaultsDataSource
- SpyUserPreferencesUseCase
- Accessibility and Dynamic Type Audit
- Profile Information Architecture
- HydrationRoutine
- ci_post_clone.sh
- pre-commit
- MockAppReviewRequestUseCase
- ChallengeStorageDataSourceImpl
- HydrationInsightCategory
- .guideCombinesRemainingServingAndNextRoutine
- check-architecture.sh
- AppReviewRequestStorageDataSourceImpl
- lint.sh
- lint-fix.sh
- .progressSnapshot
- MockAnalyticsUseCase
- .dayKey
- DrinkWaterWidgetEntryView
- Q: account challenge core domain hydration presentation routine watch
- Q: 아니 작업해달라고요
- AuthProvider
- .setOnboardingCompletion
- AnalyticsUseCase
- Equatable
- WatchDataConstants.swift

## God Nodes (most connected - your core abstractions)
1. `HydrationDomain` - 107 edges
2. `DrinkWaterViewModel` - 102 edges
3. `AccountDomain` - 96 edges
4. `HydrationRoutine` - 96 edges
5. `HydrationInsightViewModel` - 95 edges
6. `ProfileRoutineViewModel` - 74 edges
7. `CoreDomain` - 71 edges
8. `RoutineDomain` - 71 edges
9. `HydrationEvent` - 69 edges
10. `MockDrinkWaterUseCase` - 63 edges

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
- **Delivery and Review Contract** — docs_delivery_workflow_git_flow_delivery, _github_pull_request_template_pull_request_template, _github_workflows_ai_pr_review_git_flow_pr_filter [EXTRACTED 1.00]
- **Exec Plan Lifecycle** — docs_exec_plans_active_readme_active_exec_plans, docs_exec_plans_active_readme_active_plan_lifecycle, docs_exec_plans_completed_readme_completion_archive [EXTRACTED 1.00]
- **Hydration Logging Reminder Routine and Challenge Habit Loop** — docs_product_specs_hydration_logging_multi_surface_consistency, docs_product_specs_hydration_reminder_priming_daily_nudge_schedule, docs_product_specs_routine_notifications_transactional_schedule_commit, docs_personalized_challenge_strategy_recommendation_candidates, docs_product_specs_challenge_insight_routine_adherence_insight [INFERRED 0.85]
- **Repository Validation Pipeline** — docs_quality_gates_validation_baseline, docs_skills_lint_fix_loop_automated_lint_fix_loop, docs_skills_xcode_build_test_validation_order, docs_xcode_cloud_release_build_release_build_workflow [INFERRED 0.85]
- **Analytics Contract Measurement and Experiment Lifecycle** — docs_product_specs_analytics_events_event_contract, docs_product_specs_analytics_operations_core_funnel, docs_product_specs_onboarding_healthkit_conversion_experiments_baseline_conversion_funnel, docs_product_specs_sign_in_onboarding_healthkit_permission_recovery [INFERRED 0.95]
- **Architecture Guardrail Pipeline** — agents_default_validation, _github_workflows_lint_ci_architecture_gate, _swiftlint_swiftlint_configuration, architecture_dependency_direction [INFERRED 0.95]
- **Canonical Health Data Boundary** — docs_reliability_recovery_healthkit_source_of_truth, docs_security_privacy_health_data_minimization, docs_skills_healthkit_flow_healthkit_data_flow, readme_current_storage_strategy [INFERRED 0.95]
- **Cross-Target Hydration Policy** — docs_reliability_recovery_shared_hydration_rules, docs_skills_widget_watch_integration_cross_target_hydration_consistency, docs_skills_healthkit_flow_storage_policy, readme_current_storage_strategy [INFERRED 0.95]
- **Documentation Harness and Execution Lifecycle** — docs_harness_engineering_documentation_ssot_map, docs_index_document_maintenance_rule, docs_product_specs_index_spec_update_rule, docs_exec_plans_template_exec_plan_lifecycle, docs_exec_plans_tech_debt_tracker_documentation_role_debt [INFERRED 0.95]

## Communities (162 total, 12 thin omitted)

### Community 0 - "HydrationRoutineAdherenceInsight"
Cohesion: 0.10
Nodes (32): CandidateMatch, Constants, HydrationRoutineAdherenceEvent, HydrationRoutineAdherenceInsight, .adherenceRate, .bestRoutine, .bestTimeSlot, .hasDueOccurrences (+24 more)

### Community 1 - "HydrationRecord"
Cohesion: 0.11
Nodes (10): HydrationRecord, Date, Double, HydrationRecordRow, .body, .dateString, Date, MockHealthKitUseCaseForTesting (+2 more)

### Community 2 - "HydrationDomain"
Cohesion: 0.11
Nodes (4): ChallengeDomain, CoreDomain, HydrationDomain, RoutineDomain

### Community 3 - "ProfileRoutineViewModel"
Cohesion: 0.13
Nodes (18): ProfileRoutineViewModel, .activeRoutineCount, .canSaveDraft, .displayedRoutines, .editorPermissionGuidance, .guidanceSummary, .hasConfiguredRoutine, .isEditingDraft (+10 more)

### Community 4 - "RoutineRepositoryImpl"
Cohesion: 0.21
Nodes (9): RoutineNotificationDataSource, RoutineStorageDataSource, RoutineRepositoryImpl, Bool, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource, SpyRoutineStorageDataSource, Result (+1 more)

### Community 5 - "HydrationServingPreset"
Cohesion: 0.14
Nodes (14): CaseIterable, HydrationServing, .additionalPresets, HydrationServingPreset, bottle, .id, tumbler, .volumeML (+6 more)

### Community 6 - "MockHealthKitRepository"
Cohesion: 0.13
Nodes (6): HealthKitUseCaseImpl, .authorisationStatus, Date, HealthKitUseCaseTests, MockHealthKitRepository, .authorisationStatus

### Community 7 - "MockDrinkWaterUseCase"
Cohesion: 0.14
Nodes (16): Never, StaticAppInfoProvider, NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, MockDrinkWaterUseCase, .currentWaterIntakeML (+8 more)

### Community 8 - ".tr"
Cohesion: 0.07
Nodes (38): Bundle, HealthKitPermissionGateView, .accessCard, .descriptionText, .footnoteText, .headerColor, .headerSection, .headerSystemImage (+30 more)

### Community 9 - "RecordCalendarView"
Cohesion: 0.06
Nodes (44): Binding, CalendarDayView, .accessibilityLabel, .backgroundColor, .body, .borderColor, .dayNumber, .progressPercentage (+36 more)

### Community 10 - "MockSignInUseCase"
Cohesion: 0.11
Nodes (17): RootView, .body, Content, SignInUseCase, SignInView, .body, AuthenticationViewModel, .isAuthenticated (+9 more)

### Community 11 - "Product Specs Index"
Cohesion: 0.08
Nodes (46): Documentation Role Separation Debt, PostHog Analytics Consolidation, Tech Debt Tracker, Exec Plan Lifecycle, Exec Plan Template, Local GitHub Actions and Xcode Cloud Harness, Documentation SSOT Map, Harness Engineering Structure (+38 more)

### Community 12 - "HydrationEvent"
Cohesion: 0.05
Nodes (32): .analyticsFailureReason, HydrationEvent, Bool, Date, Int, HydrationWriteResult, failure, .failureReason (+24 more)

### Community 13 - "Agent Onboarding Guide"
Cohesion: 0.06
Nodes (44): Local Validation Reporting, Mulimi Pull Request Template, PR Review Checklist, AI PR Review Workflow, Architecture Review Policy, Bounded AI Review Diff, Git Flow PR Filter, Textual Diff Selection (+36 more)

### Community 14 - "DrinkWaterViewModel"
Cohesion: 0.06
Nodes (30): HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, AppReviewRequestUseCase, DrinkWaterUseCase, .body, CustomHydrationAmountValidation (+22 more)

### Community 15 - "WatchHydrationRepositoryImpl"
Cohesion: 0.27
Nodes (5): AnyView, WatchHydrationLocalDataSource, Date, Int, WatchHydrationRepositoryImpl

### Community 16 - "HydrationChallengeKind"
Cohesion: 0.07
Nodes (40): Codable, HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType, streak7, weeklyAchievement80 (+32 more)

### Community 17 - "HealthKitPermissionViewModel"
Cohesion: 0.12
Nodes (11): HealthKitUseCase, .body, HealthKitPermissionViewModel, .defaultErrorMessage, .deniedMessage, Bool, HealthKitPermissionViewModelTests, MockHealthKitUseCase (+3 more)

### Community 18 - "Color"
Cohesion: 0.09
Nodes (30): ChallengeBadge, .body, ChallengeCard, .accentColor, .body, .cardBackground, ChallengeHistoryCard, .accentColor (+22 more)

### Community 19 - "SettingsViewModel"
Cohesion: 0.14
Nodes (11): .body, MainIconSettingView, .body, SettingDetailView, .body, WithdrawalSettingView, .body, SettingsViewModel (+3 more)

### Community 20 - "SharedHydrationStoreError"
Cohesion: 0.19
Nodes (10): ModelConfiguration, ModelContainer, SharedHydrationStore, .isICloudAccountAvailable, SharedHydrationStoreError, .errorDescription, failedToCreateContainer, missingAppGroupContainer (+2 more)

### Community 21 - "Hashable"
Cohesion: 0.14
Nodes (14): Hashable, HydrationGoalRecommendation, HydrationGoalRecommendationAvailability, bodyProfileRequired, modelUnavailable, ready, HydrationGoalRecommendationInput, Int (+6 more)

### Community 22 - ".body"
Cohesion: 0.17
Nodes (3): .body, RoutineEditorView, .body

### Community 23 - "MockDrinkWaterRepository"
Cohesion: 0.17
Nodes (9): DrinkWaterUseCaseImpl, .currentWaterIntakeML, Bool, Double, DrinkWaterUseCaseTests, MockDrinkWaterRepository, .currentWaterIntakeML, Double (+1 more)

### Community 24 - ".tr"
Cohesion: 0.14
Nodes (19): CVarArg, WatchL10n, Double, Int, WatchMetricRow, .body, WatchNavigationCard, .body (+11 more)

### Community 25 - "Foundation"
Cohesion: 0.07
Nodes (10): AccountData, AccountDomain, ChallengeData, Foundation, FoundationModels, HydrationData, HydrationReminderData, RoutineData (+2 more)

### Community 26 - "SpyRoutineUseCase"
Cohesion: 0.16
Nodes (11): ProfileRoutineViewModelTests, SpyDrinkWaterUseCase, .currentWaterIntakeML, SpyRoutineRecommendationUseCase, SpyRoutineUseCase, Calendar, Date, DateInterval (+3 more)

### Community 27 - "RoutineUseCaseImpl"
Cohesion: 0.20
Nodes (6): RoutineRepository, RoutineUseCaseImpl, RoutineRecommendationUseCaseTests, Calendar, Date, Int

### Community 28 - "StartTimerIntent"
Cohesion: 0.14
Nodes (13): AppIntentControlValueProvider, ControlConfigurationIntent, ControlWidget, ControlWidgetConfiguration, Provider, StartTimerIntent, Bool, IntentResult (+5 more)

### Community 29 - "MainIcon"
Cohesion: 0.12
Nodes (12): MainIcon, cloud, .`default`, drop, heart, .id, Self, .description (+4 more)

### Community 30 - "CorePresentation"
Cohesion: 0.11
Nodes (14): AlarmKit, Charts, CoreGraphics, CorePresentation, CryptoKit, DesignSystem, HydrationPresentation, Localization (+6 more)

### Community 31 - "HydrationReminderPermissionViewModel"
Cohesion: 0.14
Nodes (10): HydrationReminderUseCase, .primingView, Constant, HydrationReminderPermissionViewModel, Bool, HydrationReminderPermissionViewModelTests, MockHydrationReminderUseCase, Bool (+2 more)

### Community 32 - "UserCredential"
Cohesion: 0.05
Nodes (27): ASAuthorization, ASAuthorizationController, ASAuthorizationControllerDelegate, AuthenticationServices, NSObject, AppleSignInCredential, AppleSignInDataSource, AppleSignInDataSourceImpl (+19 more)

### Community 33 - "HydrationChallenge"
Cohesion: 0.16
Nodes (7): HydrationChallenge, .id, Int, Calendar, Date, Calendar, Date

### Community 34 - "DrinkWaterRepository"
Cohesion: 0.13
Nodes (11): UserPreferencesRepository, DrinkWaterRepository, HydrationNextActionGuideUseCaseImpl, Calendar, Date, HydrationRoutineAdherenceUseCaseImpl, Calendar, Date (+3 more)

### Community 35 - "HealthKitDataSourceImpl"
Cohesion: 0.06
Nodes (25): HKAuthorizationStatus, HKHealthStore, HKQuantityTypeIdentifier, HKUnit, DrinkWaterHealthKitDataSource, .currentWaterIntakeML, Bool, Calendar (+17 more)

### Community 36 - "HydrationProgressSnapshot"
Cohesion: 0.20
Nodes (14): MockDrinkWaterUseCase, HydrationProgressSnapshot, Bool, Date, Double, Int, HydrationInsightViewModelTests, SpyRoutineUseCase (+6 more)

### Community 37 - "ChallengeViewModel"
Cohesion: 0.08
Nodes (25): HydrationChallengeRecommendationSource, recentRecords, routine, HydrationChallengeTier, beginner, steady, stretch, PersonalizedHydrationChallenge (+17 more)

### Community 38 - "AppCoordinator"
Cohesion: 0.08
Nodes (13): AnyObject, FullScreenRoute, AppCoordinator, DeepLinkHandling, FullScreenRouting, SheetRouting, StackRouting, .hasPath (+5 more)

### Community 39 - "String"
Cohesion: 0.14
Nodes (14): .postHogValue, Any, AnalyticsParameterName, AnalyticsParameterValue, bool, double, int, string (+6 more)

### Community 40 - "HydrationGoalRecommendationViewModel"
Cohesion: 0.12
Nodes (16): DailyLimitSettingView, .body, HydrationGoalRecommendationUseCase, EntryDestination, bodyProfileSetting, dailyLimitSetting, GoalAlignment, aboveGoal (+8 more)

### Community 41 - "RoutineWeekday"
Cohesion: 0.12
Nodes (16): .localeWeekday, Locale, RoutineWeekday, .displayOrder, friday, .id, monday, saturday (+8 more)

### Community 42 - "AnalyticsRepository"
Cohesion: 0.13
Nodes (7): PostHogAnalyticsRepository, ProductAnalyticsEvent, AnalyticsRepository, NoOpAnalyticsRepository, ProductAnalyticsEvent, AnalyticsRepositoryOverrideAssembly, Container

### Community 43 - "MockHydrationReminderRepository"
Cohesion: 0.13
Nodes (8): HydrationReminderRepository, HydrationReminderUseCaseImpl, Bool, HydrationReminderUseCaseTests, MockHydrationReminderRepository, Bool, Error, Result

### Community 44 - "HydrationChallengeBadgeHistory"
Cohesion: 0.18
Nodes (8): HydrationChallengeBadgeHistory, Date, Bool, ChallengeUseCaseTests, Calendar, Int, MockChallengeRepository, MockChallengeUseCase

### Community 45 - "Sendable"
Cohesion: 0.06
Nodes (26): PersonalizedChallengeUseCase, HydrationProgressUseCase, RoutineRecommendationUseCase, MockHydrationProgressUseCase, Calendar, Date, MockHydrationProgressUseCase, Calendar (+18 more)

### Community 46 - "ProfileRoutineView"
Cohesion: 0.21
Nodes (7): ProfileRoutineView, .guidanceCard, .permissionSection, RoutineGuidanceSlotStatus, elapsed, next, upcoming

### Community 47 - "DIContainer"
Cohesion: 0.15
Nodes (11): Assembler, Assembly, DIContainer, .resolver, Assembly, DataAssembly, DomainAssembly, PresentationAssembly (+3 more)

### Community 48 - "UserDefaults"
Cohesion: 0.10
Nodes (15): HydrationReminderStorageDataSourceImpl, Bool, RoutineStorageDataSourceImpl, Container, Bool, Double, Int, UserDefaults (+7 more)

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.10
Nodes (8): HydrationReminderAuthorizationStatus, authorized, denied, notDetermined, .analyticsValue, ProductAnalyticsEvent, MockHydrationReminderUseCaseForTesting, Bool

### Community 50 - "HydrationGoalRecommendationUnavailableReason"
Cohesion: 0.14
Nodes (11): HydrationGoalRecommendationDataSource, HydrationGoalRecommendationRepositoryImpl, HydrationGoalRecommendationError, bodyProfileRequired, modelUnavailable, HydrationGoalRecommendationUnavailableReason, appleIntelligenceNotEnabled, deviceNotEligible (+3 more)

### Community 51 - "HydrationReminderRepositoryImpl"
Cohesion: 0.18
Nodes (9): HydrationReminderNotificationDataSource, HydrationReminderStorageDataSource, HydrationReminderRepositoryImpl, Bool, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource, Bool (+1 more)

### Community 52 - "HydrationInsightView"
Cohesion: 0.08
Nodes (26): GridItem, BadgeView, .body, HydrationInsightView, .body, .emptyState, .emptyStateCTAButtons, .insightContent (+18 more)

### Community 53 - "HydrationInsightViewModel"
Cohesion: 0.09
Nodes (30): HydrationInsightViewModel, .canRecordRecoveryDrink, .chartUpperBound, .dailyGoalText, .emptyStateCTAs, .metrics, .routineAdherenceInsightText, .routineAdherenceMetrics (+22 more)

### Community 54 - "LiquidGlassSegmentedControl"
Cohesion: 0.22
Nodes (13): Value, .categoryPicker, LiquidGlassSegment, .id, LiquidGlassSegmentedControl, .activeSegmentBackground, .activeSegmentBorder, .body (+5 more)

### Community 55 - "BodyProfileViewModel"
Cohesion: 0.13
Nodes (11): BodyProfileViewModel, .availabilityState, .heightSourceText, .helperText, .resolvedHeightText, .resolvedWeightText, .summaryText, .weightSourceText (+3 more)

### Community 56 - "HydrationRoutineRecommendation"
Cohesion: 0.11
Nodes (14): HydrationRoutineRecommendation, .id, HydrationRoutineRecommendationKind, afternoonGap, frequentHydrationWindow, morningStart, .timeText, .weekdayText (+6 more)

### Community 57 - "HydrationReminderDomain"
Cohesion: 0.10
Nodes (8): AccountPresentation, ChallengePresentation, HydrationReminderDomain, HydrationReminderPresentation, PostHog, HydrationReminderAnalyticsParameterName, PreviewAssembly, Swinject

### Community 58 - "ChallengeUseCaseImpl"
Cohesion: 0.24
Nodes (8): ChallengeRepository, ChallengeEvaluation, ChallengeMergeResult, ChallengeUseCaseImpl, Calendar, Date, Double, Int

### Community 59 - "HydrationReminderSlot"
Cohesion: 0.10
Nodes (14): Constant, HydrationReminderNotificationDataSourceImpl, .notificationCenter, Int, Set, UNUserNotificationCenter, HydrationReminderSlot, afternoon (+6 more)

### Community 60 - "DrinkWaterEntry"
Cohesion: 0.15
Nodes (16): DrinkWaterLockScreenWidgetEntryView, .accentColor, .body, .circularView, .inlineView, .rectangularView, DrinkWaterEntry, .dailyLimitText (+8 more)

### Community 61 - "RoutineRecoveryReminderAction"
Cohesion: 0.14
Nodes (12): HydrationInsightEmptyAction, dailyGoal, record, routine, HydrationWeeklyCoachingAction, dailyGoal, none, routine (+4 more)

### Community 62 - "DrinkWaterApp"
Cohesion: 0.18
Nodes (9): App, DrinkWaterApp, .body, Scene, MulimiWatchApp, .body, Scene, WatchDIContainer (+1 more)

### Community 63 - "RoutineRecommendationUseCaseImpl"
Cohesion: 0.27
Nodes (8): DaySummary, RoutineRecommendationUseCaseImpl, Bool, Calendar, Date, DateInterval, Double, Int

### Community 64 - "LogWaterAppIntent"
Cohesion: 0.17
Nodes (13): AppIntent, IntentDialog, IntentModes, Constant, FailureReason, LogWaterAppIntent, .resolvedVolumeML, Bool (+5 more)

### Community 65 - "ProjectDescription"
Cohesion: 0.13
Nodes (5): PackageDescription, Plist, ProjectDescription, ProjectDescriptionHelpers, AppVersion

### Community 66 - "Test"
Cohesion: 0.14
Nodes (16): WidgetConfiguration, Test, Widget, TestBundle, .body, WidgetConfiguration, TestLiveActivity, .body (+8 more)

### Community 67 - "RoutineEditorDraft"
Cohesion: 0.31
Nodes (7): .weekdayGrid, RoutineEditorDraft, .canSave, .isEditing, Bool, Date, Set

### Community 68 - "RoutineNotificationAuthorizationStatus"
Cohesion: 0.08
Nodes (11): RoutineNotificationAuthorizationStatus, authorized, denied, notDetermined, RoutineUseCaseTests, MockRoutineRepository, Error, Result (+3 more)

### Community 69 - "UserPreferencesUseCaseImpl"
Cohesion: 0.32
Nodes (3): Double, UserPreferencesUseCaseImpl, UserPreferencesUseCaseTests

### Community 70 - "Test.swift"
Cohesion: 0.19
Nodes (13): ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, ConfigurationAppIntent, Context, Date (+5 more)

### Community 71 - "BodyProfile"
Cohesion: 0.09
Nodes (20): BodyProfile, .isComplete, .isEmpty, BodyProfileSource, healthKit, manual, BodyProfileValue, Bool (+12 more)

### Community 72 - "RoutineNotificationDataSourceImpl"
Cohesion: 0.18
Nodes (8): Alarm, AlarmManager, AlarmMetadata, AlarmPresentation, Constant, RoutineAlarmMetadata, RoutineNotificationDataSourceImpl, LocalizedStringResource

### Community 73 - "HydrationRecordListViewModel"
Cohesion: 0.06
Nodes (36): SystemWidgetTimelineReloader, WidgetTimelineReloading, HydrationRecordListView, .body, RowListView, .body, Void, HydrationRecordDaySummary (+28 more)

### Community 74 - "FoundationModelsHydrationGoalRecommendationDataSource"
Cohesion: 0.24
Nodes (6): Constants, FoundationModelsHydrationGoalRecommendationDataSource, GeneratedHydrationGoalRecommendation, Int, Locale, SystemLanguageModel

### Community 75 - "OnboardingView"
Cohesion: 0.14
Nodes (15): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+7 more)

### Community 76 - "View"
Cohesion: 0.12
Nodes (15): BodyProfileSettingView, .healthSyncCard, .summaryCard, HydrationGoalRecommendationCard, .body, .content, Bool, Void (+7 more)

### Community 77 - "DrinkWaterWidgetProvider"
Cohesion: 0.27
Nodes (6): AppIntentTimelineProvider, DrinkWaterWidgetProvider, ConfigurationAppIntent, Context, Date, Timeline

### Community 78 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.17
Nodes (11): HydrationGoalRecommendationRepository, BodyProfileUseCase, Constants, HydrationGoalRecommendationUseCaseImpl, Calendar, Date, DateInterval, Int (+3 more)

### Community 79 - ".makeUseCase"
Cohesion: 0.24
Nodes (8): AppReviewRequestUseCaseTests, .calendar, .referenceDate, Bool, Calendar, Date, Double, Int

### Community 80 - "AppRoute"
Cohesion: 0.08
Nodes (20): ContentView, .body, ProfileView, .body, .goalRecommendationCard, .goalRecommendationRoute, .routineCard, Bool (+12 more)

### Community 81 - ".makeViewModel"
Cohesion: 0.32
Nodes (5): MockHydrationGoalRecommendationUseCase, MockHydrationProgressUseCase, HydrationGoalRecommendationViewModelTests, Double, Int

### Community 82 - "WatchHydrationSnapshot"
Cohesion: 0.12
Nodes (15): Date, Int, WatchHydrationEvent, Bool, Date, Double, Int, Self (+7 more)

### Community 83 - ".assemble"
Cohesion: 0.13
Nodes (10): UserPreferencesUseCase, OnboardingViewModel, .canGoBack, .isLastPage, Bool, OnboardingViewModelTests, MockHydrationNextActionGuideUseCase, Calendar (+2 more)

### Community 84 - ".loadChallenges"
Cohesion: 0.28
Nodes (8): ChallengeViewModelTests, Calendar, MockChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCase, Calendar, Date

### Community 85 - "MockUserPreferencesUseCaseForTesting"
Cohesion: 0.21
Nodes (3): MockUserPreferencesUseCaseForTesting, Bool, Double

### Community 86 - ".shouldRequestAfterSuccessfulHydrationRecord"
Cohesion: 0.28
Nodes (5): NoOpAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 87 - "AGENTS.md Onboarding Map"
Cohesion: 0.21
Nodes (14): Quality Gates, Truthful Validation Reporting, Validation Baseline, Validation Matrix, architecture-boundary, Automated Lint Fix Loop, lint-fix-loop, Lightweight Gate (+6 more)

### Community 88 - "Growth Scorecard"
Cohesion: 0.11
Nodes (17): 72-Hour Audit, Before Release, Cadence And Ownership, Decision Rule, Deferred Scope, Experiment Record, Goal, Growth Scorecard (+9 more)

### Community 89 - "MockUserPreferencesUseCase"
Cohesion: 0.21
Nodes (3): MockUserPreferencesUseCase, Bool, Double

### Community 90 - "AppDelegate"
Cohesion: 0.19
Nodes (10): AppDelegate, Any, Bool, UNUserNotificationCenter, UIApplication, UIApplicationDelegate, UNNotification, UNNotificationPresentationOptions (+2 more)

### Community 91 - "WaterWaveView"
Cohesion: 0.24
Nodes (7): CGPoint, CGRect, Path, CGFloat, WaterWaveView, .animatableData, Shape

### Community 92 - "AppReviewRequestUseCaseImpl"
Cohesion: 0.25
Nodes (9): AppReviewRequestRepository, AppReviewRequestUseCaseImpl, Policy, Bool, Calendar, Date, DateInterval, Double (+1 more)

### Community 93 - "BodyProfileUseCaseImpl"
Cohesion: 0.28
Nodes (3): HealthKitRepository, BodyProfileUseCaseImpl, BodyProfileUseCaseTests

### Community 94 - "HydrationProgressUseCaseImpl"
Cohesion: 0.39
Nodes (7): HydrationProgressUseCaseImpl, StreakProgress, Calendar, Date, DateInterval, Double, Int

### Community 95 - "AuthTokens"
Cohesion: 0.31
Nodes (4): AuthenticationNetworkDataSource, AuthenticationNetworkDataSourceImpl, AuthTokens, Int

### Community 96 - "Data Boundary"
Cohesion: 0.17
Nodes (12): Data Boundary, Health Data Minimization, CloudKit-Backed Hydration Store, Local-Only Store Fallback, SwiftData and CloudKit Sync Strategy, Idempotent Hydration Migration, Hydration Migration Flow, UserDefaults to SwiftData Migration (+4 more)

### Community 97 - "ViewPreviews.swift"
Cohesion: 0.14
Nodes (4): ActivityKit, DependencyInjection, UserNotifications, WidgetKit

### Community 98 - "HydrationRoutineAdherenceUseCase"
Cohesion: 0.20
Nodes (6): Calendar, Sendable, HydrationRoutineAdherenceUseCase, MockHydrationRoutineAdherenceUseCase, Calendar, Date

### Community 99 - "PersonalizedChallengeUseCaseImpl"
Cohesion: 0.18
Nodes (10): Constants, PersonalizedChallengeUseCaseImpl, Calendar, Date, Int, PersonalizedChallengeUseCaseTests, Calendar, Date (+2 more)

### Community 100 - "LogWaterAmountOption"
Cohesion: 0.18
Nodes (11): AppEnum, DisplayRepresentation, LogWaterAmountOption, bottle, custom, glass, .presetID, .servingType (+3 more)

### Community 101 - "Reliability Recovery"
Cohesion: 0.22
Nodes (11): Goal Mirror Recovery Policy, HealthKit Source of Truth, Recovery Principles, Reliability Recovery, Routine Schedule Recovery, Shared Hydration Rules, HealthKit Data Flow, healthkit-flow (+3 more)

### Community 102 - "AppReviewRequestState"
Cohesion: 0.20
Nodes (6): AppReviewRequestStorageDataSource, AppReviewRequestRepositoryImpl, AppReviewRequestState, Date, Set, MockAppReviewRequestRepository

### Community 103 - "HealthKitAuthorizationStatus"
Cohesion: 0.26
Nodes (6): HealthKitAuthorizationStatus, notDetermined, sharingAuthorized, sharingDenied, .analyticsValue, ProductAnalyticsEvent

### Community 104 - "ChallengeCategory"
Cohesion: 0.25
Nodes (8): ChallengeCategory, completed, .id, inProgress, recommended, .systemImage, .title, Self

### Community 105 - "MockHydrationReminderUseCase"
Cohesion: 0.22
Nodes (4): MockHydrationReminderUseCase, Bool, Error, Result

### Community 106 - "WaterDropView"
Cohesion: 0.29
Nodes (8): CGFloat, CGSize, TimeInterval, WaterDropView, .body, .dropBackground, .dropHighlights, .dropSymbol

### Community 107 - "TokenProperty"
Cohesion: 0.18
Nodes (8): KeyChainDataSourceImpl, Bool, TokenProperty, accessToken, email, nickname, refreshToken, userIdentifier

### Community 108 - "DrinkWaterHealthKitDataSource.swift"
Cohesion: 0.18
Nodes (5): HealthKit, OSLog, WatchHydrationData, WatchHydrationDomain, WatchHydrationPresentation

### Community 109 - "ConfigurationAppIntent"
Cohesion: 0.16
Nodes (10): AppIntents, IntentDescription, ConfigurationAppIntent, .description, .title, LocalizedStringResource, ConfigurationAppIntent, IntentResult (+2 more)

### Community 110 - "SettingsViewModelTests"
Cohesion: 0.13
Nodes (14): LocalizedError, MockError, .errorDescription, signInFailed, MockError, deleteFailed, .errorDescription, SettingsViewModelTests (+6 more)

### Community 111 - "DrinkWaterRepositoryImpl"
Cohesion: 0.15
Nodes (8): DrinkWaterDataSource, DrinkWaterRepositoryImpl, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int

### Community 112 - "HydrationRoutineSchedule"
Cohesion: 0.30
Nodes (7): HydrationRoutineSchedule, Bool, Set, HydrationRoutineAdherenceUseCaseTests, Calendar, Date, Int

### Community 113 - "WatchHydrationUseCaseImpl"
Cohesion: 0.27
Nodes (6): WatchHydrationMutationResult, WatchDailyGoalRepository, WatchHydrationRepository, Date, Double, WatchHydrationUseCaseImpl

### Community 114 - "WatchHydrationViewModel"
Cohesion: 0.11
Nodes (15): State, bodyProfileRequired, idle, loading, modelUnavailable, ready, WatchHydrationUseCase, MutationAction (+7 more)

### Community 115 - "Security And Privacy Operations"
Cohesion: 0.25
Nodes (8): Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling, PostHog Privacy Controls, Privacy Impact Review, Security And Privacy Operations

### Community 116 - "Mulimi"
Cohesion: 0.29
Nodes (8): Clean Architecture and MVVM, Domain Purity, ViewModel Side Effect Boundary, navigation-coordinator, Root Navigation, Modular Clean Architecture, Mulimi, Root App Flow

### Community 117 - "UserPreferencesDataSourceImpl"
Cohesion: 0.21
Nodes (5): Constants, Bool, Double, NSUbiquitousKeyValueStore, UserPreferencesDataSourceImpl

### Community 118 - "SettingMenu"
Cohesion: 0.25
Nodes (7): SettingMenu, bodyProfile, dailyLimit, .id, mainIcon, withdrawal, Self

### Community 120 - "MockUserPreferencesRepository"
Cohesion: 0.23
Nodes (3): MockUserPreferencesRepository, Bool, Double

### Community 121 - "WatchHydrationHealthKitDataSource"
Cohesion: 0.26
Nodes (7): Constants, Calendar, Date, DateInterval, Error, Int, WatchHydrationHealthKitDataSource

### Community 122 - "HydrationReminderPermissionGateView"
Cohesion: 0.32
Nodes (6): HydrationReminderPermissionGateView, .allowButtonLabel, .benefitCard, .body, .headerSection, Content

### Community 123 - ".resolve"
Cohesion: 0.43
Nodes (6): PreviewViews, .challenge, .drinkWater, .hydrationList, .profile, Service

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (7): ActivityAttributes, ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 126 - "Error"
Cohesion: 0.07
Nodes (24): Error, AuthenticationError, cancelled, invalidCredential, networkFailed, serverError, unknown, MockSignInError (+16 more)

### Community 127 - "BundleAppInfoProvider"
Cohesion: 0.43
Nodes (4): AppInfoProviding, BundleAppInfoProvider, .appBuildNumber, .appVersion

### Community 128 - "LogWaterAppShortcuts"
Cohesion: 0.40
Nodes (6): AppShortcut, AppShortcutsProvider, LogWaterAppShortcuts, .appShortcuts, .shortcutTileColor, ShortcutTileColor

### Community 129 - "float2"
Cohesion: 0.53
Nodes (5): float2, half4, mulimiWaterDistortion(), mulimiWaterLighting(), mulimiWaveNoise()

### Community 130 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, challenge, drink, history, insight, profile

### Community 131 - "HydrationNextActionGuide"
Cohesion: 0.13
Nodes (18): Constants, HydrationNextActionGuide, .progress, HydrationNextActionGuideState, approachingRoutine, goalReached, needsGoal, readyToDrink (+10 more)

### Community 132 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 133 - "Challenge State Model"
Cohesion: 0.50
Nodes (5): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Legacy Challenge State Migration, Recurring Challenge State

### Community 134 - "Q: 지금 layer 로 모듈 나눠져있는거 feature 별로 나눌 수 있나 feature 별로 data/domain/presentation 모듈이 나눠지는거지"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: 지금 layer 로 모듈 나눠져있는거 feature 별로 나눌 수 있나 feature 별로 data/domain/presentation 모듈이 나눠지는거지, Source Nodes

### Community 135 - "UserPreferencesRepositoryImpl"
Cohesion: 0.24
Nodes (4): UserPreferencesDataSource, Bool, Double, UserPreferencesRepositoryImpl

### Community 136 - "WatchDailyGoalUserDefaultsDataSource"
Cohesion: 0.25
Nodes (6): Int, NSUbiquitousKeyValueStore, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, Int, WatchDailyGoalRepositoryImpl

### Community 137 - "SpyUserPreferencesUseCase"
Cohesion: 0.27
Nodes (3): SpyUserPreferencesUseCase, Bool, Double

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "Profile Information Architecture"
Cohesion: 0.67
Nodes (4): Goal Recommendation Entry Rules, Profile Information Architecture, Profile Root, Settings Screen

### Community 140 - "HydrationRoutine"
Cohesion: 0.10
Nodes (10): Int, UUID, HydrationRoutine, .nextActionSchedule, Bool, .timeText, MockRoutineUseCaseForTesting, HydrationEventModel (+2 more)

### Community 143 - "MockAppReviewRequestUseCase"
Cohesion: 0.48
Nodes (5): MockAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 144 - "ChallengeStorageDataSourceImpl"
Cohesion: 0.29
Nodes (4): ChallengeStorageDataSource, ChallengeStorageDataSourceImpl, ChallengeRepositoryImpl, ChallengeStorageDataSourceTests

### Community 145 - "HydrationInsightCategory"
Cohesion: 0.22
Nodes (9): HydrationInsightCategory, .id, overview, pattern, report, routine, .systemImage, .title (+1 more)

### Community 151 - ".progressSnapshot"
Cohesion: 0.39
Nodes (4): HydrationProgressUseCaseTests, Calendar, Date, Int

### Community 153 - ".dayKey"
Cohesion: 0.38
Nodes (3): Date, DateInterval, Int

### Community 154 - "DrinkWaterWidgetEntryView"
Cohesion: 0.33
Nodes (6): DrinkWaterWidget, .body, DrinkWaterWidgetEntryView, .accentColor, .body, WidgetConfiguration

### Community 155 - "Q: account challenge core domain hydration presentation routine watch"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: account challenge core domain hydration presentation routine watch, Source Nodes

### Community 156 - "Q: 아니 작업해달라고요"
Cohesion: 0.40
Nodes (4): Answer, Outcome, Q: 아니 작업해달라고요, Source Nodes

### Community 157 - "AuthProvider"
Cohesion: 0.40
Nodes (4): AuthProvider, apple, google, kakao

### Community 160 - "AnalyticsUseCase"
Cohesion: 0.40
Nodes (3): AnalyticsUseCase, NoOpAnalyticsUseCase, ProductAnalyticsEvent

### Community 162 - "Equatable"
Cohesion: 0.14
Nodes (23): Equatable, Identifiable, HydrationServingOptionModel, .volumeText, HydrationInsightEmptyCTAModel, HydrationInsightMetric, HydrationWeeklyReportMetric, RoutineAdherenceDisplayRow (+15 more)

## Ambiguous Edges - Review These
- `HealthKit Source of Truth` → `CloudKit-Backed Hydration Store`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to
- `CloudKit-Backed Hydration Store` → `Current Storage Strategy`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to

## Knowledge Gaps
- **459 isolated node(s):** `.postHogValue`, `glass`, `bottle`, `tumbler`, `custom` (+454 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Work-memory lessons

**Preferred sources** — corroborated by past sessions; start here.
- `Layer Responsibilities` (2× useful, score=1.998842619) _(code changed — re-verify)_

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `HealthKit Source of Truth` and `CloudKit-Backed Hydration Store`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `Current Storage Strategy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `String` connect `String` to `HydrationRoutineAdherenceInsight`, `HydrationRecord`, `ProfileRoutineViewModel`, `HydrationServingPreset`, `MockDrinkWaterUseCase`, `.tr`, `RecordCalendarView`, `MockSignInUseCase`, `HydrationEvent`, `DrinkWaterViewModel`, `HydrationChallengeKind`, `HealthKitPermissionViewModel`, `Color`, `SettingsViewModel`, `SharedHydrationStoreError`, `Hashable`, `.tr`, `StartTimerIntent`, `MainIcon`, `HydrationReminderPermissionViewModel`, `UserCredential`, `HydrationChallenge`, `ChallengeViewModel`, `HydrationGoalRecommendationViewModel`, `RoutineWeekday`, `AnalyticsRepository`, `HydrationChallengeBadgeHistory`, `ProfileRoutineView`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `HydrationInsightView`, `HydrationInsightViewModel`, `LiquidGlassSegmentedControl`, `BodyProfileViewModel`, `HydrationRoutineRecommendation`, `ChallengeUseCaseImpl`, `HydrationReminderSlot`, `DrinkWaterEntry`, `RoutineRecoveryReminderAction`, `LogWaterAppIntent`, `ProjectDescription`, `Test`, `RoutineEditorDraft`, `BodyProfile`, `RoutineNotificationDataSourceImpl`, `HydrationRecordListViewModel`, `FoundationModelsHydrationGoalRecommendationDataSource`, `OnboardingView`, `View`, `AppRoute`, `MockUserPreferencesUseCaseForTesting`, `.shouldRequestAfterSuccessfulHydrationRecord`, `MockUserPreferencesUseCase`, `AppReviewRequestUseCaseImpl`, `AuthTokens`, `LogWaterAmountOption`, `AppReviewRequestState`, `HealthKitAuthorizationStatus`, `ChallengeCategory`, `TokenProperty`, `ConfigurationAppIntent`, `SettingsViewModelTests`, `HydrationRoutineSchedule`, `WatchHydrationViewModel`, `UserPreferencesDataSourceImpl`, `SettingMenu`, `HydrationReminderPermissionGateView`, `ContentState`, `AnalyticsUseCaseImpl`, `Error`, `BundleAppInfoProvider`, `HydrationNextActionGuide`, `HydrationRoutine`, `MockAppReviewRequestUseCase`, `ChallengeStorageDataSourceImpl`, `HydrationInsightCategory`, `AppReviewRequestStorageDataSourceImpl`, `MockAnalyticsUseCase`, `.dayKey`, `DrinkWaterWidgetEntryView`, `Equatable`?**
  _High betweenness centrality (0.258) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `HydrationRoutineAdherenceInsight`, `HydrationRecord`, `HydrationDomain`, `HydrationNextActionGuide`, `DIEnvironment`, `HydrationServingPreset`, `WatchDailyGoalUserDefaultsDataSource`, `.tr`, `MockSignInUseCase`, `HydrationEvent`, `DrinkWaterViewModel`, `HydrationChallengeKind`, `HealthKitPermissionViewModel`, `SharedHydrationStoreError`, `Hashable`, `.tr`, `RoutineUseCaseImpl`, `MainIcon`, `CorePresentation`, `AuthProvider`, `UserCredential`, `HydrationReminderPermissionViewModel`, `DrinkWaterRepository`, `HydrationProgressSnapshot`, `ChallengeViewModel`, `AppCoordinator`, `String`, `HydrationGoalRecommendationViewModel`, `MockHydrationReminderRepository`, `HydrationChallengeBadgeHistory`, `Sendable`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `HydrationRoutineRecommendation`, `HydrationReminderDomain`, `ChallengeUseCaseImpl`, `HydrationReminderSlot`, `RoutineNotificationAuthorizationStatus`, `BodyProfile`, `HydrationGoalRecommendationUseCaseImpl`, `AppRoute`, `WatchHydrationSnapshot`, `.assemble`, `.shouldRequestAfterSuccessfulHydrationRecord`, `BodyProfileUseCaseImpl`, `AuthTokens`, `ViewPreviews.swift`, `HydrationRoutineAdherenceUseCase`, `AppReviewRequestState`, `HealthKitAuthorizationStatus`, `TokenProperty`, `DrinkWaterHealthKitDataSource.swift`, `WatchHydrationUseCaseImpl`, `WatchHydrationViewModel`, `Error`, `BundleAppInfoProvider`?**
  _High betweenness centrality (0.064) - this node is a cross-community bridge._
- **Why does `HydrationRoutine` connect `HydrationRoutine` to `HydrationDomain`, `ProfileRoutineViewModel`, `RoutineRepositoryImpl`, `.tr`, `HydrationChallengeKind`, `.guideCombinesRemainingServingAndNextRoutine`, `.body`, `SpyRoutineUseCase`, `RoutineUseCaseImpl`, `Equatable`, `HydrationProgressSnapshot`, `ChallengeViewModel`, `String`, `RoutineWeekday`, `Sendable`, `UserDefaults`, `RoutineRecommendationUseCaseImpl`, `RoutineEditorDraft`, `RoutineNotificationAuthorizationStatus`, `RoutineNotificationDataSourceImpl`, `.loadChallenges`, `PersonalizedChallengeUseCaseImpl`, `HydrationRoutineSchedule`?**
  _High betweenness centrality (0.056) - this node is a cross-community bridge._
- **Are the 31 inferred relationships involving `DrinkWaterViewModel` (e.g. with `.goalText` and `.progressAccessibilityLabel`) actually correct?**
  _`DrinkWaterViewModel` has 31 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.postHogValue`, `glass`, `bottle` to the rest of the system?**
  _459 weakly-connected nodes found - possible documentation gaps or missing edges._