//
//  LeftTodoCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

final class LeftTodoCalculation: WindowCalculation {
    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        let visibleFrameOfScreen = params.visibleFrameOfScreen
        var calculatedWindowRect = visibleFrameOfScreen

        calculatedWindowRect.size.width = Defaults.todoSidebarWidth.cgFloat

        return RectResult(calculatedWindowRect, subAction: .leftTodo)
    }
}
