# Graph Report - Mulimi  (2026-10-04)

## Corpus Check
- 403 files · ~199,200 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 22 file(s) not represented in the graph (top: .entitlements 6, .plist 5, (none) 3)

## Summary
- 4048 nodes · 10852 edges · 196 communities (149 shown, 47 thin omitted)
- Extraction: 84% EXTRACTED · 16% INFERRED · 0% AMBIGUOUS · INFERRED: 1727 edges (avg confidence: 0.84)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `221c4448`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- HydrationRoutineAdherenceInsight
- SettingsViewModel
- WatchHydrationUndoTests.swift
- UserPreferencesUseCase
- HydrationRoutine
- MockDrinkWaterUseCase
- MockHealthKitRepository
- MockUserPreferencesUseCase
- .tr
- HealthKitQuantityStore
- .assemble
- Hydration Logging
- HydrationStarterPlanViewModel
- DrinkWaterUseCase
- DrinkWaterViewModel
- RoutineDomain
- HydrationChallengeKind
- HealthKitPermissionViewModel
- MockRoutineRepository
- RoutineNotificationAuthorizationStatus
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
- StackRouting
- String
- HydrationGoalRecommendationViewModel
- UnavailableHealthStore
- WatchHydrationEvent
- MockHydrationReminderRepository
- HydrationPresentation
- AppReviewRequestUseCaseImpl
- Equatable
- Foundation
- UserDefaults
- HydrationReminderAuthorizationStatus
- LiquidGlassSegmentedControl
- HydrationReminderRepositoryImpl
- .track
- HydrationInsightViewModel
- OnboardingViewModel
- BodyProfileViewModel
- DrinkWaterHealthKitDataSource
- AnalyticsUseCase
- ChallengeUseCaseImpl
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
- RoutineNotificationDataSourceImpl
- HydrationRecordDaySummary
- HydrationGoalRecommendationUnavailableReason
- OnboardingView
- HydrationProgressUseCaseImpl
- HydrationStarterPlanViewModelTests
- HydrationGoalRecommendationUseCaseImpl
- HydrationEvent
- WatchDailyGoalRepository
- RoutineActionIntent
- DrinkWaterRepositoryImpl
- #336 Watch 최근 기록 한 건 되돌리기
- .loadChallenges
- AppleSignInCredential
- AppReviewRequestUseCase
- Xcode Cloud Release Build
- Value
- HealthKitUseCase
- AppDelegate
- WatchHydrationViewModel
- 프로젝트 전체 구조와 의존성
- HydrationGoalRecommendationAvailability
- Hashable
- fix-icon-composer-file-types.py
- Security And Privacy Operations
- AccountDomain
- MockHydrationProgressUseCase
- DrinkWaterRepository
- LogWaterAmountOption
- AGENTS.md Onboarding Map
- .recordWater
- HealthKitAuthorizationStatus
- Sendable
- MockHealthKitUseCaseForTesting
- WaterDropView
- CaseIterable
- Generation prompts
- ConfigurationAppIntent
- MockUserPreferencesUseCase
- StaticAppInfoProvider
- MockUserPreferencesRepository
- WatchHydrationSnapshot
- NavigationPresentationStyle
- AnalyticsRepository
- ReadRecoveryRepository
- UserPreferencesDataSourceImpl
- TokenProperty
- .makeViewModel
- DIEnvironment
- AI PR Review Workflow
- .handle
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
- UserPreferencesRepository
- WatchDailyGoalLocalDataSource
- HydrationInsightView
- Accessibility and Dynamic Type Audit
- HealthKitRepository
- MockHydrationReminderUseCase
- ci_post_clone.sh
- FoundationModelsHydrationGoalRecommendationDataSource
- .assemble
- MockError
- DrinkWaterWidget
- check-architecture.sh
- HydrationChallengeBadgeHistory
- lint.sh
- lint-fix.sh
- ProfileRoutineViewModel
- MockAnalyticsUseCase
- RoutineRepository
- ChallengeViewModel
- Challenge State Model
- HydrationRecordListViewModel
- AuthProvider
- Mulimi Pull Request Template
- KeyChainDataSourceImpl
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
- MockHydrationReminderUseCaseForTesting
- AppTab
- HydrationReminderRepository
- HydrationRecordListView
- Clean Architecture and MVVM
- BundleAppInfoProvider
- TestingAssembly
- Layer Responsibilities
- UserPreferencesUseCaseImpl
- HealthKitDataSourceImpl
- HydrationComebackRepositoryImpl
- AnalyticsUseCaseImpl
- HydrationStarterPlanRepositoryImpl
- MockAppReviewRequestUseCase
- .resolve
- RoutineUseCase
- MockChallengeUseCaseForTesting
- AuthenticationRepositoryImpl
- CustomHydrationAmountValidation
- LogWaterAppShortcuts
- Release And QA Runbook

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
- `Opportunity` --references--> `HydrationServing`  [INFERRED]
  Docs/feature-discovery.md → Project/Features/Hydration/Domain/Sources/Entity/HydrationServing.swift
- `#350 조회 실패 화면` --references--> `DrinkWaterView`  [INFERRED]
  Docs/product-specs/assets/issue-350/README.md → Project/Features/Hydration/Presentation/Sources/View/DrinkWater/DrinkWaterView.swift
- `추가 검증의 제한` --references--> `DIContainer`  [INFERRED]
  Docs/exec-plans/active/2026-10-03-issue-350-read-recovery.md → Project/App/DependencyInjection/Sources/Core/DIContainer.swift

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

