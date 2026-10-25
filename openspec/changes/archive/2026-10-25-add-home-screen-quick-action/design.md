# Design

## Context

Текущее состояние (проверено по коду, не по предположениям):

- Приложение: SwiftUI + SwiftData, iOS 17+, iPhone и iPad. Entry point — `SwiftUI-Days/SwiftUI_DaysApp.swift` (`@main struct SwiftUI_DaysApp`, `WindowGroup { RootScreen() }`, `@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate`).
- `SwiftUI-Days/AppDelegate.swift` — единственный метод `application(_:didFinishLaunchingWithOptions:)`, конфигурирует Firebase. Собственного `UIWindowSceneDelegate` в проекте нет.
- `SwiftUI-Days/Screens/RootScreen.swift` — `TabView` с двумя вкладками; выбор вкладки — `@State private var tab = Tab.list`, где `Tab` — вложенный `private enum` (`list` → `MainScreen()`, `more` → `MoreScreen()`). Тег вкладки `Tab.list`.
- `SwiftUI-Days/Screens/Main/MainScreen.swift` — форма добавления реализована как `@State private var sheetItem: SheetItem?` + `.sheet(item:)`, где `SheetItem.addItem` рендерит существующий `EditItemScreen`. Кнопка «+» (`addItemButton`) делает ровно две вещи: `analytics.log(.userAction(action: .create))` и `sheetItem = .addItem`.
- Аналитика: `SwiftUI-Days/Models/AnalyticsEvent.swift`, `AnalyticsEvent.userAction(action: .create)`; сервис — `AnalyticsService` через `@Environment(\.analyticsService)`.
- Локализация: `SwiftUI-Days/SupportingFiles/Localizable.xcstrings`, ключ `Add Item` (`en`: «Add Item», `ru`: «Добавить запись»). В коде проект обращается к каталогу по явному ключу через `String(localized: "...")` (например `String(localized: "Title")`, `String(localized: "Add color tag")`).
- Сборка: таргет приложения — `SWIFT_VERSION = 6.0`, `SWIFT_STRICT_CONCURRENCY = complete`; тестовые таргеты — Swift 5. Таргеты `SwiftUI-Days` и `SwiftUI-DaysTests` используют `fileSystemSynchronizedGroups` (новые файлы в папках подхватываются автоматически), таргет `SwiftUI-DaysUITests` — нет (файлы добавляются вручную).
- SwiftUI не имеет API для Home Screen quick actions — нужен UIKit.

Ограничения, заданные задачей: dynamic `UIApplicationShortcutItem`, регистрация в `AppDelegate.didFinishLaunchingWithOptions`, никаких статических `UIApplicationShortcutItems` в `Info.plist`, никаких App Intents / Siri / URL schemes / widgets / deep links, переиспользование `EditItemScreen` и `SheetItem.addItem` без параллельной формы, модель SwiftData не меняется.

## Goals / Non-Goals

**Goals:**

- Единая точка регистрации quick action и единая точка обработки входящего события — без дублирования логики между cold/warm запуском.
- Событие доходит до SwiftUI через `@Observable`-сервис, инжектируемый через `.environment`; observable-объекты не вкладываются друг в друга.
- Маршрутизация до существующей формы добавления: вкладка списка + `SheetItem.addItem`; форма открывается не более одного раза, analytics логируется не более одного раза.
- Логика маппинга типа и обработки shortcut-события (`QuickActionType`, `QuickActionService.handle/consume`) покрыта unit-тестами без UIKit-инфраструктуры; маршрутизация в UI (`MainScreen`) unit-тестами не покрывается — проверяется вручную на симуляторе (сценарии «Second activation while form is open», «Analytics logged exactly once», «No duplicate analytics», «Quick action while another sheet is open»).

**Non-Goals:**

- Не меняется UX формы добавления, набор quick actions, `Info.plist`, модель `Item`, существующие настройки приложения.
- Не вводится отдельный экран/роут для quick action и не дублируется `EditItemScreen`.
- Не реализуется multi-window UI на iPad: обрабатывается только `windowApplication`-сцена.

## Decisions

### D1. Dynamic shortcut вместо статического `Info.plist`

Регистрация выполняется в `AppDelegate.application(_:didFinishLaunchingWithOptions:)` через `UIApplication.shared.shortcutItems = [item]`.

