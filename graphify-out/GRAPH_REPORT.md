# Graph Report - mulimi-339-index-snapshot  (2026-09-22)

## Corpus Check
- 377 files · ~170,025 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 23 file(s) not represented in the graph (top: .entitlements 6, .plist 6, (none) 3)

## Summary
- 3654 nodes · 9665 edges · 181 communities (165 shown, 16 thin omitted)
- Extraction: 85% EXTRACTED · 15% INFERRED · 0% AMBIGUOUS · INFERRED: 1428 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- HydrationRoutineAdherenceInsight
- HydrationRecord
- FoundationModelsHydrationGoalRecommendationDataSource.swift
- ProfileRoutineViewModel
- RoutineRepositoryImpl
- HydrationServingPreset
- MockHealthKitRepository
- MockUserPreferencesUseCase
- DrinkWaterView
- DrinkWaterUseCase
- .assemble
- Docs Index
- HydrationEvent
- Layer Responsibilities
- DrinkWaterViewModel
- HydrationDomain
- HydrationChallengeKind
- HealthKitPermissionViewModel
- Color
- MockDrinkWaterUseCase
- HydrationWriteResult
- BodyProfile
- DrinkWaterRepository
- MockDrinkWaterRepository
- .tr
- MockSignInUseCase
- SpyRoutineUseCase
- MockRoutineRepository
- LiquidGlassSegmentedControl
- AnalyticsRepository
- SwiftUI
- HydrationReminderPermissionViewModel
- TokenProperty
- HydrationChallenge
- RecordCalendarView
- DrinkWaterHealthKitDataSource
- HydrationProgressSnapshot
- ChallengeViewModel
- AppCoordinator
- String
- HydrationGoalRecommendationViewModel
- RoutineWeekday
- HKQuantityTypeIdentifier
- MockHydrationReminderRepository
- .body
- RoutineRecommendationUseCaseImpl
- ProfileRoutineView
- DIContainer
- UserDefaults
- HydrationReminderAuthorizationStatus
- HealthKitDataSourceImpl
- HydrationReminderRepositoryImpl
- View
- HydrationInsightViewModel
- TestControl
- BodyProfileViewModel
- UserPreferencesUseCaseImpl
- Foundation
- HydrationChallengeBadgeHistory
- HydrationReminderSlot
- DrinkWaterEntry
- .tr
- .makeRootView
- SignInUseCaseImpl
- LogWaterAppIntent
- ProjectDescription
- Hashable
- UserPreferencesUseCase
- Top 5
- MainIcon
- Test.swift
- UUID
- HydrationRoutine
- HydrationRecordListViewModel
- HydrationGoalRecommendation
- OnboardingView
- HydrationGoalRecommendationCard
- .assemble
- HydrationGoalRecommendationUseCaseImpl
- AppReviewRequestState
- SharedHydrationStoreError
- .makeViewModel
- WatchHydrationSnapshot
- OnboardingViewModel
- .loadChallenges
- HydrationGoalRecommendationUnavailableReason
- AppReviewRequestUseCase
- AGENTS.md Onboarding Map
- Growth Scorecard
- Sendable
- Equatable
- WaterWaveView
- AnalyticsUseCase
- MockHydrationReminderUseCase
- HydrationProgressUseCaseImpl
- .fetchChallenges
- Data Boundary
- HydrationPresentation
- FoundationModelsHydrationGoalRecommendationDataSource
- PersonalizedChallengeUseCaseImpl
- LogWaterAmountOption
- Reliability Recovery
- SettingsViewModel
- HealthKitAuthorizationStatus
- WatchHydrationViewModel
- HydrationReminderPermissionGateView
- HealthKitDataSource
- HydrationReminderNotificationDataSource
- WatchHydrationLocalDataSource.swift
- ConfigurationAppIntent
- SettingsViewModelTests
- DrinkWaterRepositoryImpl
- .weeklyInsightCalculatesRoutineRatesAndMissPattern
- WatchHydrationUseCaseImpl
- MockUserPreferencesRepository
- AI PR Review Workflow
- Mulimi
- UserPreferencesDataSourceImpl
- HydrationGoalRecommendationAvailability
- HydrationComebackRepositoryImpl
- DIEnvironment
- WatchHydrationHealthKitDataSource
- .body
- DrinkWaterWidgetProvider
- ContentState
- BodyProfileSettingView
- Error
- Mulimi Drop — v3
- LogWaterAppShortcuts
- WaterDropShaders.metal
- .resolve
- HydrationNextActionGuide
- MockUserPreferencesUseCase
- Challenge State Model
- MockUserPreferencesUseCaseForTesting
- UserPreferencesRepositoryImpl
- WatchDailyGoalLocalDataSource
- UserPreferencesDataSource
- Accessibility and Dynamic Type Audit
- UserPreferencesRepository
- RoutineNotificationDataSourceImpl
- ci_post_clone.sh
- pre-commit
- MockAppReviewRequestUseCase
- ChallengeStorageDataSourceImpl
- HydrationInsightCategory
- Generation prompts
- check-architecture.sh
- Profile Information Architecture
- lint.sh
- lint-fix.sh
- .progressSnapshot
- .makeComebackViewModel
- HealthKitError
- Test
- RoutineEditorDraft
- .assemble
- AuthProvider
- Mulimi Pull Request Template
- HydrationReminderRepository
- Generation — Mulimi Water Glass v2
- State
- RoutineActionIntent
- ChallengeCategory
- MockAuthenticationRepository
- WatchHydrationMutationResult
- AuthenticationRepository
- WatchDataConstants.swift
- AppTab
- StartTimerIntent
- WatchHydrationRepositoryImpl
- Completed Plan Archive
- HealthQuantityStoreError
- .hasCompletedOnboarding
- CustomHydrationAmountValidation
- RoutinePermissionPrompt
- MockSignInError
- .hydrationEvents
- Bool
- .setDailyWaterLimit

