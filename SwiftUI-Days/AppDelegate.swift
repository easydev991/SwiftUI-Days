import FirebaseCore
import UIKit

@MainActor
final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        // Система хранит динамические quick actions предыдущих версий после
        // обновления приложения — очищаем, чтобы они не дублировали статический.
        UIApplication.shared.shortcutItems = []
        return true
    }

    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Cold launch: событие приходит в options ещё до подключения сцены.
        QuickActionService.shared.handle(options.shortcutItem)

        let configuration = UISceneConfiguration(
            name: nil,
            sessionRole: connectingSceneSession.role
        )
        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = AppDelegateSceneDelegate.self
        }
        return configuration
    }
}
