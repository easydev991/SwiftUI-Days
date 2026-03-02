import Observation
import SwiftUI

@Observable final class AppSettings {
    var appTheme: AppTheme {
        get {
            access(keyPath: \.appTheme)
            let rawValue = UserDefaults.standard.integer(
                forKey: DefaultsKey.appTheme.rawValue
            )
            return .init(rawValue: rawValue) ?? .system
        }
        set {
            withMutation(keyPath: \.appTheme) {
                UserDefaults.standard
                    .setValue(
                        newValue.rawValue,
                        forKey: DefaultsKey.appTheme.rawValue
                    )
            }
        }
    }

    var blurWhenMinimized: Bool {
        get {
            access(keyPath: \.blurWhenMinimized)
            return UserDefaults.standard.bool(
                forKey: DefaultsKey.blurWhenMinimized.rawValue
            )
        }
        set {
            withMutation(keyPath: \.blurWhenMinimized) {
                UserDefaults.standard
                    .setValue(
                        newValue,
                        forKey: DefaultsKey.blurWhenMinimized.rawValue
                    )
            }
        }
    }

    let appVersion = (
        Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String
    ) ?? "1"
}
