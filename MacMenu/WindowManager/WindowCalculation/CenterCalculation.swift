//
//  CenterCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

class CenterCalculation: WindowCalculation {
    
    override func calculate(_ params: WindowCalculationParameters) -> WindowCalculationResult? {

        var screenFrame: CGRect?
        if !Constants.alwaysAccountForStage.userEnabled {
            screenFrame = params.usableScreens.currentScreen.adjustedVisibleFrame(true)
        }
                
        let rectResult = calculateRect(params.asRectParams(visibleFrame: screenFrame))
        
        let resultingAction: WindowAction = rectResult.resultingAction ?? params.action

        return WindowCalculationResult(rect: rectResult.rect,
                                       screen: params.usableScreens.currentScreen,
                                       resultingAction: resultingAction,
                                       resultingScreenFrame: screenFrame)
    }
    
    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {

        let visibleFrameOfScreen = params.visibleFrameOfScreen
        var calculatedWindowRect = params.window.rect

        let heightExceeded = params.window.rect.height > visibleFrameOfScreen.height
        let widthExceeded = params.window.rect.width > visibleFrameOfScreen.width
        
        if heightExceeded && widthExceeded {
            return RectResult(visibleFrameOfScreen, resultingAction: .maximize)
        }
        
        if heightExceeded {
            calculatedWindowRect.size.height = visibleFrameOfScreen.height
            calculatedWindowRect.origin.y = visibleFrameOfScreen.minY
        } else {
            calculatedWindowRect.origin.y = round((visibleFrameOfScreen.height - params.window.rect.height) / 2.0) + visibleFrameOfScreen.minY
        }
        
        if widthExceeded {
            calculatedWindowRect.size.width = visibleFrameOfScreen.width
            calculatedWindowRect.origin.x = visibleFrameOfScreen.minX
        } else {
            calculatedWindowRect.origin.x = round((visibleFrameOfScreen.width - params.window.rect.width) / 2.0) + visibleFrameOfScreen.minX
        }

        return RectResult(calculatedWindowRect)

    }
    
}
