# Graph Report - Mulimi  (2026-09-27)

## Corpus Check
- 397 files · ~179,643 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 22 file(s) not represented in the graph (top: .entitlements 6, .plist 5, (none) 3)

## Summary
- 3893 nodes · 10213 edges · 185 communities (173 shown, 12 thin omitted)
- Extraction: 85% EXTRACTED · 15% INFERRED · 0% AMBIGUOUS · INFERRED: 1482 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `88dcc3d7`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- HydrationRoutineAdherenceInsight
- SettingsViewModel
- AppDelegate.swift
- ProfileRoutineViewModel
- HydrationRoutine
- BodyProfileViewModel
- MockHealthKitRepository
- MockUserPreferencesUseCase
- .tr
- HKQuantityTypeIdentifier
- .assemble
- Docs Index
- HydrationStarterPlanViewModel
- DrinkWaterUseCase
- DrinkWaterViewModel
- RoutineDomain
- Identifiable
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
- StartTimerIntent
- PostHogAnalyticsRepository
- Localization
- HydrationReminderPermissionViewModel
- SignInUseCaseImpl
- ChallengeViewModel
- RecordCalendarView
- HealthKitSource
- HydrationProgressSnapshot
- PersonalizedHydrationChallengeKind
- StackRouting
- String
- HydrationGoalRecommendationViewModel
- .guidanceSummary
- WatchHydrationHealthKitDataSource
- MockHydrationReminderRepository
- HydrationPresentation
- UUID
- ProfileRoutineView
- DataAssembly.swift
- UserDefaults
- HydrationReminderAuthorizationStatus
- .loadInsights
- HydrationReminderRepositoryImpl
- HydrationInsightView
- HydrationInsightViewModel
- OnboardingViewModel
- BodyProfileSnapshot
- DrinkWaterHealthKitDataSource
- StaticAppInfoProvider
- HydrationChallengeBadgeHistory
- HydrationReminderSlot
- DrinkWaterEntry
- AppReviewRequestState
- 실행·공유 경계
- MockSignInUseCase
- LogWaterAppIntent
- ProjectDescription
- .assemble
- ContentView
- Top 5
- MainIcon
- Test.swift
- #329 빠른 물 기록 가이드 제작·발행
- RoutineNotificationAuthorizationStatus
- HydrationRecordListViewModel
- HydrationGoalRecommendationUnavailableReason
- OnboardingView
- View
- Growth Scorecard
- HydrationGoalRecommendationUseCaseImpl
- ChallengeUseCase
- WatchHydrationRepositoryImpl
- MockUserPreferencesRepository
- WatchHydrationSnapshot
- MockHydrationRoutineAdherenceUseCase
- .loadChallenges
- HydrationReminderNotificationDataSource
- MockAppReviewRequestUseCase
- Mulimi Drop — v3
- LiquidGlassSegmentedControl
- AnalyticsUseCase
- AppDelegate
- WatchHydrationViewModel
- 프로젝트 전체 구조와 의존성
- HydrationGoalRecommendationAvailability
- HydrationProgressUseCaseImpl
- fix-icon-composer-file-types.py
- Security And Privacy Operations
- Foundation
- .init
- PersonalizedChallengeUseCaseImpl
- LogWaterAmountOption
- AGENTS.md Onboarding Map
- DrinkWaterWidgetProvider
- HealthKitAuthorizationStatus
- Sendable
- HydrationRecord
- WaterDropView
- HydrationServing
- Generation prompts
- ConfigurationAppIntent
- MockUserPreferencesUseCase
- DrinkWaterRepositoryImpl
- .weeklyInsightCalculatesRoutineRatesAndMissPattern
- WatchHydrationUseCaseImpl
- AppRoute
- FoundationModelsHydrationGoalRecommendationDataSource
- AI PR Review Workflow
- UserPreferencesDataSourceImpl
- TokenProperty
- .makeViewModel
- DIEnvironment
- HealthKitDataSource
- HydrationReminderActionResult
- HydrationGoalRecommendation
- ContentState
- 아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법
- Error
- HydrationWriteResult
- .save
- WaterDropShaders.metal
- .resolve
- HydrationNextActionGuide
- #320 — 7일 스타터 플랜 제품 적용
- Mulimi
- RoutineWeekday
- UserPreferencesRepositoryImpl
- WatchDailyGoalLocalDataSource
- InsightCard
- Accessibility and Dynamic Type Audit
- HealthKitRepository
- HydrationWeeklyReportTimeSlot
- ci_post_clone.sh
- pre-commit
- Equatable
- Assembly
- .drinkWater
- ChallengeStorageDataSource
- check-architecture.sh
- ChallengeStorageDataSourceImpl
- lint.sh
- lint-fix.sh
- AnalyticsUseCaseImpl
- MockAnalyticsUseCase
- CustomHydrationAmountValidation
- Test
- Challenge State Model
- ChallengeCategory
- AuthProvider
- Mulimi Pull Request Template
- .makeModelContainer
- Generation — Mulimi Water Glass v2
- WatchHydrationEvent
- RoutinePermissionPrompt
- .hasCompletedOnboarding
- Reliability Recovery
- #321 수분 알림 바로 기록
- WatchDataConstants.swift
- HydrationRecordPeriod
- UserPreferencesRepository
- Hashable
- .recordWater
- WaterWaveView
- Color
- Clean Architecture and MVVM
- CI Lint and Architecture Gate
- .progressSnapshot
- HealthKitDataSourceImpl
- HydrationRoutineAdherenceStatus
- MockHydrationProgressUseCase
- MockHydrationProgressUseCaseForTesting
- State
- LogWaterAppShortcuts
- HealthKitError
- Completed Plan Archive
- HealthQuantityStoreError

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
- `생성 검증 결과` --references--> `AppDelegate`  [INFERRED]
  Docs/project-architecture-and-dependencies.md → Project/App/Sources/AppDelegate.swift

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

## Communities (185 total, 12 thin omitted)

### Community 0 - "HydrationRoutineAdherenceInsight"
Cohesion: 0.19
Nodes (19): CandidateMatch, Constants, HydrationRoutineAdherenceInsight, .adherenceRate, .bestRoutine, .bestTimeSlot, .hasDueOccurrences, .mostMissedTimeSlot (+11 more)

### Community 1 - "SettingsViewModel"
Cohesion: 0.10
Nodes (18): SettingMenu, bodyProfile, dailyLimit, .id, mainIcon, withdrawal, Self, .body (+10 more)

