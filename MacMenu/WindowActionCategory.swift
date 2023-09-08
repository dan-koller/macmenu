//
//  WindowActionCategory.swift
//  MacMenu
//
//  Created by Daniel Koller on 06.09.23.
//

import Foundation

enum WindowActionCategory {

    case halves, corners, thirds, max, size, display, move, other, sixths, fourths
    
    var displayName: String {
        switch self {
        case .halves:
            return NSLocalizedString("Halves", tableName: "Main", value: "", comment: "")
        case .corners:
            return NSLocalizedString("Corners", tableName: "Main", value: "", comment: "")
        case .thirds:
            return NSLocalizedString("Thirds", tableName: "Main", value: "", comment: "")
        case .max:
            return NSLocalizedString("Maximize", tableName: "Main", value: "", comment: "")
        case .size:
            return NSLocalizedString("Size", tableName: "Main", value: "", comment: "")
        case .display:
            return NSLocalizedString("Display", tableName: "Main", value: "", comment: "")
        case .other:
            return NSLocalizedString("Other", tableName: "Main", value: "", comment: "")
        case .move:
            return NSLocalizedString("Move to Edge", tableName: "Main", value: "", comment: "")
        case .fourths:
            return NSLocalizedString("Fourths", tableName: "Main", value: "", comment: "")
        case .sixths:
            return NSLocalizedString("Sixths", tableName: "Main", value: "", comment: "")
        }
    }
}
