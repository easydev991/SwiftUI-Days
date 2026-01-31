import XCTest

@MainActor
final class SwiftUI_DaysUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("UITest")
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() async throws {
        try super.tearDownWithError()
        app.launchArguments.removeAll()
        app = nil
    }

    func testDemoFlow() {
        snapshot("1-demoList")
        сhooseDate()
        сhooseDisplayOption()
        app.buttons["saveItemNavButton"].tap()
        sortByDate()
    }

    private func сhooseDate() {
        app.buttons["addItemButton"].tap()
        let firstSection = app.otherElements["editSectionView"].firstMatch
        let titleTextField = firstSection.children(matching: .textField)["sectionTextField"].firstMatch
        titleTextField.tap()
        titleTextField.typeText(Snapshot.currentLocale == "en-US" ? "Travelled to the seaside" : "Слетали на море")
        app.datePickers.firstMatch.tap()
        app.buttons["DatePicker.Show"].tap()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: .now)
        components.month! -= 1
        components.year! -= 1
        let monthFormatter = DateFormatter()
        monthFormatter.locale = .init(identifier: Snapshot.currentLocale)
        monthFormatter.dateFormat = "LLLL" // Формат для месяца в именительном падеже
        let monthString = monthFormatter.string(from: calendar.date(from: components)!)
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: monthString.capitalized)
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: components.year!.description)
        snapshot("2-chooseDate")
        app.buttons["PopoverDismissRegion"].tap()
    }

    private func сhooseDisplayOption() {
        app.buttons["itemDisplayOptionPicker"].tap()
        snapshot("3-chooseDisplayOption")
        app.collectionViews.buttons.element(boundBy: 2).tap()
        snapshot("4-beforeSave")
    }

    private func sortByDate() {
        let sortButton = app.buttons["sortNavButton"]
        sortButton.tap()
        app.collectionViews.buttons.element(boundBy: 1).tap()
        sortButton.tap()
        snapshot("5-sortByDate")
    }
}
