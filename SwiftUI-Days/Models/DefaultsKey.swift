import Foundation

enum DefaultsKey: String {
    /// Тема приложения
    case appTheme
    /// Порядок сортировки на главном экране
    case listSortOrder
    /// Размытие при сворачивании приложения
    case blurWhenMinimized
    /// Счётчик созданных записей для review
    case reviewTotalItemsCreated
    /// Milestone-и, по которым уже запрашивали review
    case reviewAttemptedMilestones
}
