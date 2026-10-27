import SwiftUI

/// A decorative circle. Its color, placement and meaning belong to the caller.
public struct CircleHighlight: View {
    private let diameter: CGFloat
    private let color: Color

    public init(diameter: CGFloat, color: Color) {
        self.diameter = diameter
        self.color = color
    }

    public var body: some View {
        Circle()
            .fill(color)
            .frame(width: diameter, height: diameter)
            .accessibilityHidden(true)
    }
}
