//
//  AppDelegate.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Cocoa
import SwiftUI
import LaunchAtLogin

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
        
        // Register an observer for mouse clicks outside the popover
        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { [weak self] _ in
            guard let self = self else { return }
            if self.popover.isShown {
                self.togglePopover(nil)
            }
        }
        
        // Request permissions and launch on startup
        if !isAccessibilityTrusted() {
            requestAccessibilityPermissionsWindow()
        }

        if !LaunchAtLogin.isEnabled {
            askForLaunchOnStartup()
        }

        // Initialize window manager
        initializeWindowManager()
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

    private func isAccessibilityTrusted() -> Bool {
        // Check if the app is trusted for accessibility
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: false]
        return AXIsProcessTrustedWithOptions(options)
    }
    
    private func requestAccessibilityPermissionsWindow() {
        let alert = NSAlert()
        alert.messageText = "Accessibility permissions required"
        alert.informativeText = "MacMenu requires accessibility permissions to work. Please grant them in the system preferences."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open System Preferences")
        alert.addButton(withTitle: "Cancel")
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
            NSWorkspace.shared.open(url)
        }
    }
    
    private func askForLaunchOnStartup() {
        let alert = NSAlert()
        alert.messageText = "Launch on startup?"
        alert.informativeText = "Do you want MacMenu to launch on startup?"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        
        let response = alert.runModal()
        
        if response == .alertFirstButtonReturn {
            if !LaunchAtLogin.isEnabled {
                LaunchAtLogin.isEnabled = true
            }
        }
    }
    
    func initializeWindowManager() {
        self.windowManager = WindowManager()
        self.snappingManager = SnappingManager()
        self.shortcutManager = ShortcutManager(windowManager: windowManager)
        self.cleaningManager = CleaningManager()
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