## Communities (196 total, 47 thin omitted)

### Community 0 - "HydrationRoutineAdherenceInsight"
Cohesion: 0.06
Nodes (24): MockHydrationRoutineAdherenceUseCase, CandidateMatch, Constants, HydrationRoutineAdherenceEvent, HydrationRoutineAdherenceInsight, .adherenceRate, .bestRoutine, .bestTimeSlot (+16 more)

### Community 1 - "SettingsViewModel"
Cohesion: 0.12
Nodes (14): SettingMenu, bodyProfile, dailyLimit, .id, mainIcon, withdrawal, MainIconSettingView, .body (+6 more)

### Community 2 - "WatchHydrationUndoTests.swift"
Cohesion: 0.17
Nodes (10): 실행·공유 경계, HealthKit, MulimiHealthKit, OSLog, WatchDIContainer, WatchReadRecoveryClock, Synchronization, WatchHydrationData (+2 more)

### Community 4 - "HydrationRoutine"
Cohesion: 0.07
Nodes (9): MockRoutineUseCaseForTesting, StarterPlanRoutineStub, RoutineStorageDataSourceImpl, HydrationRoutine, .timeText, .weekdayText, .activeRoutineCount, .primaryRoutine (+1 more)

### Community 5 - "MockDrinkWaterUseCase"
Cohesion: 0.15
Nodes (3): MockDrinkWaterUseCase, .currentWaterIntakeML, .hasPendingDrinkWater

### Community 6 - "MockHealthKitRepository"
Cohesion: 0.10
Nodes (9): HydrationRecord, HealthKitUseCaseImpl, .authorisationStatus, HealthKitUseCaseTests, HydrationRecordRow, .body, .dateString, MockHealthKitRepository (+1 more)

### Community 7 - "MockUserPreferencesUseCase"
Cohesion: 0.21
Nodes (6): NoOpWidgetTimelineReloader, DrinkWaterViewModelTests, ReadRecoveryClock, SpyWidgetTimelineReloader, StubHydrationNextActionGuideUseCase, MockUserPreferencesUseCase

### Community 8 - ".tr"
Cohesion: 0.06
Nodes (34): HealthKitPermissionGateView, .accessCard, .descriptionText, .footnoteText, .headerColor, .headerSection, .headerSystemImage, .primaryButtonHint (+26 more)

### Community 9 - "HealthKitQuantityStore"
Cohesion: 0.18
Nodes (4): HealthKitQuantityStore, .isHealthDataAvailable, HealthQuantitySample, HealthQuantityStoring

### Community 10 - ".assemble"
Cohesion: 0.11
Nodes (8): AppSession, SignInView, .body, AuthenticationViewModel, .isAuthenticated, AuthenticationViewModelTests, MockSignInUseCase, .isAuthenticated

### Community 11 - "Hydration Logging"
Cohesion: 0.10
Nodes (29): PostHog Analytics Consolidation, Personalized Challenge Strategy, Personalized Challenge Recommendation Candidates, Challenge Recommendation Tier Rules, Analytics Events, Analytics Event Catalog, Product Analytics Event Contract, PostHog Activity QA (+21 more)

### Community 12 - "HydrationStarterPlanViewModel"
Cohesion: 0.11
Nodes (10): .drinkWaterView, HydrationStarterPlanRepository, HydrationStarterPlanView, .body, .checklist, HydrationReadFailureView, .body, HydrationStarterPlanViewModel (+2 more)

### Community 13 - "DrinkWaterUseCase"
Cohesion: 0.09
Nodes (17): SystemWidgetTimelineReloader, WidgetTimelineReloading, completed, DrinkWaterUseCase, HydrationReminderLogResult, failed, goalExceeded, saved (+9 more)

### Community 14 - "DrinkWaterViewModel"
Cohesion: 0.10
Nodes (14): .body, .overflowMenu, DrinkWaterViewModel, .dailyLimit, .hasCurrentIntake, .isComebackCardVisible, .isFirstRecordGuideActive, .isLimitReached (+6 more)

### Community 15 - "RoutineDomain"
Cohesion: 0.12
Nodes (5): ChallengeDomain, MulimiAnalytics, Observation, PostHog, RoutineDomain

### Community 16 - "HydrationChallengeKind"
Cohesion: 0.09
Nodes (29): HydrationChallengeKind, goalAchievement30, .id, .resetPolicy, .stateType, streak7, weeklyAchievement80, HydrationChallengeResetPolicy (+21 more)

### Community 17 - "HealthKitPermissionViewModel"
Cohesion: 0.13
Nodes (7): .body, HealthKitPermissionViewModel, .defaultErrorMessage, .deniedMessage, HealthKitPermissionViewModelTests, MockHealthKitUseCase, .authorisationStatus

### Community 18 - "MockRoutineRepository"
Cohesion: 0.13
Nodes (5): PersonalizedChallengeUseCaseTests, RoutineUseCaseImpl, RoutineRecommendationUseCaseTests, RoutineUseCaseTests, MockRoutineRepository

### Community 19 - "RoutineNotificationAuthorizationStatus"
Cohesion: 0.10
Nodes (5): MockRoutineUseCase, RoutineNotificationAuthorizationStatus, authorized, denied, notDetermined

### Community 20 - "UndoQuantityStore"
Cohesion: 0.15
Nodes (4): State, UndoGate, .isWaiting, UndoQuantityStore

### Community 21 - "BodyProfile"
Cohesion: 0.14
Nodes (7): BodyProfile, .isComplete, .isEmpty, BodyProfileSource, healthKit, manual, BodyProfileValue

