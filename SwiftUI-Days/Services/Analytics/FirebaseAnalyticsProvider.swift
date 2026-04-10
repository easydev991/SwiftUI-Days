import FirebaseAnalytics
import Foundation

struct FirebaseAnalyticsProvider: AnalyticsProvider {
    func log(event: AnalyticsEvent) {
        switch event {
        case let .screenView(screen):
            let screenName = screen.rawValue
            Analytics.logEvent(
                AnalyticsEventScreenView,
                parameters: [
                    AnalyticsParameterScreenName: screenName,
                    AnalyticsParameterScreenClass: screenName
                ]
            )
        case let .userAction(action):
            var params: [String: Any] = ["action": action.name]
            if case let .iconSelected(iconName) = action {
                params["icon_name"] = iconName
            }
            Analytics.logEvent("user_action", parameters: params)
        case let .appError(kind, error):
            let nsError = error as NSError
            Analytics.logEvent(
                "app_error",
                parameters: [
                    "operation": kind.rawValue,
                    "error_domain": nsError.domain,
                    "error_code": nsError.code
                ]
            )
        }
    }
}
