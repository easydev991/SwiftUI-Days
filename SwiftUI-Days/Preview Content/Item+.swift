//
//  Item+.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

#if DEBUG
import Foundation

extension Item {
    static var singleLong: Self {
        .init(
            title: "Какое-то давнее событие из прошлого, которое хотим запомнить",
            details: "Детали события, которые очень хочется запомнить, и никак нельзя забывать, например, первая поездка на велосипеде",
            timestamp: Calendar.current.date(byAdding: .year, value: -10, to: .now)!
        )
    }
    
    static func makeList(count: Int = 10) -> [Item] {
        (0..<count).map {
            .init(
                title: "Item # \($0)",
                timestamp: Calendar.current.date(
                    byAdding: .day,
                    value: -(1 + $0),
                    to: .now
                )!
            )
        }
    }
}
#endif
