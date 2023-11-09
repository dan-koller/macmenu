//
//  RepeatedExecutionsCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

protocol RepeatedExecutionsCalculation {
    
    // Default rect, calculated in extension
    func calculateFullRect(_ params: RectCalculationParameters) -> RectResult
    
    // Fractional rect, calculated in classes that implement this protocol
    func calculateFractionalRect(_ params: RectCalculationParameters, fraction: Float) -> RectResult

}

extension RepeatedExecutionsCalculation {
    
    func calculateFullRect(_ params: RectCalculationParameters) -> RectResult {
        return calculateFractionalRect(params, fraction: 1 / 2.0)
    }
    
}