Обоснование: у quick action динамическая локализованная строка (`String(localized: "Add Item")`), которую нужно вычислить в рантайме; статический `Info.plist` потребовал бы `InfoPlist.strings` и не даёт вычислять заголовок из каталога. Динамическая регистрация — рекомендованный Apple способ для quick action, содержимое которого зависит от состояния приложения ([Add Home Screen quick actions](https://developer.apple.com/documentation/uikit/add-home-screen-quick-actions)).

Компромисс: **action появляется только после первого запуска приложения** — до первого запуска у иконки нет зарегистрированных quick actions. Это зафиксировано в требованиях (`specs/home-screen-quick-actions/spec.md`, сценарий «No action before first launch») и здесь. Альтернатива (статический `Info.plist`) отклонена по прямому ограничению задачи; в будущей итерации её можно добавить как отдельное изменение.

### D2. Идентификатор типа и иконка

Тип shortcut — стабильная строка `com.oleg991.SwiftUI-Days.addItem` (префикс — bundle identifier приложения). Иконка — системная: `UIApplicationShortcutIcon(type: .add)` (`UIApplicationShortcutIconTypeAdd`, «An icon for a quick action that adds an item»).

### D3. Свой `UIWindowSceneDelegate` через `application(_:configurationForConnecting:options:)`

Официальный паттерн Apple для SwiftUI-приложения с собственным scene delegate:

```swift
func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
) -> UISceneConfiguration {
    let configuration = UISceneConfiguration(
        name: nil,
        sessionRole: connectingSceneSession.role
    )
    if connectingSceneSession.role == .windowApplication {
        configuration.delegateClass = AppDelegateSceneDelegate.self
    }
    return configuration
}
```

Почему так:

- `UISceneConfiguration(name: nil, sessionRole:)` + `delegateClass` — ровно тот приём, который Apple документирует для SwiftUI-приложений в «Accepting Share Invitations in a SwiftUI App»: собственный delegate-класс подключается без Info.plist-манифеста сцен и без ручного создания `UIWindow`; `WindowGroup` продолжает создавать окно.
- `delegateClass` выставляется **только** для роли `.windowApplication` — для остальных ролей (например, внешний дисплей) остаётся конфигурация по умолчанию.
- `UIWindow` вручную не создаётся и `scene(_:willConnectTo:options:)` в нашем delegate **не реализуется**: SwiftUI отвечает за создание окна, а наш delegate нужен только для приёма quick action.
- Устаревший `UIApplicationDelegate.application(_:performActionFor:completionHandler:)` не используется: в SDK он помечен `API_DEPRECATED("Use UIScene lifecycle and windowScene(_:performActionFor:completionHandler:) from UIWindowSceneDelegate instead.", ios(9.0, 26.0))` и для scene-based приложений не вызывается.

### D4. Схема обработки cold / warm запуска

**Cold launch (приложение было завершено).** Выбранный action приходит в `UIScene.ConnectionOptions.shortcutItem` — то есть в параметре `options` метода `application(_:configurationForConnecting:options:)` (это официальный путь для сцен: [Add Home Screen quick actions](https://developer.apple.com/documentation/uikit/add-home-screen-quick-actions) — «If the app isn't already loaded, it's launched and passes details of the shortcut item in through the `connectionOptions` parameter»).

Порядок:

1. `AppDelegate.application(_:didFinishLaunchingWithOptions:)` — регистрация `UIApplication.shared.shortcutItems`.
2. `AppDelegate.application(_:configurationForConnecting:options:)` — `options.shortcutItem` → `QuickActionService.shared.handle(options.shortcutItem)`; заодно конфигурация сцены с `delegateClass`.
3. Сцена подключается, SwiftUI строит `RootScreen`; вкладка по умолчанию — `.list`.
4. `MainScreen.onAppear` — запрос уже в pending, `consumeAddItemRequest()` возвращает `true` → analytics + `sheetItem = .addItem`.

Важно: `.onChange(of:)` **не срабатывает** на начальном значении, поэтому cold launch обрабатывается в `.onAppear`, а не в `.onChange`.

**Warm launch (фон или активное состояние).** Выбранный action приходит в `AppDelegateSceneDelegate.windowScene(_:performActionFor:) async -> Bool`.

Порядок:

1. `windowScene(_:performActionFor:) async -> Bool` — `QuickActionService.shared.handle(shortcutItem)`, возвращается его результат: `true` для распознанного action, `false` для неизвестного типа (без навигации и логирования).
2. `RootScreen.onChange(of: service.requestCount)` — переключение на вкладку списка (`tab = .list`).
3. `MainScreen.onChange(of: service.requestCount)` — `consumeAddItemRequest()` → если форма ещё не открыта: analytics + `sheetItem = .addItem`.

Выбран именно async-вариант: он реализуется как `async -> Bool` и компилируется без предупреждений в Swift 6 (`-strict-concurrency=complete`); компилятор генерирует ObjC-тредж селектора `windowScene:performActionForShortcutItem:completionHandler:`, через который UIKit обращается к delegate. Альтернатива — completion-handler-вариант (`completionHandler: @escaping (Bool) -> Void)`): он тоже корректен, но менее удобен — в Swift 6 (`-strict-concurrency=complete`) работа с его замыканием даёт предупреждения о `Sendable`.

### D5. `@Observable`-сервис с монотонным счётчиком и однократным consume

```swift
@MainActor
@Observable
final class QuickActionService {
    static let shared = QuickActionService()

    /// Монотонный счётчик запросов: подписчики всегда видят факт запроса.
    private(set) var requestCount = 0
    /// Запрос ещё не потреблён.
    private var isPending = false

    func requestAddItem() { requestCount += 1; isPending = true }

    /// Возвращает true ровно один раз на каждый запрос.
    func consumeAddItemRequest() -> Bool {
        guard isPending else { return false }
        isPending = false
        return true
    }

    /// Единственная точка маппинга системного shortcut в доменное действие.
    /// Возвращает true, если событие распознано и обработано.
    @discardableResult
    func handle(_ shortcutItem: UIApplicationShortcutItem?) -> Bool {
        guard let shortcutItem, let type = QuickActionType(shortcutType: shortcutItem.type) else { return false }
        switch type {
        case .addItem:
            requestAddItem()
            return true
        }
    }
}
```

Почему маппинг живёт в сервисе (`handle`), а не в вызывающих делегатах: cold- и warm-пути обрабатывают событие в разных классах; общая точка гарантирует, что новый тип quick action не получится добавить в один путь и забыть в другом.

Почему счётчик, а не просто флаг: `consume` сбрасывает флаг, поэтому наблюдатель того же флага (`RootScreen`) мог бы не увидеть переход в `true` — значение уже сброшено более ранним подписчиком — и не переключить вкладку. Монотонный счётчик не сбрасывается, поэтому оба наблюдателя гарантированно видят факт запроса, а «однократность» обеспечивается отдельным `isPending`.

Почему `static let shared`: экземпляры делегатов создаёт фреймворк по метатипу — `UISceneConfiguration.delegateClass` для scene delegate и `@UIApplicationDelegateAdaptor` для AppDelegate — без точки инъекции зависимостей (передать готовый экземпляр нельзя), а `Environment` распространяется только по иерархии view, куда делегаты не входят. Поэтому сервис — единственный app-wide экземпляр, а SwiftUI получает его через `.environment(QuickActionService.shared)`. Инъекция в окружение при этом сохраняется: в UI сервис по-прежнему попадает только через `@Environment(QuickActionService.self)`, а не через обращение к глобалу из view.

### D6. Маршрутизация до формы: где переключение вкладки, где открытие sheet

- `RootScreen` — переключает вкладку: `.onChange(of: service.requestCount) { _, _ in tab = .list }`. На cold launch вкладка и так `.list`, отдельная обработка не нужна.
- `MainScreen` — единственный потребитель запроса и единственная точка открытия формы: обрабатывает и `.onChange(of: service.requestCount)`, и `.onAppear` (cold launch), вызывая один и тот же метод.

Единая точка потребления нужна, чтобы выполнялись требования «не создавать второй sheet» и «логировать analytics ровно один раз»: если бы запрос потребляли два экрана, часть событий терялась бы, а часть обрабатывалась дважды.

Защита от дубля sheet: перед открытием сравнивается текущий `sheetItem` с `.addItem`; если форма уже открыта — запрос потребляется, но sheet не пересоздаётся и analytics не логируется. Для сравнения `SheetItem` получает конформанс `Equatable` (синтезируется автоматически: `String` и `[String]` — `Equatable`).

Порядок при warm launch с вкладки «Ещё»: `MainScreen` в это время может быть уже создан, но не виден. Установка `sheetItem` в таком состоянии приводит к предъявлению sheet поверх окна, а переключение вкладки меняет то, что видно под sheet; в итоге пользователь видит форму добавления поверх вкладки списка — целевое состояние. Если `MainScreen` ещё не создан, запрос остаётся pending и обрабатывается в его `.onAppear`.

### D7. Локализация заголовка

Заголовок берётся из существующего ключа каталога через сгенерированный аксессор: `String(localized: .addItem)` — компилятор отслеживает ключ «Add Item», поэтому его переименование в каталоге сломает сборку, а не приведёт к показу английской строки русским пользователям. Ключ `Add Item` в `Localizable.xcstrings` уже содержит `ru`: «Добавить запись» и `en`: «Add Item», поэтому новые ключи и правки каталога не нужны. Вычисление заголовка происходит при регистрации shortcut, то есть язык определяется текущей локалью устройства.

### D8. Analytics

Используется существующее событие `AnalyticsEvent.userAction(action: .create)` — модель событий не меняется. Событие логируется в точке фактического открытия формы (в обработчике quick action), а не в момент получения события от UIKit. Поэтому повторное нажатие при уже открытой форме не дублирует лог, а кнопка «+» продолжает логировать событие своим прежним кодом — сценарий из требования «Existing add flow unaffected» не затрагивается.

### D9. Маппинг типа shortcut — чистая функция

Тип shortcut разбирается в отдельной доменной модели `QuickActionType` (`SwiftUI-Days/Models/QuickActionType.swift`) с failable-инициализатором `init?(shortcutType: String)`. Неизвестный или устаревший тип возвращает `nil` — обработчик не вызывает навигацию, не логирует analytics и не падает. Это единственное место, где «строка из UIKit» превращается в доменное действие, поэтому оно же — единственное место, покрываемое unit-тестом.

### D10. Неизвестный тип и результат обработки

`windowScene(_:performActionFor:)` возвращает `true` только если событие было распознано и передано в UI, иначе `false`. Это соответствует контракту `completionHandler(succeeded:)` — «Specify true if you completed the action or false if you didn't».

### D11. Симуляция quick action для UI-теста (вспомогательно)

Длинное нажатие на иконку нельзя воспроизвести из XCUITest. Поэтому в `AppDelegate.application(_:didFinishLaunchingWithOptions:)` под `#if DEBUG` добавляется проверка launch-аргумента `"UITestQuickAction"`: при его наличии сервис получает тот же запрос, что и при реальном quick action. Это даёт детерминированный UI-тест маршрутизации (переключение вкладки + открытие формы) без изменения продакшн-поведения. Аргумент существует только в debug-сборке и присутствует лишь в UI-тестах.

**Отменено при реализации:** UI-тест признан лишним (чужероден для скриншот-таргета `SwiftUI-DaysUITests`, проверяет искусственный путь мимо UIKit), debug-хук вместе с ним не добавлялся; маршрутизация проверена вручную на симуляторе.

## Risks / Trade-offs

- **[Quick action не виден до первого запуска приложения]** → Это осознанный компромисс динамической регистрации (D1); требования и сценарий «No action before first launch» его фиксируют. Устранение потребует статического `Info.plist` — отдельная итерация.
- **[Замена `delegateClass` у сцены]** → SwiftUI-приложение продолжает создавать окно через `WindowGroup` (официальный паттерн Apple, D3). Риск проверяется первым шагом реализации: если окно перестанет создаваться, симптом — пустой экран на запуске; откат — не выставлять `delegateClass` и вернуться к `UIApplicationDelegate.application(_:performActionFor:completionHandler:)` (deprecated начиная с iOS 26, но рабочий на iOS 17+) либо к статическому `Info.plist` + обработке в app delegate.
- **[Сервис — синглтон (`QuickActionService.shared`)]** → Осознанный компромисс: экземпляры делегатов создаёт фреймворк по метатипу, точки инъекции нет (D5). В UI сервис по-прежнему приходит только через `@Environment` (D5). Альтернативы (`UISceneSession.userInfo`, `NotificationCenter`, observable-AppDelegate) требуют больше кода или ломают cold launch; подробнее — в отчёте реализации.
- **[Порядок предъявления sheet и переключения вкладки при warm launch с вкладки «Ещё»]** → Итоговое состояние (вкладка списка + открытая форма) не зависит от порядка, но возможен кратковременный показ формы поверх вкладки «Ещё». Проверяется ручным сценарием из критериев приёмки.
- **[Забытая регистрация shortcut после `UIApplication.shared.shortcutItems` был затёрт]** → Регистрация выполняется на каждом запуске в `didFinishLaunchingWithOptions`, значение перезаписывается целиком, стороннего кода, меняющего `shortcutItems`, в проекте нет.
- **[Локализация заголовка вычисляется один раз при запуске]** → Смена языка устройства без перезапуска приложения обновит заголовок только после следующего запуска. Для quick action это приемлемо и совпадает с поведением системных действий.
- **[iPad: два окна — форма может открыться в фоновом]** → Сгенерированный манифест содержит `UIApplicationSupportsMultipleScenes = true`, сервис — один на процесс: при двух окнах вкладку переключат оба `RootScreen`, а форму откроет то окно, чей `MainScreen` первым потребит запрос — возможно, не то, что перед глазами. Non-Goals исключает multi-window UI; если он понадобится, состояние сервиса нужно делать per-scene.
