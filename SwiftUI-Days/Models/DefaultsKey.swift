import Foundation

enum DefaultsKey: String {
    /// Тема приложения
    case appTheme
    /// Порядок сортировки на главном экране
    case listSortOrder
    /// Размытие при сворачивании приложения
    case blurWhenMinimized
    /// Фильтр по colorTag на главном экране
    case mainScreenColorTagFilterHex
    /// Счётчик созданных записей для review
    case reviewTotalItemsCreated
    /// Milestone-и, по которым уже запрашивали review
    case reviewAttemptedMilestones
}
