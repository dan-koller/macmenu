//
//  OrientationAware.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

typealias SimpleCalc = (_ visibleFrameOfScreen: CGRect) -> RectResult

protocol OrientationAware {
    
    func landscapeRect(_ visibleFrameOfScreen: CGRect) -> RectResult
    func portraitRect(_ visibleFrameOfScreen: CGRect) -> RectResult
    func orientationBasedRect(_ visibleFrameOfScreen: CGRect) -> RectResult
    
}

extension OrientationAware {
    func orientationBasedRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        return visibleFrameOfScreen.isLandscape
            ? landscapeRect(visibleFrameOfScreen)
            : portraitRect(visibleFrameOfScreen)
    }
}

