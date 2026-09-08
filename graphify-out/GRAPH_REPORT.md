# Graph Report - Mulimi  (2026-09-08)

## Corpus Check
- 368 files · ~163,681 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 3418 nodes · 9242 edges · 167 communities (158 shown, 9 thin omitted)
- Extraction: 85% EXTRACTED · 15% INFERRED · 0% AMBIGUOUS · INFERRED: 1409 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a01375ad`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- HydrationRoutineAdherenceInsight
- HydrationRecord
- HydrationDomain
- ProfileRoutineViewModel
- HydrationRoutine
- HydrationServing
- MockHealthKitRepository
- MockUserPreferencesUseCase
- .tr
- HydrationRecordListViewModel
- .assemble
- Docs Index
- HydrationEvent
- CI Lint and Architecture Gate
- DrinkWaterViewModel
- RoutineDomain
- HydrationChallengeKind
- HealthKitPermissionViewModel
- Color
- MockDrinkWaterUseCase
- HydrationWriteResult
- BodyProfile
- DrinkWaterRepository
- MockDrinkWaterRepository
- WatchHydrationViewModel
- AccountDomain
- SpyRoutineUseCase
- MockRoutineRepository
- LiquidGlassSegmentedControl
- .assemble
- SwiftUI
- HydrationReminderPermissionViewModel
- UserCredential
- HydrationChallenge
- RecordCalendarView
- HealthKitDataSource
- HydrationProgressSnapshot
- Sendable
- AppCoordinator
- String
- HydrationGoalRecommendationViewModel
- RoutineWeekday
- HealthKitQuantityStore
- MockHydrationReminderRepository
- .makeUseCase
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
- BodyProfileSnapshot
- MockHydrationNextActionGuideUseCase
- Foundation
- HydrationChallengeBadgeHistory
- HydrationReminderSlot
- DrinkWaterEntry
- HealthKitPermissionGateView
- MulimiWatchApp
- BodyProfileViewModel
- LogWaterAppIntent
- ProjectDescription
- AppReviewRequestUseCaseImpl
- ContentView
- Top 5
- MainIcon
- Test.swift
- UUID
- RoutineNotificationAuthorizationStatus
- HydrationRecordDaySummary
- HydrationGoalRecommendation
- OnboardingView
- HydrationGoalRecommendationCard
- BodyProfileUseCaseImpl
- HydrationGoalRecommendationUseCaseImpl
- AppReviewRequestState
- SharedHydrationStoreError
- .makeViewModel
- WatchHydrationSnapshot
- UserPreferencesUseCase
- .loadChallenges
- HydrationGoalRecommendationUnavailableReason
- .shouldRequestAfterSuccessfulHydrationRecord
- AGENTS.md Onboarding Map
- Growth Scorecard
- HydrationRoutineAdherenceUseCase
- AppDelegate
- WaterWaveView
- AnalyticsUseCase
- MockHydrationReminderUseCase
- HydrationProgressUseCaseImpl
- AuthTokens
- Data Boundary
- HydrationPresentation
- FoundationModelsHydrationGoalRecommendationDataSource
- PersonalizedChallengeUseCaseImpl
- LogWaterAmountOption
- Reliability Recovery
- SettingsViewModel
- HealthKitAuthorizationStatus
- .init
- HydrationReminderPermissionGateView
- WaterDropView
- TokenProperty
- WatchHydrationRepositoryImpl
- ConfigurationAppIntent
- SettingsViewModelTests
- DrinkWaterRepositoryImpl
- HydrationRoutineSchedule
- WatchHydrationUseCaseImpl
- HydrationWriteFailureReason
- SpyDrinkWaterUseCase
- Agent Onboarding Guide
- UserPreferencesDataSourceImpl
- HydrationGoalRecommendationAvailability
- HydrationComebackRepositoryImpl
- DIEnvironment
- WatchHydrationHealthKitDataSource
- WidgetTimelineReloading
- DrinkWaterWidgetProvider
- ContentState
- BodyProfileSettingView
- Error
- HydrationRecordListView
- LogWaterAppShortcuts
- float2
- .resolve
- HydrationNextActionGuide
- MockHealthKitUseCase
- Mulimi
- HydrationRoutineRecommendationKind
- UserPreferencesRepositoryImpl
- WatchDailyGoalUserDefaultsDataSource
- AuthenticationError
- Accessibility and Dynamic Type Audit
- SettingMenu
- RoutineNotificationDataSourceImpl
- ci_post_clone.sh
- pre-commit
- MockAppReviewRequestUseCase
- ChallengeStorageDataSourceImpl
- ChallengeCategory
- HydrationGoalRecommendationRepositoryImpl
- check-architecture.sh
- Profile Information Architecture
- lint.sh
- lint-fix.sh
- .progressSnapshot
- .makeComebackViewModel
- HealthKitError
- DrinkWaterWidget
- MockHydrationProgressUseCase
- MockHydrationNextActionGuideUseCaseForTesting
- AuthProvider
- Mulimi Pull Request Template
- MockHydrationProgressUseCaseForTesting
- MockHydrationReminderUseCaseForTesting
- HydrationNextActionGuideUseCaseTests
- RoutineActionIntent
- WatchHydrationEvent
- MockHydrationProgressUseCase
- HydrationRecordPeriod
- WatchDataConstants.swift

## God Nodes (most connected - your core abstractions)
1. `DrinkWaterViewModel` - 112 edges
2. `HydrationDomain` - 108 edges
3. `HydrationRoutine` - 99 edges
4. `AccountDomain` - 97 edges
5. `HydrationInsightViewModel` - 95 edges
6. `ProfileRoutineViewModel` - 74 edges
7. `RoutineDomain` - 73 edges
8. `HydrationEvent` - 71 edges
9. `MulimiAnalytics` - 69 edges
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

## Communities (167 total, 9 thin omitted)

### Community 0 - "HydrationRoutineAdherenceInsight"
Cohesion: 0.13
Nodes (29): CandidateMatch, Constants, HydrationRoutineAdherenceEvent, HydrationRoutineAdherenceInsight, .adherenceRate, .bestRoutine, .bestTimeSlot, .hasDueOccurrences (+21 more)

### Community 1 - "HydrationRecord"
Cohesion: 0.11
Nodes (10): MockHealthKitUseCaseForTesting, Bool, Date, HydrationRecord, Date, Double, HydrationRecordRow, .body (+2 more)

### Community 2 - "HydrationDomain"
Cohesion: 0.07
Nodes (5): CoreGraphics, FoundationModels, HealthKit, HydrationDomain, Observation

### Community 3 - "ProfileRoutineViewModel"
Cohesion: 0.07
Nodes (29): RoutineRecommendationUseCase, .body, RoutineEditorView, .body, .weekdayGrid, ProfileRoutineViewModel, .activeRoutineCount, .canSaveDraft (+21 more)

### Community 4 - "HydrationRoutine"
Cohesion: 0.11
Nodes (15): Int, RoutineNotificationDataSource, RoutineStorageDataSource, RoutineStorageDataSourceImpl, RoutineRepositoryImpl, Bool, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource (+7 more)

### Community 5 - "HydrationServing"
Cohesion: 0.25
Nodes (7): HydrationServing, .additionalPresets, Double, Int, .progressLevel, .drinkWaterCount, .numberOfGlasses

### Community 6 - "MockHealthKitRepository"
Cohesion: 0.13
Nodes (6): HealthKitUseCaseImpl, .authorisationStatus, Date, HealthKitUseCaseTests, MockHealthKitRepository, .authorisationStatus

### Community 7 - "MockUserPreferencesUseCase"
Cohesion: 0.20
Nodes (8): NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, MockDrinkWaterUseCase, MockUserPreferencesUseCase, Bool, Double

### Community 8 - ".tr"
Cohesion: 0.08
Nodes (31): Bundle, AppReviewRequestTaskID, DrinkWaterView, .actionButtons, .appReviewRequestTaskID, .completionText, .defaultDrinkButton, .defaultDrinkButtonAccessibilityLabel (+23 more)

### Community 9 - "HydrationRecordListViewModel"
Cohesion: 0.19
Nodes (6): HydrationRecordListViewModel, .showsEmptyStateRecordCTA, Calendar, Sendable, HydrationRecordListViewModelTests, RecordSpyWidgetTimelineReloader

### Community 10 - ".assemble"
Cohesion: 0.10
Nodes (20): Container, Container, RootView, .body, Content, AppSession, Bool, SignInView (+12 more)

### Community 11 - "Docs Index"
Cohesion: 0.11
Nodes (37): PostHog Analytics Consolidation, Docs Index, Personalized Challenge Strategy, Personalized Challenge Recommendation Candidates, Challenge Recommendation Tier Rules, Analytics Architecture Boundary, Analytics Events, Analytics Event Catalog (+29 more)

### Community 12 - "HydrationEvent"
Cohesion: 0.08
Nodes (21): MockDrinkWaterUseCaseForTesting, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int, HydrationEvent (+13 more)

### Community 13 - "CI Lint and Architecture Gate"
Cohesion: 0.25
Nodes (8): CI Lint and Architecture Gate, Lint Workflow, Domain Data Presentation Test Matrix, PR Unit Tests Workflow, SwiftPM Cache Retry, Selected SwiftLint Rule Set, SwiftLint Configuration, Default Validation Sequence

### Community 14 - "DrinkWaterViewModel"
Cohesion: 0.09
Nodes (24): AppReviewRequestUseCase, CustomHydrationAmountValidation, empty, invalid, overLimit, valid, DrinkWaterViewModel, .dailyLimit (+16 more)

### Community 15 - "RoutineDomain"
Cohesion: 0.17
Nodes (3): ChallengeDomain, MulimiAnalytics, RoutineDomain

### Community 16 - "HydrationChallengeKind"
Cohesion: 0.09
Nodes (34): Codable, HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType, streak7, weeklyAchievement80 (+26 more)

### Community 17 - "HealthKitPermissionViewModel"
Cohesion: 0.13
Nodes (10): HealthKitUseCase, .body, .permissionView, HealthKitPermissionViewModel, Bool, HealthKitPermissionViewModelTests, MockHealthKitUseCase, .authorisationStatus (+2 more)

### Community 18 - "Color"
Cohesion: 0.09
Nodes (30): ChallengeBadge, .body, ChallengeCard, .accentColor, .body, .cardBackground, ChallengeHistoryCard, .accentColor (+22 more)

### Community 19 - "MockDrinkWaterUseCase"
Cohesion: 0.16
Nodes (11): Never, MockDrinkWaterUseCase, .currentWaterIntakeML, .hasPendingDrinkWater, Bool, CheckedContinuation, Date, DateInterval (+3 more)

### Community 20 - "HydrationWriteResult"
Cohesion: 0.08
Nodes (16): MockDrinkWaterUseCase, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int, .analyticsFailureReason (+8 more)

### Community 21 - "BodyProfile"
Cohesion: 0.11
Nodes (18): Hashable, AppTab, challenge, drink, history, insight, profile, BodyProfile (+10 more)

### Community 22 - "DrinkWaterRepository"
Cohesion: 0.13
Nodes (11): Container, UserPreferencesRepository, DrinkWaterRepository, HydrationNextActionGuideUseCaseImpl, Calendar, Date, HydrationRoutineAdherenceUseCaseImpl, Calendar (+3 more)

### Community 23 - "MockDrinkWaterRepository"
Cohesion: 0.19
Nodes (8): DrinkWaterUseCaseImpl, .currentWaterIntakeML, Double, DrinkWaterUseCaseTests, MockDrinkWaterRepository, .currentWaterIntakeML, Double, Int

### Community 24 - "WatchHydrationViewModel"
Cohesion: 0.06
Nodes (38): AnyView, WatchDIContainer, State, bodyProfileRequired, idle, loading, modelUnavailable, ready (+30 more)

### Community 25 - "AccountDomain"
Cohesion: 0.09
Nodes (4): AccountDomain, MulimiKeychain, MulimiPlatform, Testing

### Community 26 - "SpyRoutineUseCase"
Cohesion: 0.22
Nodes (7): ProfileRoutineViewModelTests, SpyRoutineRecommendationUseCase, SpyRoutineUseCase, Calendar, Date, Error, Result

### Community 27 - "MockRoutineRepository"
Cohesion: 0.14
Nodes (10): RoutineRepository, RoutineUseCaseImpl, RoutineRecommendationUseCaseTests, Calendar, Date, Int, RoutineUseCaseTests, MockRoutineRepository (+2 more)

### Community 28 - "LiquidGlassSegmentedControl"
Cohesion: 0.22
Nodes (13): Value, .categoryPicker, .categoryPicker, LiquidGlassSegment, .id, LiquidGlassSegmentedControl, .activeSegmentBackground, .activeSegmentBorder (+5 more)

### Community 29 - ".assemble"
Cohesion: 0.10
Nodes (9): DataAssembly, Container, PostHogAnalyticsRepository, ProductAnalyticsEvent, AnalyticsRepository, NoOpAnalyticsRepository, ProductAnalyticsEvent, AnalyticsUseCaseImpl (+1 more)

### Community 30 - "SwiftUI"
Cohesion: 0.10
Nodes (11): ActivityKit, AlarmKit, Charts, CryptoKit, DesignSystem, Localization, HydrationPresentationShaderBundleToken, StoreKit (+3 more)

### Community 31 - "HydrationReminderPermissionViewModel"
Cohesion: 0.14
Nodes (10): HydrationReminderUseCase, .primingView, Constant, HydrationReminderPermissionViewModel, Bool, HydrationReminderPermissionViewModelTests, MockHydrationReminderUseCase, Bool (+2 more)

### Community 32 - "UserCredential"
Cohesion: 0.05
Nodes (26): ASAuthorization, ASAuthorizationController, ASAuthorizationControllerDelegate, AuthenticationServices, MockSignInUseCase, Bool, AppleSignInCredential, AppleSignInDataSource (+18 more)

### Community 33 - "HydrationChallenge"
Cohesion: 0.13
Nodes (10): MockChallengeUseCase, Calendar, Date, HydrationChallenge, .id, Int, ChallengeCardModel, Bool (+2 more)

### Community 34 - "RecordCalendarView"
Cohesion: 0.08
Nodes (35): Binding, CalendarDayView, .accessibilityLabel, .backgroundColor, .body, .borderColor, .dayNumber, .progressPercentage (+27 more)

### Community 35 - "HealthKitDataSource"
Cohesion: 0.13
Nodes (13): DrinkWaterHealthKitDataSource, .currentWaterIntakeML, Bool, Calendar, Date, DateInterval, Double, Error (+5 more)

### Community 36 - "HydrationProgressSnapshot"
Cohesion: 0.26
Nodes (10): HydrationProgressSnapshot, HydrationInsightViewModelTests, SpyRoutineUseCase, Calendar, Date, Int, MockDrinkWaterUseCase, MockHydrationRoutineAdherenceUseCase (+2 more)

### Community 37 - "Sendable"
Cohesion: 0.07
Nodes (29): MockPersonalizedChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCaseForTesting, Calendar, Date, HydrationChallengeRecommendationSource, recentRecords (+21 more)

### Community 38 - "AppCoordinator"
Cohesion: 0.06
Nodes (23): AnyObject, FullScreenRoute, AppCoordinator, AppRoute, hydrationLogging, .id, .presentationStyle, profileRoutineAction (+15 more)

### Community 39 - "String"
Cohesion: 0.07
Nodes (38): Equatable, Identifiable, .postHogValue, Any, AnalyticsParameterName, AnalyticsParameterValue, bool, double (+30 more)

### Community 40 - "HydrationGoalRecommendationViewModel"
Cohesion: 0.11
Nodes (16): DailyLimitSettingView, .body, HydrationGoalRecommendationUseCase, EntryDestination, bodyProfileSetting, dailyLimitSetting, GoalAlignment, aboveGoal (+8 more)

### Community 41 - "RoutineWeekday"
Cohesion: 0.09
Nodes (32): MockRoutineRecommendationUseCase, Calendar, Date, .localeWeekday, Locale, .nextActionSchedule, RoutineWeekday, .displayOrder (+24 more)

### Community 42 - "HealthKitQuantityStore"
Cohesion: 0.23
Nodes (11): HKAuthorizationStatus, HKHealthStore, HKQuantityType, HKQuantityTypeIdentifier, HKUnit, HealthKitQuantityStore, .isHealthDataAvailable, HealthQuantitySample (+3 more)

### Community 43 - "MockHydrationReminderRepository"
Cohesion: 0.15
Nodes (8): HydrationReminderRepository, HydrationReminderUseCaseImpl, Bool, HydrationReminderUseCaseTests, MockHydrationReminderRepository, Bool, Error, Result

### Community 44 - ".makeUseCase"
Cohesion: 0.24
Nodes (8): AppReviewRequestUseCaseTests, .calendar, .referenceDate, Bool, Calendar, Date, Double, Int

### Community 45 - ".assemble"
Cohesion: 0.15
Nodes (7): MockChallengeUseCaseForTesting, Calendar, Date, MockRoutineRecommendationUseCaseForTesting, Calendar, Date, Container

### Community 46 - "ProfileRoutineView"
Cohesion: 0.19
Nodes (7): ProfileRoutineView, .guidanceCard, .permissionSection, RoutineGuidanceSlotStatus, elapsed, next, upcoming

### Community 47 - "DIContainer"
Cohesion: 0.13
Nodes (11): Assembler, Assembly, DIContainer, .resolver, Assembly, DomainAssembly, PresentationAssembly, Assembly (+3 more)

### Community 48 - "UserDefaults"
Cohesion: 0.09
Nodes (18): Double, NSUbiquitousKeyValueStore, UbiquitousMirroredStore, NSUbiquitousKeyValueStore, HydrationReminderStorageDataSourceImpl, Bool, NSUbiquitousKeyValueStore, Bool (+10 more)

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.12
Nodes (7): HydrationReminderAuthorizationStatus, authorized, denied, notDetermined, .analyticsValue, ProductAnalyticsEvent, UNAuthorizationStatus

### Community 50 - "HealthQuantityStoring"
Cohesion: 0.20
Nodes (9): HealthQuantityStoring, HealthKitDataSourceImpl, .healthKitAuthorizationStatus, .isWaterSharingAuthorized, Bool, Date, Double, Error (+1 more)

### Community 51 - "HydrationReminderRepositoryImpl"
Cohesion: 0.18
Nodes (9): HydrationReminderNotificationDataSource, HydrationReminderStorageDataSource, HydrationReminderRepositoryImpl, Bool, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource, Bool (+1 more)

### Community 52 - "View"
Cohesion: 0.11
Nodes (24): GridItem, BadgeView, .body, HydrationInsightView, .body, .emptyState, .emptyStateCTAButtons, .insightContent (+16 more)

### Community 53 - "HydrationInsightViewModel"
Cohesion: 0.08
Nodes (34): DrinkWaterUseCase, HydrationInsightViewModel, .canRecordRecoveryDrink, .chartUpperBound, .dailyGoalText, .emptyStateCTAs, .routineAdherenceInsightText, .routineAdherenceMetrics (+26 more)

### Community 54 - "StartTimerIntent"
Cohesion: 0.15
Nodes (12): AppIntentControlValueProvider, ControlConfigurationIntent, Provider, StartTimerIntent, Bool, ControlWidgetConfiguration, IntentResult, LocalizedStringResource (+4 more)

### Community 55 - "BodyProfileSnapshot"
Cohesion: 0.16
Nodes (7): MockBodyProfileUseCase, BodyProfileSnapshot, Bool, MockBodyProfileUseCaseForDomain, BodyProfileViewModelTests, MockBodyProfileUseCase, Error

### Community 56 - "MockHydrationNextActionGuideUseCase"
Cohesion: 0.40
Nodes (3): MockHydrationNextActionGuideUseCase, Calendar, Date

### Community 57 - "Foundation"
Cohesion: 0.07
Nodes (11): AccountData, ChallengeData, Foundation, HydrationData, HydrationReminderData, HydrationReminderDomain, MulimiAnalyticsData, PostHog (+3 more)

### Community 58 - "HydrationChallengeBadgeHistory"
Cohesion: 0.12
Nodes (16): HydrationChallengeBadgeHistory, Date, ChallengeRepository, ChallengeEvaluation, ChallengeMergeResult, ChallengeUseCaseImpl, Bool, Calendar (+8 more)

### Community 59 - "HydrationReminderSlot"
Cohesion: 0.12
Nodes (13): Constant, HydrationReminderNotificationDataSourceImpl, .notificationCenter, Int, Set, UNUserNotificationCenter, HydrationReminderSlot, afternoon (+5 more)

### Community 60 - "DrinkWaterEntry"
Cohesion: 0.11
Nodes (21): DrinkWaterLockScreenWidgetEntryView, .accentColor, .body, .circularView, .inlineView, .rectangularView, .body, DrinkWaterWidgetEntryView (+13 more)

### Community 61 - "HealthKitPermissionGateView"
Cohesion: 0.16
Nodes (13): HealthKitPermissionGateView, .accessCard, .descriptionText, .footnoteText, .headerColor, .headerSection, .headerSystemImage, .primaryButtonHint (+5 more)

### Community 62 - "MulimiWatchApp"
Cohesion: 0.22
Nodes (8): App, DrinkWaterApp, .body, Scene, MulimiWatchApp, .body, Scene, WatchDependencyInjection

### Community 63 - "BodyProfileViewModel"
Cohesion: 0.13
Nodes (12): BodyProfileAvailability, incomplete, needsPermission, noData, permissionDenied, ready, BodyProfileViewModel, .availabilityState (+4 more)

### Community 64 - "LogWaterAppIntent"
Cohesion: 0.17
Nodes (13): AppIntent, IntentDialog, IntentModes, Constant, FailureReason, LogWaterAppIntent, .resolvedVolumeML, Bool (+5 more)

### Community 65 - "ProjectDescription"
Cohesion: 0.12
Nodes (5): PackageDescription, Plist, ProjectDescription, ProjectDescriptionHelpers, AppVersion

### Community 66 - "AppReviewRequestUseCaseImpl"
Cohesion: 0.25
Nodes (9): AppReviewRequestRepository, AppReviewRequestUseCaseImpl, Policy, Bool, Calendar, Date, DateInterval, Double (+1 more)

### Community 67 - "ContentView"
Cohesion: 0.16
Nodes (11): ContentView, .body, AccountRoute, profileRoutine, setting, ProfileView, .body, .goalRecommendationCard (+3 more)

### Community 68 - "Top 5"
Cohesion: 0.14
Nodes (13): 1. 로그인 없이 시작, 2. 7일 스타터 플랜, 3. 알림 바로 기록, 4. 제어 센터·액션 버튼 기록, 5. 컴백 모드, Candidate Ideas, Decision, Engineer (+5 more)

### Community 69 - "MainIcon"
Cohesion: 0.05
Nodes (26): MockUserPreferencesUseCase, Bool, Double, MockUserPreferencesUseCaseForTesting, Bool, Double, MainIcon, cloud (+18 more)

### Community 70 - "Test.swift"
Cohesion: 0.18
Nodes (14): ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, ConfigurationAppIntent, Context, Date (+6 more)

### Community 71 - "UUID"
Cohesion: 0.19
Nodes (7): AlarmMetadata, Bool, RoutineAlarmMetadata, UUID, HydrationEventModel, Date, Int

### Community 72 - "RoutineNotificationAuthorizationStatus"
Cohesion: 0.08
Nodes (8): MockRoutineUseCase, Error, Result, MockRoutineUseCaseForTesting, RoutineNotificationAuthorizationStatus, authorized, denied, notDetermined

### Community 73 - "HydrationRecordDaySummary"
Cohesion: 0.13
Nodes (14): .weekStripSection, HydrationRecordDaySummary, .glassCount, .id, .todaySummary, .weekDayItems, HydrationRecordPeriodSummary, HydrationRecordWeekDayItem (+6 more)

### Community 74 - "HydrationGoalRecommendation"
Cohesion: 0.25
Nodes (6): HydrationGoalRecommendation, HydrationGoalRecommendationInput, Int, MockHydrationGoalRecommendationUseCase, Date, Error

### Community 75 - "OnboardingView"
Cohesion: 0.14
Nodes (15): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+7 more)

### Community 76 - "HydrationGoalRecommendationCard"
Cohesion: 0.33
Nodes (4): HydrationGoalRecommendationCard, .body, .content, Bool

### Community 77 - "BodyProfileUseCaseImpl"
Cohesion: 0.23
Nodes (4): HealthKitRepository, BodyProfileUseCaseImpl, Bool, BodyProfileUseCaseTests

### Community 78 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.22
Nodes (8): BodyProfileUseCase, Constants, HydrationGoalRecommendationUseCaseImpl, Calendar, Date, DateInterval, Int, HydrationGoalRecommendationUseCaseTests

### Community 79 - "AppReviewRequestState"
Cohesion: 0.15
Nodes (8): AppReviewRequestStorageDataSource, AppReviewRequestStorageDataSourceImpl, AppReviewRequestRepositoryImpl, AppReviewRequestStorageDataSourceTests, AppReviewRequestState, Date, Set, MockAppReviewRequestRepository

### Community 80 - "SharedHydrationStoreError"
Cohesion: 0.19
Nodes (10): ModelConfiguration, ModelContainer, SharedHydrationStore, .isICloudAccountAvailable, SharedHydrationStoreError, .errorDescription, failedToCreateContainer, missingAppGroupContainer (+2 more)

### Community 81 - ".makeViewModel"
Cohesion: 0.32
Nodes (5): MockHydrationGoalRecommendationUseCase, MockHydrationProgressUseCase, HydrationGoalRecommendationViewModelTests, Double, Int

### Community 82 - "WatchHydrationSnapshot"
Cohesion: 0.14
Nodes (12): WatchHydrationMutationResult, Bool, Date, Double, Int, Self, WatchHydrationSnapshot, .eventCount (+4 more)

### Community 83 - "UserPreferencesUseCase"
Cohesion: 0.21
Nodes (6): UserPreferencesUseCase, OnboardingViewModel, .canGoBack, .isLastPage, Bool, OnboardingViewModelTests

### Community 84 - ".loadChallenges"
Cohesion: 0.28
Nodes (8): ChallengeViewModelTests, Calendar, MockChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCase, Calendar, Date

### Community 85 - "HydrationGoalRecommendationUnavailableReason"
Cohesion: 0.17
Nodes (11): HydrationGoalRecommendationError, bodyProfileRequired, modelUnavailable, HydrationGoalRecommendationUnavailableReason, appleIntelligenceNotEnabled, deviceNotEligible, modelNotReady, unknown (+3 more)

### Community 86 - ".shouldRequestAfterSuccessfulHydrationRecord"
Cohesion: 0.28
Nodes (5): NoOpAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 87 - "AGENTS.md Onboarding Map"
Cohesion: 0.11
Nodes (23): Quality Gates, Truthful Validation Reporting, Validation Baseline, Validation Matrix, architecture-boundary, Clean Architecture and MVVM, Domain Purity, ViewModel Side Effect Boundary (+15 more)

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

### Community 92 - "AnalyticsUseCase"
Cohesion: 0.23
Nodes (4): AnalyticsUseCase, NoOpAnalyticsUseCase, ProductAnalyticsEvent, SignInUseCase

### Community 93 - "MockHydrationReminderUseCase"
Cohesion: 0.22
Nodes (4): MockHydrationReminderUseCase, Bool, Error, Result

### Community 94 - "HydrationProgressUseCaseImpl"
Cohesion: 0.40
Nodes (7): HydrationProgressUseCaseImpl, StreakProgress, Calendar, Date, DateInterval, Double, Int

### Community 95 - "AuthTokens"
Cohesion: 0.31
Nodes (4): AuthenticationNetworkDataSource, AuthenticationNetworkDataSourceImpl, AuthTokens, Int

### Community 96 - "Data Boundary"
Cohesion: 0.12
Nodes (17): Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling, Data Boundary, Health Data Minimization, PostHog Privacy Controls (+9 more)

### Community 97 - "HydrationPresentation"
Cohesion: 0.13
Nodes (9): AccountPresentation, ChallengePresentation, DependencyInjection, HydrationPresentation, HydrationReminderPresentation, MulimiNavigation, PreviewAssembly, RoutinePresentation (+1 more)

### Community 98 - "FoundationModelsHydrationGoalRecommendationDataSource"
Cohesion: 0.24
Nodes (6): Constants, FoundationModelsHydrationGoalRecommendationDataSource, GeneratedHydrationGoalRecommendation, Int, Locale, SystemLanguageModel

### Community 99 - "PersonalizedChallengeUseCaseImpl"
Cohesion: 0.18
Nodes (10): Constants, PersonalizedChallengeUseCaseImpl, Calendar, Date, Int, PersonalizedChallengeUseCaseTests, Calendar, Date (+2 more)

### Community 100 - "LogWaterAmountOption"
Cohesion: 0.18
Nodes (11): AppEnum, DisplayRepresentation, LogWaterAmountOption, bottle, custom, glass, .presetID, .servingType (+3 more)

### Community 101 - "Reliability Recovery"
Cohesion: 0.22
Nodes (11): Goal Mirror Recovery Policy, HealthKit Source of Truth, Recovery Principles, Reliability Recovery, Routine Schedule Recovery, Shared Hydration Rules, HealthKit Data Flow, healthkit-flow (+3 more)

### Community 102 - "SettingsViewModel"
Cohesion: 0.10
Nodes (16): AppInfoProviding, BundleAppInfoProvider, .appBuildNumber, .appVersion, StaticAppInfoProvider, .body, WithdrawalSettingView, .body (+8 more)

### Community 103 - "HealthKitAuthorizationStatus"
Cohesion: 0.26
Nodes (6): HealthKitAuthorizationStatus, notDetermined, sharingAuthorized, sharingDenied, .analyticsValue, ProductAnalyticsEvent

### Community 104 - ".init"
Cohesion: 0.18
Nodes (8): Bool, Calendar, Date, Double, Int, MockHydrationProgressUseCase, Calendar, Date

### Community 105 - "HydrationReminderPermissionGateView"
Cohesion: 0.32
Nodes (6): HydrationReminderPermissionGateView, .allowButtonLabel, .benefitCard, .body, .headerSection, Content

### Community 106 - "WaterDropView"
Cohesion: 0.29
Nodes (8): CGFloat, CGSize, TimeInterval, WaterDropView, .body, .dropBackground, .dropHighlights, .dropSymbol

### Community 107 - "TokenProperty"
Cohesion: 0.12
Nodes (10): KeychainStore, KeychainStoring, KeyChainDataSourceImpl, Bool, TokenProperty, accessToken, email, nickname (+2 more)

### Community 108 - "WatchHydrationRepositoryImpl"
Cohesion: 0.19
Nodes (7): MulimiHealthKit, OSLog, WatchHydrationLocalDataSource, Date, Int, WatchHydrationRepositoryImpl, WatchHydrationDomain

### Community 109 - "ConfigurationAppIntent"
Cohesion: 0.16
Nodes (10): AppIntents, IntentDescription, ConfigurationAppIntent, .description, .title, LocalizedStringResource, ConfigurationAppIntent, IntentResult (+2 more)

### Community 110 - "SettingsViewModelTests"
Cohesion: 0.20
Nodes (10): LocalizedError, MockError, .errorDescription, signInFailed, MockError, deleteFailed, .errorDescription, MockError (+2 more)

### Community 111 - "DrinkWaterRepositoryImpl"
Cohesion: 0.15
Nodes (8): DrinkWaterDataSource, DrinkWaterRepositoryImpl, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int

### Community 112 - "HydrationRoutineSchedule"
Cohesion: 0.30
Nodes (7): HydrationRoutineSchedule, Bool, Set, HydrationRoutineAdherenceUseCaseTests, Calendar, Date, Int

### Community 113 - "WatchHydrationUseCaseImpl"
Cohesion: 0.27
Nodes (6): WatchDailyGoalRepository, WatchHydrationRepository, Date, Double, Int, WatchHydrationUseCaseImpl

### Community 114 - "HydrationWriteFailureReason"
Cohesion: 0.27
Nodes (5): HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, HydrationRecordFailureAlertModel

### Community 115 - "SpyDrinkWaterUseCase"
Cohesion: 0.14
Nodes (7): SpyDrinkWaterUseCase, .currentWaterIntakeML, SpyUserPreferencesUseCase, Bool, DateInterval, Double, Int

### Community 116 - "Agent Onboarding Guide"
Cohesion: 0.08
Nodes (32): AI PR Review Workflow, Architecture Review Policy, Bounded AI Review Diff, Git Flow PR Filter, Textual Diff Selection, Agent Onboarding Guide, Clean Architecture and MVVM Discipline, Domain Purity (+24 more)

### Community 117 - "UserPreferencesDataSourceImpl"
Cohesion: 0.24
Nodes (5): SyncedValueStoring, Constants, Bool, Double, UserPreferencesDataSourceImpl

### Community 118 - "HydrationGoalRecommendationAvailability"
Cohesion: 0.22
Nodes (7): MockHydrationGoalRecommendationUseCase, Date, Error, HydrationGoalRecommendationAvailability, bodyProfileRequired, modelUnavailable, ready

### Community 119 - "HydrationComebackRepositoryImpl"
Cohesion: 0.43
Nodes (3): HydrationComebackRepositoryImpl, Date, HydrationComebackRepositoryTests

### Community 120 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 121 - "WatchHydrationHealthKitDataSource"
Cohesion: 0.23
Nodes (8): Bool, Calendar, Date, DateInterval, Error, Int, WatchHydrationHealthKitDataSource, .isWaterSharingAuthorized

### Community 122 - "WidgetTimelineReloading"
Cohesion: 0.18
Nodes (3): SystemWidgetTimelineReloader, WidgetTimelineReloading, .body

### Community 123 - "DrinkWaterWidgetProvider"
Cohesion: 0.31
Nodes (6): AppIntentTimelineProvider, DrinkWaterWidgetProvider, ConfigurationAppIntent, Context, Date, Timeline

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (7): ActivityAttributes, ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 125 - "BodyProfileSettingView"
Cohesion: 0.31
Nodes (5): BodyProfileSettingView, .body, .healthSyncCard, .summaryCard, Void

### Community 126 - "Error"
Cohesion: 0.10
Nodes (18): Error, HealthQuantityStoreError, incompleteQuery, internalError, invalidObjectType, permissionDenied, MockSignInError, deleteAccountFailed (+10 more)

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
Cohesion: 0.36
Nodes (6): PreviewViews, .challenge, .drinkWater, .hydrationList, .profile, Service

### Community 131 - "HydrationNextActionGuide"
Cohesion: 0.20
Nodes (14): Constants, HydrationNextActionGuide, .progress, HydrationNextActionGuideState, approachingRoutine, goalReached, needsGoal, readyToDrink (+6 more)

### Community 133 - "Mulimi"
Cohesion: 0.16
Nodes (16): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Legacy Challenge State Migration, Recurring Challenge State, Documentation Role Separation Debt, Tech Debt Tracker, Exec Plan Lifecycle (+8 more)

### Community 134 - "HydrationRoutineRecommendationKind"
Cohesion: 0.29
Nodes (5): HydrationRoutineRecommendationKind, afternoonGap, frequentHydrationWindow, morningStart, .recommendationCards

### Community 135 - "UserPreferencesRepositoryImpl"
Cohesion: 0.24
Nodes (4): UserPreferencesDataSource, Bool, Double, UserPreferencesRepositoryImpl

### Community 136 - "WatchDailyGoalUserDefaultsDataSource"
Cohesion: 0.27
Nodes (6): MulimiCloudKit, Int, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, Int, WatchDailyGoalRepositoryImpl

### Community 137 - "AuthenticationError"
Cohesion: 0.29
Nodes (6): AuthenticationError, cancelled, invalidCredential, networkFailed, serverError, unknown

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "SettingMenu"
Cohesion: 0.17
Nodes (10): SettingMenu, bodyProfile, dailyLimit, .id, mainIcon, withdrawal, Self, MainIconSettingView (+2 more)

### Community 140 - "RoutineNotificationDataSourceImpl"
Cohesion: 0.21
Nodes (6): Alarm, AlarmManager, AlarmPresentation, Constant, RoutineNotificationDataSourceImpl, LocalizedStringResource

### Community 143 - "MockAppReviewRequestUseCase"
Cohesion: 0.48
Nodes (5): MockAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 144 - "ChallengeStorageDataSourceImpl"
Cohesion: 0.29
Nodes (4): ChallengeStorageDataSource, ChallengeStorageDataSourceImpl, ChallengeRepositoryImpl, ChallengeStorageDataSourceTests

### Community 145 - "ChallengeCategory"
Cohesion: 0.09
Nodes (23): CaseIterable, ChallengeCategory, completed, .id, inProgress, recommended, .systemImage, .title (+15 more)

### Community 146 - "HydrationGoalRecommendationRepositoryImpl"
Cohesion: 0.33
Nodes (3): HydrationGoalRecommendationDataSource, HydrationGoalRecommendationRepositoryImpl, HydrationGoalRecommendationRepository

### Community 148 - "Profile Information Architecture"
Cohesion: 0.67
Nodes (4): Goal Recommendation Entry Rules, Profile Information Architecture, Profile Root, Settings Screen

### Community 151 - ".progressSnapshot"
Cohesion: 0.40
Nodes (4): HydrationProgressUseCaseTests, Calendar, Date, Int

### Community 152 - ".makeComebackViewModel"
Cohesion: 0.15
Nodes (10): HydrationComebackRepository, .nextActionSummary, HydrationComebackMode, baseline, card, disabled, StubHydrationComebackRepository, Bool (+2 more)

### Community 153 - "HealthKitError"
Cohesion: 0.33
Nodes (5): HealthKitError, healthKitInternalError, incompleteExecuteQuery, invalidObjectType, permissionDenied

### Community 154 - "DrinkWaterWidget"
Cohesion: 0.11
Nodes (20): ControlWidget, Widget, TestBundle, .body, WidgetConfiguration, TestLiveActivity, .body, DrinkWaterLockScreenWidget (+12 more)

### Community 155 - "MockHydrationProgressUseCase"
Cohesion: 0.40
Nodes (3): MockHydrationProgressUseCase, Calendar, Date

### Community 156 - "MockHydrationNextActionGuideUseCaseForTesting"
Cohesion: 0.40
Nodes (3): MockHydrationNextActionGuideUseCaseForTesting, Calendar, Date

### Community 157 - "AuthProvider"
Cohesion: 0.40
Nodes (4): AuthProvider, apple, google, kakao

### Community 158 - "Mulimi Pull Request Template"
Cohesion: 0.50
Nodes (4): Local Validation Reporting, Mulimi Pull Request Template, PR Review Checklist, Truthful Validation Reporting

### Community 159 - "MockHydrationProgressUseCaseForTesting"
Cohesion: 0.40
Nodes (3): MockHydrationProgressUseCaseForTesting, Calendar, Date

### Community 162 - "RoutineActionIntent"
Cohesion: 0.10
Nodes (17): .id, Bool, HydrationInsightEmptyAction, dailyGoal, record, routine, HydrationWeeklyCoachingAction, dailyGoal (+9 more)

### Community 163 - "WatchHydrationEvent"
Cohesion: 0.60
Nodes (3): Date, Int, WatchHydrationEvent

### Community 164 - "MockHydrationProgressUseCase"
Cohesion: 0.83
Nodes (3): MockHydrationProgressUseCase, Calendar, Date

### Community 165 - "HydrationRecordPeriod"
Cohesion: 0.29
Nodes (7): .selectedPeriodRangeText, HydrationRecordPeriod, .id, month, .title, today, week

## Ambiguous Edges - Review These
- `HealthKit Source of Truth` → `CloudKit-Backed Hydration Store`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to
- `CloudKit-Backed Hydration Store` → `Current Storage Strategy`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to

## Knowledge Gaps
- **459 isolated node(s):** `.resolver`, `production`, `preview`, `testing`, `.current` (+454 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 857 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **9 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `HealthKit Source of Truth` and `CloudKit-Backed Hydration Store`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `Current Storage Strategy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `String` connect `String` to `HydrationRoutineAdherenceInsight`, `HydrationRecord`, `ProfileRoutineViewModel`, `HydrationRoutine`, `.tr`, `HydrationRecordListViewModel`, `.assemble`, `HydrationEvent`, `DrinkWaterViewModel`, `HydrationChallengeKind`, `HealthKitPermissionViewModel`, `Color`, `MockDrinkWaterUseCase`, `HydrationWriteResult`, `BodyProfile`, `WatchHydrationViewModel`, `LiquidGlassSegmentedControl`, `.assemble`, `HydrationReminderPermissionViewModel`, `UserCredential`, `HydrationChallenge`, `RecordCalendarView`, `Sendable`, `AppCoordinator`, `HydrationGoalRecommendationViewModel`, `RoutineWeekday`, `HealthKitQuantityStore`, `ProfileRoutineView`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `View`, `HydrationInsightViewModel`, `StartTimerIntent`, `HydrationChallengeBadgeHistory`, `HydrationReminderSlot`, `DrinkWaterEntry`, `HealthKitPermissionGateView`, `BodyProfileViewModel`, `LogWaterAppIntent`, `ProjectDescription`, `AppReviewRequestUseCaseImpl`, `ContentView`, `MainIcon`, `Test.swift`, `UUID`, `HydrationRecordDaySummary`, `HydrationGoalRecommendation`, `OnboardingView`, `HydrationGoalRecommendationCard`, `AppReviewRequestState`, `SharedHydrationStoreError`, `.shouldRequestAfterSuccessfulHydrationRecord`, `AnalyticsUseCase`, `AuthTokens`, `FoundationModelsHydrationGoalRecommendationDataSource`, `LogWaterAmountOption`, `SettingsViewModel`, `HealthKitAuthorizationStatus`, `HydrationReminderPermissionGateView`, `TokenProperty`, `ConfigurationAppIntent`, `SettingsViewModelTests`, `HydrationRoutineSchedule`, `HydrationWriteFailureReason`, `UserPreferencesDataSourceImpl`, `ContentState`, `BodyProfileSettingView`, `HydrationNextActionGuide`, `HydrationRoutineRecommendationKind`, `AuthenticationError`, `SettingMenu`, `RoutineNotificationDataSourceImpl`, `MockAppReviewRequestUseCase`, `ChallengeStorageDataSourceImpl`, `ChallengeCategory`, `.progressSnapshot`, `.makeComebackViewModel`, `DrinkWaterWidget`, `RoutineActionIntent`, `HydrationRecordPeriod`?**
  _High betweenness centrality (0.255) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `HydrationRoutineAdherenceInsight`, `HydrationRecord`, `HydrationDomain`, `HydrationNextActionGuide`, `ProfileRoutineViewModel`, `HydrationServing`, `HydrationRoutineRecommendationKind`, `WatchDailyGoalUserDefaultsDataSource`, `AuthenticationError`, `.tr`, `HydrationEvent`, `RoutineDomain`, `HydrationChallengeKind`, `HealthKitPermissionViewModel`, `HydrationGoalRecommendationRepositoryImpl`, `BodyProfile`, `DrinkWaterRepository`, `.makeComebackViewModel`, `AccountDomain`, `HealthKitError`, `MockRoutineRepository`, `WatchHydrationViewModel`, `AuthProvider`, `SwiftUI`, `HydrationReminderPermissionViewModel`, `UserCredential`, `RoutineActionIntent`, `WatchHydrationEvent`, `HydrationProgressSnapshot`, `Sendable`, `AppCoordinator`, `String`, `HydrationGoalRecommendationViewModel`, `MockHydrationReminderRepository`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `HydrationInsightViewModel`, `BodyProfileSnapshot`, `HydrationChallengeBadgeHistory`, `HydrationReminderSlot`, `BodyProfileViewModel`, `MainIcon`, `RoutineNotificationAuthorizationStatus`, `HydrationGoalRecommendation`, `BodyProfileUseCaseImpl`, `HydrationGoalRecommendationUseCaseImpl`, `AppReviewRequestState`, `SharedHydrationStoreError`, `WatchHydrationSnapshot`, `UserPreferencesUseCase`, `.shouldRequestAfterSuccessfulHydrationRecord`, `HydrationRoutineAdherenceUseCase`, `AnalyticsUseCase`, `AuthTokens`, `HydrationPresentation`, `SettingsViewModel`, `HealthKitAuthorizationStatus`, `TokenProperty`, `WatchHydrationRepositoryImpl`, `WatchHydrationUseCaseImpl`, `HydrationWriteFailureReason`, `DIEnvironment`, `Error`?**
  _High betweenness centrality (0.072) - this node is a cross-community bridge._
- **Why does `HydrationRoutine` connect `HydrationRoutine` to `HydrationDomain`, `PersonalizedChallengeUseCaseImpl`, `HydrationProgressSnapshot`, `Sendable`, `ProfileRoutineViewModel`, `UUID`, `RoutineNotificationAuthorizationStatus`, `String`, `RoutineWeekday`, `RoutineNotificationDataSourceImpl`, `HydrationChallengeKind`, `HydrationRoutineSchedule`, `.loadChallenges`, `DrinkWaterRepository`, `SpyRoutineUseCase`, `MockRoutineRepository`, `SwiftUI`?**
  _High betweenness centrality (0.040) - this node is a cross-community bridge._
- **Are the 4 inferred relationships involving `DrinkWaterViewModel` (e.g. with `.assemble()` and `.assemble()`) actually correct?**
  _`DrinkWaterViewModel` has 4 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.resolver`, `production`, `preview` to the rest of the system?**
  _459 weakly-connected nodes found - possible documentation gaps or missing edges._