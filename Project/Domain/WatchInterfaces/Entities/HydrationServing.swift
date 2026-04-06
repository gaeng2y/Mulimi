import Foundation

public enum HydrationServing {
    public static let defaultGlassML = 250.0

    public static func glassCount(for intakeML: Double) -> Int {
        Int((intakeML / defaultGlassML).rounded())
    }

    public static func intakeML(forGlassCount glassCount: Int) -> Double {
        Double(glassCount) * defaultGlassML
    }
}
