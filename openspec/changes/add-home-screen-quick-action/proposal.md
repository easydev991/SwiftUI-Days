# Proposal

## Why

Сейчас, чтобы создать запись в SwiftUI-Days, пользователь обязан открыть приложение и нажать кнопку «+» на экране списка. Home Screen quick action («Добавить запись») — нативный системный путь iOS, сокращающий это до долгого нажатия на иконку приложения прямо с Home Screen. Создание записи — основное действие приложения, что соответствует HIG: quick actions подходят для небольшого набора ключевых задач.

## What Changes

- Регистрация динамического quick action «Добавить запись» (dynamic `UIApplicationShortcutItem`) при запуске приложения в `AppDelegate.didFinishLaunchingWithOptions`; иконка — системная `UIApplicationShortcutIcon(type: .add)`.
- Заголовок берётся из существующего ключа локализации `Add Item` (ru «Добавить запись», en «Add Item»); новые ключи не добавляются.
- Подключение кастомного `UIWindowSceneDelegate` по официальному SwiftUI-паттерну (`application(_:configurationForConnecting:options:)`, `name: nil`, `delegateClass` только для `.windowApplication`, без ручного `UIWindow`) для приёма shortcut-событий.
- Обработка двух сценариев запуска: холодный (`options.shortcutItem` в `connectionOptions`) и тёплый (`windowScene(_:performActionFor:) async -> Bool`).
- Передача события в UI через новый `@Observable`-сервис в `Services/`, инжектируемый через `.environment`: переключение на вкладку списка и открытие существующей формы добавления (`SheetItem.addItem` → `EditItemScreen`).
- Логирование analytics `.userAction(action: .create)` ровно один раз при открытии формы через quick action.
- Существующая кнопка «+» и обычный сценарий добавления записи работают без изменений.
- Статические quick actions в `Info.plist` не добавляются (в этой итерации); компромисс «action появляется после первого запуска приложения» зафиксирован в design.md.

## Capabilities

### New Capabilities

- `home-screen-quick-actions`: отображение и обработка Home Screen quick action «Добавить запись» — динамическая регистрация, приём события при холодном и тёплом запуске, маршрутизация к форме добавления с переключением вкладки, локализация заголовка, однократный analytics-лог, устойчивость к неизвестным и устаревшим типам shortcut.

### Modified Capabilities

<!-- Спеков в проекте пока нет (openspec list --specs пуст): это первый OpenSpec change. -->

## Impact

- **AppDelegate** (`SwiftUI-Days/AppDelegate.swift`): регистрация shortcut + метод `application(_:configurationForConnecting:options:)`; использует app-wide экземпляр сервиса события (`QuickActionService.shared` — UIKit сам создаёт scene delegate, до `.environment` он не дотягивается).
- **Новый AppDelegateSceneDelegate** (`SwiftUI-Days/AppDelegateSceneDelegate.swift`): `UIWindowSceneDelegate`, приём warm-события через `windowScene(_:performActionFor:) async -> Bool`.
- **Новый доменный тип QuickActionType** (`SwiftUI-Days/Models/QuickActionType.swift`): маппинг типа shortcut в доменное действие; неизвестный тип отбрасывается.
- **Новый сервис QuickActionService** (`SwiftUI-Days/Services/`): `@Observable` pending-состояние с однократным consume и монотонным счётчиком запросов.
- **SwiftUI_DaysApp** (`SwiftUI-Days/SwiftUI_DaysApp.swift`): инжекция сервиса через `.environment`.
- **RootScreen** (`SwiftUI-Days/Screens/RootScreen.swift`): переключение на вкладку списка при получении события.
- **MainScreen** (`SwiftUI-Days/Screens/Main/MainScreen.swift`): потребление события в единственной точке — открытие `sheetItem = .addItem` (второй sheet не создаётся; открытый sheet не дублируется).
- **Аналитика**: переиспользуется существующее `AnalyticsEvent.userAction(action: .create)`; изменений модели событий нет.
- **SwiftData**: модель `Item` не меняется; форма `EditItemScreen` переиспользуется как есть.
- **Локализация**: только переиспользование ключа `Add Item`; файл `Localizable.xcstrings` не редактируется.
- **Тесты**: новые unit-тесты (Swift Testing) для маппинга типа shortcut, обработки shortcut-события и однократного consume pending-состояния; маршрутизация в UI проверяется вручную.
- **Зависимости**: новые не требуются (нативный UIKit, iOS 17+).
