//
//  LiquidGlassSegmentedControl.swift
//  MulimiUISystem
//
//  Created by Codex on 4/19/26.
//

import SwiftUI

public struct LiquidGlassSegment<Value: Hashable>: Identifiable {
    public let value: Value
    public let title: String
    public let systemImage: String?

    public var id: Value {
        value
    }

    public init(
        value: Value,
        title: String,
        systemImage: String? = nil
    ) {
        self.value = value
        self.title = title
        self.systemImage = systemImage
    }
}

public struct LiquidGlassSegmentedControl<Value: Hashable>: View {
    @Binding private var selection: Value
    private let segments: [LiquidGlassSegment<Value>]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Namespace private var activeSegmentNamespace

    public init(
        selection: Binding<Value>,
        segments: [LiquidGlassSegment<Value>]
    ) {
        self._selection = selection
        self.segments = segments
    }

    private var style: LiquidGlassSegmentStyle {
        LiquidGlassSegmentStyle(
            reduceMotion: reduceMotion,
            reduceTransparency: reduceTransparency,
            dynamicTypeSize: dynamicTypeSize
        )
    }

    public var body: some View {
        HStack(spacing: style.spacing) {
            ForEach(segments) { segment in
                segmentButton(segment)
            }
        }
        .padding(style.padding)
        .background(style.containerBackground, in: Capsule(style: .continuous))
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(style.containerBorder, lineWidth: style.borderWidth)
        }
        .shadow(color: style.containerShadow, radius: 18, x: 0, y: 10)
    }

    private func segmentButton(_ segment: LiquidGlassSegment<Value>) -> some View {
        let isSelected = selection == segment.value

        return Button {
            withAnimation(style.animation) {
                selection = segment.value
            }
        } label: {
            HStack(spacing: style.labelSpacing) {
                if let systemImage = segment.systemImage {
                    Image(systemName: systemImage)
                        .font(style.font)
                }

                Text(segment.title)
                    .font(style.font)
                    .lineLimit(style.lineLimit)
                    .minimumScaleFactor(style.minimumScaleFactor)
            }
            .frame(maxWidth: .infinity, minHeight: style.minimumHeight)
            .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
            .contentShape(Capsule(style: .continuous))
            .background {
                if isSelected {
                    Capsule(style: .continuous)
                        .fill(style.activeBackground)
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(style.activeBorder, lineWidth: style.borderWidth)
                        }
                        .matchedGeometryEffect(
                            id: "activeSegment",
                            in: activeSegmentNamespace
                        )
                        .shadow(color: style.activeShadow, radius: 10, x: 0, y: 5)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(segment.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

}
