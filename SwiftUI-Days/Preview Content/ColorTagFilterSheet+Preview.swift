#if DEBUG
import SwiftUI

enum ColorTagFilterSheetPreviewData {
    static let hueRange = 360.0
    static let saturation = 0.75
    static let brightness = 0.85
    static let colors1 = 1
    static let colors3 = 3
    static let colors8 = 8
    static let colors30 = 30
    static let selectedIndex3 = 0
    static let selectedIndex8 = 2
    static let selectedIndex30 = 10

    static func previewColorHexes(count: Int) -> [String] {
        (0 ..< count).compactMap { index in
            let hue = (Double(index) * hueRange) / Double(max(count, 1))
            return Color(
                hue: hue / hueRange,
                saturation: saturation,
                brightness: brightness
            ).hexRGBA
        }
    }

    static func getOrNil(_ values: [String], index: Int) -> String? {
        values.indices.contains(index) ? values[index] : nil
    }
}
#endif
