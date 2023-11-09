//
//  MoveUpDownCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

class MoveUpDownCalculation: WindowCalculation, RepeatedExecutionsCalculation {
    
    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        
        let visibleFrameOfScreen = params.visibleFrameOfScreen
        
        var calculatedWindowRect: CGRect

        calculatedWindowRect = calculateGenericRect(params).rect
        
        if Constants.centeredDirectionalMove.enabled != false {
            calculatedWindowRect.origin.x = round((visibleFrameOfScreen.width - calculatedWindowRect.width) / 2.0) + visibleFrameOfScreen.minX
        }
        
        if params.window.rect.width >= visibleFrameOfScreen.width {
            calculatedWindowRect.size.width = visibleFrameOfScreen.width
            calculatedWindowRect.origin.x = visibleFrameOfScreen.minX
        }
        
        return RectResult(calculatedWindowRect)

    }
    
    func calculateFractionalRect(_ params: RectCalculationParameters, fraction: Float) -> RectResult {
        return calculateGenericRect(params, fraction: fraction)
    }
    
    func calculateGenericRect(_ params: RectCalculationParameters, fraction: Float? = nil) -> RectResult {
        let visibleFrameOfScreen = params.visibleFrameOfScreen
        
        var rect = params.window.rect
        if let requestedFraction = fraction {
            rect.size.height = floor(visibleFrameOfScreen.height * CGFloat(requestedFraction))
        }
        
        if params.action == .moveUp {
            rect.origin.y = visibleFrameOfScreen.maxY - rect.height
        } else {
            rect.origin.y = visibleFrameOfScreen.minY
        }
        
        return RectResult(rect)
    }
    
}