### Community 2 - "AppDelegate.swift"
Cohesion: 0.12
Nodes (8): HealthKit, HydrationReminderData, MulimiHealthKit, OSLog, UserNotifications, WatchHydrationData, WatchHydrationDomain, WatchHydrationPresentation

### Community 3 - "ProfileRoutineViewModel"
Cohesion: 0.07
Nodes (26): .body, RoutineEditorView, .body, .weekdayGrid, ProfileRoutineViewModel, .canSaveDraft, .displayedRoutines, .editorPermissionGuidance (+18 more)

### Community 4 - "HydrationRoutine"
Cohesion: 0.09
Nodes (16): RoutineNotificationDataSource, RoutineStorageDataSource, RoutineStorageDataSourceImpl, RoutineRepositoryImpl, Bool, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource, SpyRoutineStorageDataSource (+8 more)

### Community 5 - "BodyProfileViewModel"
Cohesion: 0.18
Nodes (8): BodyProfileViewModel, .availabilityState, .heightSourceText, .helperText, .resolvedWeightText, .summaryText, .weightSourceText, BodyProfileViewModelTests

### Community 6 - "MockHealthKitRepository"
Cohesion: 0.13
Nodes (7): HealthKitUseCaseImpl, .authorisationStatus, Date, HealthKitUseCaseTests, MockHealthKitRepository, .authorisationStatus, Date

### Community 7 - "MockUserPreferencesUseCase"
Cohesion: 0.18
Nodes (7): NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, MockUserPreferencesUseCase, Bool, Double

### Community 8 - ".tr"
Cohesion: 0.06
Nodes (43): Bundle, .body, HealthKitPermissionGateView, .accessCard, .descriptionText, .footnoteText, .headerColor, .headerSection (+35 more)

### Community 9 - "HKQuantityTypeIdentifier"
Cohesion: 0.32
Nodes (5): HKHealthStore, HKQuantityType, HKQuantityTypeIdentifier, HealthKitQuantityStore, .isHealthDataAvailable

### Community 10 - ".assemble"
Cohesion: 0.13
Nodes (13): Container, Container, RootView, .body, Content, AppSession, Bool, SignInView (+5 more)

### Community 11 - "Docs Index"
Cohesion: 0.10
Nodes (40): PostHog Analytics Consolidation, Documentation SSOT Map, Docs Index, Document Maintenance Rule, Personalized Challenge Strategy, Personalized Challenge Recommendation Candidates, Challenge Recommendation Tier Rules, Analytics Architecture Boundary (+32 more)

### Community 12 - "HydrationStarterPlanViewModel"
Cohesion: 0.05
Nodes (34): PreviewStarterPlanRepository, HydrationStarterPlanRepositoryImpl, HydrationStarterPlanRepositoryTests, Bool, HydrationQuickRecordingMethod, shortcuts, watch, widget (+26 more)

### Community 13 - "DrinkWaterUseCase"
Cohesion: 0.08
Nodes (15): SystemWidgetTimelineReloader, WidgetTimelineReloading, Double, UserPreferencesUseCase, DrinkWaterUseCase, HydrationReminderLogResult, failed, goalExceeded (+7 more)

### Community 14 - "DrinkWaterViewModel"
Cohesion: 0.07
Nodes (23): Bool, .body, DrinkWaterViewModel, .dailyLimit, .isComebackCardVisible, .isFirstRecordGuideActive, .isLimitReached, .mililiters (+15 more)

### Community 15 - "RoutineDomain"
Cohesion: 0.14
Nodes (4): ChallengeDomain, MulimiAnalytics, PostHog, RoutineDomain

### Community 16 - "Identifiable"
Cohesion: 0.10
Nodes (35): Codable, Identifiable, HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType, streak7 (+27 more)

### Community 17 - "HealthKitPermissionViewModel"
Cohesion: 0.14
Nodes (11): .body, .permissionView, HealthKitPermissionViewModel, .defaultErrorMessage, .deniedMessage, Bool, HealthKitPermissionViewModelTests, MockHealthKitUseCase (+3 more)

### Community 18 - "RoutineActionIntent"
Cohesion: 0.13
Nodes (18): .id, ChallengeSectionHeader, .body, ChallengeView, .body, .challengeContent, .completedCategorySection, .emptyCardBackground (+10 more)

### Community 19 - "MockDrinkWaterUseCase"
Cohesion: 0.10
Nodes (14): Never, HydrationRecordListViewModelTests, RecordSpyWidgetTimelineReloader, MockDrinkWaterUseCase, .currentWaterIntakeML, .hasPendingDrinkWater, Bool, CheckedContinuation (+6 more)

### Community 20 - "HydrationEvent"
Cohesion: 0.07
Nodes (20): MockDrinkWaterUseCase, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int, MockDrinkWaterUseCaseForTesting (+12 more)

### Community 21 - "BodyProfile"
Cohesion: 0.11
Nodes (12): MockHealthKitUseCase, Date, BodyProfile, .isComplete, .isEmpty, BodyProfileSource, healthKit, manual (+4 more)

### Community 22 - "DrinkWaterRepository"
Cohesion: 0.07
Nodes (15): Container, DrinkWaterRepository, Bool, Double, Int, HydrationNextActionGuideUseCaseImpl, Calendar, Date (+7 more)

### Community 23 - "MockDrinkWaterRepository"
Cohesion: 0.10
Nodes (16): DrinkWaterUseCaseImpl, .currentWaterIntakeML, Bool, Date, DateInterval, Double, DrinkWaterUseCaseTests, ReminderLoggingTests (+8 more)

### Community 24 - ".tr"
Cohesion: 0.14
Nodes (19): CVarArg, WatchL10n, Double, Int, WatchMetricRow, .body, WatchNavigationCard, .body (+11 more)

### Community 26 - "SpyRoutineUseCase"
Cohesion: 0.10
Nodes (14): ProfileRoutineViewModelTests, SpyDrinkWaterUseCase, .currentWaterIntakeML, SpyRoutineRecommendationUseCase, SpyRoutineUseCase, SpyUserPreferencesUseCase, Bool, Calendar (+6 more)

### Community 27 - "MockRoutineRepository"
Cohesion: 0.09
Nodes (10): RoutineRepository, RoutineUseCaseImpl, RoutineRecommendationUseCaseTests, Calendar, Date, Int, RoutineUseCaseTests, MockRoutineRepository (+2 more)

### Community 28 - "StartTimerIntent"
Cohesion: 0.15
Nodes (12): AppIntentControlValueProvider, ControlConfigurationIntent, Provider, StartTimerIntent, Bool, ControlWidgetConfiguration, IntentResult, LocalizedStringResource (+4 more)

