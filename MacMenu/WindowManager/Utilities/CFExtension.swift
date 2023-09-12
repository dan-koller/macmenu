//
//  CFExtension.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

extension CFArray {
    func getValue<T>(_ index: CFIndex) -> T {
        return unsafeBitCast(CFArrayGetValueAtIndex(self, index), to: T.self)
    }
    
    func getCount() -> CFIndex {
        return CFArrayGetCount(self)
    }
}

extension CFDictionary {
    func getValue<T>(_ key: CFString) -> T {
        return unsafeBitCast(CFDictionaryGetValue(self, unsafeBitCast(key, to: UnsafeRawPointer.self)), to: T.self)
    }
    
    func toRect() -> CGRect? {
        return CGRect(dictionaryRepresentation: self)
    }
}
