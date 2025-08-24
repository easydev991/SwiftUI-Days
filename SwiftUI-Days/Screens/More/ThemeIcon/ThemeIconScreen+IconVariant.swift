import SwiftUI
import UIKit

extension ThemeIconScreen {
    enum IconVariant: String, CaseIterable {
        case primary = "AppIcon1"
        case one = "AppIcon2"
        case two = "AppIcon3"
        case three = "AppIcon4"
        case four = "AppIcon5"
        case five = "AppIcon6"
        case six = "AppIcon7"

        /// Название альтернативной иконки, для дефолтной иконки всегда `nil`
        var alternateName: String? {
            switch self {
            case .primary: nil
            default: rawValue
            }
        }

        /// Уменьшенная картинка (обычный ассет) для отображения в списке
        var listImage: Image {
            Image("\(rawValue)Small")
        }

        @MainActor
        var isSelected: Bool {
            alternateName == UIApplication.shared.alternateIconName
        }

        @MainActor
        var accessibilityLabel: String {
            let isSelectedText = isSelected ? String(localized: "Selected") : String(localized: "Not selected")
            switch self {
            case .primary:
                return String(localized: "Primary icon") + ", " + isSelectedText
            default:
                return String(format: String(localized: "Variant %lld"), variantNumber) + ", " + isSelectedText
            }
        }

        init(name: String?) {
            self = IconVariant(rawValue: name ?? "") ?? .primary
        }

        private var variantNumber: Int {
            switch self {
            case .primary: 1
            case .one: 2
            case .two: 3
            case .three: 4
            case .four: 5
            case .five: 6
            case .six: 7
            }
        }
    }
}