### Community 30 - "Localization"
Cohesion: 0.08
Nodes (14): ActivityKit, AlarmKit, AppIntents, Charts, CoreGraphics, CryptoKit, DesignSystem, Localization (+6 more)

### Community 31 - "HydrationReminderPermissionViewModel"
Cohesion: 0.10
Nodes (11): HydrationReminderUseCase, Bool, .primingView, Constant, HydrationReminderPermissionViewModel, Bool, HydrationReminderPermissionViewModelTests, MockHydrationReminderUseCase (+3 more)

### Community 32 - "SignInUseCaseImpl"
Cohesion: 0.11
Nodes (9): AuthenticationRepository, SignInUseCaseImpl, .isAuthenticated, Bool, SignInUseCaseTests, MockAuthenticationRepository, .isAuthenticated, Bool (+1 more)

### Community 33 - "ChallengeViewModel"
Cohesion: 0.07
Nodes (23): MockPersonalizedChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCaseForTesting, Calendar, Date, HydrationChallenge, .id (+15 more)

### Community 34 - "RecordCalendarView"
Cohesion: 0.06
Nodes (42): GridItem, CalendarDayView, .accessibilityLabel, .backgroundColor, .body, .borderColor, .dayNumber, .progressPercentage (+34 more)

### Community 35 - "HealthKitSource"
Cohesion: 0.15
Nodes (7): HealthKitSource, ReminderHealthKitWriteTests, Bool, Date, Double, Error, Int

### Community 36 - "HydrationProgressSnapshot"
Cohesion: 0.23
Nodes (10): HydrationProgressSnapshot, HydrationInsightViewModelTests, SpyRoutineUseCase, Calendar, Date, Int, MockDrinkWaterUseCase, MockHydrationRoutineAdherenceUseCase (+2 more)

### Community 37 - "PersonalizedHydrationChallengeKind"
Cohesion: 0.14
Nodes (14): HydrationChallengeRecommendationSource, recentRecords, routine, HydrationChallengeTier, beginner, steady, stretch, PersonalizedHydrationChallengeKind (+6 more)

### Community 38 - "StackRouting"
Cohesion: 0.09
Nodes (11): AnyObject, FullScreenRoute, DeepLinkHandling, URL, FullScreenRouting, SheetRouting, StackRouting, .hasPath (+3 more)

### Community 39 - "String"
Cohesion: 0.10
Nodes (18): .postHogValue, Any, AnalyticsParameterName, AnalyticsParameterValue, bool, double, int, string (+10 more)

### Community 40 - "HydrationGoalRecommendationViewModel"
Cohesion: 0.09
Nodes (21): DailyLimitSettingView, .body, HydrationProgressUseCase, Calendar, Date, EntryDestination, bodyProfileSetting, dailyLimitSetting (+13 more)

### Community 41 - ".guidanceSummary"
Cohesion: 0.19
Nodes (9): .guidanceSummary, RoutineGuidanceMetric, RoutineGuidanceSummary, RoutineGuidanceTone, ahead, behind, neutral, onTrack (+1 more)

### Community 42 - "WatchHydrationHealthKitDataSource"
Cohesion: 0.20
Nodes (8): Bool, Calendar, Date, DateInterval, Error, Int, WatchHydrationHealthKitDataSource, WatchHydrationLocalDataSource

### Community 43 - "MockHydrationReminderRepository"
Cohesion: 0.10
Nodes (9): HydrationReminderRepository, Bool, HydrationReminderUseCaseImpl, Bool, HydrationReminderUseCaseTests, MockHydrationReminderRepository, Bool, Error (+1 more)

### Community 44 - "HydrationPresentation"
Cohesion: 0.08
Nodes (11): AccountPresentation, ChallengePresentation, DependencyInjection, HydrationPresentation, HydrationReminderDomain, HydrationReminderPresentation, MulimiNavigation, PreviewAssembly (+3 more)

### Community 45 - "UUID"
Cohesion: 0.33
Nodes (5): Bool, UUID, HydrationEventModel, Date, Int

### Community 46 - "ProfileRoutineView"
Cohesion: 0.21
Nodes (8): ProfileRoutineView, .guidanceCard, .permissionSection, RoutineGuidanceSlot, RoutineGuidanceSlotStatus, elapsed, next, upcoming

### Community 47 - "DataAssembly.swift"
Cohesion: 0.15
Nodes (5): AccountData, ChallengeData, MulimiAnalyticsData, RoutineData, Utils

### Community 48 - "UserDefaults"
Cohesion: 0.13
Nodes (14): HydrationComebackRepositoryImpl, Date, HydrationComebackRepositoryTests, Bool, Double, Int, UserDefaults, .appGroup (+6 more)

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.08
Nodes (12): MockHydrationReminderUseCase, Bool, Error, Result, MockHydrationReminderUseCaseForTesting, Bool, HydrationReminderAuthorizationStatus, authorized (+4 more)

### Community 50 - ".loadInsights"
Cohesion: 0.20
Nodes (7): .body, .chartUpperBound, HydrationInsightWeekdayDistribution, .id, Date, DateInterval, Int

### Community 51 - "HydrationReminderRepositoryImpl"
Cohesion: 0.16
Nodes (7): HydrationReminderRepositoryImpl, Bool, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource, Bool, Result

### Community 52 - "HydrationInsightView"
Cohesion: 0.09
Nodes (22): HydrationInsightView, .emptyState, .emptyStateCTAButtons, .insightContent, .routineAdherenceCard, .weeklyReportCard, Bool, Void (+14 more)

### Community 53 - "HydrationInsightViewModel"
Cohesion: 0.12
Nodes (24): HydrationInsightMetric, HydrationInsightViewModel, .canRecordRecoveryDrink, .dailyGoalText, .emptyStateCTAs, .metrics, .routineAdherenceInsightText, .routineAdherenceMetrics (+16 more)

### Community 54 - "OnboardingViewModel"
Cohesion: 0.19
Nodes (6): Bool, OnboardingViewModel, .canGoBack, .isLastPage, Bool, OnboardingViewModelTests

### Community 55 - "BodyProfileSnapshot"
Cohesion: 0.15
Nodes (7): MockBodyProfileUseCase, BodyProfileSnapshot, Bool, BodyProfileUseCase, MockBodyProfileUseCaseForDomain, MockBodyProfileUseCase, Error