## God Nodes (most connected - your core abstractions)
1. `HydrationDomain` - 108 edges
2. `AccountDomain` - 97 edges
3. `HydrationInsightViewModel` - 95 edges
4. `HydrationRoutine` - 92 edges
5. `DrinkWaterViewModel` - 85 edges
6. `ProfileRoutineViewModel` - 74 edges
7. `RoutineDomain` - 73 edges
8. `HydrationEvent` - 71 edges
9. `MulimiAnalytics` - 69 edges
10. `MockUserPreferencesUseCase` - 63 edges

## Surprising Connections (you probably didn't know these)
- `4. 제어 센터·액션 버튼 기록` --references--> `LogWaterAppIntent`  [INFERRED]
  Docs/feature-discovery.md → Project/App/Sources/AppIntents/LogWaterAppIntent.swift
- `Engineer` --references--> `LogWaterAppIntent`  [INFERRED]
  Docs/feature-discovery.md → Project/App/Sources/AppIntents/LogWaterAppIntent.swift
- `Opportunity` --references--> `HydrationServing`  [INFERRED]
  Docs/feature-discovery.md → Project/Features/Hydration/Domain/Sources/Entity/HydrationServing.swift
- `Release Filter` --references--> `NoOpAnalyticsRepository`  [INFERRED]
  Docs/product-specs/growth-scorecard.md → Project/Core/Analytics/Domain/Sources/Repository/AnalyticsRepository.swift
- `디렉터리와 소유권` --references--> `AppSession`  [INFERRED]
  Docs/project-architecture-and-dependencies.md → Project/Features/Account/Presentation/Sources/State/AppSession.swift

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
Cohesion: 0.13
Nodes (26): MockHydrationRoutineAdherenceUseCase, Calendar, Date, CandidateMatch, Constants, HydrationRoutineAdherenceEvent, HydrationRoutineAdherenceInsight, .adherenceRate (+18 more)

### Community 1 - "HydrationRecord"
Cohesion: 0.10
Nodes (12): Date, MockHealthKitUseCaseForTesting, Bool, Date, HydrationRecord, Date, Double, Date (+4 more)

### Community 3 - "ProfileRoutineViewModel"
Cohesion: 0.09
Nodes (24): ProfileRoutineViewModel, .activeRoutineCount, .canSaveDraft, .displayedRoutines, .editorPermissionGuidance, .guidanceSummary, .hasConfiguredRoutine, .isEditingDraft (+16 more)

### Community 4 - "RoutineRepositoryImpl"
Cohesion: 0.16
Nodes (9): RoutineNotificationDataSource, RoutineStorageDataSource, RoutineRepositoryImpl, Bool, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource, SpyRoutineStorageDataSource, Result (+1 more)

### Community 5 - "HydrationServingPreset"
Cohesion: 0.15
Nodes (14): CaseIterable, HydrationServing, .additionalPresets, HydrationServingPreset, bottle, .id, tumbler, .volumeML (+6 more)

### Community 6 - "MockHealthKitRepository"
Cohesion: 0.13
Nodes (6): HealthKitUseCaseImpl, .authorisationStatus, Date, HealthKitUseCaseTests, MockHealthKitRepository, .authorisationStatus

### Community 7 - "MockUserPreferencesUseCase"
Cohesion: 0.20
Nodes (6): NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, MockUserPreferencesUseCase, Double

### Community 8 - "DrinkWaterView"
Cohesion: 0.10
Nodes (23): AppReviewRequestTaskID, DrinkWaterView, .actionButtons, .appReviewRequestTaskID, .completionText, .defaultDrinkButton, .defaultDrinkButtonAccessibilityLabel, .defaultDrinkButtonBackground (+15 more)

### Community 9 - "DrinkWaterUseCase"
Cohesion: 0.12
Nodes (10): DrinkWaterUseCase, Bool, Date, DateInterval, HydrationRecordEventRow, .body, .sourceText, .timeText (+2 more)

### Community 10 - ".assemble"
Cohesion: 0.11
Nodes (15): Container, Container, RootView, .body, Content, AppSession, Bool, SignInView (+7 more)

### Community 11 - "Docs Index"
Cohesion: 0.10
Nodes (40): PostHog Analytics Consolidation, Documentation SSOT Map, Docs Index, Document Maintenance Rule, Personalized Challenge Strategy, Personalized Challenge Recommendation Candidates, Challenge Recommendation Tier Rules, Analytics Architecture Boundary (+32 more)

### Community 12 - "HydrationEvent"
Cohesion: 0.09
Nodes (18): MockDrinkWaterUseCase, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int, MockDrinkWaterUseCaseForTesting (+10 more)

### Community 13 - "Layer Responsibilities"
Cohesion: 0.18
Nodes (11): CI Lint and Architecture Gate, Lint Workflow, Domain Data Presentation Test Matrix, PR Unit Tests Workflow, SwiftPM Cache Retry, Selected SwiftLint Rule Set, SwiftLint Configuration, Default Validation Sequence (+3 more)

### Community 14 - "DrinkWaterViewModel"
Cohesion: 0.10
Nodes (22): HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, DrinkWaterViewModel, .dailyLimit, .isComebackCardVisible, .isFirstRecordGuideActive (+14 more)

### Community 15 - "HydrationDomain"
Cohesion: 0.10
Nodes (4): ChallengeDomain, HydrationDomain, MulimiAnalytics, RoutineDomain

### Community 16 - "HydrationChallengeKind"
Cohesion: 0.10
Nodes (33): Codable, HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType, streak7, weeklyAchievement80 (+25 more)

### Community 17 - "HealthKitPermissionViewModel"
Cohesion: 0.14
Nodes (11): .body, .permissionView, HealthKitPermissionViewModel, .defaultErrorMessage, .deniedMessage, Bool, HealthKitPermissionViewModelTests, MockHealthKitUseCase (+3 more)

