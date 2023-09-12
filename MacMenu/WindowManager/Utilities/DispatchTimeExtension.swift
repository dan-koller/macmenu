//
//  DispatchTimeExtension.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

extension DispatchTime {
    var uptimeMilliseconds: UInt64 { uptimeNanoseconds / 1_000_000 }
}
