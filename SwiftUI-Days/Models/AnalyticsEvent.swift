import Foundation

enum AnalyticsEvent {
    case screenView(screen: AppScreen)
    case userAction(action: UserAction)
    case appError(kind: AppErrorKind, error: any Error)
}

extension AnalyticsEvent {
    enum AppScreen: String {
        case root
        case main
        case item
        case more
        case themeIcon = "theme_icon"
        case appData = "app_data"
        case privacy
    }

    enum UserAction {
        case iconSelected(iconName: String)
        case delete
        case sort
        case openFilter
        case applyFilter
        case resetFilter
        case itemSaved
        case create
        case edit

        var name: String {
            switch self {
            case .iconSelected: "icon_selected"
            case .delete: "delete"
            case .sort: "sort"
            case .openFilter: "open_filter"
            case .applyFilter: "apply_filter"
            case .resetFilter: "reset_filter"
            case .itemSaved: "item_saved"
            case .create: "create"
            case .edit: "edit"
            }
        }
    }

    enum AppErrorKind: String {
        case setIcon = "set_icon"
        case createBackup = "create_backup"
        case restoreBackup = "restore_backup"
        case deleteAllData = "delete_all_data"
    }
}
