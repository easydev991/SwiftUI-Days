import SwiftData
import SwiftUI

struct AppDataScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showDeleteDataConfirmation = false
    @State private var isCreatingBackup = false
    @State private var isRestoringFromBackup = false
    @State private var operationResult: OperationResult?

    var body: some View {
        VStack(spacing: 16) {
            Group {
                if !items.isEmpty {
                    backupDataButton
                }
                restoreDataButton
                if !items.isEmpty {
                    removeAllDataButton
                }
            }
            .daysButtonStyle()
        }
        .animation(.default, value: items.isEmpty)
        .alert(
            operationResult?.title ?? "",
            isPresented: $operationResult.mappedToBool(),
            presenting: operationResult,
            actions: { _ in
                Button(.ok) {}
            },
            message: { result in
                Text(result.message)
            }
        )
        .navigationTitle(.appData)
    }

    private var backupDataButton: some View {
        Button(.createABackup) {
            isCreatingBackup.toggle()
        }
        .accessibilityIdentifier("backupDataButton")
        .fileExporter(
            isPresented: $isCreatingBackup,
            document: BackupFileDocument(items: items.map(BackupFileDocument.toBackupItem)),
            contentType: .json,
            defaultFilename: "Days backup"
        ) { result in
            switch result {
            case .success:
                operationResult = .backupSuccess
            case let .failure(error):
                operationResult = .error(error.localizedDescription)
            }
        }
    }

    private var restoreDataButton: some View {
        Button(.restoreFromBackup) {
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
                guard let url = urls.first, url.startAccessingSecurityScopedResource() else {
                    operationResult = .failedToRestore
                    return
                }
                do {
                    defer { url.stopAccessingSecurityScopedResource() }
                    let data = try Data(contentsOf: url)
                    let importer = try BackupImporter(data: data)
                    let importedItems = importer.items
                    let currentItems = items.map(\.backupItem)
                    let newItemsFromBackup = importedItems.filter { !currentItems.contains($0) }
                    newItemsFromBackup.forEach { modelContext.insert($0.realItem) }
                    try modelContext.save()
                    operationResult = .restoreSuccess
                } catch {
                    operationResult = .failedToRestore
                }
            case let .failure(error):
                operationResult = .error(error.localizedDescription)
            }
        }
    }

    private var removeAllDataButton: some View {
        Button(.deleteAllData, role: .destructive) {
            showDeleteDataConfirmation.toggle()
        }
        .accessibilityIdentifier("removeAllDataButton")
        .transition(.slide.combined(with: .scale).combined(with: .opacity))
        .confirmationDialog(
            .doYouWantToDeleteAllDataPermanently,
            isPresented: $showDeleteDataConfirmation,
            titleVisibility: .visible
        ) {
            Button(.delete, role: .destructive) {
                do {
                    try modelContext.delete(model: Item.self)
                    try modelContext.save()
                    operationResult = .deletionSuccess
                } catch {
                    assertionFailure(error.localizedDescription)
                    operationResult = .error(error.localizedDescription)
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
        case deletionSuccess
        case failedToRestore
        case error(String)

        var title: String {
            switch self {
            case .backupSuccess, .restoreSuccess, .deletionSuccess: String(localized: .done)
            case .failedToRestore, .error: String(localized: .error)
            }
        }

        var message: String {
            switch self {
            case .backupSuccess: String(localized: .backupDataSaved)
            case .restoreSuccess: String(localized: .dataRestoredFromBackup)
            case .deletionSuccess: String(localized: .allDataDeleted)
            case .failedToRestore: String(localized: .unableToRecoverDataFromTheSelectedFile)
            case let .error(message): .init(message)
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        AppDataScreen()
    }
    .environment(AppSettings())
    .modelContainer(PreviewModelContainer.make(with: Item.makeList()))
}
#endif
