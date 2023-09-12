//
//  RepeatedExecutionsInThirdsCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

protocol RepeatedExecutionsInThirdsCalculation: RepeatedExecutionsCalculation {
    
    func calculateFractionalRect(_ params: RectCalculationParameters, fraction: Float) -> RectResult

}

extension RepeatedExecutionsInThirdsCalculation {
    
    func calculateFirstRect(_ params: RectCalculationParameters) -> RectResult {
        return calculateFractionalRect(params, fraction: 1 / 2.0)
    }
    
    func calculateSecondRect(_ params: RectCalculationParameters) -> RectResult {
        let fraction: Float = Constants.altThirdCycle.userEnabled ? (1 / 3.0) : (2 / 3.0)
        return calculateFractionalRect(params, fraction: fraction)
    }
    
    func calculateThirdRect(_ params: RectCalculationParameters) -> RectResult {
        let fraction: Float = Constants.altThirdCycle.userEnabled ? (2 / 3.0) : (1 / 3.0)
        return calculateFractionalRect(params, fraction: fraction)
    }
    
}
