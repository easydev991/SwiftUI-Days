import UIKit

/// Делегат сцены: принимает quick action, пришедшие в уже подключённую сцену (warm launch).
@MainActor
final class AppDelegateSceneDelegate: NSObject, UIWindowSceneDelegate {
    func windowScene(
        _: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem
    ) async -> Bool {
        QuickActionService.shared.handle(shortcutItem)
    }
}
