import SwiftUI

/// Brand-independent values currently used by the UI system.
public enum DesignTokens {
    public enum Palette {
        public static let highlight = Color.white
        public static let shadow = Color.black
    }

    public enum Spacing {
        public static let compact: CGFloat = 4
        public static let tight: CGFloat = 5
    }

    public enum Typography {
        public static let emphasizedCaption = Font.caption.weight(.semibold)
    }

    public enum Control {
        public static let minimumHeight: CGFloat = 44
        public static let accessibilityMinimumHeight: CGFloat = 52
        public static let borderWidth: CGFloat = 1
    }

    public enum Motion {
        public static let quick = Animation.easeOut(duration: 0.25)
    }
}
