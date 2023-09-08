//
//  MiddleCenterNinthCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

class MiddleCenterNinthCalculation: WindowCalculation, OrientationAware, NinthsRepeated {
        
    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        let visibleFrameOfScreen = params.visibleFrameOfScreen

        guard Defaults.subsequentExecutionMode.value != .none,
              let last = params.lastAction,
              let lastSubAction = last.subAction
        else {
            return orientationBasedRect(visibleFrameOfScreen)
        }
        
        if last.action != .middleCenterNinth {
            return orientationBasedRect(visibleFrameOfScreen)
        }
        
        if let calculation = self.nextCalculation(subAction: lastSubAction, direction: .right) {
            return calculation(visibleFrameOfScreen)
        }

        return orientationBasedRect(visibleFrameOfScreen)
    }
    
    func landscapeRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        var rect = visibleFrameOfScreen
        rect.size.width = floor(visibleFrameOfScreen.width / 3.0)
        rect.size.height = floor(visibleFrameOfScreen.height / 3.0)
        rect.origin.y = visibleFrameOfScreen.minY + rect.height
        rect.origin.x = visibleFrameOfScreen.minX + rect.width
        return RectResult(rect, subAction: .middleCenterNinth)
    }
    
    func portraitRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        var rect = visibleFrameOfScreen
        rect.size.width = floor(visibleFrameOfScreen.width / 3.0)
        rect.size.height = floor(visibleFrameOfScreen.height / 3.0)
        rect.origin.y = visibleFrameOfScreen.minY + rect.height
        rect.origin.x = visibleFrameOfScreen.minX + rect.width
        return RectResult(rect, subAction: .middleCenterNinth)
    }
}