### Community 22 - "HydrationStarterPlan"
Cohesion: 0.14
Nodes (8): PreviewStarterPlanRepository, HydrationQuickRecordingMethod, shortcuts, watch, widget, HydrationStarterPlan, HydrationStarterPlanTests, StarterPlanRepositorySpy

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
Cohesion: 0.12
Nodes (7): MockRoutineRecommendationUseCase, HydrationRoutineRecommendation, .id, DaySummary, RoutineRecommendationUseCaseImpl, .timeText, .weekdayText

### Community 28 - "ContentView"
Cohesion: 0.16
Nodes (11): AppCoordinator, AppRoute, hydrationLogging, hydrationStarterPlan, .id, .presentationStyle, profileRoutineAction, NavigationRoute (+3 more)

### Community 30 - "Localization"
Cohesion: 0.09
Nodes (12): ActivityKit, AlarmKit, AppIntents, Charts, CryptoKit, DesignSystem, Localization, HydrationPresentationShaderBundleToken (+4 more)

### Community 31 - "HydrationReminderPermissionViewModel"
Cohesion: 0.11
Nodes (9): HydrationReminderPermissionGateView, .allowButtonLabel, .body, .headerSection, .primingView, Constant, HydrationReminderPermissionViewModel, HydrationReminderPermissionViewModelTests (+1 more)

### Community 32 - "SignInUseCaseImpl"
Cohesion: 0.12
Nodes (5): SignInUseCaseImpl, .isAuthenticated, SignInUseCaseTests, MockAuthenticationRepository, .isAuthenticated

### Community 33 - "PersonalizedHydrationChallenge"
Cohesion: 0.07
Nodes (18): MockPersonalizedChallengeUseCase, MockPersonalizedChallengeUseCaseForTesting, HydrationChallengeRecommendationSource, recentRecords, routine, HydrationChallengeTier, beginner, steady (+10 more)

### Community 34 - "RecordCalendarView"
Cohesion: 0.07
Nodes (34): CalendarDayView, .accessibilityLabel, .backgroundColor, .body, .borderColor, .dayNumber, .progressPercentage, HydrationProgressBar (+26 more)

### Community 35 - "AppReviewRequestState"
Cohesion: 0.15
Nodes (6): AppReviewRequestStorageDataSource, AppReviewRequestStorageDataSourceImpl, AppReviewRequestRepositoryImpl, AppReviewRequestStorageDataSourceTests, AppReviewRequestState, MockAppReviewRequestRepository

### Community 36 - "HydrationProgressSnapshot"
Cohesion: 0.10
Nodes (7): MockHydrationProgressUseCase, HydrationProgressSnapshot, HydrationInsightViewModelTests, InsightRecoveryClock, SpyRoutineUseCase, MockHydrationProgressUseCase, MockHydrationRoutineAdherenceUseCase

### Community 37 - "RoutineRepositoryImpl"
Cohesion: 0.20
Nodes (6): RoutineNotificationDataSource, RoutineStorageDataSource, RoutineRepositoryImpl, RoutineRepositoryImplTests, SpyRoutineNotificationDataSource, SpyRoutineStorageDataSource

### Community 38 - "StackRouting"
Cohesion: 0.09
Nodes (5): DeepLinkHandling, FullScreenRouting, SheetRouting, StackRouting, .hasPath

### Community 39 - "String"
Cohesion: 0.07
Nodes (18): .postHogValue, AnalyticsParameterName, AnalyticsParameterValue, bool, double, int, string, ProductAnalyticsEvent (+10 more)

### Community 40 - "HydrationGoalRecommendationViewModel"
Cohesion: 0.08
Nodes (20): DailyLimitSettingView, .body, EntryDestination, bodyProfileSetting, dailyLimitSetting, GoalAlignment, aboveGoal, aligned (+12 more)

### Community 42 - "WatchHydrationEvent"
Cohesion: 0.07
Nodes (10): HydrationWriteFailureReason, invalidObjectType, permissionDenied, systemError, WatchHydrationHealthKitDataSource, .isWaterSharingAuthorized, WatchHydrationLocalDataSource, WatchHydrationRepositoryImpl (+2 more)

### Community 43 - "MockHydrationReminderRepository"
Cohesion: 0.14
Nodes (3): HydrationReminderUseCaseImpl, HydrationReminderUseCaseTests, MockHydrationReminderRepository

### Community 44 - "HydrationPresentation"
Cohesion: 0.09
Nodes (11): AccountPresentation, ChallengePresentation, DependencyInjection, HydrationPresentation, HydrationReminderDomain, HydrationReminderPresentation, MulimiNavigation, HydrationReminderAnalyticsParameterName (+3 more)

### Community 45 - "AppReviewRequestUseCaseImpl"
Cohesion: 0.23
Nodes (3): AppReviewRequestRepository, AppReviewRequestUseCaseImpl, Policy

### Community 46 - "Equatable"
Cohesion: 0.08
Nodes (28): PersonalizedChallengeCardModel, .servingOptions, HydrationServingOptionModel, .volumeText, HydrationInsightEmptyCTAModel, ProfileRoutineView, .guidanceCard, .permissionSection (+20 more)

### Community 47 - "Foundation"
Cohesion: 0.07
Nodes (6): Foundation, FoundationModels, HydrationData, HydrationDomain, HydrationReminderData, Testing

### Community 48 - "UserDefaults"
Cohesion: 0.12
Nodes (8): UserDefaults, .appGroup, .dailyLimit, .glassesOfToday, .hasCompletedOnboarding, .mainIcon, .manualBodyHeightCM, .manualBodyWeightKG

