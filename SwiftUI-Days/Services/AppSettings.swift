import Foundation
import Observation
import SwiftUI

@Observable final class AppSettings {
    private let defaults: UserDefaults
    private let bundle: Bundle

    init(
        defaults: UserDefaults = .standard,
        bundle: Bundle = .main
    ) {
        self.defaults = defaults
        self.bundle = bundle
    }

    var appTheme: AppTheme {
        get {
            access(keyPath: \.appTheme)
            let rawValue = defaults.integer(
                forKey: DefaultsKey.appTheme.rawValue
            )
            return .init(rawValue: rawValue) ?? .system
        }
        set {
            withMutation(keyPath: \.appTheme) {
                defaults
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
            return defaults.bool(
                forKey: DefaultsKey.blurWhenMinimized.rawValue
            )
        }
        set {
            withMutation(keyPath: \.blurWhenMinimized) {
                defaults
                    .setValue(
                        newValue,
                        forKey: DefaultsKey.blurWhenMinimized.rawValue
                    )
            }
        }
    }

    var mainScreenColorTagFilterHex: String? {
        get {
            access(keyPath: \.mainScreenColorTagFilterHex)
            return defaults.string(
                forKey: DefaultsKey.mainScreenColorTagFilterHex.rawValue
            )
        }
        set {
            withMutation(keyPath: \.mainScreenColorTagFilterHex) {
                guard let newValue else {
                    defaults.removeObject(forKey: DefaultsKey.mainScreenColorTagFilterHex.rawValue)
                    return
                }
                defaults.setValue(
                    newValue,
                    forKey: DefaultsKey.mainScreenColorTagFilterHex.rawValue
                )
            }
        }
    }

    var appVersion: String {
        (bundle.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String) ?? "1"
    }
}
