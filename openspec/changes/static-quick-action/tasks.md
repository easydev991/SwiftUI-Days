# Tasks

## 1. Статический quick action в Info.plist

- [ ] 1.1 Добавить в `SwiftUI-Days/SupportingFiles/Info.plist` ключ `UIApplicationShortcutItems` с одним shortcut: тип `com.oleg991.SwiftUI-Days.addItem`, заголовок — ключ локализации «Add Item», иконка — SF Symbol `plus` (`UIApplicationShortcutItemIconSymbolName`). Проверка: `plutil -lint` проходит, `make build` собирается.

## 2. Удаление динамической регистрации и регресс

- [ ] 2.1 Удалить из `SwiftUI-Days/AppDelegate.swift` метод `registerShortcutItem()` и его вызов в `didFinishLaunchingWithOptions`. Проверка: `make build` без ошибок и предупреждений.
- [ ] 2.2 Прогнать тесты `make test`: все зелёные, включая все тесты `QuickActionService`/`QuickActionType` (обработка не изменилась). Перед коммитом выполнить `make format`.

## 3. Ручная приёмка на симуляторе

- [ ] 3.1 Установка без запуска: удалить приложение с симулятора, установить новую сборку и, не запуская её, выполнить долгое нажатие на иконку — в меню отображается «Добавить запись» (сценарий «Action visible immediately after install or update»).
- [ ] 3.2 Обновление без запуска: установить предыдущую сборку, запустить и завершить её, затем установить новую поверх и, не запуская, выполнить долгое нажатие — «Добавить запись» отображается, дублей нет.
- [ ] 3.3 Санити обработки: выбрать quick action из завершённого и из фонового состояния — открывается вкладка списка с формой добавления, по одному sheet и одному analytics-событию (сценарии «Cold launch» / «Warm launch» спеки).

## Workflow follow-up

- Заархивировать change после ревью (`openspec archive static-quick-action`) и проверить, что дельта влилась в `openspec/specs/home-screen-quick-actions/spec.md`.
