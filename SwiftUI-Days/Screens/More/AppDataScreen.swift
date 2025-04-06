//
//  AppDataScreen.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 06.04.2025.
//

import SwiftUI
import SwiftData

struct AppDataScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showDeleteDataConfirmation = false
    @State private var isCreatingBackup = false
    @State private var isRestoringFromBackup = false
    @State private var showResult = false
    @State private var operationResult: OperationResult?
    
    var body: some View {
        VStack(spacing: 16) {
            Group {
                backupDataButton
                restoreDataButton
                if !items.isEmpty {
                    removeAllDataButton
                }
            }
            .buttonStyle(.borderedProminent)
            .foregroundStyle(.buttonTint)
        }
        .animation(.default, value: items.isEmpty)
        .alert(
            operationResult?.title ?? "",
            isPresented: $showResult,
            presenting: operationResult,
            actions: { _ in
                Button("Ok") {}
            },
            message: { result in
                Text(result.message)
            }
        )
        .navigationTitle("App data")
    }
    
    private var backupDataButton: some View {
        Button("Create a backup") {
            isCreatingBackup.toggle()
        }
        .accessibilityIdentifier("backupDataButton")
        .fileExporter(
            isPresented: $isCreatingBackup,
            document: BackupFileDocument(items: items.map(BackupFileDocument.makeBackupItem)),
            contentType: .json,
            defaultFilename: "Days backup"
        ) { result in
            switch result {
            case .success:
                operationResult = .backupSuccess
            case let .failure(error):
                operationResult = .error(error.localizedDescription)
            }
            showResult = true
        }
    }
    
    private var restoreDataButton: some View {
        Button("Restore from backup") {
            isRestoringFromBackup.toggle()
        }
        .accessibilityIdentifier("restoreDataButton")
        .fileImporter(
            isPresented: $isRestoringFromBackup,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case let .success(urls):
                if let url = urls.first,
                   url.startAccessingSecurityScopedResource(),
                   let data = try? Data(contentsOf: url),
                   let importedItems = try? JSONDecoder().decode([BackupFileDocument.BackupItem].self, from: data) {
                    defer { url.stopAccessingSecurityScopedResource() }
                    let mappedRealItems = importedItems.map(\.realItem)
                    mappedRealItems.forEach { modelContext.insert($0) }
                    operationResult = .restoreSuccess
                } else {
                    operationResult = .failedToRestore
                }
            case let .failure(error):
                operationResult = .error(error.localizedDescription)
            }
            showResult = true
        }
    }
    
    private var removeAllDataButton: some View {
        Button("Delete all data", role: .destructive) {
            showDeleteDataConfirmation.toggle()
        }
        .accessibilityIdentifier("removeAllDataButton")
        .transition(.slide.combined(with: .scale).combined(with: .opacity))
        .confirmationDialog(
            "Do you want to delete all data permanently?",
            isPresented: $showDeleteDataConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                do {
                    try modelContext.delete(model: Item.self)
                } catch {
                    assertionFailure(error.localizedDescription)
                    operationResult = .error(error.localizedDescription)
                    showResult = true
                }
            }
            .accessibilityIdentifier("confirmRemoveAllDataButton")
        }
    }
}

extension AppDataScreen {
    private enum OperationResult: Equatable {
        case backupSuccess
        case restoreSuccess
        case failedToRestore
        case error(String)
        
        var title: LocalizedStringKey {
            switch self {
            case .backupSuccess, .restoreSuccess: "Done"
            case .failedToRestore, .error: "Error"
            }
        }
        
        var message: LocalizedStringKey {
            switch self {
            case .backupSuccess: "Backup data saved"
            case .restoreSuccess: "Data restored from backup"
            case .failedToRestore: "Unable to recover data from the selected file"
            case let .error(message): .init(message)
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        AppDataScreen()
            .environment(AppSettings())
            .modelContainer(PreviewModelContainer.make(with: Item.makeList()))
    }
}
#endif
