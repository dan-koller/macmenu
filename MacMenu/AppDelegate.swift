//
//  AppDelegate.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var popover: NSPopover!
    var statusBar: NSStatusItem!
    
    static let windowHistory = WindowHistory()
    
    private var windowManager: WindowManager!
    private var snappingManager: SnappingManager!
    private var shortcutManager: ShortcutManager!
    
    private var cleaningManager: CleaningManager!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let systemInfoView = SystemInfoView()
        let keyboardCleaningView = CleaningModeView()
        let windowManagerView = WindowManagerView()
        
        let popoverView = PopoverView(
            systemInfoView: systemInfoView,
            keyboardCleaningView: keyboardCleaningView,
            windowManagerView: windowManagerView
        )
        
        // Create the popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 200)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: popoverView)
        
        // Create the status bar item
        statusBar = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let statusButton = statusBar.button {
            statusButton.image = NSImage(systemSymbolName: "speedometer", accessibilityDescription: "MacMenu")
            statusButton.action = #selector(togglePopover(_:))
        }
        
        // Request permissions and start the wm
        requestAccessibilityPermissions()
        initializeWindowManager()
        
        // TODO: Show a small welcome window that displays the shortcuts
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = statusBar.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }

    // Disable xcode sandbox when developing to get an accessibilty prompt
    func requestAccessibilityPermissions() {
        // TODO: Wait for the user to grant permission
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: true]
        
        let trusted = AXIsProcessTrustedWithOptions(options)
        if trusted {
            print("Accessibility permissions granted.")
        } else {
            print("Accessibility permissions denied.")
        }
    }
    
    func initializeWindowManager() {
        self.windowManager = WindowManager()
        self.snappingManager = SnappingManager()
        self.shortcutManager = ShortcutManager(windowManager: windowManager)
        
        self.cleaningManager = CleaningManager(appDelegate: self)
    }

    func toggleWindowManager(_ isListening: Bool) {
        snappingManager.toggleListening(isListening)
        shortcutManager.toggleListening(isListening)
    }
    
    func toggleCleaningMode(_ isListening: Bool) {
        cleaningManager.toggleCleaning(isListening)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

}

