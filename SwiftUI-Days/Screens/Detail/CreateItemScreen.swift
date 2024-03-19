//
//  CreateItemScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 19.03.2024.
//

import SwiftUI

struct CreateItemScreen: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var title = ""
    @State private var details = ""
    @State private var timestamp = Date.now
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Details", text: $details)
                DatePicker("Date", selection: $timestamp, displayedComponents: .date)
            }
            .navigationTitle("New Item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { 
                        save()
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
    
    private var canSave: Bool {
        !title.isEmpty
    }
    
    private func save() {
        let item = Item(title: title, details: details, timestamp: timestamp)
        modelContext.insert(item)
    }
}

#Preview {
    CreateItemScreen()
}
