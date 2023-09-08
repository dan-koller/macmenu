//
//  RightTodoCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

final class RightTodoCalculation: WindowCalculation {
    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        let visibleFrameOfScreen = params.visibleFrameOfScreen
        var calculatedWindowRect = visibleFrameOfScreen

        calculatedWindowRect.origin.x = visibleFrameOfScreen.maxX - Defaults.todoSidebarWidth.cgFloat
        calculatedWindowRect.size.width = Defaults.todoSidebarWidth.cgFloat

        return RectResult(calculatedWindowRect, subAction: .rightTodo)
    }
}
