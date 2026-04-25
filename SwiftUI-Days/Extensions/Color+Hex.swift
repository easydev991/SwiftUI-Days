import Foundation
import SwiftUI

extension Color {
    /// Создаёт Color из hex-строки формата #RRGGBB
    /// - Parameter hex: `Hex`-строка (например, "#FF5722", "#ff5722")
    /// - Returns: `Color` или `nil`, если формат невалиден
    init?(hex: String) {
        guard let hexNumber = Self.hexNumber(from: hex, digitsCount: 6) else { return nil }
        let r = Double((hexNumber & 0xFF0000) >> 16) / 255.0
        let g = Double((hexNumber & 0x00FF00) >> 8) / 255.0
        let b = Double(hexNumber & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, opacity: 1)
    }

    /// Создаёт Color из hex-строки формата #RRGGBBAA
    /// - Parameter hexRGBA: `Hex`-строка с alpha (например, "#FF5722FF")
    /// - Returns: `Color` или `nil`, если формат невалиден
    init?(hexRGBA: String) {
        guard let hexNumber = Self.hexNumber(from: hexRGBA, digitsCount: 8) else { return nil }
        let r = Double((hexNumber & 0xFF00_0000) >> 24) / 255.0
        let g = Double((hexNumber & 0x00FF_0000) >> 16) / 255.0
        let b = Double((hexNumber & 0x0000_FF00) >> 8) / 255.0
        let a = Double(hexNumber & 0x0000_00FF) / 255.0
        self.init(red: r, green: g, blue: b, opacity: a)
    }

    /// Возвращает hex-строку в формате #RRGGBBAA для RGB-цветов.
    /// Для `.clear` и не-RGB/динамических системных цветов возвращает `nil`.
    var hexRGBA: String? {
        var red: CGFloat = .zero
        var green: CGFloat = .zero
        var blue: CGFloat = .zero
        var alpha: CGFloat = .zero
        let uiColor = UIColor(self)
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
        guard alpha > .zero else { return nil }
        let r = Int((red * 255).rounded())
        let g = Int((green * 255).rounded())
        let b = Int((blue * 255).rounded())
        let a = Int((alpha * 255).rounded())
        return String(format: "#%02X%02X%02X%02X", r, g, b, a)
    }
}

private extension Color {
    static func hexNumber(
        from string: String,
        digitsCount: Int
    ) -> UInt64? {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        guard trimmed.hasPrefix("#") else { return nil }
        let hexWithoutHash = String(trimmed.dropFirst())
        guard hexWithoutHash.count == digitsCount else { return nil }
        let scanner = Scanner(string: hexWithoutHash)
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return nil }
        guard scanner.isAtEnd else { return nil }
        return hexNumber
    }
}

#if DEBUG
#Preview("Hex colors") {
    let hexColors: [(hex: String, name: String)] = [
        ("#FF5722", "Deep Orange"),
        ("#E91E63", "Pink"),
        ("#9C27B0", "Purple"),
        ("#673AB7", "Deep Purple"),
        ("#3F51B5", "Indigo"),
        ("#2196F3", "Blue"),
        ("#00BCD4", "Cyan"),
        ("#009688", "Teal"),
        ("#4CAF50", "Green"),
        ("#FFEB3B", "Yellow"),
        ("#FF9800", "Orange"),
        ("#795548", "Brown"),
        ("#000000", "Black"),
        ("#FFFFFF", "White")
    ]

    ScrollView {
        LazyVStack {
            ForEach(hexColors, id: \.hex) { item in
                HStack {
                    if let color = Color(hex: item.hex) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color)
                            .frame(width: 44, height: 44)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red.opacity(0.2))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "xmark")
                                    .foregroundStyle(.red)
                            )
                    }
                    Text(item.hex)
                        .font(.system(.body, design: .monospaced))
                        .frame(width: 80, alignment: .leading)
                    Text(item.name)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding()
    }
}
#endif
