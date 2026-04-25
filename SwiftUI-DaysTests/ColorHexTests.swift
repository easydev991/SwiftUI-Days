import Foundation
import SwiftUI
@testable import SwiftUI_Days
import Testing

@Suite("Color hex parsing tests")
struct ColorHexTests {
    @Test("Корректно парсит валидный hex #FF5722")
    func validHexColor() throws {
        _ = try #require(Color(hex: "#FF5722"))
    }

    @Test("Корректно парсит черный цвет")
    func blackHexColor() throws {
        _ = try #require(Color(hex: "#000000"))
    }

    @Test("Корректно парсит белый цвет")
    func whiteHexColor() throws {
        _ = try #require(Color(hex: "#FFFFFF"))
    }

    @Test("Возвращает nil для невалидной строки")
    func invalidStringReturnsNil() {
        let color = Color(hex: "invalid")
        #expect(color == nil)
    }

    @Test("Возвращает nil для невалидных hex символов")
    func invalidHexCharactersReturnsNil() {
        let color = Color(hex: "#GGGGGG")
        #expect(color == nil)
    }

    @Test("Возвращает nil для короткого формата")
    func shortFormatReturnsNil() {
        let color = Color(hex: "#123")
        #expect(color == nil)
    }

    @Test("Возвращает nil для alpha формата в hex инициализаторе")
    func alphaFormatReturnsNil() {
        let color = Color(hex: "#12345678")
        #expect(color == nil)
    }

    @Test("Корректно парсит валидный hex RGBA")
    func validHexRGBAColor() throws {
        _ = try #require(Color(hexRGBA: "#FF572280"))
    }

    @Test("Возвращает nil для невалидного hex RGBA")
    func invalidHexRGBAColorReturnsNil() {
        let color = Color(hexRGBA: "#GG572280")
        #expect(color == nil)
    }

    @Test("Конвертирует Color в формат #RRGGBBAA")
    func colorToHexRGBA() {
        let color = Color(red: 1, green: 0.5, blue: 0, opacity: 0.5)
        let hex = color.hexRGBA
        #expect(hex == "#FF800080")
    }

    @Test("Возвращает nil для .clear при конвертации в hex RGBA")
    func clearColorToHexRGBAReturnsNil() {
        #expect(Color.clear.hexRGBA == nil)
    }

    @Test("Возвращает nil если отсутствует символ #")
    func noHashPrefixReturnsNil() {
        let color = Color(hex: "FF5722")
        #expect(color == nil)
    }

    @Test("Возвращает nil для пустой строки")
    func emptyStringReturnsNil() {
        let color = Color(hex: "")
        #expect(color == nil)
    }

    @Test("Возвращает nil для строки только с символом #")
    func onlyHashReturnsNil() {
        let color = Color(hex: "#")
        #expect(color == nil)
    }

    @Test("Корректно парсит lowercase hex")
    func lowercaseHexWorks() throws {
        _ = try #require(Color(hex: "#ff5722"))
    }

    @Test("Корректно парсит mixed case hex")
    func mixedCaseHexWorks() throws {
        _ = try #require(Color(hex: "#Ff5722"))
    }

    @Test("Корректно парсит hex с пробелами")
    func hexWithLeadingTrailingSpaces() throws {
        _ = try #require(Color(hex: "  #FF5722  "))
    }

    @Test("Корректно парсит hex с переносами строк")
    func hexWithNewline() throws {
        _ = try #require(Color(hex: "\n#FF5722\n"))
    }

    @Test("Корректно парсит hex с табуляцией")
    func hexWithTab() throws {
        _ = try #require(Color(hex: "\t#FF5722\t"))
    }
}
