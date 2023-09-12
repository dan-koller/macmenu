//
//  WindowHistory.swift
//  MacMenu
//
//  Created by Daniel Koller on 06.09.23.
//

import Foundation

class WindowHistory {
    
    var restoreRects = [CGWindowID: CGRect]() // the last window frame that the user positioned
    
    var lastRectangleActions = [CGWindowID: RectangleAction]() // the last window frame that this app positioned
    
}
