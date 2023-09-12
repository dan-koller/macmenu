//
//  WindowManager.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Cocoa

class WindowManager {

    private let screenDetection = ScreenDetection()
    private let standardWindowMoverChain: [WindowMover]
    private let fixedSizeWindowMoverChain: [WindowMover]

    init() {
        standardWindowMoverChain = [
            StandardWindowMover(),
            BestEffortWindowMover()
        ]

        fixedSizeWindowMoverChain = [
            CenteringFixedSizedWindowMover(),
            BestEffortWindowMover()
        ]
        
        subscribeAll(selector: #selector(windowActionTriggered))
    }
    
    @objc func windowActionTriggered(notification: NSNotification) {
        guard var parameters = notification.object as? ExecutionParameters else { return }
        
        if MultiWindowManager.execute(parameters: parameters) {
            return
        }
        
        if Constants.subsequentExecutionMode.value == .cycleMonitor {
            guard let windowElement = parameters.windowElement ?? AccessibilityElement.getFrontWindowElement(),
                  let windowId = parameters.windowId ?? windowElement.getWindowId()
            else {
                NSSound.beep()
                return
            }
            
            if isRepeatAction(parameters: parameters, windowElement: windowElement, windowId: windowId) {
                if let screen = ScreenDetection().detectScreens(using: windowElement)?.adjacentScreens?.next{
                    parameters = ExecutionParameters(parameters.action, updateRestoreRect: parameters.updateRestoreRect, screen: screen, windowElement: windowElement, windowId: windowId)
                    // Bypass any other subsequent action by removing the last action
                    AppDelegate.windowHistory.lastRectangleActions.removeValue(forKey: windowId)
                }
            }
        }
        
        execute(parameters)
    }
    
    private func isRepeatAction(parameters: ExecutionParameters, windowElement: AccessibilityElement, windowId: CGWindowID) -> Bool {
        
        if parameters.action == .maximize {
            if ScreenDetection().detectScreens(using: windowElement)?.currentScreen.visibleFrame.size == windowElement.frame.size {
                return true
            }
        }
        if parameters.action == AppDelegate.windowHistory.lastRectangleActions[windowId]?.action {
            return true
        }
        return false
    }
    
    private func subscribe(notification: WindowAction, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification.notificationName, object: nil)
    }
    
    private func unsubscribe() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribeAll(selector: Selector) {
        for windowAction in WindowAction.active {
            subscribe(notification: windowAction, selector: selector)
        }
    }

    private func recordAction(windowId: CGWindowID, resultingRect: CGRect, action: WindowAction, subAction: SubWindowAction?) {
        let newCount: Int
        if let lastRectangleAction = AppDelegate.windowHistory.lastRectangleActions[windowId], lastRectangleAction.action == action {
            newCount = lastRectangleAction.count + 1
        } else {
            newCount = 1
        }

        AppDelegate.windowHistory.lastRectangleActions[windowId] = RectangleAction(
            action: action,
            subAction: subAction,
            rect: resultingRect,
            count: newCount
        )
    }