### Community 56 - "DrinkWaterHealthKitDataSource"
Cohesion: 0.18
Nodes (7): DrinkWaterDataSource, DrinkWaterHealthKitDataSource, .currentWaterIntakeML, Calendar, Date, DateInterval, Double

### Community 57 - "StaticAppInfoProvider"
Cohesion: 0.18
Nodes (9): AppInfoProviding, BundleAppInfoProvider, .appBuildNumber, .appVersion, StaticAppInfoProvider, SettingsViewModelTests, SpyWidgetTimelineReloader, Sendable (+1 more)

### Community 58 - "HydrationChallengeBadgeHistory"
Cohesion: 0.12
Nodes (16): Calendar, HydrationChallengeBadgeHistory, Date, ChallengeRepository, ChallengeEvaluation, ChallengeMergeResult, ChallengeUseCaseImpl, Bool (+8 more)

### Community 59 - "HydrationReminderSlot"
Cohesion: 0.11
Nodes (14): Constant, HydrationReminderNotificationDataSourceImpl, .notificationCenter, Int, Set, UNUserNotificationCenter, HydrationReminderSlot, afternoon (+6 more)

### Community 60 - "DrinkWaterEntry"
Cohesion: 0.13
Nodes (19): DrinkWaterLockScreenWidgetEntryView, .accentColor, .body, .circularView, .inlineView, .rectangularView, DrinkWaterWidgetEntryView, .accentColor (+11 more)

### Community 61 - "AppReviewRequestState"
Cohesion: 0.07
Nodes (25): AppReviewRequestStorageDataSource, AppReviewRequestStorageDataSourceImpl, AppReviewRequestRepositoryImpl, AppReviewRequestStorageDataSourceTests, AppReviewRequestState, Date, Set, AppReviewRequestRepository (+17 more)

### Community 62 - "실행·공유 경계"
Cohesion: 0.17
Nodes (10): App, 실행·공유 경계, WatchDIContainer, DrinkWaterApp, .body, Scene, MulimiWatchApp, .body (+2 more)

### Community 63 - "MockSignInUseCase"
Cohesion: 0.10
Nodes (9): MockSignInUseCase, Bool, UserCredential, SignInUseCase, MockSignInUseCase, .isAuthenticated, Bool, Error (+1 more)

### Community 64 - "LogWaterAppIntent"
Cohesion: 0.16
Nodes (13): AppIntent, IntentDialog, IntentModes, Constant, FailureReason, LogWaterAppIntent, .resolvedVolumeML, Bool (+5 more)

### Community 65 - "ProjectDescription"
Cohesion: 0.12
Nodes (5): PackageDescription, Plist, ProjectDescription, ProjectDescriptionHelpers, AppVersion

### Community 66 - ".assemble"
Cohesion: 0.17
Nodes (6): Release Filter, DataAssembly, Container, AnalyticsRepository, NoOpAnalyticsRepository, ProductAnalyticsEvent

### Community 67 - "ContentView"
Cohesion: 0.12
Nodes (15): AppCoordinator, URL, AppCoordinatorTests, ContentView, .body, .drinkWaterView, AccountRoute, profileRoutine (+7 more)

### Community 68 - "Top 5"
Cohesion: 0.14
Nodes (13): 1. 로그인 없이 시작, 2. 7일 스타터 플랜, 3. 알림 바로 기록, 4. 제어 센터·액션 버튼 기록, 5. 컴백 모드, Candidate Ideas, Decision, Engineer (+5 more)

### Community 69 - "MainIcon"
Cohesion: 0.07
Nodes (16): MockUserPreferencesUseCaseForTesting, Bool, Double, MainIcon, cloud, .`default`, drop, heart (+8 more)

### Community 70 - "Test.swift"
Cohesion: 0.19
Nodes (13): ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, ConfigurationAppIntent, Context, Date (+5 more)

### Community 71 - "#329 빠른 물 기록 가이드 제작·발행"
Cohesion: 0.11
Nodes (18): #329 빠른 물 기록 가이드 제작·발행, Capture Assets, Community Draft, Completion Notes, Constraints, Context, Device Verification, First-Use Check (+10 more)

### Community 72 - "RoutineNotificationAuthorizationStatus"
Cohesion: 0.05
Nodes (17): Alarm, AlarmManager, AlarmMetadata, AlarmPresentation, MockRoutineUseCase, Error, Result, MockRoutineUseCaseForTesting (+9 more)

### Community 73 - "HydrationRecordListViewModel"
Cohesion: 0.11
Nodes (24): HydrationRecordListView, .body, RowListView, .body, Void, HydrationRecordDaySummary, .glassCount, .id (+16 more)

### Community 74 - "HydrationGoalRecommendationUnavailableReason"
Cohesion: 0.13
Nodes (11): HydrationGoalRecommendationDataSource, HydrationGoalRecommendationRepositoryImpl, HydrationGoalRecommendationUnavailableReason, appleIntelligenceNotEnabled, deviceNotEligible, modelNotReady, unknown, unsupportedLocale (+3 more)

### Community 75 - "OnboardingView"
Cohesion: 0.14
Nodes (15): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+7 more)

### Community 76 - "View"
Cohesion: 0.12
Nodes (15): CGPoint, BodyProfileSettingView, .healthSyncCard, .summaryCard, HydrationGoalRecommendationCard, .content, Bool, Void (+7 more)

### Community 77 - "Growth Scorecard"
Cohesion: 0.12
Nodes (16): 72-Hour Audit, Before Release, Cadence And Ownership, Decision Rule, Deferred Scope, Experiment Record, Goal, Growth Scorecard (+8 more)

### Community 78 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.24
Nodes (7): Constants, HydrationGoalRecommendationUseCaseImpl, Calendar, Date, DateInterval, Int, HydrationGoalRecommendationUseCaseTests

### Community 79 - "ChallengeUseCase"
Cohesion: 0.17
Nodes (6): MockChallengeUseCase, Calendar, Date, ChallengeUseCase, Calendar, Date

### Community 80 - "WatchHydrationRepositoryImpl"
Cohesion: 0.32
Nodes (4): AnyView, Date, Int, WatchHydrationRepositoryImpl

### Community 81 - "MockUserPreferencesRepository"
Cohesion: 0.19
Nodes (6): Double, UserPreferencesUseCaseImpl, UserPreferencesUseCaseTests, MockUserPreferencesRepository, Bool, Double

### Community 82 - "WatchHydrationSnapshot"
Cohesion: 0.11
Nodes (14): WatchHydrationMutationResult, Bool, Date, Double, Int, Self, WatchHydrationSnapshot, .eventCount (+6 more)