### Community 18 - "Color"
Cohesion: 0.09
Nodes (30): ChallengeBadge, .body, ChallengeCard, .accentColor, .body, .cardBackground, ChallengeHistoryCard, .accentColor (+22 more)

### Community 19 - "MockDrinkWaterUseCase"
Cohesion: 0.11
Nodes (13): Never, HydrationRecordListViewModelTests, RecordSpyWidgetTimelineReloader, MockDrinkWaterUseCase, .currentWaterIntakeML, .hasPendingDrinkWater, Bool, CheckedContinuation (+5 more)

### Community 20 - "HydrationWriteResult"
Cohesion: 0.13
Nodes (10): .analyticsFailureReason, HydrationWriteResult, failure, .failureReason, .isSuccess, success, Bool, Int (+2 more)

### Community 21 - "BodyProfile"
Cohesion: 0.12
Nodes (10): MockHealthKitUseCase, BodyProfile, .isComplete, .isEmpty, BodyProfileSource, healthKit, manual, BodyProfileValue (+2 more)

### Community 22 - "DrinkWaterRepository"
Cohesion: 0.09
Nodes (12): DrinkWaterRepository, Int, HydrationNextActionGuideUseCaseImpl, Calendar, Date, HydrationRoutineAdherenceUseCaseImpl, Calendar, Date (+4 more)

### Community 23 - "MockDrinkWaterRepository"
Cohesion: 0.16
Nodes (10): DrinkWaterUseCaseImpl, .currentWaterIntakeML, Double, DrinkWaterUseCaseTests, MockDrinkWaterRepository, .currentWaterIntakeML, Date, DateInterval (+2 more)

### Community 24 - ".tr"
Cohesion: 0.14
Nodes (19): CVarArg, WatchL10n, Double, Int, WatchMetricRow, .body, WatchNavigationCard, .body (+11 more)

### Community 25 - "MockSignInUseCase"
Cohesion: 0.10
Nodes (9): MockSignInUseCase, Bool, UserCredential, SignInUseCase, MockSignInUseCase, .isAuthenticated, Bool, Error (+1 more)

### Community 26 - "SpyRoutineUseCase"
Cohesion: 0.11
Nodes (14): ProfileRoutineViewModelTests, SpyDrinkWaterUseCase, .currentWaterIntakeML, SpyRoutineRecommendationUseCase, SpyRoutineUseCase, SpyUserPreferencesUseCase, Bool, Calendar (+6 more)

### Community 27 - "MockRoutineRepository"
Cohesion: 0.15
Nodes (9): RoutineUseCaseImpl, RoutineRecommendationUseCaseTests, Calendar, Date, Int, RoutineUseCaseTests, MockRoutineRepository, Error (+1 more)

### Community 28 - "LiquidGlassSegmentedControl"
Cohesion: 0.18
Nodes (14): Binding, Value, .categoryPicker, .categoryPicker, LiquidGlassSegment, .id, LiquidGlassSegmentedControl, .activeSegmentBackground (+6 more)

### Community 29 - "AnalyticsRepository"
Cohesion: 0.14
Nodes (6): Release Filter, AnalyticsRepository, NoOpAnalyticsRepository, ProductAnalyticsEvent, AnalyticsUseCaseImpl, ProductAnalyticsEvent

### Community 30 - "SwiftUI"
Cohesion: 0.08
Nodes (14): ActivityKit, AlarmKit, AppIntents, Charts, CoreGraphics, CryptoKit, DesignSystem, Localization (+6 more)

### Community 31 - "HydrationReminderPermissionViewModel"
Cohesion: 0.10
Nodes (11): HydrationReminderUseCase, Bool, .primingView, Constant, HydrationReminderPermissionViewModel, Bool, HydrationReminderPermissionViewModelTests, MockHydrationReminderUseCase (+3 more)

### Community 32 - "TokenProperty"
Cohesion: 0.05
Nodes (33): ASAuthorization, ASAuthorizationController, ASAuthorizationControllerDelegate, AuthenticationServices, NSObject, AppDelegate, Any, Bool (+25 more)

### Community 33 - "HydrationChallenge"
Cohesion: 0.08
Nodes (16): MockChallengeUseCase, Calendar, Date, MockChallengeUseCaseForTesting, Calendar, Date, HydrationChallenge, .id (+8 more)

### Community 34 - "RecordCalendarView"
Cohesion: 0.08
Nodes (34): GridItem, CalendarDayView, .accessibilityLabel, .backgroundColor, .body, .borderColor, .dayNumber, .progressPercentage (+26 more)

### Community 35 - "DrinkWaterHealthKitDataSource"
Cohesion: 0.15
Nodes (9): DrinkWaterHealthKitDataSource, .currentWaterIntakeML, Calendar, Date, DateInterval, Double, Error, Int (+1 more)

### Community 36 - "HydrationProgressSnapshot"
Cohesion: 0.14
Nodes (18): HydrationProgressSnapshot, Bool, Calendar, Date, Double, Int, HydrationInsightViewModelTests, SpyRoutineUseCase (+10 more)

### Community 37 - "ChallengeViewModel"
Cohesion: 0.06
Nodes (30): MockPersonalizedChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCaseForTesting, Calendar, Date, HydrationChallengeRecommendationSource, recentRecords (+22 more)

### Community 38 - "AppCoordinator"
Cohesion: 0.05
Nodes (27): AnyObject, App · 조립 루트 — 9개, Core — 6개, Features — 18개, Shared — 5개, Tests — 15개, 검증과 갱신, 기능 간 직접 의존에서 주의할 점 (+19 more)

### Community 39 - "String"
Cohesion: 0.07
Nodes (20): .postHogValue, Any, AnalyticsParameterName, AnalyticsParameterValue, bool, double, int, string (+12 more)

### Community 40 - "HydrationGoalRecommendationViewModel"
Cohesion: 0.06
Nodes (34): ContentView, .body, AccountRoute, profileRoutine, setting, SettingMenu, bodyProfile, dailyLimit (+26 more)

