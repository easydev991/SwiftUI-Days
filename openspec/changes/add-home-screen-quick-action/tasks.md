# Tasks

## 1. Доменная модель и сервис quick action

- [ ] 1.1 Создать `SwiftUI-Days/Models/QuickActionType.swift`: `enum QuickActionType: Equatable` с единственным кейсом `addItem`, константой `addItemIdentifier` со значением `com.oleg991.SwiftUI-Days.addItem` и failable-инициализатором `init?(shortcutType: String)`, возвращающим `nil` для любого неизвестного/пустого типа. Проверка: файл компилируется (`make build`), а поведение зафиксировано тестом из 1.3.
- [ ] 1.2 Создать `SwiftUI-Days/Services/QuickActionService.swift`: `@MainActor @Observable final class QuickActionService` с `static let shared`, `private(set) var requestCount`, приватным `isPending`, методами `requestAddItem()` и `consumeAddItemRequest() -> Bool` (однократный consume). Проверка: файл компилируется (`make build`), поведение зафиксировано тестом из 1.4.
- [ ] 1.3 Добавить `SwiftUI-DaysTests/QuickActionTypeTests.swift` (Swift Testing, русские описания): известный тип `com.oleg991.SwiftUI-Days.addItem` маппится в `.addItem`; произвольный неизвестный тип и пустая строка дают `nil`. Проверка: `make test` — тесты проходят и падают при смене идентификатора типа.
- [ ] 1.4 Добавить `SwiftUI-DaysTests/QuickActionServiceTests.swift` (Swift Testing, русские описания): `consumeAddItemRequest()` возвращает `true` ровно один раз на запрос, второй вызов — `false`; новый `requestAddItem()` снова делает запрос потребляемым; без запроса consume возвращает `false`; `requestCount` растёт монотонно. Проверка: `make test` — все тесты зелёные.

## 2. UIKit-мост: регистрация quick action и приём события

- [ ] 2.1 В `SwiftUI-Days/AppDelegate.swift` в `application(_:didFinishLaunchingWithOptions:)` зарегистрировать dynamic shortcut: `UIApplication.shared.shortcutItems = [UIApplicationShortcutItem(type: QuickActionType.addItemIdentifier, localizedTitle: String(localized: "Add Item"), localizedSubtitle: nil, icon: UIApplicationShortcutIcon(type: .add), userInfo: nil)]`. Заголовок берётся только из существующего ключа `Add Item`, каталог локализации не редактируется. Проверка: `make build`; в симуляторе после запуска долгое нажатие на иконку показывает «Добавить запись» с системной иконкой «+».
- [ ] 2.2 В `SwiftUI-Days/AppDelegate.swift` реализовать `application(_:configurationForConnecting:options:)`: вернуть `UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)` с `delegateClass = AppDelegateSceneDelegate.self` только для роли `.windowApplication`; из `options.shortcutItem` выполнить маппинг типа и при распознавании вызвать `QuickActionService.shared.requestAddItem()`, при неизвестном типе — ничего не делать. Проверка: `make build`; cold launch через quick action открывает форму добавления, а `UIWindow` вручную не создаётся.
- [ ] 2.3 Создать `SwiftUI-Days/AppDelegateSceneDelegate.swift`: `final class AppDelegateSceneDelegate: NSObject, UIWindowSceneDelegate` с методом `windowScene(_:performActionFor:) async -> Bool`, который маппит тип shortcut, при `.addItem` вызывает `QuickActionService.shared.requestAddItem()` и возвращает `true`, а для неизвестного типа возвращает `false` без навигации и логирования. Проверка: `make build`; warm launch (фон и активное состояние) открывает форму; событие с неизвестным типом не меняет UI и не ломает приложение.

## 3. Маршрутизация события в UI

- [ ] 3.1 В `SwiftUI-Days/SwiftUI_DaysApp.swift` внедрить сервис в окружение: `.environment(QuickActionService.shared)` рядом с существующими `.environment(...)`. Проверка: `make build`; экраны получают сервис через `@Environment(QuickActionService.self)`, а не через прямой доступ к глобалу.
- [ ] 3.2 В `SwiftUI-Days/Screens/RootScreen.swift` добавить наблюдение за сервисом: `.onChange(of: quickActionService.requestCount) { _, _ in tab = .list }` — переключение на вкладку списка при любом quick action. Проверка: `make build`; запуск с quick action с вкладки «Ещё» переключает приложение на вкладку списка.
- [ ] 3.3 В `SwiftUI-Days/Screens/Main/MainScreen.swift` обработать запрос в одной точке: вызвать общий обработчик из `.onAppear` (cold launch — значение уже в pending) и из `.onChange(of: quickActionService.requestCount)` (warm launch). Обработчик: `consumeAddItemRequest()` → если форма ещё не открыта (`sheetItem != .addItem`), логирует `analytics.log(.userAction(action: .create))` и присваивает `sheetItem = .addItem`; если форма уже открыта — не создаёт второй sheet и не логирует analytics повторно. Для сравнения добавить конформанс `Equatable` в `SheetItem`. Проверка: `make build`; повторное нажатие при открытой форме оставляет один sheet и один analytics-лог; кнопка «+» работает как раньше.

## 4. UI-тест маршрутизации (опционально)

- [ ] 4.1 В `SwiftUI-Days/AppDelegate.swift` под `#if DEBUG` добавить симуляцию quick action: при наличии launch-аргумента `"UITestQuickAction"` вызвать `QuickActionService.shared.requestAddItem()` при запуске — приложение стартует с тем же запросом, что и при реальном quick action. Проверка: `make build`; запуск в Xcode с аргументом `"UITestQuickAction"` открывает форму добавления.
- [ ] 4.2 В `SwiftUI-DaysUITests/SwiftUI_DaysUITests.swift` добавить UI-тест: вынести `app.launch()` из `setUp` в существующий `testDemoFlow` (чтобы каждый тест управлял запуском сам), в новом тесте добавить launch-аргумент `"UITestQuickAction"` и проверить, что форма добавления появилась (`app.otherElements["editSectionView"].firstMatch.waitForExistence(timeout: 5)`). Файл уже в таргеле `SwiftUI-DaysUITests` — ручное редактирование `.pbxproj` не требуется. Проверка: тест проходит, а существующий `testDemoFlow` продолжает проходить.

## 5. Финальная проверка

- [ ] 5.1 Выполнить `make build` и `make test` — сборка без ошибок, все unit-тесты зелёные. Проверка: обе команды завершаются с кодом 0.
- [ ] 5.2 Выполнить `make format` (swiftformat + markdownlint) — код отформатирован по правилам репозитория. Проверка: `git diff` не показывает неформатированных изменений после запуска.
- [ ] 5.3 Пройти ручные сценарии приёмки на симуляторе: cold launch (приложение завершено) и warm launch (фон и активное состояние) открывают форму добавления; quick action виден после первого запуска; заголовок «Добавить запись» при системном языке ru и «Add Item» при en; запуск с вкладки «Ещё» переключает на вкладку списка; повторное нажатие при уже открытой форме не создаёт второй sheet и не дублирует analytics; неизвестный тип shortcut игнорируется. Проверка: каждый сценарий из `specs/home-screen-quick-actions/spec.md` воспроизведён вручную и отмечен в отчёте.

## Workflow follow-up

- Архивировать change после выполнения задач и проверки требований репозитория.
- Проверить результат архивирования (`openspec validate` для архивной спеки).
