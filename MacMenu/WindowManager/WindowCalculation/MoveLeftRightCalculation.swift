//
//  MoveLeftRightCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Cocoa

// Applicable options:
// Defaults.subsequentExecutionMode.traversesDisplays
// Defaults.centeredDirectionalMove.enabled
// Defaults.resizeOnDirectionalMove.enabled (resizes in thirds, or just to half-width if traversesDisplays is enabled

class MoveLeftRightCalculation: WindowCalculation, RepeatedExecutionsCalculation {
    
    override func calculate(_ params: WindowCalculationParameters) -> WindowCalculationResult? {
        
        var screen = params.usableScreens.currentScreen
        var action = params.action
        
        let canTraverseDisplays = Constants.subsequentExecutionMode.traversesDisplays && params.usableScreens.numScreens > 1
        
        let rectResult: RectResult
        if canTraverseDisplays {
            if action == .moveLeft {
                if let prevScreen = params.usableScreens.adjacentScreens?.prev {
                    screen = prevScreen
                }
                action = .moveRight
            } else {
                if let nextScreen = params.usableScreens.adjacentScreens?.next {
                    screen = nextScreen
                }
                action = .moveLeft
            }
            
            rectResult = calculateRect(params.asRectParams(visibleFrame: screen.adjustedVisibleFrame(true), differentAction: action))
        } else {
            rectResult = calculateRect(params.asRectParams())
        }
        
        return WindowCalculationResult(rect: rectResult.rect, screen: screen, resultingAction: action)

    }
    
    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        calculateRect(params, newDisplay: false)
    }
    
    func calculateRect(_ params: RectCalculationParameters, newDisplay: Bool) -> RectResult {
        
        let visibleFrameOfScreen = params.visibleFrameOfScreen
        
        var calculatedWindowRect: CGRect
//        if newDisplay && Constants.resizeOnDirectionalMove.enabled {
//            calculatedWindowRect = calculateFirstRect(params).rect
//        } else if Constants.resizeOnDirectionalMove.enabled {
//            calculatedWindowRect = calculateFirstRect(params).rect
//        } else {
//            calculatedWindowRect = calculateGenericRect(params).rect
//        }
        
        calculatedWindowRect = calculateGenericRect(params).rect
        
        if Constants.centeredDirectionalMove.enabled != false {
            calculatedWindowRect.origin.y = round((visibleFrameOfScreen.height - calculatedWindowRect.height) / 2.0) + visibleFrameOfScreen.minY
        }
        
        if params.window.rect.height >= visibleFrameOfScreen.height {
            calculatedWindowRect.size.height = visibleFrameOfScreen.height
            calculatedWindowRect.origin.y = visibleFrameOfScreen.minY
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
            rect.size.width = floor(visibleFrameOfScreen.width * CGFloat(requestedFraction))
        }
        
        if params.action == .moveRight {
            rect.origin.x = visibleFrameOfScreen.maxX - rect.width
        } else {
            rect.origin.x = visibleFrameOfScreen.minX
        }
        
        return RectResult(rect)
    }
    
}

