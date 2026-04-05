import DomainLayerInterface

extension MainIcon {
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
}