### Community 49 - "HydrationReminderAuthorizationStatus"
Cohesion: 0.10
Nodes (6): HydrationReminderAuthorizationStatus, authorized, denied, notDetermined, .analyticsValue, ProductAnalyticsEvent

### Community 50 - "LiquidGlassSegmentedControl"
Cohesion: 0.17
Nodes (9): .categoryPicker, LiquidGlassSegment, .id, LiquidGlassSegmentedControl, .activeSegmentBackground, .activeSegmentBorder, .body, .containerBackground (+1 more)

### Community 51 - "HydrationReminderRepositoryImpl"
Cohesion: 0.21
Nodes (6): HydrationReminderNotificationDataSource, HydrationReminderStorageDataSource, HydrationReminderRepositoryImpl, HydrationReminderRepositoryImplTests, SpyHydrationReminderNotificationDataSource, SpyHydrationReminderStorageDataSource

### Community 52 - ".track"
Cohesion: 0.09
Nodes (14): .permissionView, .emptyStateCTAButtons, HydrationInsightEmptyAction, dailyGoal, record, routine, HydrationWeeklyCoachingAction, dailyGoal (+6 more)

### Community 53 - "HydrationInsightViewModel"
Cohesion: 0.08
Nodes (29): HydrationInsightViewModel, .canRecordRecoveryDrink, .chartUpperBound, .dailyGoalText, .emptyStateCTAs, .hasLoadedInsights, .monthlyAverageText, .routineAdherenceInsightText (+21 more)

### Community 54 - "OnboardingViewModel"
Cohesion: 0.20
Nodes (6): RootView, .body, OnboardingViewModel, .canGoBack, .isLastPage, OnboardingViewModelTests

### Community 55 - "BodyProfileViewModel"
Cohesion: 0.08
Nodes (19): MockBodyProfileUseCase, BodyProfileAvailability, incomplete, needsPermission, noData, permissionDenied, ready, BodyProfileSnapshot (+11 more)

### Community 57 - "AnalyticsUseCase"
Cohesion: 0.13
Nodes (4): AnalyticsUseCase, NoOpAnalyticsUseCase, SignInUseCase, HydrationReminderUseCase

### Community 58 - "ChallengeUseCaseImpl"
Cohesion: 0.25
Nodes (3): ChallengeEvaluation, ChallengeMergeResult, ChallengeUseCaseImpl

### Community 59 - "HydrationReminderSlot"
Cohesion: 0.11
Nodes (9): Constant, HydrationReminderNotificationDataSourceImpl, .notificationCenter, HydrationReminderSlot, afternoon, evening, .hour, .minute (+1 more)

### Community 60 - "DrinkWaterEntry"
Cohesion: 0.10
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
Cohesion: 0.17
Nodes (12): Cadence And Ownership, Decision Rule, Deferred Scope, Experiment Record, Goal, Growth Scorecard, Input And Health Metrics, Measurement Boundary (+4 more)

### Community 68 - "Top 5"
Cohesion: 0.14
Nodes (13): 1. 로그인 없이 시작, 2. 7일 스타터 플랜, 3. 알림 바로 기록, 4. 제어 센터·액션 버튼 기록, 5. 컴백 모드, Candidate Ideas, Decision, Engineer (+5 more)

### Community 69 - "MainIcon"
Cohesion: 0.09
Nodes (12): MainIcon, cloud, .`default`, drop, heart, .id, .description, .displayName (+4 more)

### Community 70 - "Test.swift"
Cohesion: 0.16
Nodes (9): ConfigurationAppIntent, .smiley, .starEyes, Provider, SimpleEntry, Test, .body, TestEntryView (+1 more)

### Community 71 - "#329 빠른 물 기록 가이드 제작·발행"
Cohesion: 0.11
Nodes (18): #329 빠른 물 기록 가이드 제작·발행, Capture Assets, Community Draft, Completion Notes, Constraints, Context, Device Verification, First-Use Check (+10 more)

### Community 72 - "RoutineNotificationDataSourceImpl"
Cohesion: 0.16
Nodes (3): Constant, RoutineAlarmMetadata, RoutineNotificationDataSourceImpl

### Community 73 - "HydrationRecordDaySummary"
Cohesion: 0.11
Nodes (17): HydrationRecordDaySummary, .glassCount, .id, .hasLoadedRecords, .selectedPeriodRangeText, .todaySummary, .weekDayItems, HydrationRecordPeriod (+9 more)

### Community 74 - "HydrationGoalRecommendationUnavailableReason"
Cohesion: 0.17
Nodes (8): HydrationGoalRecommendationDataSource, HydrationGoalRecommendationRepositoryImpl, HydrationGoalRecommendationUnavailableReason, appleIntelligenceNotEnabled, deviceNotEligible, modelNotReady, unknown, unsupportedLocale

### Community 75 - "OnboardingView"
Cohesion: 0.14
Nodes (10): OnboardingPage, OnboardingView, .backgroundGradient, .body, .footer, .footerActions, .header, .nextButton (+2 more)

### Community 78 - "HydrationGoalRecommendationUseCaseImpl"
Cohesion: 0.16
Nodes (6): HydrationGoalRecommendationRepository, BodyProfileUseCase, Constants, HydrationGoalRecommendationUseCaseImpl, HydrationGoalRecommendationUseCaseTests, MockHydrationGoalRecommendationRepository

### Community 79 - "HydrationEvent"
Cohesion: 0.10
Nodes (3): MockDrinkWaterUseCase, .currentWaterIntakeML, HydrationEvent

