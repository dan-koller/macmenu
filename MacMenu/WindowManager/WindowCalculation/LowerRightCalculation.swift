//
//  LowerRightCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

class LowerRightCalculation: WindowCalculation, RepeatedExecutionsInThirdsCalculation {

    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {

        if params.lastAction == nil || !Constants.subsequentExecutionMode.resizes {
            return calculateFirstRect(params)
        }
        
        return calculateRepeatedRect(params)
    }
    
    func calculateFractionalRect(_ params: RectCalculationParameters, fraction: Float) -> RectResult {
        let visibleFrameOfScreen = params.visibleFrameOfScreen

        var rect = visibleFrameOfScreen
        
        rect.size.width = floor(visibleFrameOfScreen.width * CGFloat(fraction))
        rect.origin.x = visibleFrameOfScreen.maxX - rect.width
        rect.size.height = floor(visibleFrameOfScreen.height / 2.0)
        
        return RectResult(rect)
    }
}