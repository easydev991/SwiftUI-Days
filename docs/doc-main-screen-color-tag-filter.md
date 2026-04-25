# Главный экран iOS: фильтр по colorTag

Документ фиксирует текущее поведение фильтра по цвету на главном экране iOS (паритет с Android 1.8, с iOS-адаптацией через `sheet`).

## Где находится

- Экран: `MainScreen`
- Открытие фильтра: кнопка в top bar, справа от кнопки сортировки
- Роутинг модальных экранов: единый `.sheet(item:)` через enum `SheetItem` (`addItem`, `colorFilter`)
- UI выбора: `ColorTagFilterSheet` (`NavigationStack` + `ScrollView` + `LazyVGrid`)

## Правила видимости и состояния кнопки фильтра

- Иконка без активного фильтра: `line.3.horizontal.decrease.circle`
- Иконка с активным фильтром: `line.3.horizontal.decrease.circle.fill`
- Кнопка фильтра показывается, когда:
`availableColorTags` не пустой AND (`itemsCountForFilterButton >= 2` OR `selectedColorFilterHex != nil`)

## Источник данных и фильтрация

- `MainScreenFilterState` вычисляет `availableColorTags` из всех записей (уникальные hex).
- `visibleItems` формируется как результат `search + color filter`.
- `itemsCountForFilterButton` считается как `visibleItems.count`.
- `ListView` получает уже готовый `visibleItems` и не содержит собственной логики цветовой фильтрации.

## Персистентность фильтра

- Выбранный цвет сохраняется в `AppSettings.mainScreenColorTagFilterHex`
- Формат идентификатора: `hex RGBA` (`#RRGGBBAA`)
- `Color` в бизнес-логике напрямую не сравнивается; сравнение идёт по hex-строке.

## Нормализация и delete all

- При несоответствии сохранённого цвета текущим `availableColorTags` фильтр автоматически сбрасывается в `nil`.
- После `delete all data` прямой очистки defaults не требуется:
фильтр сбрасывается реактивно через ту же нормализацию на `MainScreen`.

## Поведение sheet

- Вверху: inline-заголовок и кнопка «Закрыть» справа.
- Внутри: сетка круглых цветовых ячеек (`single-select`, повторный тап снимает выбор).
- Внизу: кнопки `Применить` (primary) и `Сбросить` (secondary).
- `sheet` хранит локальный черновик выбора (`@State`) и не использует `@Query`/`modelContext`.
- На `Применить`: вызывает `onApply(draftSelectedColorHex)` и закрывается через `dismiss()`.
- На `Сбросить`:

1. если есть примененный фильтр, вызывает `onApply(nil)` и закрывается;
2. если примененного фильтра нет, очищает только локальный черновик.

## Аналитика

- При открытии sheet фильтра логируется `open_filter`.
- При нажатии `Применить` логируется `apply_filter`.
- При нажатии `Сбросить` логируется `reset_filter`.

## Логика состояния sheet

- Логика `isApplyEnabled`, `isResetEnabled`, переключения выбранного цвета и результата `Reset` вынесена в `ColorTagFilterSheetState`.
- `ColorTagFilterSheet` использует `ColorTagFilterSheetState` как источник вычислений состояния UI, не дублируя бизнес-правила в `View`.

## Покрытие тестами

- `MainScreenFilterStateTests`:

1. доступные цвета;
2. фильтрация `search + color`;
3. `itemsCountForFilterButton`;
4. авто-сброс невалидного фильтра, включая `items.isEmpty`.

- `ColorTagFilterSheetStateTests`:

1. enable/disable для `Применить` и `Сбросить`;
2. toggle выбора цвета;
3. поведение `Сбросить` для сценариев с активным и неактивным примененным фильтром.

- `AnalyticsEventTests`:

1. проверка имен событий `open_filter`, `apply_filter`, `reset_filter`.