    func execute(_ parameters: ExecutionParameters) {
        guard let frontmostWindowElement = parameters.windowElement ?? AccessibilityElement.getFrontWindowElement(),
              let windowId = parameters.windowId ?? frontmostWindowElement.getWindowId()
        else {
            NSSound.beep()
            return
        }

        let action = parameters.action

        if action == .restore {
            if let restoreRect = AppDelegate.windowHistory.restoreRects[windowId] {
                frontmostWindowElement.setFrame(restoreRect)
            }
            AppDelegate.windowHistory.lastRectangleActions.removeValue(forKey: windowId)
            return
        }
        
        var screens: UsableScreens?
        if let screen = parameters.screen {
            screens = UsableScreens(currentScreen: screen, numScreens: 1)
        } else {
            screens = screenDetection.detectScreens(using: frontmostWindowElement)
        }
        
        guard let usableScreens = screens else {
            NSSound.beep()
            return
        }
        
        let currentWindowRect: CGRect = frontmostWindowElement.frame
        
        var lastRectangleAction = AppDelegate.windowHistory.lastRectangleActions[windowId]
        
        let windowMovedExternally = currentWindowRect != lastRectangleAction?.rect
        
        if windowMovedExternally {
            lastRectangleAction = nil
            AppDelegate.windowHistory.lastRectangleActions.removeValue(forKey: windowId)
        }
        
        if parameters.updateRestoreRect {
            if AppDelegate.windowHistory.restoreRects[windowId] == nil
                || windowMovedExternally {
                AppDelegate.windowHistory.restoreRects[windowId] = currentWindowRect
            }
        }
        
        // TODO: try to remove this
        let ignoreTodo = true
        
        if frontmostWindowElement.isSheet == true
            || currentWindowRect.isNull
            || usableScreens.frameOfCurrentScreen.isNull
            || usableScreens.currentScreen.adjustedVisibleFrame(ignoreTodo).isNull {
            NSSound.beep()
            return
        }
        
        let currentNormalizedRect = currentWindowRect.screenFlipped
        let currentWindow = Window(id: windowId, rect: currentNormalizedRect)
        
        let windowCalculation = WindowCalculationFactory.calculationsByAction[action]
        
        let calculationParams = WindowCalculationParameters(window: currentWindow, usableScreens: usableScreens, action: action, lastAction: lastRectangleAction, ignoreTodo: ignoreTodo)
        guard var calcResult = windowCalculation?.calculate(calculationParams) else {
            NSSound.beep()
            return
        }
        
        let gapsApplicable = calcResult.resultingAction.gapsApplicable
        
        if Constants.gapSize.value > 0, gapsApplicable != .none {
            let gapSharedEdges = calcResult.resultingSubAction?.gapSharedEdge ?? calcResult.resultingAction.gapSharedEdge
            
            calcResult.rect = GapCalculation.applyGaps(calcResult.rect, dimension: gapsApplicable, sharedEdges: gapSharedEdges, gapSize: Constants.gapSize.value)
        }

        if currentNormalizedRect.equalTo(calcResult.rect) {
            
            recordAction(windowId: windowId, resultingRect: currentWindowRect, action: calcResult.resultingAction, subAction: calcResult.resultingSubAction)
            
            return
        }
        
        let newRect = calcResult.rect.screenFlipped
        
        let visibleFrameOfDestinationScreen = calcResult.resultingScreenFrame ?? calcResult.screen.adjustedVisibleFrame(ignoreTodo)

        let useFixedSizeMover = (!frontmostWindowElement.isResizable() && action.resizes) || frontmostWindowElement.isSystemDialog == true
        let windowMoverChain = useFixedSizeMover
            ? fixedSizeWindowMoverChain
            : standardWindowMoverChain

        for windowMover in windowMoverChain {
            windowMover.moveWindowRect(newRect, frameOfScreen: usableScreens.frameOfCurrentScreen, visibleFrameOfScreen: visibleFrameOfDestinationScreen, frontmostWindowElement: frontmostWindowElement, action: action)
        }
        
        let resultingRect = frontmostWindowElement.frame
        
        if Constants.moveCursor.userEnabled, parameters.source == .keyboardShortcut {
            let windowCenter = NSMakePoint(NSMidX(resultingRect), NSMidY(resultingRect))
            CGWarpMouseCursorPosition(windowCenter)
        }
        
        if usableScreens.currentScreen != calcResult.screen {
            frontmostWindowElement.bringToFront(force: true)
            
            if Constants.moveCursorAcrossDisplays.userEnabled {
                let windowCenter = NSMakePoint(NSMidX(resultingRect), NSMidY(resultingRect))
                CGWarpMouseCursorPosition(windowCenter)
            }
        }
        
        recordAction(windowId: windowId, resultingRect: resultingRect, action: calcResult.resultingAction, subAction: calcResult.resultingSubAction)
    }
}

struct RectangleAction {
    let action: WindowAction
    let subAction: SubWindowAction?
    let rect: CGRect
    let count: Int
}

struct ExecutionParameters {
    let action: WindowAction
    let updateRestoreRect: Bool
    let screen: NSScreen?
    let windowElement: AccessibilityElement?
    let windowId: CGWindowID?
    let source: ExecutionSource

    init(_ action: WindowAction, updateRestoreRect: Bool = true, screen: NSScreen? = nil, windowElement: AccessibilityElement? = nil, windowId: CGWindowID? = nil, source: ExecutionSource = .keyboardShortcut) {
        self.action = action
        self.updateRestoreRect = updateRestoreRect
        self.screen = screen
        self.windowElement = windowElement
        self.windowId = windowId
        self.source = source
    }
}

enum ExecutionSource {
    case keyboardShortcut, dragToSnap, menuItem, url, titleBar
}
