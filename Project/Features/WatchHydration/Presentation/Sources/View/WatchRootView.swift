import SwiftUI

public struct WatchRootView: View {
    private let accentColor = Color.teal

    @Environment(\.scenePhase) private var scenePhase
    @State private var viewModel: WatchHydrationViewModel

    public init(viewModel: WatchHydrationViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    heroCard

                    NavigationLink {
                        WatchTodayView(viewModel: viewModel)
                    } label: {
                        WatchNavigationCard(
                            title: WatchL10n.tr("watchHomeRecordsCardTitle"),
                            detail: WatchL10n.tr(
                                "watchHomeRecordsCardDetailFormat",
                                Int64(viewModel.snapshot.eventCount)
                            )
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        WatchStatusView(viewModel: viewModel)
                    } label: {
                        WatchNavigationCard(
                            title: WatchL10n.tr("watchHomeStatusCardTitle"),
                            detail: remainingText(viewModel.snapshot.remainingML)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .background(backgroundGradient)
            .navigationTitle(WatchL10n.tr("watchHomeNavigationTitle"))
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            await viewModel.load()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else {
                return
            }

            Task {
                await viewModel.load()
            }
        }
        .alert(
            WatchL10n.tr("watchHydrationMutationFailureTitle"),
            isPresented: Binding(
                get: { viewModel.mutationErrorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.clearMutationError()
                    }
                }
            )
        ) {
            Button(WatchL10n.tr("watchCommonConfirmButton")) {
                viewModel.clearMutationError()
            }
        } message: {
            Text(viewModel.mutationErrorMessage ?? "")
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 3) {
                Text(mlText(viewModel.snapshot.todayIntakeML))
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.62)

                Text(WatchL10n.tr("watchHomeGoalFormat", mlText(viewModel.snapshot.dailyGoalML)))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }

            VStack(alignment: .leading, spacing: 8) {
                WatchProgressBar(
                    progress: viewModel.snapshot.progress,
                    accentColor: accentColor
                )

                HStack {
                    Text(percentText(Int((viewModel.snapshot.progress * 100).rounded())))
                        .font(.caption.weight(.semibold))
                        .monospacedDigit()

                    Spacer(minLength: 8)

                    Text(
                        viewModel.snapshot.isGoalReached
                        ? WatchL10n.tr("watchHomeGoalReached")
                        : remainingText(viewModel.snapshot.remainingML)
                    )
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                }
            }

            HStack(spacing: 8) {
                Button {
                    Task {
                        await viewModel.drinkWater()
                    }
                } label: {
                    Text(
                        viewModel.snapshot.isGoalReached
                        ? WatchL10n.tr("watchHomeDrinkCompleteButton")
                        : WatchL10n.tr("watchCommonDrinkButton")
                    )
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(viewModel.canDrinkWater ? accentColor : .gray)
                .disabled(viewModel.isMutating || !viewModel.canDrinkWater)

                Button(role: .destructive) {
                    Task {
                        await viewModel.resetToday()
                    }
                } label: {
                    Text(WatchL10n.tr("watchCommonResetButton"))
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.isMutating || viewModel.snapshot.events.isEmpty)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(
                    WatchL10n.tr(
                        "watchHomeDrinkCountFormat",
                        Int64(viewModel.snapshot.eventCount)
                    )
                )
                    .font(.caption.weight(.semibold))
                    .contentTransition(.numericText())

                if let lastDrinkDate = viewModel.snapshot.lastDrinkDate {
                    Text(
                        WatchL10n.tr(
                            "watchHomeRecentRecordFormat",
                            lastDrinkDate.formatted(.dateTime.hour().minute())
                        )
                    )
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                } else {
                    Text(WatchL10n.tr("watchHomeNoRecordsPrompt"))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }

                Text(nextActionText)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(accentColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                accentColor.opacity(0.34),
                accentColor.opacity(0.16),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private func formattedML(_ value: Int) -> String {
        value.formatted(.number.grouping(.automatic))
    }

    private func mlText(_ value: Int) -> String {
        WatchL10n.tr("watchCommonMLTextFormat", formattedML(value))
    }

    private func remainingText(_ value: Int) -> String {
        WatchL10n.tr("watchHomeRemainingFormat", mlText(value))
    }

    private func percentText(_ value: Int) -> String {
        WatchL10n.tr("watchCommonPercentFormat", Int64(value))
    }

    private var nextActionText: String {
        switch viewModel.snapshot.nextActionGuide.state {
        case .goalReached:
            return WatchL10n.tr("watchHomeNextActionGoalReached")
        case .needsGoal:
            return WatchL10n.tr("watchHomeNextActionNeedsGoal")
        case .readyToDrink, .approachingRoutine:
            return WatchL10n.tr(
                "watchHomeNextActionRemainingGlassFormat",
                Int64(viewModel.snapshot.nextActionGuide.remainingGlassCount)
            )
        }
    }
}

private struct WatchProgressBar: View {
    let progress: Double
    let accentColor: Color

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.12))

                if progress > 0 {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [accentColor.opacity(0.95), accentColor.opacity(0.55)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(proxy.size.width * progress, 16))
                        .animation(.spring(response: 0.42, dampingFraction: 0.82), value: progress)
                }
            }
        }
        .frame(height: 12)
    }
}