### Community 83 - "MockHydrationRoutineAdherenceUseCase"
Cohesion: 0.40
Nodes (3): MockHydrationRoutineAdherenceUseCase, Calendar, Date

### Community 84 - ".loadChallenges"
Cohesion: 0.26
Nodes (8): ChallengeViewModelTests, Calendar, MockChallengeUseCase, Calendar, Date, MockPersonalizedChallengeUseCase, Calendar, Date

### Community 85 - "HydrationReminderNotificationDataSource"
Cohesion: 0.18
Nodes (4): HydrationReminderNotificationDataSource, HydrationReminderStorageDataSource, HydrationReminderStorageDataSourceImpl, Bool

### Community 86 - "MockAppReviewRequestUseCase"
Cohesion: 0.18
Nodes (11): AppReviewRequestUseCase, NoOpAppReviewRequestUseCase, Bool, Calendar, Date, Double, MockAppReviewRequestUseCase, Bool (+3 more)

### Community 87 - "Mulimi Drop — v3"
Cohesion: 0.17
Nodes (10): Generation and editing — Mulimi Drop v3, Original body layer prompt, Original face layer prompt, Original master prompt, Mulimi Drop — v3, 레이어, 배경과 외관, 앱 적용 (+2 more)

### Community 88 - "LiquidGlassSegmentedControl"
Cohesion: 0.18
Nodes (14): Binding, Value, .categoryPicker, .categoryPicker, LiquidGlassSegment, .id, LiquidGlassSegmentedControl, .activeSegmentBackground (+6 more)

### Community 89 - "AnalyticsUseCase"
Cohesion: 0.14
Nodes (5): AnalyticsUseCase, NoOpAnalyticsUseCase, ProductAnalyticsEvent, HealthKitUseCase, Date

### Community 90 - "AppDelegate"
Cohesion: 0.18
Nodes (11): 생성 검증 결과, AppDelegate, Any, Bool, UNUserNotificationCenter, UIApplication, UIApplicationDelegate, UNNotification (+3 more)

### Community 91 - "WatchHydrationViewModel"
Cohesion: 0.22
Nodes (8): MutationAction, record, reset, Bool, Date, Sendable, WatchHydrationViewModel, .canDrinkWater

### Community 92 - "프로젝트 전체 구조와 의존성"
Cohesion: 0.17
Nodes (12): App · 조립 루트 — 8개, Core — 6개, Features — 18개, Shared — 5개, Tests — 15개, 검증과 갱신, 기능 간 직접 의존에서 주의할 점, 디렉터리와 소유권 (+4 more)

### Community 93 - "HydrationGoalRecommendationAvailability"
Cohesion: 0.14
Nodes (12): MockHydrationGoalRecommendationUseCase, Date, Error, HydrationGoalRecommendationAvailability, bodyProfileRequired, modelUnavailable, ready, HydrationGoalRecommendationUseCase (+4 more)

### Community 94 - "HydrationProgressUseCaseImpl"
Cohesion: 0.30
Nodes (9): Date, DateInterval, HydrationProgressUseCaseImpl, StreakProgress, Calendar, Date, DateInterval, Double (+1 more)

### Community 95 - "fix-icon-composer-file-types.py"
Cohesion: 0.21
Nodes (11): json, pathlib, plistlib, runpy, fix_icon_file_types(), Path, Declare Icon Composer resources explicitly in a generated Xcode project., Run on macOS; optionally pass the generated app project.pbxproj to verify… (+3 more)

### Community 96 - "Security And Privacy Operations"
Cohesion: 0.15
Nodes (13): Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling, Data Boundary, Health Data Minimization, PostHog Privacy Controls (+5 more)

### Community 97 - "Foundation"
Cohesion: 0.08
Nodes (6): Foundation, FoundationModels, HydrationData, HydrationDomain, MulimiPlatform, Testing

### Community 98 - ".init"
Cohesion: 0.18
Nodes (8): Bool, Calendar, Date, Double, Int, MockHydrationProgressUseCase, Calendar, Date

### Community 99 - "PersonalizedChallengeUseCaseImpl"
Cohesion: 0.18
Nodes (10): Constants, PersonalizedChallengeUseCaseImpl, Calendar, Date, Int, PersonalizedChallengeUseCaseTests, Calendar, Date (+2 more)

### Community 100 - "LogWaterAmountOption"
Cohesion: 0.18
Nodes (11): AppEnum, DisplayRepresentation, LogWaterAmountOption, bottle, custom, glass, .presetID, .servingType (+3 more)

### Community 101 - "AGENTS.md Onboarding Map"
Cohesion: 0.11
Nodes (24): Goal Recommendation Entry Rules, Profile Information Architecture, Profile Root, Settings Screen, Quality Gates, Truthful Validation Reporting, Validation Baseline, Validation Matrix (+16 more)

### Community 102 - "DrinkWaterWidgetProvider"
Cohesion: 0.27
Nodes (6): AppIntentTimelineProvider, DrinkWaterWidgetProvider, ConfigurationAppIntent, Context, Date, Timeline

### Community 103 - "HealthKitAuthorizationStatus"
Cohesion: 0.26
Nodes (6): HealthKitAuthorizationStatus, notDetermined, sharingAuthorized, sharingDenied, .analyticsValue, ProductAnalyticsEvent

### Community 104 - "Sendable"
Cohesion: 0.07
Nodes (20): MockHydrationNextActionGuideUseCase, Calendar, Date, MockChallengeUseCaseForTesting, Calendar, Date, MockHydrationNextActionGuideUseCaseForTesting, Calendar (+12 more)

### Community 105 - "HydrationRecord"
Cohesion: 0.11
Nodes (10): MockHealthKitUseCaseForTesting, Bool, Date, HydrationRecord, Date, Double, Date, HydrationRecordRow (+2 more)

### Community 106 - "WaterDropView"
Cohesion: 0.25
Nodes (8): CGFloat, CGSize, TimeInterval, WaterDropView, .body, .dropBackground, .dropHighlights, .dropSymbol

### Community 107 - "HydrationServing"
Cohesion: 0.25
Nodes (7): HydrationServing, .additionalPresets, Double, Int, .progressLevel, .drinkWaterCount, .numberOfGlasses

### Community 108 - "Generation prompts"
Cohesion: 0.18
Nodes (9): body, cheeks, face, Generation prompts, Master, Mulimi Liquid Glass 아이콘 — #339, v1, 미리보기와 확인, 사용 (+1 more)

