//
//  Debounce.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Foundation
import Dispatch

class Debounce<T: Equatable> {

    private init() {}

    static func input(_ input: T,
                      comparedAgainst current: @escaping @autoclosure () -> (T),
                      perform: @escaping (T) -> ()) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if input == current() { perform(input) }
        }
    }
}
