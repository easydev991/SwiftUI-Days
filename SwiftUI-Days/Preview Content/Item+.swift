//
//  Item+.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

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
        (0 ..< count).map {
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

extension Item {
    static func makeDemoList(isEnglish: Bool) -> [Item] {
        let items = [
            (
                title: ("Новые кроссовки", "New Sneakers"),
                details: ("Купили спортивную обувь для утренних пробежек", "Purchased sports shoes for morning runs"),
                timestamp: 1_672_531_200 // 2023-01-01
            ),
            (
                title: ("Ремонт окна", "Window Repair"),
                details: ("Замена старой рамы на энергосберегающую конструкцию", "Replacing old frame with energy-saving structure"),
                timestamp: 1_641_081_600 // 2022-01-02
            ),
            (
                title: ("Торжественное мероприятие", "Celebratory Event"),
                details: ("Посещение праздничного вечера с друзьями", "Attending a festive evening with friends"),
                timestamp: 1_633_046_400 // 2021-10-01
            ),
            (
                title: ("Приобретение автомобиля", "Car Purchase"),
                details: ("Оформление кредита на новый внедорожник", "Arranging a loan for a new SUV"),
                timestamp: 1_654_041_600 // 2022-06-01
            ),
            (
                title: ("Стоматологический осмотр", "Dental Checkup"),
                details: ("Установка пломбы на коренной зуб", "Filling placement on a molar tooth"),
                timestamp: 1_664_582_400 // 2022-10-01
            ),
            (
                title: ("Зарубежное путешествие", "Overseas Trip"),
                details: ("Тур по историческим достопримечательностям", "Tour of historical landmarks"),
                timestamp: 1_598_918_400 // 2020-09-01
            ),
            (
                title: ("Защита проекта", "Project Defense"),
                details: ("Успешная презентация годового исследования", "Successful presentation of annual research"),
                timestamp: 1_561_939_200 // 2019-07-01
            ),
            (
                title: ("Появление котенка", "Kitten Adoption"),
                details: ("Взяли домой пушистого питомца из приюта", "Took home a fluffy shelter pet"),
                timestamp: 1_617_235_200 // 2021-04-01
            ),
            (
                title: ("Смена адреса", "Address Change"),
                details: ("Переезд в новую квартиру с улучшенной планировкой", "Moving to a new apartment with better layout"),
                timestamp: 1_585_699_200 // 2020-04-02
            ),
            (
                title: ("Обновление техники", "Equipment Upgrade"),
                details: ("Приобретение профессионального ноутбука для работы", "Purchasing a professional work laptop"),
                timestamp: 1_609_459_200 // 2021-01-01
            ),
            (
                title: ("Техническая экскурсия", "Technical Tour"),
                details: ("Ознакомительный визит на производственное предприятие", "Familiarization visit to manufacturing plant"),
                timestamp: 1_577_836_800 // 2020-01-01
            ),
            (
                title: ("Водительский экзамен", "Driving Exam"),
                details: ("Успешная сдача теста в ГИБДД с первого раза", "Passed driving test on first attempt"),
                timestamp: 1_483_228_800 // 2017-01-01
            ),
            (
                title: ("Медицинская операция", "Medical Surgery"),
                details: ("Плановое хирургическое вмешательство в клинике", "Scheduled surgical procedure at clinic"),
                timestamp: 1_538_352_000 // 2018-10-01
            ),
        ]

        return items.map { item in
            Item(
                title: isEnglish ? item.title.1 : item.title.0,
                details: isEnglish ? item.details.1 : item.details.0,
                timestamp: Date(timeIntervalSince1970: TimeInterval(item.timestamp))
            )
        }
    }
}
