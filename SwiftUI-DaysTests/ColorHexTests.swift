import Foundation
import SwiftUI
@testable import SwiftUI_Days
import Testing

@Suite("Color hex parsing tests")
struct ColorHexTests {
    /// Валидный hex-цвет #FF5722 возвращает корректный Color
    @Test func validHexColor() {
        let color = Color(hex: "#FF5722")
        #expect(color != nil)
    }

    /// Чёрный цвет #000000
    @Test func blackHexColor() {
        let color = Color(hex: "#000000")
        #expect(color != nil)
    }

    /// Белый цвет #FFFFFF
    @Test func whiteHexColor() {
        let color = Color(hex: "#FFFFFF")
        #expect(color != nil)
    }

    /// Невалидная строка возвращает nil
    @Test func invalidStringReturnsNil() {
        let color = Color(hex: "invalid")
        #expect(color == nil)
    }

    /// Невалидные hex-символы #GGGGGG возвращают nil
    @Test func invalidHexCharactersReturnsNil() {
        let color = Color(hex: "#GGGGGG")
        #expect(color == nil)
    }

    /// Короткий формат #123 не поддерживается
    @Test func shortFormatReturnsNil() {
        let color = Color(hex: "#123")
        #expect(color == nil)
    }

    /// Формат с alpha #12345678 не поддерживается
    @Test func alphaFormatReturnsNil() {
        let color = Color(hex: "#12345678")
        #expect(color == nil)
    }

    /// Строка без решётки возвращает nil
    @Test func noHashPrefixReturnsNil() {
        let color = Color(hex: "FF5722")
        #expect(color == nil)
    }

    /// Пустая строка возвращает nil
    @Test func emptyStringReturnsNil() {
        let color = Color(hex: "")
        #expect(color == nil)
    }

    /// Только решётка возвращает nil
    @Test func onlyHashReturnsNil() {
        let color = Color(hex: "#")
        #expect(color == nil)
    }

    /// Lowercase hex работает
    @Test func lowercaseHexWorks() {
        let color = Color(hex: "#ff5722")
        #expect(color != nil)
    }

    /// Mixed case hex работает
    @Test func mixedCaseHexWorks() {
        let color = Color(hex: "#Ff5722")
        #expect(color != nil)
    }

    /// Hex с пробелами в начале/конце работает
    @Test func hexWithLeadingTrailingSpaces() {
        let color = Color(hex: "  #FF5722  ")
        #expect(color != nil)
    }

    /// Hex с newline работает
    @Test func hexWithNewline() {
        let color = Color(hex: "\n#FF5722\n")
        #expect(color != nil)
    }

    /// Hex с tab работает
    @Test func hexWithTab() {
        let color = Color(hex: "\t#FF5722\t")
        #expect(color != nil)
    }
}
