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

    enum UserAction: String {
        case iconSelected = "icon_selected"
        case itemSaved = "item_saved"
        case create
        case edit
    }

    enum AppErrorKind: String {
        case setIcon = "set_icon"
        case createBackup = "create_backup"
        case restoreBackup = "restore_backup"
        case deleteAllData = "delete_all_data"
    }
}
