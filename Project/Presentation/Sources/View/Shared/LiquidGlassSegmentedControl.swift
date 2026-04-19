//
//  LiquidGlassSegmentedControl.swift
//  PresentationLayer
//
//  Created by Codex on 4/19/26.
//

import SwiftUI

struct LiquidGlassSegment<Value: Hashable>: Identifiable {
    let value: Value
    let title: String
    let systemImage: String?

    var id: Value {
        value
    }

    init(
        value: Value,
        title: String,
        systemImage: String? = nil
    ) {
        self.value = value
        self.title = title
        self.systemImage = systemImage
    }
}

struct LiquidGlassSegmentedControl<Value: Hashable>: View {
    @Binding private var selection: Value
    private let segments: [LiquidGlassSegment<Value>]

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Namespace private var activeSegmentNamespace

    init(
        selection: Binding<Value>,
        segments: [LiquidGlassSegment<Value>]
    ) {
        self._selection = selection
        self.segments = segments
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(segments) { segment in
                segmentButton(segment)
            }
        }
        .padding(5)
        .background(containerBackground, in: Capsule(style: .continuous))
        .overlay {
            Capsule(style: .continuous)
                .strokeBorder(containerBorder, lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.08), radius: 18, x: 0, y: 10)
    }

    private func segmentButton(_ segment: LiquidGlassSegment<Value>) -> some View {
        let isSelected = selection == segment.value

        return Button {
            withAnimation(.easeOut(duration: 0.25)) {
                selection = segment.value
            }
        } label: {
            HStack(spacing: 5) {
                if let systemImage = segment.systemImage {
                    Image(systemName: systemImage)
                        .font(.caption.weight(.semibold))
                }

                Text(segment.title)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
            }
            .frame(maxWidth: .infinity, minHeight: 44)
            .foregroundStyle(isSelected ? Color.accentColor : Color.secondary)
            .contentShape(Capsule(style: .continuous))
            .background {
                if isSelected {
                    Capsule(style: .continuous)
                        .fill(activeSegmentBackground)
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(activeSegmentBorder, lineWidth: 1)
                        }
                        .matchedGeometryEffect(
                            id: "activeSegment",
                            in: activeSegmentNamespace
                        )
                        .shadow(color: Color.accentColor.opacity(0.18), radius: 10, x: 0, y: 5)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(segment.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var containerBackground: AnyShapeStyle {
        if reduceTransparency {
            return AnyShapeStyle(Color(uiColor: .secondarySystemBackground))
        }

        return AnyShapeStyle(.ultraThinMaterial)
    }

    private var activeSegmentBackground: AnyShapeStyle {
        if reduceTransparency {
            return AnyShapeStyle(Color(uiColor: .systemBackground))
        }

        return AnyShapeStyle(Color(uiColor: .systemBackground).opacity(0.72))
    }

    private var containerBorder: LinearGradient {
        LinearGradient(
            colors: [
                .white.opacity(0.42),
                .white.opacity(0.12),
                Color.accentColor.opacity(0.12)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var activeSegmentBorder: LinearGradient {
        LinearGradient(
            colors: [
                .white.opacity(0.7),
                Color.accentColor.opacity(0.22)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
