# План внедрения аналитики (простой и расширяемый)

## Цель

- Удобно логировать события в коде.
- Не зависеть жестко от Firebase: в будущем можно подменить/добавить провайдеры.

## Минимальная архитектура

### 1. `AnalyticsEvent` (единая модель событий)

- Один enum с кейсами:
  - `screenView(screen: AppScreen)`
  - `userAction(action: UserAction)`
  - `appError(kind: AppErrorKind, error: any Error)`
- В enum хранится только бизнес-смысл события, без Firebase API.
- Вложенный enum `UserAction`:
  - `iconSelected` (TODO: добавить `iconName: String`)
  - `delete`
  - `sort`
  - `itemSaved`
  - `create`
  - `edit`
- Вложенный enum `AppScreen`:
  - `root`, `main`, `item`, `more`, `themeIcon`, `appData`, `privacy`
- Вложенный enum `AppErrorKind`:
  - `setIcon`, `createBackup`, `restoreBackup`, `deleteAllData`

### 2. `AnalyticsProvider` (легкий протокол)

- Протокол с 1 методом: `log(event: AnalyticsEvent)`.
- Реализации:
  - `FirebaseAnalyticsProvider` (основной)
  - `NoopAnalyticsProvider` (для тестов/превью)

### 3. `AnalyticsService` (единая точка входа)

- Сервис вызывает один или несколько провайдеров.
- Публичный API: `log(_ event: AnalyticsEvent)`.
- Без сложной магии и без преждевременной оптимизации.

### 4. DI через Environment

- В `SwiftUI_DaysApp` инжектить `AnalyticsService` через `.environment(...)`.
- Во View использовать `@Environment(AnalyticsService.self)`.
- Во view model передавать `AnalyticsService` явно через инициализатор (constructor injection) и хранить ссылку на сервис.

### 5. Общий `View`-модификатор для трекинга

- Добавить единый модификатор вида `trackEvent(...)`.
- Под капотом модификатор берет `AnalyticsService` из `Environment` и логирует событие.
- Для `screenView` использовать `onAppear` как базовый и самый простой вариант.
- Если появятся дубли на сложной навигации, добавить легкую защиту от повторного трекинга в самом модификаторе, не меняя экраны.

## План задач

### Базовая инфраструктура

- [x] Создать `Models/AnalyticsEvent.swift`.
- [x] Создать `Services/Analytics/AnalyticsProvider.swift`.
- [x] Создать `Services/Analytics/FirebaseAnalyticsProvider.swift`.
- [x] Создать `Services/Analytics/NoopAnalyticsProvider.swift`.
- [x] Создать `Services/Analytics/AnalyticsService.swift`.
- [x] Создать `Extensions/View+Analytics.swift` с модификатором `trackEvent(...)`.
- [x] Подключить сервис в `SwiftUI_DaysApp`.

### События просмотра экранов

- [x] Добавить `screenView` через общий модификатор (`.trackEvent(...)`) на:
  - `RootScreen` (`root`)
  - `MainScreen` (`main`)
  - `ItemScreen` (`item`)
  - `MoreScreen` (`more`)
  - `ThemeIconScreen` (`theme_icon`)
  - `AppDataScreen` (`app_data`)
  - `PrivacyScreen` (`privacy`)

### Событие выбора иконки

- [x] В `ThemeIconScreen`/`IconViewModel` логировать `userAction(.iconSelected)` при `Task { await iconViewModel.setIcon(icon) }`.
- [ ] Передавать название выбранной иконки (например, `iconName` или номер `iconNumber`) в аналитику.
  - **TODO**: Изменить `UserAction.iconSelected` на `iconSelected(iconName: String)` и обновить `IconViewModel.setIcon()`.

### События действий пользователя

- [ ] Логировать `userAction(.delete)` при нажатии кнопки удаления (в `MainScreen` или связанной view model).
- [ ] Логировать `userAction(.sort)` при изменении сортировки списка (в `MainScreen` или связанной view model).

### Ошибки из `try/catch`

- [x] Логировать `appError` в `catch` минимум в:
  - `ThemeIconScreen+IconViewModel`
  - `AppDataScreen`
- [x] Для каждого события ошибки передавать:
  - `operation` (например, `set_icon`, `restore_backup`)
  - `domain`
  - `code`

### Тесты

- [ ] Добавить тесты для `AnalyticsService` и провайдеров (`SwiftUI-DaysTests/AnalyticsTests.swift`).

## Правила простоты

- Не вызывать Firebase API напрямую из экранов.
- Не использовать `params: [String: Any]` в публичном API сервиса.
- На первом шаге для `screenView` использовать `onAppear` через общий модификатор.
- Не добавлять сложную дедупликацию экранов на первом шаге.
- Если появится второй инструмент (например, Amplitude), добавить новый provider без изменения UI-кода.
- `Environment` использовать только во View; для view model — только явный DI сервиса.

## Критерии готовности

- [x] События отправляются через `AnalyticsService` из экранов и view model.
- [x] Firebase-провайдер работает для `screenView`, `userAction`, `appError`.
- [x] Добавление нового провайдера не требует правок в экранах.
- [ ] `iconSelected` передаёт название иконки в аналитику.
- [ ] `delete` и `sort` события логируются.
- [ ] Тесты аналитики написаны.