### Community 80 - "WatchDailyGoalRepository"
Cohesion: 0.15
Nodes (3): WatchDailyGoalRepository, UndoDailyGoalRepository, UndoHealthStore

### Community 81 - "RoutineActionIntent"
Cohesion: 0.06
Nodes (39): .id, ChallengeBadge, .body, ChallengeCard, .accentColor, .body, .cardBackground, ChallengeCategory (+31 more)

### Community 82 - "DrinkWaterRepositoryImpl"
Cohesion: 0.15
Nodes (3): DrinkWaterDataSource, DrinkWaterRepositoryImpl, .currentWaterIntakeML

### Community 83 - "#336 Watch 최근 기록 한 건 되돌리기"
Cohesion: 0.13
Nodes (11): #336 Watch 최근 기록 한 건 되돌리기, Completion Notes, Constraints, Context, Goal, Non-Goals, Open Questions, Plan (+3 more)

### Community 84 - ".loadChallenges"
Cohesion: 0.28
Nodes (3): ChallengeViewModelTests, MockChallengeUseCase, MockPersonalizedChallengeUseCase

### Community 85 - "AppleSignInCredential"
Cohesion: 0.17
Nodes (4): AuthenticationServices, AppleSignInCredential, AppleSignInDataSourceImpl, AppleSignInDelegate

### Community 87 - "Xcode Cloud Release Build"
Cohesion: 0.14
Nodes (12): Release-Build Workflow, Xcode Cloud Release Build, Generation and editing — Mulimi Drop v3, Original body layer prompt, Original face layer prompt, Original master prompt, Mulimi Drop — v3, 레이어 (+4 more)

### Community 88 - "Value"
Cohesion: 0.16
Nodes (6): Provider, StartTimerIntent, TestControl, .body, TimerConfiguration, Value

### Community 91 - "WatchHydrationViewModel"
Cohesion: 0.18
Nodes (8): MutationAction, record, reset, undo, WatchHydrationViewModel, .canDrinkWater, .hasCurrentSnapshot, WatchHydrationUndoTests

### Community 92 - "프로젝트 전체 구조와 의존성"
Cohesion: 0.17
Nodes (12): App · 조립 루트 — 8개, Core — 6개, Features — 18개, Shared — 5개, Tests — 16개, 검증과 갱신, 기능 간 직접 의존에서 주의할 점, 디렉터리와 소유권 (+4 more)

### Community 93 - "HydrationGoalRecommendationAvailability"
Cohesion: 0.14
Nodes (7): MockHydrationGoalRecommendationUseCase, HydrationGoalRecommendationAvailability, bodyProfileRequired, modelUnavailable, ready, HydrationGoalRecommendationUseCase, MockHydrationGoalRecommendationUseCase

### Community 94 - "Hashable"
Cohesion: 0.25
Nodes (5): HydrationGoalRecommendation, HydrationGoalRecommendationError, bodyProfileRequired, modelUnavailable, HydrationGoalRecommendationInput

### Community 96 - "Security And Privacy Operations"
Cohesion: 0.17
Nodes (9): Analytics Allowlist, App Group and iCloud KVS Boundary, Apple Account Deletion Guidance, Apple App Privacy Details, Apple Credential Handling, Data Boundary, PostHog Privacy Controls, Security And Privacy Operations (+1 more)

### Community 97 - "AccountDomain"
Cohesion: 0.09
Nodes (4): AccountDomain, CoreGraphics, MulimiKeychain, MulimiPlatform

### Community 99 - "DrinkWaterRepository"
Cohesion: 0.14
Nodes (3): Constants, PersonalizedChallengeUseCaseImpl, DrinkWaterRepository

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

### Community 104 - "Sendable"
Cohesion: 0.10
Nodes (9): MockHydrationNextActionGuideUseCase, MockHydrationNextActionGuideUseCaseForTesting, MockHydrationProgressUseCaseForTesting, MockHydrationRoutineAdherenceUseCaseForTesting, MockRoutineRecommendationUseCaseForTesting, HydrationProgressUseCase, HydrationNextActionGuideUseCase, HydrationRoutineAdherenceUseCase (+1 more)

### Community 106 - "WaterDropView"
Cohesion: 0.13
Nodes (7): WaterDropView, .body, .dropBackground, .dropHighlights, .dropSymbol, WaterWaveView, .animatableData

### Community 107 - "CaseIterable"
Cohesion: 0.16
Nodes (10): HydrationServing, .additionalPresets, HydrationServingPreset, bottle, .id, tumbler, .volumeML, .progressLevel (+2 more)

### Community 108 - "Generation prompts"
Cohesion: 0.18
Nodes (9): body, cheeks, face, Generation prompts, Master, Mulimi Liquid Glass 아이콘 — #339, v1, 미리보기와 확인, 사용 (+1 more)

### Community 109 - "ConfigurationAppIntent"
Cohesion: 0.18
Nodes (4): ConfigurationAppIntent, .description, .title, ConfigurationAppIntent

### Community 111 - "StaticAppInfoProvider"
Cohesion: 0.24
Nodes (3): StaticAppInfoProvider, SettingsViewModelTests, SpyWidgetTimelineReloader

### Community 113 - "WatchHydrationSnapshot"
Cohesion: 0.10
Nodes (9): WatchHydrationMutationResult, WatchHydrationSnapshot, .eventCount, .isGoalReached, .lastDrinkDate, .progress, .remainingML, WatchHydrationUseCase (+1 more)

