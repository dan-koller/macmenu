//
//  LeftTwoThirdsCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

class FirstTwoThirdsCalculation: WindowCalculation, OrientationAware {
    
    
    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        let visibleFrameOfScreen = params.visibleFrameOfScreen

        guard Constants.subsequentExecutionMode.value != .none,
            let last = params.lastAction, let lastSubAction = last.subAction else {
            return orientationBasedRect(visibleFrameOfScreen)
        }

        if lastSubAction == .leftTwoThirds || lastSubAction == .topTwoThirds {
            return WindowCalculationFactory.lastTwoThirdsCalculation.orientationBasedRect(visibleFrameOfScreen)
        }
        
        return orientationBasedRect(visibleFrameOfScreen)
    }
    
    func landscapeRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        var rect = visibleFrameOfScreen
        rect.size.width = floor(visibleFrameOfScreen.width * 2 / 3.0)
        return RectResult(rect, subAction: .leftTwoThirds)
    }
    
    func portraitRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        var rect = visibleFrameOfScreen
        rect.size.height = floor(visibleFrameOfScreen.height * 2 / 3.0)
        rect.origin.y = visibleFrameOfScreen.origin.y + visibleFrameOfScreen.height - rect.height
        return RectResult(rect, subAction: .topTwoThirds)
    }
    
}

