//
//  HorizontalThirdsRepeated.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

protocol HorizontalThirdsRepeated {
    func nextCalculation(subAction: SubWindowAction, direction: Direction) -> SimpleCalc?
}

extension HorizontalThirdsRepeated {
    func nextCalculation(subAction: SubWindowAction, direction: Direction) -> SimpleCalc? {
        
        if direction == .left {
            switch subAction {
            case .topLeftThird:
                return WindowCalculationFactory.bottomRightThirdCalculation.orientationBasedRect
            case .topRightThird:
                return WindowCalculationFactory.topLeftThirdCalculation.orientationBasedRect
            case .bottomLeftThird:
                return WindowCalculationFactory.topRightThirdCalculation.orientationBasedRect
            case .bottomRightThird:
                return WindowCalculationFactory.bottomLeftThirdCalculation.orientationBasedRect
            default: break
            }
        }
        
        else if direction == .right {
            switch subAction {
            case .topLeftThird:
                return WindowCalculationFactory.topRightThirdCalculation.orientationBasedRect
            case .topRightThird:
                return WindowCalculationFactory.bottomLeftThirdCalculation.orientationBasedRect
            case .bottomLeftThird:
                return WindowCalculationFactory.bottomRightThirdCalculation.orientationBasedRect
            case .bottomRightThird:
                return WindowCalculationFactory.topLeftThirdCalculation.orientationBasedRect
            default: break
            }
        }
        
        return nil
    }
}
