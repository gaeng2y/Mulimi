import Localization
import SwiftUI

public struct ProfileRoutineView: View {
    @Bindable private var viewModel: ProfileRoutineViewModel

    public init(viewModel: ProfileRoutineViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        List {
            Section {
                overviewCard
            }

            Section(L10n.tr("profileRoutineOverviewSectionTitle")) {
                ForEach(viewModel.detailRows) { row in
                    detailRow(for: row)
                }
            }

            if !viewModel.displayedRoutines.isEmpty {
                Section(L10n.tr("profileRoutineSchedulesSectionTitle")) {
                    ForEach(viewModel.displayedRoutines) { routine in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(routine.title)
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("\(routine.timeDescription) · \(routine.repeatDescription)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle(L10n.tr("profileRoutineSectionTitle"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.summaryBadgeText)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.accentColor)

            Text(viewModel.summaryHeadline)
                .font(.headline)

            Text(viewModel.summaryDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }

    private func detailRow(for row: RoutineDetailRow) -> some View {
        HStack(spacing: 12) {
            Image(systemName: row.systemImage)
                .foregroundColor(.accentColor)
                .frame(width: 20)

            Text(row.title)
                .foregroundColor(.primary)

            Spacer()

            Text(row.value)
                .foregroundColor(.secondary)
        }
    }
}
