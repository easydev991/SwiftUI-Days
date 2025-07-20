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
                        .transition(
                            .move(edge: .trailing)
                                .combined(with: .scale)
                                .combined(with: .opacity)
                        )
                } else {
                    regularView
                        .transition(
                            .move(edge: .leading)
                                .combined(with: .scale)
                                .combined(with: .opacity)
                        )
                }
            }
            .animation(.default, value: isEditing)
            .navigationBarTitleDisplayMode(.inline)
        }
        .scrollBounceBehavior(.basedOnSize)
    }

    private var regularView: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleSection
            detailsSection
            colorTagSection
            datePicker
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

    @ViewBuilder
    private var titleSection: some View {
        ReadSectionView(
            headerText: "Title",
            bodyText: item.title
        )
    }

    @ViewBuilder
    private var detailsSection: some View {
        if !item.details.isEmpty {
            ReadSectionView(
                headerText: "Details",
                bodyText: item.details
            )
        }
    }

    @ViewBuilder
    private var colorTagSection: some View {
        if let colorTag = item.colorTag {
            ColorPicker(
                "Color tag",
                selection: .constant(colorTag)
            )
            .font(.title3.bold())
            .disabled(true)
            .padding(.bottom, 4)
        }
    }

    private var datePicker: some View {
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
    }
}

#if DEBUG
#Preview("Много текста, без цветового тега") {
    NavigationStack {
        ItemScreen(item: .singleLong)
    }
}

#Preview("Есть цветовой тег") {
    NavigationStack {
        ItemScreen(item: .singleWithColorTag)
    }
}
#endif
