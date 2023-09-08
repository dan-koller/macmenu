//
//  CGExtension.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

extension CGPoint {
    var screenFlipped: CGPoint {
        .init(x: x, y: NSScreen.screens[0].frame.maxY - y)
    }
}

extension CGRect {
    var screenFlipped: CGRect {
        guard !isNull else {
            return self
        }
        return .init(origin: .init(x: origin.x, y: NSScreen.screens[0].frame.maxY - maxY), size: size)
    }

    var isLandscape: Bool { width > height }
}
