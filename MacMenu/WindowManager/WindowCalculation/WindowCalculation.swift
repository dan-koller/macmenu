//
//  WindowCalculation.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Cocoa

protocol Calculation {
    
    func calculate(_ params: WindowCalculationParameters) -> WindowCalculationResult?
    
    func calculateRect(_ params: RectCalculationParameters) -> RectResult
}

class WindowCalculation: Calculation {
    
     func calculate(_ params: WindowCalculationParameters) -> WindowCalculationResult? {
        
        let rectResult = calculateRect(params.asRectParams())
        
        if rectResult.rect.isNull {
            return nil
        }
        
        return WindowCalculationResult(rect: rectResult.rect, screen: params.usableScreens.currentScreen, resultingAction: params.action, resultingSubAction: rectResult.subAction)
    }

    func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        RectResult(.null)
    }
    
    func rectCenteredWithinRect(_ rect1: CGRect, _ rect2: CGRect) -> Bool {
        let centeredMidX = abs(rect2.midX - rect1.midX) <= 1.0
        let centeredMidY = abs(rect2.midY - rect1.midY) <= 1.0
        return rect1.contains(rect2) && centeredMidX && centeredMidY
    }
    
    func rectFitsWithinRect(rect1: CGRect, rect2: CGRect) -> Bool {
        (rect1.width <= rect2.width) && (rect1.height <= rect2.height)
    }
}

struct Window {
    let id: CGWindowID
    let rect: CGRect
}

struct WindowCalculationParameters {
    let window: Window
    let usableScreens: UsableScreens
    let action: WindowAction
    let lastAction: RectangleAction?
    let ignoreTodo: Bool
    
    func asRectParams(visibleFrame: CGRect? = nil, differentAction: WindowAction? = nil) -> RectCalculationParameters {
        RectCalculationParameters(window: window,
                                  visibleFrameOfScreen: visibleFrame ?? usableScreens.currentScreen.adjustedVisibleFrame(ignoreTodo),
                                  action: differentAction ?? action,
                                  lastAction: lastAction)
    }
    
    func withDifferentAction(_ differentAction: WindowAction) -> WindowCalculationParameters {
        .init(window: window,
              usableScreens: usableScreens,
              action: differentAction,
              lastAction: lastAction,
              ignoreTodo: ignoreTodo)
    }
}

struct RectCalculationParameters {
    let window: Window
    let visibleFrameOfScreen: CGRect
    let action: WindowAction
    let lastAction: RectangleAction?
}

struct RectResult {
    let rect: CGRect
    let resultingAction: WindowAction?
    let subAction: SubWindowAction?
    
    init(_ rect: CGRect, resultingAction: WindowAction? = nil, subAction: SubWindowAction? = nil) {
        self.rect = rect
        self.resultingAction = resultingAction
        self.subAction = subAction
    }
}

struct WindowCalculationResult {
    var rect: CGRect
    let screen: NSScreen
    let resultingAction: WindowAction
    let resultingSubAction: SubWindowAction?
    let resultingScreenFrame: CGRect?

    init(rect: CGRect,
         screen: NSScreen,
         resultingAction: WindowAction,
         resultingSubAction: SubWindowAction? = nil,
         resultingScreenFrame: CGRect? = nil) {
        
        self.rect = rect
        self.screen = screen
        self.resultingAction = resultingAction
        self.resultingSubAction = resultingSubAction
        self.resultingScreenFrame = resultingScreenFrame
    }
}

class WindowCalculationFactory {
    
    static let leftHalfCalculation = LeftRightHalfCalculation()
    static let rightHalfCalculation = LeftRightHalfCalculation()
    static let centerHalfCalculation = CenterHalfCalculation()
    static let bottomHalfCalculation = BottomHalfCalculation()
    static let topHalfCalculation = TopHalfCalculation()
    static let centerCalculation = CenterCalculation()
    static let nextPrevDisplayCalculation = NextPrevDisplayCalculation()
    static let maximizeCalculation = MaximizeCalculation()
    static let changeSizeCalculation = ChangeSizeCalculation()
    static let lowerLeftCalculation = LowerLeftCalculation()
    static let lowerRightCalculation = LowerRightCalculation()
    static let upperLeftCalculation = UpperLeftCalculation()
    static let upperRightCalculation = UpperRightCalculation()
    static let maxHeightCalculation = MaximizeHeightCalculation()
    static let firstThirdCalculation = FirstThirdCalculation()
    static let firstTwoThirdsCalculation = FirstTwoThirdsCalculation()
    static let centerThirdCalculation = CenterThirdCalculation()
    static let lastTwoThirdsCalculation = LastTwoThirdsCalculation()
    static let lastThirdCalculation = LastThirdCalculation()
    static let moveLeftRightCalculation = MoveLeftRightCalculation()
    static let moveUpCalculation = MoveUpDownCalculation()
    static let moveDownCalculation = MoveUpDownCalculation()

    // Add actions for window calculations here
    static let calculationsByAction: [WindowAction: WindowCalculation] = [
     .leftHalf: leftHalfCalculation,
     .rightHalf: rightHalfCalculation,
     .maximize: maximizeCalculation,
     .maximizeHeight: maxHeightCalculation,
     .previousDisplay: nextPrevDisplayCalculation,
     .nextDisplay: nextPrevDisplayCalculation,
     .larger: changeSizeCalculation,
     .smaller: changeSizeCalculation,
     .bottomHalf: bottomHalfCalculation,
     .topHalf: topHalfCalculation,
     .center: centerCalculation,
     .bottomLeft: lowerLeftCalculation,
     .bottomRight: lowerRightCalculation,
     .topLeft: upperLeftCalculation,
     .topRight: upperRightCalculation,
     .centerHalf: centerHalfCalculation,
     .firstThird: firstThirdCalculation,
     .firstTwoThirds: firstTwoThirdsCalculation,
     .centerThird: centerThirdCalculation,
     .lastTwoThirds: lastTwoThirdsCalculation,
     .lastThird: lastThirdCalculation,
     .moveLeft: moveLeftRightCalculation,
     .moveRight: moveLeftRightCalculation,
     .moveUp: moveUpCalculation,
     .moveDown: moveDownCalculation
    ]
}
