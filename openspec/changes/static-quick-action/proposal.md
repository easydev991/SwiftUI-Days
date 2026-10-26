# Proposal

## Why

Quick action «Добавить запись» регистрируется динамически — код присваивает `UIApplication.shared.shortcutItems` при запуске приложения. Такой action не существует, пока приложение хотя бы раз не запущено: после установки или обновления из App Store пользователь, выполняющий долгое нажатие на иконку, не видит кнопку (iOS до первого запуска обновления показывает динамические quick actions предыдущей версии). Это документированное поведение динамических quick actions, но для постоянного действия оно выглядит как баг: кнопка появляется только после первого запуска. В симуляторе проблема не видна, потому что Xcode всегда запускает приложение сразу после установки.

## What Changes

- Quick action «Добавить запись» переносится из динамической регистрации в статическую: объявляется в массиве `UIApplicationShortcutItems` в `Info.plist`, поэтому система регистрирует его в момент установки — action виден сразу после установки и обновления, до первого запуска.
- Из `AppDelegate` удаляется динамическая регистрация (метод `registerShortcutItem()` и его вызов); вместо неё при каждом запуске выполняется очистка `UIApplication.shared.shortcutItems = []`, чтобы закешированные системой динамические items предыдущих версий не дублировали статический action.
- Обработка событий не меняется: статический shortcut приходит через те же delegate-пути (`configurationForConnecting` → `AppDelegateSceneDelegate`) с тем же типом `com.oleg991.SwiftUI-Days.addItem`, поэтому `QuickActionService`, `QuickActionType` и их тесты остаются без изменений.
- Изменение не ломающее: тип shortcut и все сценарии обработки сохраняются, меняется только момент появления action в системном меню (раньше и надёжнее).

## Capabilities

### New Capabilities

(none)

### Modified Capabilities

- `home-screen-quick-actions`: requirement «Quick action display on long press» (динамическая регистрация при каждом запуске, допустимое отсутствие до первого запуска) удаляется и заменяется новым «Static quick action display on long press» — статическая регистрация через Info.plist с гарантированной видимостью сразу после установки и обновления. Остальные requirements (локализация, иконка, cold/warm launch, дубли, analytics, неизвестные типы) не меняются.

## Impact

- `SwiftUI-Days/SupportingFiles/Info.plist` — добавляется ключ `UIApplicationShortcutItems` со статическим shortcut (тип `com.oleg991.SwiftUI-Days.addItem`, локализуемый заголовок «Add Item», SF Symbol `plus`).
- `SwiftUI-Days/AppDelegate.swift` — удаляется метод `registerShortcutItem()` и его вызов в `didFinishLaunchingWithOptions`, добавляется очистка закешированных динамических items при запуске (`UIApplication.shared.shortcutItems = []`).
- `SwiftUI-Days/SupportingFiles/InfoPlist.xcstrings` — заполняются переводы ключа `Add Item` (en — «Add Item», ru — «Добавить запись»): Xcode при сборке синхронизирует статический заголовок shortcut в таблицу InfoPlist, и без переводов на русских устройствах отображался бы текст без локализации.
- `SwiftUI-DaysTests/QuickActionTypeTests.swift` — добавлен guard-тест `staticShortcutTypeMatchesPlist`: статический shortcut в Info.plist обязан использовать закреплённый `QuickActionType.addItemIdentifier` (существующие unit-тесты модели и сервиса остаются валидными без изменений).
- Без изменений: `AppDelegateSceneDelegate`, `QuickActionService`, `QuickActionType`, `MainScreen`, `RootScreen`, ключи локализации (существующий ключ `Add Item` используется как есть).
- Пользовательская видимость: кнопка появляется в меню иконки сразу после установки/обновления приложения на всех каналах (App Store, TestFlight, симулятор) без первого запуска.