### Community 114 - "NavigationPresentationStyle"
Cohesion: 0.40
Nodes (4): NavigationPresentationStyle, fullScreenCover, push, sheet

### Community 115 - "AnalyticsRepository"
Cohesion: 0.22
Nodes (3): Release Filter, AnalyticsRepository, NoOpAnalyticsRepository

### Community 116 - "ReadRecoveryRepository"
Cohesion: 0.27
Nodes (3): ReadRecoveryGoal, ReadRecoveryRepository, WatchHydrationReadRecoveryTests

### Community 117 - "UserPreferencesDataSourceImpl"
Cohesion: 0.17
Nodes (4): Constants, UserPreferencesDataSource, UserPreferencesDataSourceImpl, UserPreferencesRepositoryImpl

### Community 118 - "TokenProperty"
Cohesion: 0.22
Nodes (6): TokenProperty, accessToken, email, nickname, refreshToken, userIdentifier

### Community 120 - "DIEnvironment"
Cohesion: 0.33
Nodes (5): DIEnvironment, .current, preview, production, testing

### Community 121 - "AI PR Review Workflow"
Cohesion: 0.18
Nodes (8): AI PR Review Workflow, Architecture Review Policy, Git Flow PR Filter, Textual Diff Selection, Clean Architecture and MVVM Discipline, Hydration Source of Truth, Data Sources of Truth, AI Review Automation Contract

### Community 124 - "ContentState"
Cohesion: 0.38
Nodes (6): ContentState, TestAttributes, TestAttributes.ContentState, .smiley, .starEyes, .preview

### Community 125 - "아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법"
Cohesion: 0.17
Nodes (10): Apple Watch에서 기록하기, Siri·단축어로 기록하기, Siri에게 말하기, 기록이 저장됐는지 확인하기, 내게 맞는 방법 고르기, 단축어 앱에서 실행, 설정하거나 기록하다 막혔다면, 아이폰에서 물 마시기 기록을 쉽게: 위젯·애플워치·단축어 설정법 (+2 more)

### Community 126 - "Error"
Cohesion: 0.05
Nodes (35): HealthQuantityStoreError, incompleteQuery, internalError, invalidObjectType, permissionDenied, AuthenticationError, cancelled, invalidCredential (+27 more)

### Community 127 - "HydrationWriteResult"
Cohesion: 0.07
Nodes (9): MockDrinkWaterUseCaseForTesting, .currentWaterIntakeML, .analyticsFailureReason, HydrationWriteResult, failure, .failureReason, .isSuccess, success (+1 more)

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

### Community 136 - "WatchDailyGoalLocalDataSource"
Cohesion: 0.24
Nodes (4): MulimiCloudKit, WatchDailyGoalLocalDataSource, WatchDailyGoalUserDefaultsDataSource, WatchDailyGoalRepositoryImpl

### Community 137 - "HydrationInsightView"
Cohesion: 0.07
Nodes (25): BadgeView, .body, HydrationInsightCategory, analysis, .id, routine, .systemImage, .title (+17 more)

### Community 138 - "Accessibility and Dynamic Type Audit"
Cohesion: 0.50
Nodes (4): Accessibility and Dynamic Type Audit, Dynamic Type Adaptation, Reduce Motion and Transparency Support, VoiceOver Semantics

### Community 139 - "HealthKitRepository"
Cohesion: 0.14
Nodes (3): HealthKitRepository, BodyProfileUseCaseImpl, BodyProfileUseCaseTests

### Community 143 - "FoundationModelsHydrationGoalRecommendationDataSource"
Cohesion: 0.28
Nodes (3): Constants, FoundationModelsHydrationGoalRecommendationDataSource, GeneratedHydrationGoalRecommendation

### Community 144 - ".assemble"
Cohesion: 0.24
Nodes (4): PreviewAssembly, DataAssembly, DomainAssembly, PresentationAssembly

### Community 145 - "MockError"
Cohesion: 0.20
Nodes (9): MockError, .errorDescription, signInFailed, MockError, deleteFailed, .errorDescription, MockError, .errorDescription (+1 more)

### Community 146 - "DrinkWaterWidget"
Cohesion: 0.10
Nodes (12): TestBundle, .body, TestLiveActivity, .body, DrinkWaterLockScreenWidget, .body, DrinkWaterWidget, .body (+4 more)

### Community 148 - "HydrationChallengeBadgeHistory"
Cohesion: 0.13
Nodes (6): MockChallengeUseCase, ChallengeRepositoryImpl, HydrationChallengeBadgeHistory, ChallengeRepository, ChallengeUseCaseTests, MockChallengeRepository

### Community 151 - "ProfileRoutineViewModel"
Cohesion: 0.08
Nodes (19): .body, RoutineEditorView, .body, .weekdayGrid, ProfileRoutineViewModel, .canSaveDraft, .displayedRoutines, .guidanceSummary (+11 more)

### Community 152 - "MockAnalyticsUseCase"
Cohesion: 0.10
Nodes (7): HydrationComebackRepository, HydrationComebackMode, baseline, card, disabled, StubHydrationComebackRepository, MockAnalyticsUseCase

### Community 154 - "ChallengeViewModel"
Cohesion: 0.12
Nodes (7): HydrationChallenge, .id, ChallengeUseCase, ChallengeCardModel, ChallengeHistoryCardModel, ChallengeViewModel, .hasLoadedChallenges

### Community 155 - "Challenge State Model"
Cohesion: 0.50
Nodes (4): Challenge Recalculation and Merge Cycle, Challenge State Model, Cumulative Challenge State, Recurring Challenge State