### Community 41 - "RoutineWeekday"
Cohesion: 0.07
Nodes (30): MockRoutineRecommendationUseCase, Calendar, Date, Calendar, Date, .localeWeekday, Locale, .nextActionSchedule (+22 more)

### Community 42 - "HKQuantityTypeIdentifier"
Cohesion: 0.17
Nodes (11): HKHealthStore, HKQuantityType, HKQuantityTypeIdentifier, HKUnit, HealthKitQuantityStore, .isHealthDataAvailable, HealthQuantitySample, HealthQuantityStoring (+3 more)

### Community 43 - "MockHydrationReminderRepository"
Cohesion: 0.13
Nodes (7): HydrationReminderUseCaseImpl, Bool, HydrationReminderUseCaseTests, MockHydrationReminderRepository, Bool, Error, Result

### Community 44 - ".body"
Cohesion: 0.14
Nodes (5): Calendar, Date, .body, RoutineEditorView, .body

### Community 45 - "RoutineRecommendationUseCaseImpl"
Cohesion: 0.27
Nodes (8): DaySummary, RoutineRecommendationUseCaseImpl, Bool, Calendar, Date, DateInterval, Double, Int

### Community 46 - "ProfileRoutineView"
Cohesion: 0.19
Nodes (7): ProfileRoutineView, .guidanceCard, .permissionSection, RoutineGuidanceSlotStatus, elapsed, next, upcoming

### Community 47 - "DIContainer"
Cohesion: 0.12
Nodes (12): Assembler, Assembly, DependencyInjection, DIContainer, .resolver, Assembly, DomainAssembly, PresentationAssembly (+4 more)

### Community 48 - "UserDefaults"
Cohesion: 0.12
Nodes (12): RoutineStorageDataSourceImpl, Bool, Double, Int, UserDefaults, .appGroup, .dailyLimit, .glassesOfToday (+4 more)

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.09
Nodes (9): MockHydrationReminderUseCaseForTesting, Bool, HydrationReminderAuthorizationStatus, authorized, denied, notDetermined, HydrationReminderAnalyticsParameterName, .analyticsValue (+1 more)

### Community 50 - "HealthKitDataSourceImpl"
Cohesion: 0.16
Nodes (9): HKAuthorizationStatus, HealthKitDataSourceImpl, .healthKitAuthorizationStatus, .isWaterSharingAuthorized, Bool, Date, Double, Error (+1 more)

### Community 51 - "HydrationReminderRepositoryImpl"
Cohesion: 0.23
Nodes (7): HydrationReminderRepositoryImpl, Bool, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource, Bool, Result

### Community 52 - "View"
Cohesion: 0.07
Nodes (28): CGPoint, BadgeView, .body, HydrationInsightView, .emptyStateCTAButtons, .insightContent, .overviewCard, .routineAdherenceCard (+20 more)

### Community 53 - "HydrationInsightViewModel"
Cohesion: 0.08
Nodes (35): HydrationInsightEmptyCTAModel, HydrationInsightMetric, HydrationInsightViewModel, .canRecordRecoveryDrink, .chartUpperBound, .dailyGoalText, .emptyStateCTAs, .metrics (+27 more)

### Community 54 - "TestControl"
Cohesion: 0.24
Nodes (8): AppIntentControlValueProvider, ControlConfigurationIntent, Provider, ControlWidgetConfiguration, LocalizedStringResource, TestControl, .body, TimerConfiguration

### Community 55 - "BodyProfileViewModel"
Cohesion: 0.08
Nodes (22): MockBodyProfileUseCase, BodyProfileAvailability, incomplete, needsPermission, noData, permissionDenied, ready, BodyProfileSnapshot (+14 more)

### Community 57 - "Foundation"
Cohesion: 0.06
Nodes (12): AccountData, AccountDomain, ChallengeData, Foundation, HydrationData, HydrationReminderData, HydrationReminderDomain, MulimiAnalyticsData (+4 more)

### Community 58 - "HydrationChallengeBadgeHistory"
Cohesion: 0.11
Nodes (13): ChallengeStorageDataSource, ChallengeRepositoryImpl, HydrationChallengeBadgeHistory, Date, ChallengeRepository, ChallengeEvaluation, ChallengeMergeResult, ChallengeUseCaseImpl (+5 more)

### Community 59 - "HydrationReminderSlot"
Cohesion: 0.11
Nodes (14): Constant, HydrationReminderNotificationDataSourceImpl, .notificationCenter, Int, Set, UNUserNotificationCenter, HydrationReminderSlot, afternoon (+6 more)

### Community 60 - "DrinkWaterEntry"
Cohesion: 0.13
Nodes (19): DrinkWaterLockScreenWidgetEntryView, .accentColor, .body, .circularView, .inlineView, .rectangularView, DrinkWaterWidgetEntryView, .accentColor (+11 more)

### Community 61 - ".tr"
Cohesion: 0.09
Nodes (25): Bundle, HealthKitPermissionGateView, .accessCard, .descriptionText, .footnoteText, .headerColor, .headerSection, .headerSystemImage (+17 more)

### Community 62 - ".makeRootView"
Cohesion: 0.14
Nodes (11): AnyView, App, 실행·공유 경계, WatchDIContainer, DrinkWaterApp, .body, Scene, MulimiWatchApp (+3 more)

### Community 63 - "SignInUseCaseImpl"
Cohesion: 0.21
Nodes (4): SignInUseCaseImpl, .isAuthenticated, Bool, SignInUseCaseTests

### Community 64 - "LogWaterAppIntent"
Cohesion: 0.16
Nodes (13): AppIntent, IntentDialog, IntentModes, Constant, FailureReason, LogWaterAppIntent, .resolvedVolumeML, Bool (+5 more)

### Community 65 - "ProjectDescription"
Cohesion: 0.12
Nodes (5): PackageDescription, Plist, ProjectDescription, ProjectDescriptionHelpers, AppVersion

