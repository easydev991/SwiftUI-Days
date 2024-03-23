//
//  Item+.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

import Foundation

extension Item {
    static func single(
        title: String = "Single item",
        details: String? = nil,
        date: Date = .now
    ) -> Self {
        .init(
            title: title,
            details: details,
            timestamp: date
        )
    }
    
    static func makeList(count: Int = 10) -> [Item] {
        (0..<count).map {
            .init(title: "Item # \($0)", timestamp: .now)
        }
    }
}