### Community 109 - "ConfigurationAppIntent"
Cohesion: 0.18
Nodes (9): IntentDescription, ConfigurationAppIntent, .description, .title, LocalizedStringResource, ConfigurationAppIntent, IntentResult, LocalizedStringResource (+1 more)

### Community 110 - "MockUserPreferencesUseCase"
Cohesion: 0.21
Nodes (3): MockUserPreferencesUseCase, Bool, Double

### Community 111 - "DrinkWaterRepositoryImpl"
Cohesion: 0.17
Nodes (7): DrinkWaterRepositoryImpl, .currentWaterIntakeML, Bool, Date, DateInterval, Double, Int

### Community 112 - ".weeklyInsightCalculatesRoutineRatesAndMissPattern"
Cohesion: 0.44
Nodes (4): HydrationRoutineAdherenceUseCaseTests, Calendar, Date, Int

### Community 113 - "WatchHydrationUseCaseImpl"
Cohesion: 0.16
Nodes (9): Int, WatchDailyGoalRepository, Date, Int, WatchHydrationRepository, Date, Double, Int (+1 more)

### Community 114 - "AppRoute"
Cohesion: 0.18
Nodes (10): AppRoute, hydrationLogging, hydrationStarterPlan, .id, .presentationStyle, profileRoutineAction, NavigationPresentationStyle, fullScreenCover (+2 more)

### Community 115 - "FoundationModelsHydrationGoalRecommendationDataSource"
Cohesion: 0.24
Nodes (6): Constants, FoundationModelsHydrationGoalRecommendationDataSource, GeneratedHydrationGoalRecommendation, Int, Locale, SystemLanguageModel

### Community 116 - "AI PR Review Workflow"
Cohesion: 0.40
Nodes (5): AI PR Review Workflow, Bounded AI Review Diff, Git Flow PR Filter, Textual Diff Selection, AI Review Automation Contract

### Community 117 - "UserPreferencesDataSourceImpl"
Cohesion: 0.10
Nodes (10): Double, NSUbiquitousKeyValueStore, SyncedValueStoring, UbiquitousMirroredStore, Constants, Bool, Double, NSUbiquitousKeyValueStore (+2 more)

### Community 118 - "TokenProperty"
Cohesion: 0.05
Nodes (25): ASAuthorization, ASAuthorizationController, ASAuthorizationControllerDelegate, AuthenticationServices, NSObject, KeychainStore, KeychainStoring, AppleSignInCredential (+17 more)

### Community 119 - ".makeViewModel"
Cohesion: 0.23
Nodes (5): MockHydrationGoalRecommendationUseCase, MockHydrationProgressUseCase, HydrationGoalRecommendationViewModelTests, Double, Int

### Community 120 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 121 - "HealthKitDataSource"
Cohesion: 0.23
Nodes (3): HealthKitDataSource, HealthKitRepositoryImpl, .authorisationStatus

### Community 122 - "HydrationReminderActionResult"
Cohesion: 0.15
Nodes (14): HydrationReminderActionResult, duplicate, failed, goalExceeded, permissionRequired, protectedDataUnavailable, saved, signInRequired (+6 more)

### Community 123 - "HydrationGoalRecommendation"
Cohesion: 0.40
Nodes (3): HydrationGoalRecommendation, HydrationGoalRecommendationInput, Int

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (7): ActivityAttributes, ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 125 - "아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법"
Cohesion: 0.20
Nodes (10): Apple Watch에서 기록하기, Siri·단축어로 기록하기, Siri에게 말하기, 기록이 저장됐는지 확인하기, 내게 맞는 방법 고르기, 단축어 앱에서 실행, 설정하거나 기록하다 막혔다면, 아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법 (+2 more)

### Community 126 - "Error"
Cohesion: 0.10
Nodes (19): Error, AuthenticationError, cancelled, invalidCredential, networkFailed, serverError, unknown, MockSignInError (+11 more)

### Community 127 - "HydrationWriteResult"
Cohesion: 0.12
Nodes (13): .analyticsFailureReason, HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, HydrationWriteResult, failure, .failureReason (+5 more)

### Community 128 - ".save"
Cohesion: 0.42
Nodes (5): HKUnit, HealthQuantitySample, Bool, Date, Double

### Community 129 - "WaterDropShaders.metal"
Cohesion: 0.43
Nodes (6): float2, half4, metal_stdlib, mulimiWaterDistortion(), mulimiWaterLighting(), mulimiWaveNoise()

### Community 130 - ".resolve"
Cohesion: 0.17
Nodes (10): Assembler, DIContainer, .resolver, PreviewViews, .challenge, .drinkWater, .hydrationList, .profile (+2 more)

### Community 131 - "HydrationNextActionGuide"
Cohesion: 0.17
Nodes (17): Constants, HydrationNextActionGuide, .progress, HydrationNextActionGuideState, approachingRoutine, goalReached, needsGoal, readyToDrink (+9 more)

### Community 132 - "#320 — 7일 스타터 플랜 제품 적용"
Cohesion: 0.20
Nodes (9): #320 — 7일 스타터 플랜 제품 적용, Constraints And Decisions, Context, Goal, Implementation Notes (2026-09-14), Non-Goals, Plan, Rollback (+1 more)

### Community 133 - "Mulimi"
Cohesion: 0.11
Nodes (30): Architecture Review Policy, Agent Onboarding Guide, Clean Architecture and MVVM Discipline, Domain Purity, Graphify-Assisted Code Navigation, Hydration Source of Truth, ViewModel System API Boundary, Mulimi Architecture SSOT (+22 more)

### Community 134 - "RoutineWeekday"
Cohesion: 0.06
Nodes (43): Int, MockRoutineRecommendationUseCase, Calendar, Date, MockRoutineRecommendationUseCaseForTesting, Calendar, Date, .localeWeekday (+35 more)

### Community 135 - "UserPreferencesRepositoryImpl"
Cohesion: 0.28
Nodes (3): Bool, Double, UserPreferencesRepositoryImpl

### Community 136 - "WatchDailyGoalLocalDataSource"
Cohesion: 0.21
Nodes (7): MulimiCloudKit, Int, NSUbiquitousKeyValueStore, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, Int, WatchDailyGoalRepositoryImpl

### Community 137 - "InsightCard"
Cohesion: 0.20
Nodes (10): BadgeView, .body, .weekdayPatternCard, InsightCard, .body, .cardBackground, .cardBorder, AnyShapeStyle (+2 more)

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "HealthKitRepository"
Cohesion: 0.16
Nodes (4): HealthKitRepository, BodyProfileUseCaseImpl, Bool, BodyProfileUseCaseTests

