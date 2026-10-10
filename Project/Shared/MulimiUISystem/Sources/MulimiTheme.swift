import Foundation
import SwiftUI

/// Mulimi's semantic colors, loaded from this framework rather than the host app.
public enum MulimiTheme {
    public static var accent: Color {
        Color("AccentColor", bundle: MulimiUIResources.bundle)
    }

    public static var background: Color {
        Color("BackgroundColor", bundle: MulimiUIResources.bundle)
    }
}

enum MulimiUIResources {
    static let bundle = Bundle(for: BundleToken.self)

    private final class BundleToken {}
}
