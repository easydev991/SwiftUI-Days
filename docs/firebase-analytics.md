# Аналитика (Firebase)

В проекте подключена аналитика через Firebase. UI-код не зависит от Firebase напрямую: события проходят через `AnalyticsService` и набор `AnalyticsProvider`-ов. Это позволяет подменить или добавить провайдер без правок в экранах.

## Архитектура

### `AnalyticsEvent` — модель событий

`Models/AnalyticsEvent.swift` — единый enum бизнес-событий. Не содержит Firebase API.

```swift
enum AnalyticsEvent {
    case screenView(screen: AppScreen)
    case userAction(action: UserAction)
    case appError(kind: AppErrorKind, error: any Error)
}
```

Вложенные enums: `AppScreen`, `UserAction` (со свойством `name` для строки в Firebase), `AppErrorKind` (`rawValue` для operation).

### `AnalyticsProvider` — протокол

`Services/Analytics/AnalyticsProvider.swift`:

```swift
protocol AnalyticsProvider {
    func log(event: AnalyticsEvent)
}
```

Реализации:

- `FirebaseAnalyticsProvider` (`Services/Analytics/FirebaseAnalyticsProvider.swift`) — отправляет события в Firebase Analytics:
  - `screenView` → `AnalyticsEventScreenView` с параметром `screen_name`.
  - `userAction` → событие `user_action` с параметрами `action` и `icon_name` (для `.iconSelected`).
  - `appError` → событие `app_error` с параметрами `operation`, `error_domain`, `error_code`.
- `NoopAnalyticsProvider` (`Services/Analytics/NoopAnalyticsProvider.swift`) — пустая реализация для тестов, превью и запуска с аргументом `UITest`.

### `AnalyticsService` — точка входа

`Services/Analytics/AnalyticsService.swift`:

```swift
struct AnalyticsService {
    private let providers: [any AnalyticsProvider]
    func log(_ event: AnalyticsEvent) {
        providers.forEach { $0.log(event: event) }
    }
}
```

Публичный API — один метод `log(_:)`. Параметры событий в виде `[String: Any]` наружу не торчат.

### DI

- В `SwiftUI_DaysApp` собирается `AnalyticsService` (Firebase в проде, `NoopAnalyticsProvider` при запуске с аргументом `UITest`).
- В `EnvironmentKeys/EnvironmentValues+.swift` задан `@Entry var analyticsService` с дефолтом `NoopAnalyticsProvider`.
- Во View: `@Environment(\.analyticsService)`.
- Во view model: явный `init(analytics: AnalyticsService)` (constructor injection).

### `trackScreen` — модификатор для просмотров экранов

`Extensions/View+Analytics.swift` — `.trackScreen(.main)` логирует `screenView` в `onAppear`. Используется на каждом экране, чтобы не дублировать `onAppear` руками.

## Firebase

- Подключение через SPM: `firebase-ios-sdk` 12.12.0, модули `FirebaseAnalytics` и `FirebaseCrashlytics`.
- В проекте лежит `GoogleService-Info.plist`.
- Инициализация: `FirebaseApp.configure()` в `AppDelegate`.

## События

### Просмотры экранов (`screenView`)

Отправляются через `.trackScreen(_:)`:

- `root` — `RootScreen`
- `main` — `MainScreen`
- `item` — `ItemScreen`
- `more` — `MoreScreen`
- `theme_icon` — `ThemeIconScreen`
- `app_data` — `AppDataScreen`
- `privacy` — `PrivacyScreen`

### Действия пользователя (`user_action`)

- `icon_selected` — выбор иконки в `ThemeIconScreen` (параметр `icon_name`).
- `delete` — удаление в `MainScreen`.
- `sort` — изменение сортировки в `MainScreen`.
- `open_filter` — открытие фильтра в `MainScreen`.
- `apply_filter` / `reset_filter` — в `ColorTagFilterSheet`.
- `create` / `edit` / `item_saved` — в `MainScreen`, `ItemScreen`, `EditItemScreen`.

### Ошибки (`app_error`)

Логируются в `catch` `try/catch`:

- `ThemeIconScreen+IconViewModel` — `set_icon`.
- `AppDataScreen` — `create_backup`, `restore_backup`, `delete_all_data`.

Для каждой ошибки передаются `operation`, `error_domain`, `error_code`.

## Правила

- Не вызывать Firebase API напрямую из экранов и view model.
- Не использовать `params: [String: Any]` в публичном API сервиса.
- Для `screenView` — единый модификатор `.trackScreen(_:)`.
- `Environment` — только во View; для view model — явный DI через инициализатор.
- Новый провайдер (Amplitude и т.п.) добавляется без правок UI-кода — только регистрация в `SwiftUI_DaysApp`.

## Тесты

`SwiftUI-DaysTests/AnalyticsServiceTests.swift` покрывает:

- `AnalyticsService` — рассылка событий по всем провайдерам.
- `NoopAnalyticsProvider` — не падает на всех типах событий.
- `AnalyticsEvent` — строковые имена `UserAction`, `rawValue` для `AppScreen` и `AppErrorKind`.
