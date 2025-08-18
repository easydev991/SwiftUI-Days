import SwiftUI

extension SortOrder {
    var name: LocalizedStringKey {
        switch self {
        case .forward: "Old first"
        case .reverse: "New first"
        }
    }
}

// Для использования с `@AppStorage`
extension SortOrder: @retroactive RawRepresentable {
    public init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .forward
        case 1: self = .reverse
        default: return nil
        }
    }

    public var rawValue: Int {
        switch self {
        case .forward: 0
        case .reverse: 1
        }
    }
}