private struct WatchNavigationCard: View {
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(detail)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

private struct WatchTodayView: View {
    let viewModel: WatchHydrationViewModel

    var body: some View {
        List {
            Section {
                HStack {
                    Text(WatchL10n.tr("watchTodayTotalLabel"))
                    Spacer()
                    Text(mlText(viewModel.snapshot.todayIntakeML))
                        .foregroundStyle(.teal)
                }

                HStack {
                    Text(WatchL10n.tr("watchTodayRemainingLabel"))
                    Spacer()
                    Text(mlText(viewModel.snapshot.remainingML))
                }
            }

            if viewModel.snapshot.events.isEmpty {
                Section {
                    Text(WatchL10n.tr("watchTodayEmpty"))
                        .foregroundStyle(.secondary)
                }
            } else {
                Section {
                    ForEach(viewModel.snapshot.events.reversed()) { event in
                        HStack {
                            Text(event.consumedAt.formatted(.dateTime.hour().minute()))
                            Spacer()
                            Text(mlText(event.volumeML))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(WatchL10n.tr("watchTodayTitle"))
    }

    private func mlText(_ value: Int) -> String {
        WatchL10n.tr("watchCommonMLTextFormat", value.formatted(.number.grouping(.automatic)))
    }
}

private struct WatchStatusView: View {
    let viewModel: WatchHydrationViewModel

    var body: some View {
        List {
            Section {
                WatchMetricRow(
                    title: WatchL10n.tr("watchStatusProgressTitle"),
                    value: WatchL10n.tr(
                        "watchCommonPercentFormat",
                        Int64(Int((viewModel.snapshot.progress * 100).rounded()))
                    )
                )
                WatchMetricRow(
                    title: WatchL10n.tr("watchStatusRemainingTitle"),
                    value: mlText(viewModel.snapshot.remainingML)
                )
                WatchMetricRow(
                    title: WatchL10n.tr("watchStatusCountTitle"),
                    value: WatchL10n.tr(
                        "watchStatusCountFormat",
                        Int64(viewModel.snapshot.eventCount)
                    )
                )
            }

            Section {
                Button(WatchL10n.tr("watchCommonResetButton"), role: .destructive) {
                    Task {
                        await viewModel.resetToday()
                    }
                }
                .disabled(viewModel.isMutating || viewModel.snapshot.events.isEmpty)
            }
        }
        .navigationTitle(WatchL10n.tr("watchStatusTitle"))
    }

    private func mlText(_ value: Int) -> String {
        WatchL10n.tr("watchCommonMLTextFormat", value.formatted(.number.grouping(.automatic)))
    }
}

private struct WatchMetricRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}
