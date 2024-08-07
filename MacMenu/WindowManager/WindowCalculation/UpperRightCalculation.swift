//
//  UpperRightCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

class UpperRightCalculation: WindowCalculation, RepeatedExecutionsCalculation {

    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        return calculateFullRect(params)
    }
    
    func calculateFractionalRect(_ params: RectCalculationParameters, fraction: Float) -> RectResult {
        let visibleFrameOfScreen = params.visibleFrameOfScreen

        var rect = visibleFrameOfScreen
        
        rect.size.width = floor(visibleFrameOfScreen.width * CGFloat(fraction))
        rect.origin.x = visibleFrameOfScreen.maxX - rect.width
        rect.size.height = floor(visibleFrameOfScreen.height / 2.0)
        rect.origin.y = visibleFrameOfScreen.maxY - rect.height
        return RectResult(rect)
    }
}
