//
//  ThirdsCompoundCalculation.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

struct ThirdsCompoundCalculation: CompoundSnapAreaCalculation {
    
    func snapArea(cursorLocation loc: NSPoint, screen: NSScreen, directional: Directional, priorSnapArea: SnapArea?) -> SnapArea? {
        let frame = screen.frame
        let thirdWidth = floor(frame.width / 3)
        if loc.x <= frame.minX + thirdWidth {
            return SnapArea(screen: screen, directional: directional, action: .firstThird)
        }
        if loc.x >= frame.minX + thirdWidth && loc.x <= frame.maxX - thirdWidth{
            if let priorAction = priorSnapArea?.action {
                let action: WindowAction
                switch priorAction {
                case .firstThird, .firstTwoThirds:
                    action = .firstTwoThirds
                case .lastThird, .lastTwoThirds:
                    action = .lastTwoThirds
                default: action = .centerThird
                }
                return SnapArea(screen: screen, directional: directional, action: action)
            }
            return SnapArea(screen: screen, directional: directional, action: .centerThird)
        }
        if loc.x >= frame.minX + thirdWidth {
            return SnapArea(screen: screen, directional: directional, action: .lastThird)
        }
        return nil
    }
    
}

struct PortraitSideThirdsCompoundCalculation: CompoundSnapAreaCalculation {
    
    private let marginTop = Constants.snapEdgeMarginTop.cgFloat
    private let marginBottom = Constants.snapEdgeMarginBottom.cgFloat
    private let ignoredSnapAreas = SnapAreaOption(rawValue: Constants.ignoredSnapAreas.value)
    
    func snapArea(cursorLocation loc: NSPoint, screen: NSScreen, directional: Directional, priorSnapArea: SnapArea?) -> SnapArea? {
        let frame = screen.frame
        let thirdHeight = floor(frame.height / 3)
        let shortEdgeSize = Constants.shortEdgeSnapAreaSize.cgFloat
        
        if loc.y <= frame.minY + marginBottom + shortEdgeSize {
            let snapAreaOption: SnapAreaOption = loc.x < frame.midX ? .bottomLeftShort : .bottomRightShort
            if !ignoredSnapAreas.contains(snapAreaOption) {
                return SnapArea(screen: screen, directional: directional, action: .bottomHalf)
            }
        }
        if loc.y >= frame.maxY - marginTop - shortEdgeSize {
            let snapAreaOption: SnapAreaOption = loc.x < frame.midX ? .topLeftShort : .topRightShort
            if !ignoredSnapAreas.contains(snapAreaOption) {
                return SnapArea(screen: screen, directional: directional, action: .topHalf)
            }
        }
        
        if loc.y >= frame.minY && loc.y <= frame.minY + thirdHeight {
            return SnapArea(screen: screen, directional: directional, action: .lastThird)
        }
        if loc.y >= frame.minY + thirdHeight && loc.y <= frame.maxY - thirdHeight {
            if let priorAction = priorSnapArea?.action {
                let action: WindowAction
                switch priorAction {
                case .firstThird, .firstTwoThirds:
                    action = .firstTwoThirds
                case .lastThird, .lastTwoThirds:
                    action = .lastTwoThirds
                default: action = .centerThird
                }
                return SnapArea(screen: screen, directional: directional, action: action)
            }
            return SnapArea(screen: screen, directional: directional, action: .centerThird)
        }
        if loc.y >= frame.minY + thirdHeight && loc.y <= frame.maxY {
            return SnapArea(screen: screen, directional: directional, action: .firstThird)
        }
        return nil
    }

}
