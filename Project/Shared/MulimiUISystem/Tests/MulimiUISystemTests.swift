@testable import MulimiUISystem
import SwiftUI
import Testing
import UIKit

@MainActor
struct MulimiUISystemTests {
    @Test("테마 색상은 호스트 앱과 다른 framework 번들에 존재한다")
    func resourceBundle() throws {
        let bundle = MulimiUIResources.bundle
        #expect(bundle.bundleIdentifier == "gaeng2y.DrinkWater.MulimiUISystem")
        #expect(bundle.bundleURL != Bundle.main.bundleURL)
        for name in ["AccentColor", "BackgroundColor"] {
            _ = try #require(UIColor(named: name, in: bundle, compatibleWith: nil))
        }
    }

    @Test("라이트·다크 테마와 기존 Color API가 동일한 색상을 반환한다", arguments: [false, true])
    func semanticColors(dark: Bool) throws {
        let traits = UITraitCollection(userInterfaceStyle: dark ? .dark : .light)
        let background = try #require(UIColor(
            named: "BackgroundColor", in: MulimiUIResources.bundle, compatibleWith: traits
        )).resolvedColor(with: traits)
        let expected = dark ? UIColor.black : UIColor(red: 235 / 255, green: 234 / 255, blue: 230 / 255, alpha: 1)
        expectSameColor(background, expected)
        expectSameColor(UIColor(MulimiTheme.background).resolvedColor(with: traits), background)
        expectSameColor(UIColor(Color.background).resolvedColor(with: traits), background)
        expectSameColor(UIColor(MulimiTheme.accent).resolvedColor(with: traits), UIColor.systemTeal.resolvedColor(with: traits))
        expectSameColor(UIColor(Color.accent).resolvedColor(with: traits), UIColor(MulimiTheme.accent).resolvedColor(with: traits))
    }

    @Test("Reduce Motion은 선택 애니메이션을 제거한다")
    func reducedMotion() {
        #expect(style(reduceMotion: true).animation == nil)
        #expect(style(reduceMotion: false).animation != nil)
    }

    @Test("접근성 글씨에서는 컨트롤 높이와 라벨 공간을 늘린다")
    func accessibilityLayout() {
        let regular = style(size: .large)
        let accessible = style(size: .accessibility5)
        #expect(regular.minimumHeight >= 44)
        #expect(accessible.minimumHeight > regular.minimumHeight)
        #expect(accessible.lineLimit > regular.lineLimit)
    }

    @Test("컴포넌트는 테마와 접근성 환경에서 렌더링된다", arguments: [false, true], [false, true])
    func renderComponents(dark: Bool, accessible: Bool) throws {
        let content = VStack {
            LiquidGlassSegmentedControl(
                selection: .constant(0),
                segments: [
                    .init(value: 0, title: "수분 인사이트", systemImage: "drop.fill"),
                    .init(value: 1, title: "챌린지", systemImage: "trophy.fill")
                ]
            )
            Circle().fill(MulimiTheme.accent).frame(width: 180, height: 180).waterDropGlareEffect()
        }
        .padding()
        .frame(width: 390)
        .background(MulimiTheme.background)
        .environment(\.colorScheme, dark ? .dark : .light)
        .environment(\.dynamicTypeSize, accessible ? .accessibility5 : .large)
        let renderer = ImageRenderer(content: content)
        let image = try #require(renderer.uiImage)
        #expect(image.size.width == 390)
        #expect(image.size.height >= 240)
    }

    private func expectSameColor(_ actual: UIColor, _ expected: UIColor) {
        func components(_ color: UIColor) -> [CGFloat] {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            #expect(color.getRed(&red, green: &green, blue: &blue, alpha: &alpha))
            return [red, green, blue, alpha]
        }
        for (actual, expected) in zip(components(actual), components(expected)) {
            #expect(abs(actual - expected) < 0.00001)
        }
    }

    private func style(reduceMotion: Bool = false, size: DynamicTypeSize = .large) -> LiquidGlassSegmentStyle {
        LiquidGlassSegmentStyle(reduceMotion: reduceMotion, reduceTransparency: false, dynamicTypeSize: size)
    }
}