### Community 66 - "Hashable"
Cohesion: 0.13
Nodes (14): Hashable, AppRoute, hydrationLogging, .id, .presentationStyle, profileRoutineAction, NavigationPresentationStyle, fullScreenCover (+6 more)

### Community 67 - "UserPreferencesUseCase"
Cohesion: 0.21
Nodes (5): SystemWidgetTimelineReloader, WidgetTimelineReloading, Double, UserPreferencesUseCase, Calendar

### Community 68 - "Top 5"
Cohesion: 0.14
Nodes (13): 1. 로그인 없이 시작, 2. 7일 스타터 플랜, 3. 알림 바로 기록, 4. 제어 센터·액션 버튼 기록, 5. 컴백 모드, Candidate Ideas, Decision, Engineer (+5 more)

### Community 69 - "MainIcon"
Cohesion: 0.11
Nodes (13): MainIcon, cloud, .`default`, drop, heart, .id, Self, .description (+5 more)

### Community 70 - "Test.swift"
Cohesion: 0.19
Nodes (13): ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, ConfigurationAppIntent, Context, Date (+5 more)

### Community 71 - "UUID"
Cohesion: 0.13
Nodes (8): Bool, Bool, Bool, UUID, Bool, HydrationEventModel, Date, Int

### Community 72 - "HydrationRoutine"
Cohesion: 0.06
Nodes (14): Int, MockRoutineUseCase, Error, Result, MockRoutineUseCaseForTesting, HydrationRoutine, Bool, RoutineNotificationAuthorizationStatus (+6 more)

### Community 73 - "HydrationRecordListViewModel"
Cohesion: 0.09
Nodes (31): HydrationRecordListView, .body, RowListView, .body, Void, .body, .yearMonthPickerSheet, HydrationRecordDaySummary (+23 more)

### Community 74 - "HydrationGoalRecommendation"
Cohesion: 0.40
Nodes (3): HydrationGoalRecommendation, HydrationGoalRecommendationInput, Int

### Community 75 - "OnboardingView"
Cohesion: 0.14
Nodes (15): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+7 more)

### Community 76 - "HydrationGoalRecommendationCard"
Cohesion: 0.29
Nodes (4): HydrationGoalRecommendationCard, .body, .content, Bool

### Community 77 - ".assemble"
Cohesion: 0.14
Nodes (5): Container, HealthKitRepository, BodyProfileUseCaseImpl, Bool, BodyProfileUseCaseTests

### Community 78 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.23
Nodes (7): Constants, HydrationGoalRecommendationUseCaseImpl, Calendar, Date, DateInterval, Int, HydrationGoalRecommendationUseCaseTests

### Community 79 - "AppReviewRequestState"
Cohesion: 0.07
Nodes (25): AppReviewRequestStorageDataSource, AppReviewRequestStorageDataSourceImpl, AppReviewRequestRepositoryImpl, AppReviewRequestStorageDataSourceTests, AppReviewRequestState, Date, Set, AppReviewRequestRepository (+17 more)

### Community 80 - "SharedHydrationStoreError"
Cohesion: 0.19
Nodes (10): ModelConfiguration, ModelContainer, SharedHydrationStore, .isICloudAccountAvailable, SharedHydrationStoreError, .errorDescription, failedToCreateContainer, missingAppGroupContainer (+2 more)

### Community 81 - ".makeViewModel"
Cohesion: 0.23
Nodes (5): MockHydrationGoalRecommendationUseCase, MockHydrationProgressUseCase, HydrationGoalRecommendationViewModelTests, Double, Int

### Community 82 - "WatchHydrationSnapshot"
Cohesion: 0.13
Nodes (14): Date, Int, WatchHydrationEvent, Bool, Date, Double, Int, Self (+6 more)

### Community 83 - "OnboardingViewModel"
Cohesion: 0.19
Nodes (6): Bool, OnboardingViewModel, .canGoBack, .isLastPage, Bool, OnboardingViewModelTests

### Community 84 - ".loadChallenges"
Cohesion: 0.28
Nodes (8): ChallengeViewModelTests, Calendar, MockChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCase, Calendar, Date

### Community 85 - "HydrationGoalRecommendationUnavailableReason"
Cohesion: 0.13
Nodes (11): HydrationGoalRecommendationDataSource, HydrationGoalRecommendationRepositoryImpl, HydrationGoalRecommendationUnavailableReason, appleIntelligenceNotEnabled, deviceNotEligible, modelNotReady, unknown, unsupportedLocale (+3 more)

### Community 86 - "AppReviewRequestUseCase"
Cohesion: 0.30
Nodes (6): AppReviewRequestUseCase, NoOpAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 87 - "AGENTS.md Onboarding Map"
Cohesion: 0.11
Nodes (23): Quality Gates, Truthful Validation Reporting, Validation Baseline, Validation Matrix, architecture-boundary, Clean Architecture and MVVM, Domain Purity, ViewModel Side Effect Boundary (+15 more)

### Community 88 - "Growth Scorecard"
Cohesion: 0.12
Nodes (16): 72-Hour Audit, Before Release, Cadence And Ownership, Decision Rule, Deferred Scope, Experiment Record, Goal, Growth Scorecard (+8 more)

### Community 89 - "Sendable"
Cohesion: 0.05
Nodes (31): MockHydrationNextActionGuideUseCase, Calendar, Date, MockHydrationProgressUseCase, Calendar, Date, MockHydrationNextActionGuideUseCaseForTesting, Calendar (+23 more)

### Community 90 - "Equatable"
Cohesion: 0.21
Nodes (15): Equatable, Identifiable, PersonalizedChallengeCardModel, HydrationServingOptionModel, RoutineAdherenceDisplayRow, HydrationRoutineAdherenceStatus, inactive, needsAttention (+7 more)

### Community 91 - "WaterWaveView"
Cohesion: 0.28
Nodes (6): CGRect, Path, CGFloat, WaterWaveView, .animatableData, Shape

