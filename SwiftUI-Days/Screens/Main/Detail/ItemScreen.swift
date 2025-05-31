//
//  ItemScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

import SwiftUI

struct ItemScreen: View {
    @Environment(\.currentDate) private var currentDate
    @State private var isEditing = false
    let item: Item

    var body: some View {
        ScrollView {
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
        .scrollBounceBehavior(.basedOnSize)
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
            DatePicker(
                "Date",
                selection: .init(
                    get: { item.timestamp },
                    set: { _ in }
                ),
                displayedComponents: .date
            )
            .font(.title3.bold())
            .disabled(true)
            Spacer()
        }
        .padding()
        .navigationTitle("\(item.makeDaysCount(to: currentDate)) days")
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
        ItemScreen(item: .singleLong)
    }
}
#endif
