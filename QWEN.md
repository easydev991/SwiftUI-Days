# SwiftUI-Days — Счётчик дней

iOS-приложение для отслеживания событий и подсчёта прошедших дней.

> **Для пользователей**: функционал, скриншоты и начало работы — см. [README.md](README.md)

## Обзор проекта

**Технологии:**

- SwiftUI, Swift 6.2
- iOS 17+
- SwiftData
- Swift Testing (`@Suite`, `@Test`, `#expect`) — НЕ XCTest
- fastlane (скриншоты, TestFlight)

**Архитектура:**

```
SwiftUI-Days/
├── Models/          # Item, DisplayOption, BackupFileDocument, AppTheme
├── Screens/         # RootScreen → Main/, Detail/, More/, CommonViews/
├── Services/        # AppSettings, FeedbackSender
├── Extensions/      # Color+Hex, Date+Timestamp
└── EnvironmentKeys/
```

---

## Команды для разработки

### make

```bash
make build     # Сборка проекта
make test      # Unit-тесты (xcodebuild)
make format    # SwiftFormat + markdownlint
make help      # Список всех команд
```

> Установка зависимостей и деплой — см. [README.md](README.md)

### MCP (внутри Qwen Code)

```bash
mcp__XcodeBuildMCP__test_sim       # Запуск тестов в симуляторе
mcp__XcodeBuildMCP__build_run_sim  # Сборка и запуск в симуляторе
```

---

## Конвенции разработки

### Тестирование (Swift Testing)

Используется **Swift Testing**, не XCTest:

```swift
import Testing
@testable import SwiftUI_Days

@Suite("Описание группы тестов")
struct ColorHexTests {
    @Test("Пояснение на русском для отчётов")
    func validHexColor() {
        let color = Color(hex: "#FF5722")
        #expect(color != nil)
    }
}
```

- `@testable import` даёт доступ к `internal` методам — `public` не нужен
- Русские описания в `@Test("...")` для читаемости в отчётах

### Форматирование

При изменениях в коде или документации:

```bash
make format  # SwiftFormat + markdownlint
```

---

## Документация

- [Формат резервных копий](docs/doc-backup.md) — структура, различия iOS/Android, совместимость
- [План импорта Android-бекапов](plan-android-backup-import.md) — TDD-реализация

---

## Файловая структура

| Файл/Директория | Описание |
|-----------------|----------|
| `SwiftUI-Days/Models/Item.swift` | SwiftData-сущность события |
| `SwiftUI-Days/Models/BackupFileDocument.swift` | Импорт/экспорт JSON-бекапов |
| `SwiftUI-Days/Extensions/Color+Hex.swift` | Парсинг hex-цветов (#RRGGBB) |
| `SwiftUI-Days/Extensions/Date+Timestamp.swift` | Конвертация timestamp (мс/сек) |
| `SwiftUI-DaysTests/` | Unit-тесты (Swift Testing) |
| `docs/` | Документация |
