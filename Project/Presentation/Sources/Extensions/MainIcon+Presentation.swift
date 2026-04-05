import DomainLayerInterface
import Localization

extension MainIcon {
    var displayName: String {
        switch self {
        case .drop:
            return L10n.tr("mainAppearanceDropName")
        case .heart:
            return L10n.tr("mainAppearanceHeartName")
        case .cloud:
            return L10n.tr("mainAppearanceCloudName")
        }
    }

    var systemImage: String {
        switch self {
        case .drop:
            return "drop"
        case .heart:
            return "heart"
        case .cloud:
            return "cloud"
        }
    }

    var fillSystemImage: String {
        switch self {
        case .drop:
            return "drop.fill"
        case .heart:
            return "heart.fill"
        case .cloud:
            return "cloud.fill"
        }
    }

    var description: String {
        switch self {
        case .drop:
            return L10n.tr("mainAppearanceDropDescription")
        case .heart:
            return L10n.tr("mainAppearanceHeartDescription")
        case .cloud:
            return L10n.tr("mainAppearanceCloudDescription")
        }
    }
}
