import UIKit

enum FeedbackSender {
    /// Открывает диплинк `mailto` для создания письма
    @MainActor
    static func sendFeedback() {
        let encodedSubject = Feedback.subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "Feedback"
        let encodedBody = Feedback.body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        if let url = URL(string: "mailto:\(Feedback.recipient)?subject=\(encodedSubject)&body=\(encodedBody)"),
           UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url)
        }
    }

    private enum Feedback {
        private static var processInfo: ProcessInfo {
            ProcessInfo.processInfo
        }

        static let subject = "\(processInfo.processName): Обратная связь"

        static var body: String {
            var platformName: String {
                let idiom = switch UIDevice.current.userInterfaceIdiom {
                case .pad: "iPadOS"
                default: "iOS"
                }
                return processInfo.isiOSAppOnMac ? "macOS" : idiom
            }
            return """
                \(platformName): \(processInfo.operatingSystemVersionString)
                Версия приложения: \((Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1")
                ---
                Что можно улучшить в приложении?
                \n
            """
        }

        static let recipient = "starker.words-01@icloud.com"
    }
}