### Community 140 - "HydrationWeeklyReportTimeSlot"
Cohesion: 0.24
Nodes (6): HydrationWeeklyReportTimeSlot, afternoon, evening, morning, .sortOrder, Bool

### Community 143 - "Equatable"
Cohesion: 0.42
Nodes (5): Equatable, HydrationRoutineAdherenceEvent, Calendar, Date, DateInterval

### Community 144 - "Assembly"
Cohesion: 0.25
Nodes (6): Assembly, Assembly, DomainAssembly, PresentationAssembly, Assembly, TestingAssembly

### Community 145 - ".drinkWater"
Cohesion: 0.29
Nodes (3): Error, Int, Int

### Community 152 - "MockAnalyticsUseCase"
Cohesion: 0.10
Nodes (13): HydrationComebackRepository, Date, HydrationComebackMode, baseline, card, disabled, StubHydrationComebackRepository, Bool (+5 more)

### Community 153 - "CustomHydrationAmountValidation"
Cohesion: 0.40
Nodes (5): CustomHydrationAmountValidation, empty, invalid, overLimit, valid

### Community 154 - "Test"
Cohesion: 0.10
Nodes (23): ControlWidget, WidgetConfiguration, Test, Widget, TestBundle, .body, WidgetConfiguration, TestLiveActivity (+15 more)

### Community 155 - "Challenge State Model"
Cohesion: 0.50
Nodes (5): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Legacy Challenge State Migration, Recurring Challenge State

### Community 156 - "ChallengeCategory"
Cohesion: 0.09
Nodes (23): CaseIterable, ChallengeCategory, completed, .id, inProgress, recommended, .systemImage, .title (+15 more)

### Community 157 - "AuthProvider"
Cohesion: 0.40
Nodes (4): AuthProvider, apple, google, kakao

### Community 158 - "Mulimi Pull Request Template"
Cohesion: 0.50
Nodes (4): Local Validation Reporting, Mulimi Pull Request Template, PR Review Checklist, Truthful Validation Reporting

### Community 159 - ".makeModelContainer"
Cohesion: 0.10
Nodes (20): LocalizedError, ModelConfiguration, ModelContainer, MockError, .errorDescription, signInFailed, MockError, deleteFailed (+12 more)

### Community 160 - "Generation — Mulimi Water Glass v2"
Cohesion: 0.25
Nodes (6): droplet, Generation — Mulimi Water Glass v2, glass, Master, water, Mulimi — Water Glass v2

### Community 161 - "WatchHydrationEvent"
Cohesion: 0.60
Nodes (3): Date, Int, WatchHydrationEvent

### Community 162 - "RoutinePermissionPrompt"
Cohesion: 0.40
Nodes (5): RoutinePermissionPrompt, .id, openSettings, requestAuthorization, scheduleFailure

### Community 164 - "Reliability Recovery"
Cohesion: 0.22
Nodes (11): Goal Mirror Recovery Policy, HealthKit Source of Truth, Recovery Principles, Reliability Recovery, Routine Schedule Recovery, Shared Hydration Rules, HealthKit Data Flow, healthkit-flow (+3 more)

### Community 166 - "#321 수분 알림 바로 기록"
Cohesion: 0.18
Nodes (11): #321 수분 알림 바로 기록, Completion Notes, Constraints, Context, Goal, Non-Goals, Open Questions, Plan (+3 more)

### Community 169 - "HydrationRecordPeriod"
Cohesion: 0.29
Nodes (7): .selectedPeriodRangeText, HydrationRecordPeriod, .id, month, .title, today, week

### Community 170 - "UserPreferencesRepository"
Cohesion: 0.20
Nodes (3): Bool, Double, UserPreferencesRepository

### Community 171 - "Hashable"
Cohesion: 0.11
Nodes (17): Hashable, NavigationRoute, AppTab, challenge, drink, history, insight, profile (+9 more)

### Community 173 - ".recordWater"
Cohesion: 0.19
Nodes (7): Date, HydrationReminderNotification, .category, Bool, Date, HydrationReminderNotificationTests, UNNotificationCategory

### Community 174 - "WaterWaveView"
Cohesion: 0.28
Nodes (6): CGRect, CGFloat, Path, WaterWaveView, .animatableData, Shape

### Community 175 - "Color"
Cohesion: 0.10
Nodes (22): ChallengeBadge, .body, ChallengeCard, .accentColor, .body, .cardBackground, ChallengeHistoryCard, .accentColor (+14 more)

### Community 176 - "Clean Architecture and MVVM"
Cohesion: 0.29
Nodes (7): Clean Architecture and MVVM, Domain Purity, ViewModel Side Effect Boundary, navigation-coordinator, Root Navigation, Modular Clean Architecture, Root App Flow

### Community 177 - "CI Lint and Architecture Gate"
Cohesion: 0.25
Nodes (8): CI Lint and Architecture Gate, Lint Workflow, Domain Data Presentation Test Matrix, PR Unit Tests Workflow, SwiftPM Cache Retry, Selected SwiftLint Rule Set, SwiftLint Configuration, Default Validation Sequence

### Community 178 - ".progressSnapshot"
Cohesion: 0.40
Nodes (4): HydrationProgressUseCaseTests, Calendar, Date, Int

### Community 179 - "HealthKitDataSourceImpl"
Cohesion: 0.14
Nodes (7): HKAuthorizationStatus, HealthQuantityStoring, HealthKitDataSourceImpl, .healthKitAuthorizationStatus, .isWaterSharingAuthorized, Bool, .isWaterSharingAuthorized

### Community 182 - "HydrationRoutineAdherenceStatus"
Cohesion: 0.29
Nodes (6): HydrationRoutineAdherenceStatus, inactive, needsAttention, noDueOccurrences, noRecords, onTrack

### Community 184 - "MockHydrationProgressUseCase"
Cohesion: 0.40
Nodes (3): MockHydrationProgressUseCase, Calendar, Date

### Community 186 - "MockHydrationProgressUseCaseForTesting"
Cohesion: 0.40
Nodes (3): MockHydrationProgressUseCaseForTesting, Calendar, Date

### Community 191 - "State"
Cohesion: 0.25
Nodes (6): State, bodyProfileRequired, idle, loading, modelUnavailable, ready

### Community 192 - "LogWaterAppShortcuts"
Cohesion: 0.29
Nodes (6): AppShortcut, AppShortcutsProvider, LogWaterAppShortcuts, .appShortcuts, .shortcutTileColor, ShortcutTileColor

