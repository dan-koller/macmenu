//
//  LeftHalfCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Cocoa

class LeftRightHalfCalculation: WindowCalculation, RepeatedExecutionsCalculation {
    
    override func calculate(_ params: WindowCalculationParameters) -> WindowCalculationResult? {
        
        let usableScreens = params.usableScreens
        
        switch Constants.subsequentExecutionMode.value {
            
        case .acrossMonitor, .acrossAndResize:
            if params.action == .leftHalf {
                return calculateLeftAcrossDisplays(params, screen: usableScreens.currentScreen)
            } else if params.action == .rightHalf {
                return calculateRightAcrossDisplays(params, screen: usableScreens.currentScreen)
            }
            return nil
        case .resize:
            let screen = usableScreens.currentScreen
            let rectResult: RectResult = calculateFullRect(params.asRectParams())
            return WindowCalculationResult(rect: rectResult.rect, screen: screen, resultingAction: params.action)
        case .none, .cycleMonitor:
            let screen = usableScreens.currentScreen
            let oneHalfRect = calculateFullRect(params.asRectParams())
            return WindowCalculationResult(rect: oneHalfRect.rect, screen: screen, resultingAction: params.action)
        }
        
    }
    
    func calculateFractionalRect(_ params: RectCalculationParameters, fraction: Float) -> RectResult {
        let visibleFrameOfScreen = params.visibleFrameOfScreen

        var rect = visibleFrameOfScreen
        
        rect.size.width = floor(visibleFrameOfScreen.width * CGFloat(fraction))
        if params.action == .rightHalf {
            rect.origin.x = visibleFrameOfScreen.maxX - rect.width
        }
        
        return RectResult(rect)
    }

    func calculateLeftAcrossDisplays(_ params: WindowCalculationParameters, screen: NSScreen) -> WindowCalculationResult? {
        let oneHalfRect = calculateFullRect(params.asRectParams(visibleFrame: screen.adjustedVisibleFrame(true), differentAction: .leftHalf))
        return WindowCalculationResult(rect: oneHalfRect.rect, screen: screen, resultingAction: .leftHalf)
    }
    
    
    func calculateRightAcrossDisplays(_ params: WindowCalculationParameters, screen: NSScreen) -> WindowCalculationResult? {
        let oneHalfRect = calculateFullRect(params.asRectParams(visibleFrame: screen.adjustedVisibleFrame(true), differentAction: .rightHalf))
        return WindowCalculationResult(rect: oneHalfRect.rect, screen: screen, resultingAction: .rightHalf)
    }

    // Used to draw box for snapping
    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        if params.action == .leftHalf {
            var oneHalfRect = params.visibleFrameOfScreen
            oneHalfRect.size.width = floor(oneHalfRect.width / 2.0)
            return RectResult(oneHalfRect)
        } else {
            var oneHalfRect = params.visibleFrameOfScreen
            oneHalfRect.size.width = floor(oneHalfRect.width / 2.0)
            oneHalfRect.origin.x += oneHalfRect.size.width
            return RectResult(oneHalfRect)
        }
    }
}
