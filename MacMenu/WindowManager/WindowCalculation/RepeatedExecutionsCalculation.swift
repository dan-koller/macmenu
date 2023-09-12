//
//  RepeatedExecutionsCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

protocol RepeatedExecutionsCalculation {
    
    func calculateFirstRect(_ params: RectCalculationParameters) -> RectResult
    
    func calculateSecondRect(_ params: RectCalculationParameters) -> RectResult

    func calculateThirdRect(_ params: RectCalculationParameters) -> RectResult

}

extension RepeatedExecutionsCalculation {
    
    func calculateRepeatedRect(_ params: RectCalculationParameters) -> RectResult {
        
        guard let count = params.lastAction?.count,
              params.lastAction?.action == params.action
        else {
            return calculateFirstRect(params)
        }
                
        let position = count % 3
        
        switch (position) {
        case 1:
            return calculateSecondRect(params)
        case 2:
            return calculateThirdRect(params)
        default:
            return calculateFirstRect(params)
        }
        
    }
    
}