### Community 194 - "HealthKitError"
Cohesion: 0.15
Nodes (9): Date, Double, Error, Date, HealthKitError, healthKitInternalError, incompleteExecuteQuery, invalidObjectType (+1 more)

### Community 195 - "Completed Plan Archive"
Cohesion: 0.40
Nodes (5): Stale Document Handling, Active Exec Plans, Active Plan Lifecycle, Completed Exec Plans, Completed Plan Archive

### Community 196 - "HealthQuantityStoreError"
Cohesion: 0.33
Nodes (5): HealthQuantityStoreError, incompleteQuery, internalError, invalidObjectType, permissionDenied

## Ambiguous Edges - Review These
- `CloudKit-Backed Hydration Store` → `HealthKit Source of Truth`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to
- `CloudKit-Backed Hydration Store` → `Current Storage Strategy`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to

## Knowledge Gaps
- **547 isolated node(s):** `.resolver`, `production`, `preview`, `testing`, `.current` (+542 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1013 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `HealthKit Source of Truth`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `Current Storage Strategy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `String` connect `String` to `HydrationRoutineAdherenceInsight`, `SettingsViewModel`, `ProfileRoutineViewModel`, `HydrationRoutine`, `BodyProfileViewModel`, `.tr`, `HKQuantityTypeIdentifier`, `.assemble`, `HydrationStarterPlanViewModel`, `DrinkWaterUseCase`, `DrinkWaterViewModel`, `Identifiable`, `HealthKitPermissionViewModel`, `RoutineActionIntent`, `MockDrinkWaterUseCase`, `HydrationEvent`, `BodyProfile`, `DrinkWaterRepository`, `MockDrinkWaterRepository`, `.tr`, `SpyRoutineUseCase`, `StartTimerIntent`, `PostHogAnalyticsRepository`, `HydrationReminderPermissionViewModel`, `ChallengeViewModel`, `RecordCalendarView`, `HealthKitSource`, `PersonalizedHydrationChallengeKind`, `HydrationGoalRecommendationViewModel`, `.guidanceSummary`, `UUID`, `ProfileRoutineView`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `.loadInsights`, `HydrationInsightView`, `HydrationInsightViewModel`, `StaticAppInfoProvider`, `HydrationChallengeBadgeHistory`, `HydrationReminderSlot`, `DrinkWaterEntry`, `AppReviewRequestState`, `MockSignInUseCase`, `LogWaterAppIntent`, `ProjectDescription`, `.assemble`, `ContentView`, `MainIcon`, `RoutineNotificationAuthorizationStatus`, `HydrationRecordListViewModel`, `OnboardingView`, `View`, `MockAppReviewRequestUseCase`, `LiquidGlassSegmentedControl`, `WatchHydrationViewModel`, `LogWaterAmountOption`, `HealthKitAuthorizationStatus`, `HydrationRecord`, `ConfigurationAppIntent`, `MockUserPreferencesUseCase`, `DrinkWaterRepositoryImpl`, `AppRoute`, `FoundationModelsHydrationGoalRecommendationDataSource`, `UserPreferencesDataSourceImpl`, `TokenProperty`, `HydrationReminderActionResult`, `HydrationGoalRecommendation`, `ContentState`, `Error`, `HydrationWriteResult`, `.save`, `HydrationNextActionGuide`, `RoutineWeekday`, `InsightCard`, `HydrationWeeklyReportTimeSlot`, `Equatable`, `.drinkWater`, `ChallengeStorageDataSourceImpl`, `AnalyticsUseCaseImpl`, `MockAnalyticsUseCase`, `Test`, `ChallengeCategory`, `.makeModelContainer`, `RoutinePermissionPrompt`, `HydrationRecordPeriod`, `.recordWater`, `Color`, `.progressSnapshot`, `HealthKitDataSourceImpl`, `HydrationRoutineAdherenceStatus`?**
  _High betweenness centrality (0.281) - this node is a cross-community bridge._
- **Why does `프로젝트 전체 구조와 의존성` connect `프로젝트 전체 구조와 의존성` to `AppDelegate`, `Mulimi`, `실행·공유 경계`?**
  _High betweenness centrality (0.081) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `AppDelegate.swift`, `HydrationNextActionGuide`, `RoutineWeekday`, `WatchDailyGoalLocalDataSource`, `.tr`, `HealthKitRepository`, `HydrationStarterPlanViewModel`, `DrinkWaterUseCase`, `RoutineDomain`, `Identifiable`, `RoutineActionIntent`, `HydrationEvent`, `BodyProfile`, `DrinkWaterRepository`, `MockAnalyticsUseCase`, `AccountDomain`, `.tr`, `MockRoutineRepository`, `AuthProvider`, `Localization`, `HydrationReminderPermissionViewModel`, `SignInUseCaseImpl`, `WatchHydrationEvent`, `.makeModelContainer`, `HydrationProgressSnapshot`, `PersonalizedHydrationChallengeKind`, `StackRouting`, `String`, `HydrationGoalRecommendationViewModel`, `UserPreferencesRepository`, `Hashable`, `HydrationPresentation`, `MockHydrationReminderRepository`, `DataAssembly.swift`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `HydrationRoutineAdherenceStatus`, `BodyProfileSnapshot`, `StaticAppInfoProvider`, `HydrationChallengeBadgeHistory`, `HydrationReminderSlot`, `AppReviewRequestState`, `MockSignInUseCase`, `HealthKitError`, `HealthQuantityStoreError`, `MainIcon`, `RoutineNotificationAuthorizationStatus`, `HydrationGoalRecommendationUnavailableReason`, `ChallengeUseCase`, `WatchHydrationSnapshot`, `MockAppReviewRequestUseCase`, `AnalyticsUseCase`, `HydrationGoalRecommendationAvailability`, `HealthKitAuthorizationStatus`, `Sendable`, `HydrationRecord`, `HydrationServing`, `WatchHydrationUseCaseImpl`, `UserPreferencesDataSourceImpl`, `TokenProperty`, `DIEnvironment`, `HydrationGoalRecommendation`, `Error`, `HydrationWriteResult`?**
  _High betweenness centrality (0.071) - this node is a cross-community bridge._
- **What connects `.resolver`, `production`, `preview` to the rest of the system?**
  _547 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `SettingsViewModel` be split into smaller, more focused modules?**
  _Cohesion score 0.09659090909090909 - nodes in this community are weakly interconnected._