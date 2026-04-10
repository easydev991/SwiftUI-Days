import Foundation
import Observation
import OSLog
import UIKit.UIApplication

extension ThemeIconScreen {
    @Observable @MainActor
    final class IconViewModel {
        private let analytics: AnalyticsService
        private let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: IconViewModel.self)
        )
        private(set) var currentAppIcon: IconVariant

        init(analytics: AnalyticsService) {
            self.analytics = analytics
            if let currentIconName = UIApplication.shared.alternateIconName {
                currentAppIcon = IconVariant(name: currentIconName)
            } else {
                currentAppIcon = .primary
            }
        }

        func setIcon(_ icon: IconVariant) async {
            analytics.log(.userAction(action: .iconSelected))
            do {
                guard UIApplication.shared.supportsAlternateIcons else {
                    throw IconError.alternateIconsNotSupported
                }
                guard icon.alternateName != UIApplication.shared.alternateIconName else { return }
                try await UIApplication.shared.setAlternateIconName(icon.alternateName)
                currentAppIcon = icon
                logger.info("Установили иконку: \(icon.rawValue)")
            } catch {
                analytics.log(
                    .appError(
                        kind: .setIcon,
                        error: error
                    )
                )
                logger.error("\(error.localizedDescription)")
            }
        }
    }
}

extension ThemeIconScreen.IconViewModel {
    enum IconError: Error, LocalizedError {
        case alternateIconsNotSupported

        var errorDescription: String? {
            switch self {
            case .alternateIconsNotSupported:
                "Альтернативные иконки не поддерживаются"
            }
        }
    }
}
