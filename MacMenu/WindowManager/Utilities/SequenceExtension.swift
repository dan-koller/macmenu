//
//  SequenceExtension.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation

extension Sequence {
    func uniqueMap<T>(_ transform: (Element) -> T) -> [T] where T: Hashable {
        var set = Set<T>()
        var array = Array<T>()
        for element in self {
            let element = transform(element)
            if set.insert(element).inserted {
                array.append(element)
            }
        }
        return array
    }
}
