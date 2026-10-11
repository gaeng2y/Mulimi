internal import DesignSystemFoundation
import SwiftUI

/// Mulimi styling stays here; Foundation only supplies reusable base values.
struct LiquidGlassSegmentStyle {
    let reduceMotion: Bool
    let reduceTransparency: Bool
    let dynamicTypeSize: DynamicTypeSize

    var spacing: CGFloat { DesignTokens.Spacing.compact }
    var padding: CGFloat { DesignTokens.Spacing.tight }
    var labelSpacing: CGFloat { DesignTokens.Spacing.tight }
    var font: Font { DesignTokens.Typography.emphasizedCaption }
    var borderWidth: CGFloat { DesignTokens.Control.borderWidth }
    var animation: Animation? { reduceMotion ? nil : DesignTokens.Motion.quick }
    var lineLimit: Int { dynamicTypeSize.isAccessibilitySize ? 2 : 1 }
    var minimumScaleFactor: CGFloat { 0.78 }

    var minimumHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize
            ? DesignTokens.Control.accessibilityMinimumHeight
            : DesignTokens.Control.minimumHeight
    }

    var containerShadow: Color { DesignTokens.Palette.shadow.opacity(0.08) }
    var activeShadow: Color { Color.accentColor.opacity(0.18) }

    var containerBackground: AnyShapeStyle {
        reduceTransparency
            ? AnyShapeStyle(Color(uiColor: .secondarySystemBackground))
            : AnyShapeStyle(.ultraThinMaterial)
    }

    var activeBackground: AnyShapeStyle {
        AnyShapeStyle(Color(uiColor: .systemBackground).opacity(reduceTransparency ? 1 : 0.72))
    }

    var containerBorder: LinearGradient {
        LinearGradient(
            colors: [
                DesignTokens.Palette.highlight.opacity(0.42),
                DesignTokens.Palette.highlight.opacity(0.12),
                Color.accentColor.opacity(0.12)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var activeBorder: LinearGradient {
        LinearGradient(
            colors: [DesignTokens.Palette.highlight.opacity(0.7), Color.accentColor.opacity(0.22)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
