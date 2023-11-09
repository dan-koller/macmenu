//
//  CleaningManager.swift
//  MacMenu
//
//  Created by Daniel Koller on 25.10.23.
//

import Foundation

class CleaningManager {
    
    let appDelegate: AppDelegate
    
    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }
    
    /// Used directly in the toggle switch of the CleaningModeView in the AppDelegate
    func toggleCleaning(_ isListening: Bool) {
        if isListening {
            print("Enabling cleaning mode...")
        } else {
            print("...disbaling cleaning mode")
        }
    }
    
    // TODO: Implement methods to enable and disable keyboard input, while cleaning mode is active
}
