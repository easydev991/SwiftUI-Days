import Foundation
import SwiftUI
@testable import SwiftUI_Days
import Testing

@Suite("IconVariant tests")
struct IconVariantTests {
    typealias IconVariant = ThemeIconScreen.IconVariant

    @Test("alternateName: для primary возвращает nil, для остальных возвращает rawValue")
    func alternateName() {
        #expect(IconVariant.primary.alternateName == nil)
        #expect(IconVariant.one.alternateName == "AppIcon2")
        #expect(IconVariant.two.alternateName == "AppIcon3")
        #expect(IconVariant.three.alternateName == "AppIcon4")
        #expect(IconVariant.four.alternateName == "AppIcon5")
        #expect(IconVariant.five.alternateName == "AppIcon6")
        #expect(IconVariant.six.alternateName == "AppIcon7")
    }

    @Test("listImage: возвращает корректное изображение для каждого варианта")
    func listImage() {
        #expect(IconVariant.primary.listImage == Image("AppIcon1Small"))
        #expect(IconVariant.one.listImage == Image("AppIcon2Small"))
        #expect(IconVariant.two.listImage == Image("AppIcon3Small"))
        #expect(IconVariant.three.listImage == Image("AppIcon4Small"))
        #expect(IconVariant.four.listImage == Image("AppIcon5Small"))
        #expect(IconVariant.five.listImage == Image("AppIcon6Small"))
        #expect(IconVariant.six.listImage == Image("AppIcon7Small"))
    }

    @Test("init(name:) возвращает primary", arguments: [nil, "", "AppIcon99", "InvalidIcon"])
    func initWithNil(rawValue: String?) {
        let variant = IconVariant(name: rawValue)
        #expect(variant == .primary)
    }

    @Test("init(name:): с корректным именем возвращает соответствующий вариант")
    func initWithValidName() {
        #expect(IconVariant(name: "AppIcon1") == .primary)
        #expect(IconVariant(name: "AppIcon2") == .one)
        #expect(IconVariant(name: "AppIcon3") == .two)
        #expect(IconVariant(name: "AppIcon4") == .three)
        #expect(IconVariant(name: "AppIcon5") == .four)
        #expect(IconVariant(name: "AppIcon6") == .five)
        #expect(IconVariant(name: "AppIcon7") == .six)
    }

    @Test("accessibilityLabel: возвращает локализованную строку для primary")
    @MainActor
    func accessibilityLabelPrimary() {
        let variant = IconVariant.primary
        let label = variant.accessibilityLabel
        let containsPrimaryIcon = label.contains("Primary icon") || label.contains("Основная иконка")
        #expect(containsPrimaryIcon)
    }

    @Test("accessibilityLabel: возвращает локализованную строку с номером варианта")
    @MainActor
    func accessibilityLabelWithVariantNumber() {
        let variant = IconVariant.one
        let label = variant.accessibilityLabel
        let containsVariant2 = label.contains("Variant 2") || label.contains("Вариант 2")
        #expect(containsVariant2)
    }

    @Test(
        "accessibilityLabel: содержит информацию о состоянии выбора",
        arguments: IconVariant.allCases
    )
    @MainActor
    func accessibilityLabelContainsSelectionState(variant: IconVariant) {
        let label = variant.accessibilityLabel
        let selectedLocalizedString = String(localized: "Selected")
        let notSelectedLocalizedString = String(localized: "Not selected")
        let containsSelected = label.contains(selectedLocalizedString)
        let containsNotSelected = label.contains(notSelectedLocalizedString)
        #expect(containsSelected || containsNotSelected)
    }
}
