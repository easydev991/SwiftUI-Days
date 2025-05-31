//
//  AppTheme.swift
//  SwiftUI-Days
//
//  Created by Oleg991 on 26.03.2025.
//

import SwiftUI

enum AppTheme: Int, CaseIterable, Identifiable {
    var id: Int { rawValue }
    case system = 0
    case light = 1
    case dark = 2

    var title: LocalizedStringResource {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light: .light
        case .dark: .dark
        case .system: nil
        }
    }
}
