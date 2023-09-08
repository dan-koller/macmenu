//
//  StandardWindowMover.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

class StandardWindowMover: WindowMover {
    func moveWindowRect(_ windowRect: CGRect, frameOfScreen: CGRect, visibleFrameOfScreen: CGRect, frontmostWindowElement: AccessibilityElement?, action: WindowAction?) {
        let previousWindowRect: CGRect? = frontmostWindowElement?.frame
        if previousWindowRect?.isNull == true {
            return
        }
        frontmostWindowElement?.setFrame(windowRect)
    }
}
