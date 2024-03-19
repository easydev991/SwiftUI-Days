//
//  Item+.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

import Foundation

extension Item {
    static var single: Self {
        .init(title: "Single item", timestamp: .now)
    }
    
    static func makeList(count: Int = 10) -> [Item] {
        (0..<count).map {
            .init(title: "Item # \($0)", timestamp: .now)
        }
    }
}
