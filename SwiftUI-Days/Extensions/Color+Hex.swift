import SwiftUI

extension Color {
    /// Создаёт Color из hex-строки формата #RRGGBB
    /// - Parameter hex: `Hex`-строка (например, "#FF5722", "#ff5722")
    /// - Returns: `Color` или `nil`, если формат невалиден
    init?(hex: String) {
        // Убираем пробелы и переносы строк
        let trimmed = hex.trimmingCharacters(in: .whitespacesAndNewlines)

        // Проверка на пустую строку
        guard !trimmed.isEmpty else { return nil }

        // Строка должна начинаться с #
        guard trimmed.hasPrefix("#") else { return nil }

        // Убираем #
        let hexWithoutHash = String(trimmed.dropFirst())

        // Должно быть ровно 6 символов (RRGGBB)
        guard hexWithoutHash.count == 6 else { return nil }

        // Парсим hex в Int
        let scanner = Scanner(string: hexWithoutHash)
        var hexNumber: UInt64 = 0

        guard scanner.scanHexInt64(&hexNumber) else { return nil }

        // Проверяем, что вся строка была просканирована
        guard scanner.isAtEnd else { return nil }

        // Извлекаем RGB компоненты
        let r = Double((hexNumber & 0xFF0000) >> 16) / 255.0
        let g = Double((hexNumber & 0x00FF00) >> 8) / 255.0
        let b = Double(hexNumber & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
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