### Community 92 - "AnalyticsUseCase"
Cohesion: 0.12
Nodes (5): AnalyticsUseCase, NoOpAnalyticsUseCase, ProductAnalyticsEvent, HealthKitUseCase, Date

### Community 93 - "MockHydrationReminderUseCase"
Cohesion: 0.22
Nodes (4): MockHydrationReminderUseCase, Bool, Error, Result

### Community 94 - "HydrationProgressUseCaseImpl"
Cohesion: 0.30
Nodes (9): Date, DateInterval, HydrationProgressUseCaseImpl, StreakProgress, Calendar, Date, DateInterval, Double (+1 more)

### Community 95 - ".fetchChallenges"
Cohesion: 0.35
Nodes (5): Calendar, ChallengeUseCaseTests, Calendar, Int, MockChallengeRepository

### Community 96 - "Data Boundary"
Cohesion: 0.12
Nodes (17): Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling, Data Boundary, Health Data Minimization, PostHog Privacy Controls (+9 more)

### Community 97 - "HydrationPresentation"
Cohesion: 0.12
Nodes (9): AccountPresentation, ChallengePresentation, HydrationPresentation, HydrationReminderPresentation, MulimiNavigation, MulimiPlatform, PreviewAssembly, RoutinePresentation (+1 more)

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
Nodes (18): AppInfoProviding, BundleAppInfoProvider, .appBuildNumber, .appVersion, StaticAppInfoProvider, MainIconSettingView, .body, .body (+10 more)

### Community 103 - "HealthKitAuthorizationStatus"
Cohesion: 0.26
Nodes (6): HealthKitAuthorizationStatus, notDetermined, sharingAuthorized, sharingDenied, .analyticsValue, ProductAnalyticsEvent

### Community 104 - "WatchHydrationViewModel"
Cohesion: 0.18
Nodes (8): MutationAction, record, reset, Bool, Date, Sendable, WatchHydrationViewModel, .canDrinkWater

### Community 105 - "HydrationReminderPermissionGateView"
Cohesion: 0.32
Nodes (6): HydrationReminderPermissionGateView, .allowButtonLabel, .benefitCard, .body, .headerSection, Content

### Community 106 - "HealthKitDataSource"
Cohesion: 0.19
Nodes (4): HealthKitDataSource, HealthKitRepositoryImpl, .authorisationStatus, Date

### Community 107 - "HydrationReminderNotificationDataSource"
Cohesion: 0.18
Nodes (4): HydrationReminderNotificationDataSource, HydrationReminderStorageDataSource, HydrationReminderStorageDataSourceImpl, Bool

### Community 108 - "WatchHydrationLocalDataSource.swift"
Cohesion: 0.18
Nodes (6): HealthKit, MulimiHealthKit, OSLog, WatchHydrationData, WatchHydrationDomain, WatchHydrationPresentation

### Community 109 - "ConfigurationAppIntent"
Cohesion: 0.18
Nodes (9): IntentDescription, ConfigurationAppIntent, .description, .title, LocalizedStringResource, ConfigurationAppIntent, IntentResult, LocalizedStringResource (+1 more)

### Community 110 - "SettingsViewModelTests"
Cohesion: 0.20
Nodes (10): LocalizedError, MockError, .errorDescription, signInFailed, MockError, deleteFailed, .errorDescription, MockError (+2 more)

### Community 111 - "DrinkWaterRepositoryImpl"
Cohesion: 0.13
Nodes (8): DrinkWaterDataSource, DrinkWaterRepositoryImpl, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int

### Community 112 - ".weeklyInsightCalculatesRoutineRatesAndMissPattern"
Cohesion: 0.47
Nodes (4): HydrationRoutineAdherenceUseCaseTests, Calendar, Date, Int

### Community 113 - "WatchHydrationUseCaseImpl"
Cohesion: 0.16
Nodes (9): Int, WatchDailyGoalRepository, Date, Int, WatchHydrationRepository, Date, Double, Int (+1 more)

### Community 114 - "MockUserPreferencesRepository"
Cohesion: 0.23
Nodes (3): MockUserPreferencesRepository, Bool, Double

### Community 115 - "AI PR Review Workflow"
Cohesion: 0.18
Nodes (12): AI PR Review Workflow, Architecture Review Policy, Bounded AI Review Diff, Git Flow PR Filter, Textual Diff Selection, Clean Architecture and MVVM Discipline, Domain Purity, Hydration Source of Truth (+4 more)

### Community 116 - "Mulimi"
Cohesion: 0.16
Nodes (20): Agent Onboarding Guide, Graphify-Assisted Code Navigation, Mulimi Architecture SSOT, Core User Flow, Claude Agent Entrypoint, Delivery Workflow, Git Flow Delivery Strategy, Issue Closure Policy (+12 more)

### Community 117 - "UserPreferencesDataSourceImpl"
Cohesion: 0.16
Nodes (7): Double, NSUbiquitousKeyValueStore, SyncedValueStoring, UbiquitousMirroredStore, Constants, NSUbiquitousKeyValueStore, UserPreferencesDataSourceImpl

### Community 118 - "HydrationGoalRecommendationAvailability"
Cohesion: 0.14
Nodes (12): MockHydrationGoalRecommendationUseCase, Date, Error, HydrationGoalRecommendationAvailability, bodyProfileRequired, modelUnavailable, ready, HydrationGoalRecommendationUseCase (+4 more)

### Community 119 - "HydrationComebackRepositoryImpl"
Cohesion: 0.43
Nodes (3): HydrationComebackRepositoryImpl, Date, HydrationComebackRepositoryTests

### Community 120 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 121 - "WatchHydrationHealthKitDataSource"
Cohesion: 0.20
Nodes (8): Bool, Calendar, Date, DateInterval, Error, Int, WatchHydrationHealthKitDataSource, WatchHydrationLocalDataSource

### Community 122 - ".body"
Cohesion: 0.13
Nodes (4): .body, .overflowMenu, Calendar, Date

