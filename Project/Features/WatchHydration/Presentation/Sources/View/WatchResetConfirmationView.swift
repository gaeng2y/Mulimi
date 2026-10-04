import SwiftUI

struct WatchResetConfirmationView: View {
    let viewModel: WatchHydrationViewModel
    let confirmation: WatchHydrationResetConfirmation

    private var dateText: String {
        confirmation.date.formatted(.dateTime.year().month(.wide).day())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if confirmation.dateChanged {
                    Text(WatchL10n.tr("watchHydrationResetDateChanged"))
                        .font(.headline)
                }

                Text(WatchL10n.tr("watchHydrationResetDateFormat", dateText))
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)
                Text(WatchL10n.tr("watchHydrationResetScope"))
                Text(WatchL10n.tr("watchHydrationResetUndoDifference"))
                    .foregroundStyle(.secondary)

                Button(WatchL10n.tr("watchHydrationResetCancelButton"), role: .cancel) {
                    viewModel.cancelResetConfirmation()
                }
                .accessibilityLabel(WatchL10n.tr("watchHydrationResetCancelAccessibility"))

                Button(role: .destructive) {
                    Task { await viewModel.confirmReset(id: confirmation.id) }
                } label: {
                    Text(WatchL10n.tr("watchHydrationResetConfirmButton"))
                        .frame(maxWidth: .infinity)
                }
                .disabled(viewModel.isLoading || viewModel.isMutating)
                .accessibilityLabel(WatchL10n.tr("watchHydrationResetConfirmAccessibilityFormat", dateText))
            }
            .font(.body)
            .buttonStyle(.bordered)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .navigationTitle(WatchL10n.tr("watchHydrationResetConfirmationTitle"))
    }
}
