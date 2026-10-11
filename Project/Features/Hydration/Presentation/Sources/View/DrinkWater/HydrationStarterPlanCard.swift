import MulimiUISystem
import Localization
import SwiftUI

struct HydrationStarterPlanCard: View {
    let viewModel: HydrationStarterPlanViewModel
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "checklist")
                        .font(.system(size: 22, weight: .semibold))
                        .frame(width: 44, height: 44)
                        .background(Color.accent.opacity(0.18), in: RoundedRectangle(cornerRadius: 12))
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(L10n.tr("starterPlanTitle"))
                            .font(.headline)
                        Text(progressText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                ProgressView(value: Double(viewModel.completedStepCount), total: 3)
                    .tint(Color.accent)
                    .accessibilityHidden(true)

                Text(nextStepText)
                    .font(.subheadline.weight(.medium))

                HStack(spacing: 8) {
                    Text(L10n.tr(viewModel.nextStep == .finish ? "starterPlanFinishEntry" : "starterPlanContinueEntry"))
                    Image(systemName: "arrow.right")
                        .accessibilityHidden(true)
                }
                .font(.subheadline.weight(.bold))
            }
            .foregroundStyle(.primary)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color.accent.opacity(0.4), lineWidth: 1)
            }
            .contentShape(RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.tr("starterPlanTitle"))
        .accessibilityValue("\(progressText), \(nextStepText)")
        .accessibilityHint(L10n.tr("starterPlanOpenAccessibilityHint"))
    }

    private var progressText: String {
        L10n.tr("starterPlanProgressFormat", viewModel.dayNumber ?? 1, viewModel.completedStepCount)
    }

    private var nextStepText: String {
        switch viewModel.nextStep {
        case .recordWater: L10n.tr("starterPlanNextRecord")
        case .saveRoutine: L10n.tr("starterPlanNextRoutine")
        case .chooseMethod: L10n.tr("starterPlanNextMethod")
        case .finish: L10n.tr("starterPlanNextFinish")
        case nil: ""
        }
    }
}
