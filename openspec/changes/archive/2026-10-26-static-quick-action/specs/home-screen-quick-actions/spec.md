# Spec Delta

## ADDED Requirements

### Requirement: Static quick action display on long press

The app SHALL объявлять quick action «Добавить запись» статически в Info.plist, чтобы система регистрировала его в момент установки приложения: action SHALL отображаться в меню долгого нажатия на иконку сразу после установки и после каждого обновления приложения, без необходимости первого запуска. Кроме того, приложение SHALL при запуске очищать закешированные системой динамические shortcut items предыдущих версий, чтобы статический action не дублировался в меню.

#### Scenario: Action visible after first launch

- **WHEN** приложение запускалось хотя бы один раз и пользователь выполняет долгое нажатие на иконку на Home Screen
- **THEN** в системном меню иконки отображается quick action «Добавить запись»

#### Scenario: Action visible immediately after install or update

- **WHEN** приложение установлено или обновлено (в том числе из App Store или TestFlight), но ещё ни разу не запускалось, и пользователь выполняет долгое нажатие на иконку
- **THEN** в системном меню иконки отображается quick action «Добавить запись»

#### Scenario: Cached dynamic items cleared after first launch of the updated app

- **WHEN** приложение обновлено с предыдущей версии, регистрировавшей динамический quick action, и пользователь запускает обновлённое приложение в первый раз
- **THEN** закешированный динамический action удаляется из системного меню: при долгом нажатии на иконку отображается ровно один quick action «Добавить запись»

## REMOVED Requirements

### Requirement: Quick action display on long press

**Reason**: Динамическая семантика старого требования (регистрация при каждом запуске, допустимое отсутствие action до первого запуска) — первопричина проблемы: после установки или обновления из App Store кнопка не видна, пока пользователь не запустит приложение. Сценарий «No action before first launch» закреплял это нежелательное поведение.

**Migration**: Заменено требованием «Static quick action display on long press» (секция ADDED): статическая регистрация в Info.plist, action отображается сразу после установки и обновления. Остальные требования capability (локализация, иконка, cold/warm launch, дубли, analytics, неизвестные типы) сохраняются без изменений.