### Community 123 - "DrinkWaterWidgetProvider"
Cohesion: 0.27
Nodes (6): AppIntentTimelineProvider, DrinkWaterWidgetProvider, ConfigurationAppIntent, Context, Date, Timeline

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (7): ActivityAttributes, ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 125 - "BodyProfileSettingView"
Cohesion: 0.31
Nodes (5): BodyProfileSettingView, .body, .healthSyncCard, .summaryCard, Void

### Community 126 - "Error"
Cohesion: 0.11
Nodes (16): Error, AuthenticationError, cancelled, invalidCredential, networkFailed, serverError, unknown, TestError (+8 more)

### Community 127 - "Mulimi Drop — v3"
Cohesion: 0.17
Nodes (10): Generation and editing — Mulimi Drop v3, Original body layer prompt, Original face layer prompt, Original master prompt, Mulimi Drop — v3, 레이어, 배경과 외관, 앱 적용 (+2 more)

### Community 128 - "LogWaterAppShortcuts"
Cohesion: 0.29
Nodes (6): AppShortcut, AppShortcutsProvider, LogWaterAppShortcuts, .appShortcuts, .shortcutTileColor, ShortcutTileColor

### Community 129 - "WaterDropShaders.metal"
Cohesion: 0.43
Nodes (6): float2, half4, metal_stdlib, mulimiWaterDistortion(), mulimiWaterLighting(), mulimiWaveNoise()

### Community 130 - ".resolve"
Cohesion: 0.43
Nodes (6): PreviewViews, .challenge, .drinkWater, .hydrationList, .profile, Service

### Community 131 - "HydrationNextActionGuide"
Cohesion: 0.17
Nodes (17): Constants, HydrationNextActionGuide, .progress, HydrationNextActionGuideState, approachingRoutine, goalReached, needsGoal, readyToDrink (+9 more)

### Community 132 - "MockUserPreferencesUseCase"
Cohesion: 0.21
Nodes (3): MockUserPreferencesUseCase, Bool, Double

### Community 133 - "Challenge State Model"
Cohesion: 0.50
Nodes (5): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Legacy Challenge State Migration, Recurring Challenge State

### Community 134 - "MockUserPreferencesUseCaseForTesting"
Cohesion: 0.21
Nodes (3): MockUserPreferencesUseCaseForTesting, Bool, Double

### Community 135 - "UserPreferencesRepositoryImpl"
Cohesion: 0.28
Nodes (3): Bool, Double, UserPreferencesRepositoryImpl

### Community 136 - "WatchDailyGoalLocalDataSource"
Cohesion: 0.21
Nodes (7): MulimiCloudKit, Int, NSUbiquitousKeyValueStore, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, Int, WatchDailyGoalRepositoryImpl

### Community 137 - "UserPreferencesDataSource"
Cohesion: 0.20
Nodes (3): Bool, Double, UserPreferencesDataSource

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "UserPreferencesRepository"
Cohesion: 0.20
Nodes (3): Bool, Double, UserPreferencesRepository

### Community 140 - "RoutineNotificationDataSourceImpl"
Cohesion: 0.18
Nodes (8): Alarm, AlarmManager, AlarmMetadata, AlarmPresentation, Constant, RoutineAlarmMetadata, RoutineNotificationDataSourceImpl, LocalizedStringResource

### Community 143 - "MockAppReviewRequestUseCase"
Cohesion: 0.48
Nodes (5): MockAppReviewRequestUseCase, Bool, Calendar, Date, Double

### Community 145 - "HydrationInsightCategory"
Cohesion: 0.22
Nodes (9): HydrationInsightCategory, .id, overview, pattern, report, routine, .systemImage, .title (+1 more)

### Community 146 - "Generation prompts"
Cohesion: 0.18
Nodes (9): body, cheeks, face, Generation prompts, Master, Mulimi Liquid Glass 아이콘 — #339, v1, 미리보기와 확인, 사용 (+1 more)

### Community 148 - "Profile Information Architecture"
Cohesion: 0.67
Nodes (4): Goal Recommendation Entry Rules, Profile Information Architecture, Profile Root, Settings Screen

### Community 151 - ".progressSnapshot"
Cohesion: 0.40
Nodes (4): HydrationProgressUseCaseTests, Calendar, Date, Int

### Community 152 - ".makeComebackViewModel"
Cohesion: 0.12
Nodes (12): HydrationComebackRepository, Date, .nextActionSummary, HydrationComebackMode, baseline, card, disabled, StubHydrationComebackRepository (+4 more)

### Community 153 - "HealthKitError"
Cohesion: 0.33
Nodes (5): HealthKitError, healthKitInternalError, incompleteExecuteQuery, invalidObjectType, permissionDenied

### Community 154 - "Test"
Cohesion: 0.10
Nodes (23): ControlWidget, WidgetConfiguration, Test, Widget, TestBundle, .body, WidgetConfiguration, TestLiveActivity (+15 more)

### Community 155 - "RoutineEditorDraft"
Cohesion: 0.31
Nodes (7): .weekdayGrid, RoutineEditorDraft, .canSave, .isEditing, Bool, Date, Set

### Community 156 - ".assemble"
Cohesion: 0.22
Nodes (4): DataAssembly, Container, PostHogAnalyticsRepository, ProductAnalyticsEvent

### Community 157 - "AuthProvider"
Cohesion: 0.40
Nodes (4): AuthProvider, apple, google, kakao

### Community 158 - "Mulimi Pull Request Template"
Cohesion: 0.50
Nodes (4): Local Validation Reporting, Mulimi Pull Request Template, PR Review Checklist, Truthful Validation Reporting

### Community 160 - "Generation — Mulimi Water Glass v2"
Cohesion: 0.25
Nodes (6): droplet, Generation — Mulimi Water Glass v2, glass, Master, water, Mulimi — Water Glass v2

