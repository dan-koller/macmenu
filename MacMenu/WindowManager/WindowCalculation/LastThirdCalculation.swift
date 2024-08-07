//
//  RightThirdCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

class LastThirdCalculation: WindowCalculation, OrientationAware {
    
    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        let visibleFrameOfScreen = params.visibleFrameOfScreen

        guard Constants.subsequentExecutionMode.value != .none,
            let last = params.lastAction, let lastSubAction = last.subAction else {
            return orientationBasedRect(visibleFrameOfScreen)
        }
        
        var calculation: WindowCalculation?
        
        if last.action == .lastThird {
            switch lastSubAction {
            case .bottomThird, .rightThird:
                calculation = WindowCalculationFactory.centerThirdCalculation
            case .centerHorizontalThird, .centerVerticalThird:
                calculation = WindowCalculationFactory.firstThirdCalculation
            default:
                break
            }
        } else if last.action == .firstThird {
            switch lastSubAction {
            case .bottomThird, .rightThird:
                calculation = WindowCalculationFactory.centerThirdCalculation
            default:
                break
            }
        }
        
        if let calculation = calculation {
            return calculation.calculateRect(params)
        }
        
        return orientationBasedRect(visibleFrameOfScreen)
    }
    
    func landscapeRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        var rect = visibleFrameOfScreen
        rect.size.width = floor(visibleFrameOfScreen.width / 3.0)
        rect.origin.x = visibleFrameOfScreen.origin.x + visibleFrameOfScreen.width - rect.width
        return RectResult(rect, subAction: .rightThird)
    }
    
    func portraitRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        var rect = visibleFrameOfScreen
        rect.size.height = floor(visibleFrameOfScreen.height / 3.0)
        return RectResult(rect, subAction: .bottomThird)
    }

}