### Community 156 - "HydrationRecordListViewModel"
Cohesion: 0.14
Nodes (9): .body, .yearMonthPickerSheet, HydrationRecordListViewModel, .emptyStateDescription, .emptyStateTitle, .showsEmptyStateRecordCTA, HydrationRecordListViewModelTests, RecordRecoveryClock (+1 more)

### Community 157 - "AuthProvider"
Cohesion: 0.40
Nodes (4): AuthProvider, apple, google, kakao

### Community 158 - "Mulimi Pull Request Template"
Cohesion: 0.50
Nodes (3): Local Validation Reporting, Mulimi Pull Request Template, PR Review Checklist

### Community 159 - "KeyChainDataSourceImpl"
Cohesion: 0.24
Nodes (3): KeychainStore, KeychainStoring, KeyChainDataSourceImpl

### Community 160 - "Generation — Mulimi Water Glass v2"
Cohesion: 0.25
Nodes (6): droplet, Generation — Mulimi Water Glass v2, glass, Master, water, Mulimi — Water Glass v2

### Community 163 - "View"
Cohesion: 0.08
Nodes (19): AccountRoute, profileRoutine, setting, ProfileView, .body, .goalRecommendationCard, .goalRecommendationRoute, .routineCard (+11 more)

### Community 164 - "ChallengeStorageDataSourceImpl"
Cohesion: 0.35
Nodes (3): ChallengeStorageDataSource, ChallengeStorageDataSourceImpl, ChallengeStorageDataSourceTests

### Community 166 - "#321 수분 알림 바로 기록"
Cohesion: 0.18
Nodes (11): #321 수분 알림 바로 기록, Completion Notes, Constraints, Context, Goal, Non-Goals, Open Questions, Plan (+3 more)

### Community 168 - "DataAssembly.swift"
Cohesion: 0.18
Nodes (5): AccountData, ChallengeData, MulimiAnalyticsData, RoutineData, Utils

### Community 169 - "Reliability Recovery"
Cohesion: 0.22
Nodes (6): HealthKit Source of Truth, Reliability Recovery, Shared Hydration Rules, HealthKit Data Flow, healthkit-flow, widget-watch-integration

### Community 171 - "AppTab"
Cohesion: 0.33
Nodes (6): AppTab, challenge, drink, history, insight, profile

### Community 173 - "HydrationRecordListView"
Cohesion: 0.25
Nodes (4): HydrationRecordListView, .body, RowListView, .body

### Community 174 - "Clean Architecture and MVVM"
Cohesion: 0.29
Nodes (5): Clean Architecture and MVVM, navigation-coordinator, Root Navigation, Modular Clean Architecture, Root App Flow

### Community 175 - "BundleAppInfoProvider"
Cohesion: 0.43
Nodes (4): AppInfoProviding, BundleAppInfoProvider, .appBuildNumber, .appVersion

### Community 177 - "Layer Responsibilities"
Cohesion: 0.18
Nodes (9): CI Lint and Architecture Gate, Lint Workflow, Domain Data Presentation Test Matrix, PR Unit Tests Workflow, Selected SwiftLint Rule Set, SwiftLint Configuration, Default Validation Sequence, Dependency Direction (+1 more)

### Community 179 - "HealthKitDataSourceImpl"
Cohesion: 0.10
Nodes (6): HealthKitDataSource, HealthKitDataSourceImpl, .healthKitAuthorizationStatus, .isWaterSharingAuthorized, HealthKitRepositoryImpl, .authorisationStatus

### Community 184 - ".resolve"
Cohesion: 0.36
Nodes (5): PreviewViews, .challenge, .drinkWater, .hydrationList, .profile

### Community 185 - "RoutineUseCase"
Cohesion: 0.21
Nodes (3): HydrationNextActionGuideUseCaseImpl, RoutineUseCase, HydrationNextActionGuideUseCaseTests

### Community 187 - "AuthenticationRepositoryImpl"
Cohesion: 0.14
Nodes (5): AppleSignInDataSource, KeyChainDataSource, AuthenticationRepositoryImpl, .isAuthenticated, AuthenticationRepository

### Community 188 - "CustomHydrationAmountValidation"
Cohesion: 0.40
Nodes (5): CustomHydrationAmountValidation, empty, invalid, overLimit, valid

### Community 192 - "LogWaterAppShortcuts"
Cohesion: 0.33
Nodes (3): LogWaterAppShortcuts, .appShortcuts, .shortcutTileColor

### Community 194 - "Release And QA Runbook"
Cohesion: 0.50
Nodes (4): 72-Hour Audit, Before Release, Release Activity Check, Release And QA Runbook

## Ambiguous Edges - Review These
- `HealthKit Source of Truth` → `CloudKit-Backed Hydration Store`  [AMBIGUOUS]
  Docs/swiftdata-cloudkit-sync.md · relation: conceptually_related_to
- `CloudKit-Backed Hydration Store` → `Current Storage Strategy`  [AMBIGUOUS]
  README.md · relation: conceptually_related_to