### Community 161 - "State"
Cohesion: 0.25
Nodes (6): State, bodyProfileRequired, idle, loading, modelUnavailable, ready

### Community 162 - "RoutineActionIntent"
Cohesion: 0.11
Nodes (17): .id, Bool, HydrationInsightEmptyAction, dailyGoal, record, routine, HydrationWeeklyCoachingAction, dailyGoal (+9 more)

### Community 163 - "ChallengeCategory"
Cohesion: 0.25
Nodes (8): ChallengeCategory, completed, .id, inProgress, recommended, .systemImage, .title, Self

### Community 164 - "MockAuthenticationRepository"
Cohesion: 0.25
Nodes (4): MockAuthenticationRepository, .isAuthenticated, Bool, Error

### Community 165 - "WatchHydrationMutationResult"
Cohesion: 0.36
Nodes (3): WatchHydrationMutationResult, Date, WatchHydrationUseCase

### Community 168 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, challenge, drink, history, insight, profile

### Community 169 - "StartTimerIntent"
Cohesion: 0.33
Nodes (4): StartTimerIntent, Bool, IntentResult, SetValueIntent

### Community 170 - "WatchHydrationRepositoryImpl"
Cohesion: 0.47
Nodes (3): Date, Int, WatchHydrationRepositoryImpl

### Community 171 - "Completed Plan Archive"
Cohesion: 0.40
Nodes (5): Stale Document Handling, Active Exec Plans, Active Plan Lifecycle, Completed Exec Plans, Completed Plan Archive

### Community 172 - "HealthQuantityStoreError"
Cohesion: 0.40
Nodes (5): HealthQuantityStoreError, incompleteQuery, internalError, invalidObjectType, permissionDenied

### Community 174 - "CustomHydrationAmountValidation"
Cohesion: 0.40
Nodes (5): CustomHydrationAmountValidation, empty, invalid, overLimit, valid

### Community 175 - "RoutinePermissionPrompt"
Cohesion: 0.40
Nodes (5): RoutinePermissionPrompt, .id, openSettings, requestAuthorization, scheduleFailure

### Community 176 - "MockSignInError"
Cohesion: 0.67
Nodes (3): MockSignInError, deleteAccountFailed, signInFailed

## Ambiguous Edges - Review These
- `HealthKit Source of Truth` → `CloudKit-Backed Hydration Store`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to
- `CloudKit-Backed Hydration Store` → `Current Storage Strategy`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to

## Knowledge Gaps
- **493 isolated node(s):** `.resolver`, `production`, `preview`, `testing`, `.current` (+488 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 928 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **16 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `HealthKit Source of Truth` and `CloudKit-Backed Hydration Store`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `Current Storage Strategy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `String` connect `String` to `HydrationRoutineAdherenceInsight`, `HydrationRecord`, `ProfileRoutineViewModel`, `HydrationServingPreset`, `DrinkWaterView`, `DrinkWaterUseCase`, `.assemble`, `DrinkWaterViewModel`, `HydrationChallengeKind`, `HealthKitPermissionViewModel`, `Color`, `MockDrinkWaterUseCase`, `HydrationWriteResult`, `BodyProfile`, `.tr`, `MockSignInUseCase`, `LiquidGlassSegmentedControl`, `AnalyticsRepository`, `HydrationReminderPermissionViewModel`, `TokenProperty`, `HydrationChallenge`, `RecordCalendarView`, `ChallengeViewModel`, `HydrationGoalRecommendationViewModel`, `RoutineWeekday`, `HKQuantityTypeIdentifier`, `ProfileRoutineView`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `View`, `HydrationInsightViewModel`, `TestControl`, `BodyProfileViewModel`, `HydrationChallengeBadgeHistory`, `HydrationReminderSlot`, `DrinkWaterEntry`, `.tr`, `LogWaterAppIntent`, `ProjectDescription`, `Hashable`, `MainIcon`, `UUID`, `HydrationRoutine`, `HydrationRecordListViewModel`, `HydrationGoalRecommendation`, `OnboardingView`, `HydrationGoalRecommendationCard`, `AppReviewRequestState`, `SharedHydrationStoreError`, `AppReviewRequestUseCase`, `Equatable`, `.fetchChallenges`, `FoundationModelsHydrationGoalRecommendationDataSource`, `LogWaterAmountOption`, `SettingsViewModel`, `HealthKitAuthorizationStatus`, `WatchHydrationViewModel`, `HydrationReminderPermissionGateView`, `ConfigurationAppIntent`, `SettingsViewModelTests`, `UserPreferencesDataSourceImpl`, `ContentState`, `BodyProfileSettingView`, `Error`, `HydrationNextActionGuide`, `MockUserPreferencesUseCase`, `MockUserPreferencesUseCaseForTesting`, `RoutineNotificationDataSourceImpl`, `MockAppReviewRequestUseCase`, `ChallengeStorageDataSourceImpl`, `HydrationInsightCategory`, `.progressSnapshot`, `.makeComebackViewModel`, `Test`, `RoutineEditorDraft`, `.assemble`, `RoutineActionIntent`, `ChallengeCategory`, `StartTimerIntent`, `RoutinePermissionPrompt`?**
  _High betweenness centrality (0.316) - this node is a cross-community bridge._
- **Why does `프로젝트 전체 구조와 의존성` connect `AppCoordinator` to `Mulimi`, `.makeRootView`?**
  _High betweenness centrality (0.086) - this node is a cross-community bridge._
- **Why does `실행·공유 경계` connect `.makeRootView` to `HydrationNextActionGuide`, `HydrationWriteResult`, `HydrationServingPreset`, `AppCoordinator`?**
  _High betweenness centrality (0.069) - this node is a cross-community bridge._
- **What connects `.resolver`, `production`, `preview` to the rest of the system?**
  _493 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `HydrationRoutineAdherenceInsight` be split into smaller, more focused modules?**
  _Cohesion score 0.12513842746400886 - nodes in this community are weakly interconnected._