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
    private let oldItem: Item?
    private let closeAction: () -> Void
    
    init(
        oldItem: Item? = nil,
        closeAction: @escaping () -> Void
    ) {
        self._title = .init(initialValue: oldItem?.title ?? "")
        self._details = .init(initialValue: oldItem?.details ?? "")
        self._timestamp = .init(initialValue: oldItem?.timestamp ?? .now)
        self.oldItem = oldItem
        self.closeAction = closeAction
    }
    
    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .textFieldStyle(.roundedBorder)
            TextField("Details", text: $details)
                .textFieldStyle(.roundedBorder)
            DatePicker("Date", selection: $timestamp, displayedComponents: .date)
            Spacer()
        }
        .padding()
        .navigationTitle(navigationTitle)
        .navigationBarBackButtonHidden(oldItem != nil)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(backButtonTitle, action: closeAction)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    save()
                    closeAction()
                }
                .disabled(!canSave)
            }
        }
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
    
    private var navigationTitle: String {
        oldItem == nil ? "New Item" : "Edit Item"
    }
    
    private var backButtonTitle: String {
        oldItem == nil ? "Close" : "Cancel"
    }
    
    private var canSave: Bool {
        let isTitleEmpty = title.isEmpty
        return if let oldItem {
            !isTitleEmpty
            && title != oldItem.title
            || details != oldItem.details
            || timestamp != oldItem.timestamp
        } else {
            !isTitleEmpty
        }
    }
    
    private func save() {
        if let oldItem {
            oldItem.title = title
            oldItem.details = details
            oldItem.timestamp = timestamp
        } else {
            let item = Item(title: title, details: details, timestamp: timestamp)
            modelContext.insert(item)
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        EditItemScreen(oldItem: .single(), closeAction: {})
    }
}
#endif
