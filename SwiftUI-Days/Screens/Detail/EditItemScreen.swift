import SwiftUI

struct EditItemScreen: View {
    @Environment(\.modelContext) private var modelContext
    @State private var title: String
    @State private var details: String
    @State private var timestamp: Date
    @State private var colorTag: Color?
    @State private var displayOption: DisplayOption
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
        _displayOption = .init(initialValue: oldItem?.displayOption ?? .day)
        self.oldItem = oldItem
        self.closeAction = closeAction
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleSection
            detailsSection
            colorPicker
            datePicker
            displayOptionPicker
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
                Button(.save) {
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
            headerText: String(localized: .title),
            placeholder: String(localized: .titleForTheItem),
            text: $title
        )
        .focused($isFirstFieldFocused)
        .onAppear { isFirstFieldFocused = true }
    }

    private var detailsSection: some View {
        EditSectionView(
            headerText: String(localized: .details),
            placeholder: String(localized: .detailsForTheItem),
            text: $details
        )
    }

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
                    SectionTitleView(String(localized: .addColorTag))
                }
            )
            if let colorTag {
                ColorPicker(
                    .colorTag,
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
        ItemDatePicker(date: $timestamp)
    }

    private var displayOptionPicker: some View {
        ItemDisplayOptionPicker(displayOption: $displayOption)
    }

    private var navigationTitle: String {
        oldItem == nil ? String(localized: .newItem) : String(localized: .editItem)
    }

    private var backButtonTitle: String {
        oldItem == nil ? String(localized: .close) : String(localized: .cancel)
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
                    || colorTag != oldItem.colorTag
                    || displayOption != (oldItem.displayOption ?? .day))
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
                colorTag: colorTag,
                displayOption: displayOption
            )
            modelContext.insert(newItem)
            return
        }
        oldItem.title = title
        oldItem.details = details
        oldItem.timestamp = timestamp
        oldItem.colorTag = colorTag
        oldItem.displayOption = displayOption
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        EditItemScreen(oldItem: .singleLong, closeAction: {})
    }
}
#endif
