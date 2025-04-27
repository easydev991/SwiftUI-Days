//
//  CurrentDateEnvironmentKey.swift
//  SwiftUI-Days
//
//  Created by Олег Еременко on 27.04.2025.
//

import SwiftUI

private struct CurrentDateKey: EnvironmentKey {
    static let defaultValue = Date.now
}

extension EnvironmentValues {
    /// Текущая дата, нужна для вычисления количества дней
    /// при переходе приложения в активное состояние
    ///
    /// Например, если свернуть приложение и открыть через пару дней,
    /// то количество дней в списке не обновится по умолчанию, а если
    /// считать дни по отношению к этой дате, то все будет обновляться
    var currentDate: Date {
        get { self[CurrentDateKey.self] }
        set { self[CurrentDateKey.self] = newValue }
    }
}