## Knowledge Gaps
- **566 isolated node(s):** `.resolver`, `production`, `preview`, `testing`, `.current` (+561 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1035 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **47 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `HealthKit Source of Truth` and `CloudKit-Backed Hydration Store`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `CloudKit-Backed Hydration Store` and `Current Storage Strategy`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `String` connect `String` to `HydrationRoutineAdherenceInsight`, `SettingsViewModel`, `HydrationRoutine`, `MockDrinkWaterUseCase`, `MockHealthKitRepository`, `.tr`, `HealthKitQuantityStore`, `.assemble`, `HydrationStarterPlanViewModel`, `DrinkWaterUseCase`, `DrinkWaterViewModel`, `HydrationChallengeKind`, `HealthKitPermissionViewModel`, `UndoQuantityStore`, `BodyProfile`, `HydrationStarterPlan`, `MockDrinkWaterRepository`, `.tr`, `UUID`, `SpyRoutineUseCase`, `HydrationRoutineRecommendation`, `ContentView`, `PostHogAnalyticsRepository`, `HydrationReminderPermissionViewModel`, `PersonalizedHydrationChallenge`, `RecordCalendarView`, `AppReviewRequestState`, `HydrationGoalRecommendationViewModel`, `UnavailableHealthStore`, `AppReviewRequestUseCaseImpl`, `Equatable`, `Foundation`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `LiquidGlassSegmentedControl`, `.track`, `HydrationInsightViewModel`, `BodyProfileViewModel`, `DrinkWaterHealthKitDataSource`, `ChallengeUseCaseImpl`, `HydrationReminderSlot`, `DrinkWaterEntry`, `UserCredential`, `LogWaterAppIntent`, `ProjectDescription`, `HealthKitSource`, `MainIcon`, `Test.swift`, `RoutineNotificationDataSourceImpl`, `HydrationRecordDaySummary`, `OnboardingView`, `HydrationEvent`, `RoutineActionIntent`, `AppleSignInCredential`, `AppReviewRequestUseCase`, `Value`, `WatchHydrationViewModel`, `Hashable`, `LogWaterAmountOption`, `.recordWater`, `HealthKitAuthorizationStatus`, `CaseIterable`, `ConfigurationAppIntent`, `MockUserPreferencesUseCase`, `StaticAppInfoProvider`, `AnalyticsRepository`, `UserPreferencesDataSourceImpl`, `TokenProperty`, `UbiquitousMirroredStore`, `ContentState`, `Error`, `HydrationWriteResult`, `HydrationNextActionGuide`, `RoutineWeekday`, `HydrationInsightView`, `FoundationModelsHydrationGoalRecommendationDataSource`, `MockError`, `DrinkWaterWidget`, `HydrationChallengeBadgeHistory`, `ProfileRoutineViewModel`, `MockAnalyticsUseCase`, `ChallengeViewModel`, `HydrationRecordListViewModel`, `KeyChainDataSourceImpl`, `.progressSnapshot`, `View`, `ChallengeStorageDataSourceImpl`, `MockUserPreferencesUseCaseForTesting`, `BundleAppInfoProvider`, `HealthKitDataSourceImpl`, `AnalyticsUseCaseImpl`, `MockAppReviewRequestUseCase`, `AuthenticationRepositoryImpl`?**
  _High betweenness centrality (0.282) - this node is a cross-community bridge._
- **Why does `Foundation` connect `Foundation` to `HydrationRoutineAdherenceInsight`, `WatchHydrationUndoTests.swift`, `UserPreferencesUseCase`, `HydrationNextActionGuide`, `MockHealthKitRepository`, `UserPreferencesRepository`, `WatchDailyGoalLocalDataSource`, `HealthKitQuantityStore`, `.tr`, `HealthKitRepository`, `DrinkWaterUseCase`, `RoutineDomain`, `HydrationChallengeKind`, `RoutineNotificationAuthorizationStatus`, `HydrationChallengeBadgeHistory`, `BodyProfile`, `HydrationStarterPlan`, `MockAnalyticsUseCase`, `RoutineRepository`, `ChallengeViewModel`, `HydrationRoutineRecommendation`, `.tr`, `AuthProvider`, `Localization`, `KeyChainDataSourceImpl`, `SignInUseCaseImpl`, `AppReviewRequestState`, `HydrationProgressSnapshot`, `StackRouting`, `String`, `DataAssembly.swift`, `WatchHydrationEvent`, `MockHydrationReminderRepository`, `HydrationPresentation`, `HydrationReminderRepository`, `Equatable`, `BundleAppInfoProvider`, `UserDefaults`, `HydrationReminderAuthorizationStatus`, `HydrationInsightViewModel`, `BodyProfileViewModel`, `AnalyticsUseCase`, `RoutineUseCase`, `AuthenticationRepositoryImpl`, `HydrationReminderSlot`, `UserCredential`, `MainIcon`, `HydrationGoalRecommendationUseCaseImpl`, `HydrationEvent`, `AppleSignInCredential`, `AppReviewRequestUseCase`, `HealthKitUseCase`, `HydrationGoalRecommendationAvailability`, `Hashable`, `AccountDomain`, `DrinkWaterRepository`, `HealthKitAuthorizationStatus`, `Sendable`, `CaseIterable`, `WatchHydrationSnapshot`, `TokenProperty`, `DIEnvironment`, `UbiquitousMirroredStore`, `Error`?**
  _High betweenness centrality (0.081) - this node is a cross-community bridge._
- **Why does `프로젝트 전체 구조와 의존성` connect `프로젝트 전체 구조와 의존성` to `AppDelegate`, `WatchHydrationUndoTests.swift`, `Docs Index`?**
  _High betweenness centrality (0.058) - this node is a cross-community bridge._
- **Are the 23 inferred relationships involving `HydrationInsightViewModel` (e.g. with `.assemble()` and `.assemble()`) actually correct?**
  _`HydrationInsightViewModel` has 23 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.resolver`, `production`, `preview` to the rest of the system?**
  _566 weakly-connected nodes found - possible documentation gaps or missing edges._