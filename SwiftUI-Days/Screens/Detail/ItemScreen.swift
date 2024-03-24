//
//  ItemScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

import SwiftUI

struct ItemScreen: View {
    @State private var isEditing = false
    let item: Item
    
    var body: some View {
        ZStack {
            if isEditing {
                EditItemScreen(oldItem: item) { isEditing = false }
                    .transition(.move(edge: .trailing).combined(with: .scale))
            } else {
                regularView
                    .transition(.move(edge: .leading).combined(with: .scale))
            }
        }
        .animation(.default, value: isEditing)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var regularView: some View {
        VStack(spacing: 16) {
            ReadSectionView(
                headerText: "Title",
                bodyText: item.title
            )
            if !item.details.isEmpty {
                ReadSectionView(
                    headerText: "Details",
                    bodyText: item.details
                )
            }
            Spacer()
        }
        .padding()
        .navigationTitle("\(item.daysCount) d")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                DaysEditButton { isEditing.toggle() }
                    .labelStyle(.titleOnly)
            }
        }
    }
}

#if DEBUG
#Preview("Много текста") {
    NavigationStack {
        ItemScreen(
            item: .single(
                title: "Какое-то давнее событие из прошлого, которое хотим запомнить",
                details: "Детали события, которые очень хочется запомнить, и никак нельзя забывать, например, первая поездка на велосипеде",
                date: Calendar.current.date(byAdding: .year, value: -10, to: .now)!
            )
        )
    }
}
#endif
