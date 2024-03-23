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
        VStack {
            LabeledContent {
                Text(item.title)
            } label: {
                Text("Title")
            }
            if !item.details.isEmpty {
                LabeledContent {
                    Text(item.details)
                } label: {
                    Text("Details")
                }
            }
            LabeledContent {
                Text("\(item.daysCount) d")
            } label: {
                Text("Date")
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Info")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                DaysEditButton { isEditing.toggle() }
                    .labelStyle(.titleOnly)
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ItemScreen(
            item: .single(
                title: "Какое-то давнее событие из прошлого",
                details: "Детали события, которые очень хочется запомнить, и никак нельзя забывать",
                date: Calendar.current.date(byAdding: .year, value: -10, to: .now)!
            )
        )
    }
}
#endif
