//
//  CleaningManager.swift
//  MacMenu
//
//  Created by Daniel Koller on 25.10.23.
//

import Foundation
import Carbon

class CleaningManager {
    private var eventTap: EventTap
    
    init() {
        self.eventTap = EventTap()
    }
    
    // Additional flag to track cleaning mode
    private var isCleaningMode = false
    
    // Function to set the cleaning mode flag
    func setCleaningMode(active: Bool) {
        isCleaningMode = active
    }

    // Function to check if cleaning mode is active
    func isCleaningModeActive() -> Bool {
        return isCleaningMode
    }
    
    /// Used directly in the toggle switch of the CleaningModeView in the AppDelegate
    func toggleCleaning(_ isListening: Bool) {
        if isListening {
            print("Enabling cleaning mode for 20 seconds...")
            setCleaningMode(active: true)
            eventTap.toggleEventTap()
        } else {
            print("Disabling cleaning mode...")
            setCleaningMode(active: false)
            eventTap.toggleEventTap()
        }
    }
}

