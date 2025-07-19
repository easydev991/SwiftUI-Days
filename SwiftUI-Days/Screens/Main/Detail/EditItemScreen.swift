//
//  EditItemScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 23.03.2024.
//

import SwiftUI

struct EditItemScreen: View {
    @Environment(\.modelContext) private var modelContext
    @State private var title: String
    @State private var details: String
    @State private var timestamp: Date
    @State private var colorTag: Color?
    @FocusState private var isFirstFieldFocused
    private let oldItem: Item?
    private let closeAction: () -> Void

    init(
        oldItem: Item? = nil,
        closeAction: @escaping () -> Void
    ) {
        _title = .init(initialValue: oldItem?.title ?? "")
        _details = .init(initialValue: oldItem?.details ?? "")
        _timestamp = .init(initialValue: oldItem?.timestamp ?? .now)
        _colorTag = .init(initialValue: oldItem?.colorTag)
        self.oldItem = oldItem
        self.closeAction = closeAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleSection
            detailsSection
            colorPicker
            datePicker
            Spacer()
        }
        .padding()
        .navigationTitle(navigationTitle)
        .navigationBarBackButtonHidden(oldItem != nil)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(backButtonTitle) {
                    isFirstFieldFocused = false
                    closeAction()
                }
                .accessibilityIdentifier(backButtonAccessibilityIdentifier)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    save()
                    closeAction()
                }
                .disabled(!canSave)
                .accessibilityIdentifier("saveItemNavButton")
            }
        }
    }

    private var titleSection: some View {
        EditSectionView(
            headerText: "Title",
            placeholder: "Title for the Item",
            text: $title
        )
        .focused($isFirstFieldFocused)
        .onAppear { isFirstFieldFocused = true }
    }

    private var detailsSection: some View {
        EditSectionView(
            headerText: "Details",
            placeholder: "Details for the Item",
            text: $details
        )
    }

    @ViewBuilder
    private var colorPicker: some View {
        VStack(spacing: 20) {
            Toggle(
                isOn: .init(
                    get: { colorTag != nil },
                    set: { isOn in
                        withAnimation {
                            colorTag = isOn ? .yellow : nil
                        }
                    }
                ),
                label: {
                    Text("Add color tag")
                        .font(.title3.bold())
                }
            )
            if let colorTag {
                ColorPicker(
                    "Color tag",
                    selection: .init(
                        get: { colorTag },
                        set: { self.colorTag = $0 }
                    )
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.bottom, 4)
            }
        }
    }

    private var datePicker: some View {
        DatePicker(
            "Date",
            selection: $timestamp,
            displayedComponents: .date
        )
        .font(.title3.bold())
    }

    private var navigationTitle: LocalizedStringKey {
        oldItem == nil ? "New Item" : "Edit Item"
    }

    private var backButtonTitle: LocalizedStringKey {
        oldItem == nil ? "Close" : "Cancel"
    }

    private var backButtonAccessibilityIdentifier: String {
        oldItem == nil ? "closeButton" : "cancelButton"
    }

    private var canSave: Bool {
        let isTitleEmpty = title.isEmpty
        return if let oldItem {
            !isTitleEmpty
                && (title != oldItem.title
                    || details != oldItem.details
                    || timestamp != oldItem.timestamp
                    || colorTag != oldItem.colorTag)
        } else {
            !isTitleEmpty
        }
    }

    private func save() {
        guard let oldItem else {
            let newItem = Item(
                title: title,
                details: details,
                timestamp: timestamp,
                colorTag: colorTag
            )
            modelContext.insert(newItem)
            return
        }
        oldItem.title = title
        oldItem.details = details
        oldItem.timestamp = timestamp
        oldItem.colorTag = colorTag
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        EditItemScreen(oldItem: .singleLong, closeAction: {})
    }
}
#endif
