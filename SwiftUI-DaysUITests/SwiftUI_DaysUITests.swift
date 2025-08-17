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

    func testDemoFlow() throws {
        snapshot("1-demoList")
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
        app.buttons["saveItemNavButton"].tap()
        app.buttons["sortNavButton"].tap()
        snapshot("3-sortByDate")
    }
}
