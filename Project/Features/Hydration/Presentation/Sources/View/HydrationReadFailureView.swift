import Localization
import SwiftUI

struct HydrationReadFailureView: View {
    var showsPreviousData = false
    var isLoading = false
    let retry: () async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(L10n.tr("hydrationReadFailureTitle"), systemImage: "exclamationmark.triangle")
                .font(.headline)
            Text(L10n.tr(showsPreviousData ? "hydrationReadStaleDescription" : "hydrationReadFailureDescription"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button(L10n.tr("hydrationReadRetryTitle")) {
                Task { await retry() }
            }
            .buttonStyle(.bordered)
            .disabled(isLoading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
