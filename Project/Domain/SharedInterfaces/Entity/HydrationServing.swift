import Foundation

public enum HydrationServingPreset: String, CaseIterable, Identifiable, Sendable {
    case bottle
    case tumbler

    public var id: String {
        rawValue
    }

    public var volumeML: Int {
        switch self {
        case .bottle:
            return HydrationServing.bottleML
        case .tumbler:
            return HydrationServing.tumblerML
        }
    }
}

public enum HydrationServing {
    public static let defaultGlassVolumeML = 250
    public static let defaultGlassML = Double(defaultGlassVolumeML)
    public static let bottleML = 330
    public static let tumblerML = 500

    public static var additionalPresets: [HydrationServingPreset] {
        HydrationServingPreset.allCases
    }

    public static func glassCount(for intakeML: Double) -> Int {
        Int((intakeML / defaultGlassML).rounded())
    }

    public static func remainingGlassCount(for remainingML: Double) -> Int {
        guard remainingML > 0 else {
            return 0
        }

        return Int((remainingML / defaultGlassML).rounded(.up))
    }

    public static func intakeML(forGlassCount glassCount: Int) -> Double {
        Double(glassCount) * defaultGlassML
    }
}
