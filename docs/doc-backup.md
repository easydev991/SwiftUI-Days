# Формат резервных копий

Документация по формату JSON-файлов резервных копий.

## Формат BackupWrapper

Унифицированный формат с явным указанием платформы:

```json
{
  "format": "ios",
  "items": [
    {
      "title": "День рождения",
      "details": "Мой день рождения",
      "timestamp": 699417600.0,
      "colorTag": "YnBsaXN0MDDU...",
      "displayOption": "day"
    }
  ]
}
```

| Поле | Тип | Описание |
|------|-----|----------|
| `format` | String? | `"ios"` или `"android"` (опционально) |
| `items` | Array | Массив объектов BackupItem |

## Структура BackupItem

| Поле | Тип | Описание |
|------|-----|----------|
| `title` | String | Название события |
| `details` | String? | Описание (пустая строка если `null`) |
| `timestamp` | Double | Дата события |
| `colorTag` | String? | Цвет (hex или Base64) |
| `displayOption` | String | Опция отображения |

## Различия платформ

| Поле | iOS | Android |
|------|-----|---------|
| `format` | `"ios"` | `"android"` |
| `timestamp` | Секунды с 2001-01-01 | Миллисекунды с 1970-01-01 |
| `colorTag` | Base64 (NSKeyedArchiver) | Hex `#RRGGBB` |

### Timestamp

- **iOS**: `Date.timeIntervalSinceReferenceDate` (секунды с 2001-01-01)
- **Android**: `System.currentTimeMillis()` (миллисекунды с 1970-01-01)

### ColorTag

- **iOS**: Base64-закодированный `NSKeyedArchiver` с `UIColor`
- **Android**: Hex-строка `#RRGGBB` (регистронезависимый)

### DisplayOption

| Значение | Описание |
|----------|----------|
| `day` | Только день |
| `monthDay` | День и месяц |
| `yearMonthDay` | Полная дата |

## Реализация в iOS

### Логика импорта (`BackupImporter`)

1. Попытка декодировать `BackupWrapper`
   - `format == "android"` → timestamp как миллисекунды с 1970
   - `format == "ios"` или `nil` → timestamp как секунды с 2001
2. Fallback: декодировать как `[BackupItem]` (старый формат без обёртки)

### Парсинг colorTag (`RawBackupItem.init(from:)`)

1. Попытка декодировать как `Data` → `NSKeyedUnarchiver` → `UIColor`
2. Иначе как `String` → `Color(hex:)` (Android-формат)

### Экспорт (`BackupFileDocument.exportWrapper()`)

- `format: .ios`
- `timestamp`: `timeIntervalSinceReferenceDate`
- `colorTag`: `NSKeyedArchiver.archivedData(withRootObject: UIColor)`

## Обратная совместимость

Файлы без поля `format`:

```json
[
  {
    "title": "День рождения",
    "timestamp": 699417600.0,
    "colorTag": "...",
    "displayOption": "day"
  }
]
```

- Декодируются как `[BackupItem]`
- Timestamp интерпретируется как секунды с 2001

## Файлы

| Файл | Назначение |
|------|------------|
| `Models/BackupFileDocument.swift` | Экспорт/импорт, `BackupWrapper`, `RawBackupItem` |
| `Models/BackupFormat.swift` | `enum BackupFormat` |
| `Services/BackupImporter.swift` | Парсинг JSON с определением формата |
| `Extensions/Color+Hex.swift` | Парсинг hex-цветов |
