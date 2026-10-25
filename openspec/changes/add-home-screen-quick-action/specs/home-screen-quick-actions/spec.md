# Spec Delta

## Purpose

Дает пользователям системный путь быстрого создания записи из Home Screen: долгое нажатие на иконку приложения показывает quick action «Добавить запись», выбор которого открывает существующую форму добавления на вкладке списка без навигации по приложению.

## ADDED Requirements

### Requirement: Quick action display on long press

The app SHALL регистрировать Home Screen quick action «Добавить запись» при каждом запуске приложения, чтобы action отображался при долгом нажатии на иконку; до первого запуска после установки action MAY отсутствовать.

#### Scenario: Action visible after first launch

- **WHEN** приложение запускалось хотя бы один раз и пользователь выполняет долгое нажатие на иконку на Home Screen
- **THEN** в системном меню иконки отображается quick action «Добавить запись»

#### Scenario: No action before first launch

- **WHEN** приложение установлено, но ещё ни разу не запускалось, и пользователь выполняет долгое нажатие на иконку
- **THEN** quick action «Добавить запись» не отображается (допустимое поведение динамической регистрации)

### Requirement: Localized quick action title

Заголовок quick action SHALL браться из существующего ключа локализации `Add Item`: ru — «Добавить запись», en — «Add Item». Новые ключи локализации MUST NOT добавляться.

#### Scenario: Russian system language

- **WHEN** системный язык устройства — русский и пользователь открывает меню иконки
- **THEN** заголовок quick action — «Добавить запись»

#### Scenario: English system language

- **WHEN** системный язык устройства — английский и пользователь открывает меню иконки
- **THEN** заголовок quick action — «Add Item»

### Requirement: System add icon

Иконка quick action SHALL быть системной иконкой добавления (встроенный тип системной иконки «+»), без кастомных изображений.

#### Scenario: System plus icon is displayed

- **WHEN** пользователь открывает меню долгого нажатия на иконку приложения
- **THEN** слева от заголовка quick action отображается системная иконка «+»

### Requirement: Cold launch via quick action

The app SHALL при выборе quick action из завершённого состояния запустить приложение, переключиться на вкладку списка и открыть форму добавления записи. Форма SHALL переиспользовать существующую форму создания записи; повторная реализация формы и изменение модели данных MUST NOT происходить.

#### Scenario: Launch from terminated state opens add form

- **WHEN** приложение полностью завершено и пользователь выбирает quick action «Добавить запись»
- **THEN** приложение запускается, активной становится вкладка списка и поверх неё открывается форма добавления записи

### Requirement: Warm launch via quick action

The app SHALL при выборе quick action из фонового или активного состояния вывести приложение вперёд, переключиться на вкладку списка и открыть форму добавления записи.

#### Scenario: App in background opens add form

- **WHEN** приложение находится в фоне и пользователь выбирает quick action «Добавить запись»
- **THEN** выходя на передний план, приложение показывает вкладку списка с открытой формой добавления записи

#### Scenario: App active opens add form

- **WHEN** приложение активно и пользователь выбирает quick action «Добавить запись»
- **THEN** приложение остаётся на переднем плане, переключается на вкладку списка и открывает форму добавления записи

#### Scenario: Launched from More tab

- **WHEN** приложение в фоне или активно, пользователь находится на вкладке «Ещё» и выбирает quick action «Добавить запись»
- **THEN** приложение переключается на вкладку списка и открывает форму добавления записи

### Requirement: No duplicate add form on repeated activation

Если форма добавления уже открыта, повторное нажатие quick action SHALL NOT создавать второй sheet. Повторное нажатие SHALL оставлять уже открытую форму единственной.

#### Scenario: Second activation while form is open

- **WHEN** форма добавления открыта через quick action и пользователь выбирает quick action ещё раз
- **THEN** в приложении остаётся один sheet с формой добавления записи, второй не создаётся

#### Scenario: Quick action while another sheet is open

- **WHEN** открыт другой sheet (например, фильтр списка) и пользователь выбирает quick action «Добавить запись»
- **THEN** открытый sheet заменяется формой добавления записи поверх вкладки списка, в приложении остаётся один sheet

### Requirement: Unknown shortcut type ignored

The app SHALL игнорировать любой системный shortcut-тип, кроме типа quick action «Добавить запись»: неизвестный или устаревший тип MUST NOT вызывать навигацию, analytics или сбой приложения.

#### Scenario: Unknown shortcut type handled silently

- **WHEN** устройство доставляет событие shortcut с неизвестным типом (например, устаревший тип из другой версии приложения)
- **THEN** приложение продолжает работу без навигации и изменений UI, не падает и не логирует analytics пользовательского действия

### Requirement: Single analytics event for quick action opening

Открытие формы добавления через quick action SHALL логировать ровно одно событие analytics «пользовательское действие: создание записи». Повторное нажатие при уже открытой форме SHALL NOT дублировать событие.

#### Scenario: Analytics logged exactly once per opening

- **WHEN** пользователь выбирает quick action «Добавить запись» и форма добавления открывается
- **THEN** отправляется ровно один аналитический лог пользовательского действия создания записи

#### Scenario: No duplicate analytics when form already open

- **WHEN** форма добавления уже открыта и пользователь выбирает quick action повторно
- **THEN** новый аналитический лог пользовательского действия создания записи не отправляется

### Requirement: Existing add flow unaffected

Существующий сценарий добавления через кнопку «+» SHALL работать без изменений: навигация, поведение формы и analytics этого сценария MUST NOT изменяться появлением quick action.

#### Scenario: Plus button keeps current behavior

- **WHEN** пользователь в приложении нажимает кнопку «+» на экране списка
- **THEN** открывается существующая форма добавления записи, ведёт себя и логируется так же, как до появления quick action
