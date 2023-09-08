//
//  ApplicationToggle.swift
//  MacMenu
//
//  Created by Daniel Koller on 06.09.23.
//

import Cocoa

class ApplicationToggle: NSObject {
    
    private var disabledApps = Set<String>()
    //TODO: Update strings...
    public private(set) var frontAppId: String? = "com.knollsoft.Rectangle"
    public private(set) var frontAppName: String? = "Rectangle"

    override init() {
        super.init()
        registerFrontAppChangeNote()
        if let disabledApps = getDisabledApps() {
            self.disabledApps = disabledApps
        }
    }
    
    public func reloadFromDefaults() {
        if let disabledApps = getDisabledApps() {
            self.disabledApps = disabledApps
        } else {
            disabledApps.removeAll()
        }
    }
    
    private func saveDisabledApps() {
        let encoder = JSONEncoder()
        if let jsonDisabledApps = try? encoder.encode(disabledApps) {
            if let jsonString = String(data: jsonDisabledApps, encoding: .utf8) {
                Defaults.disabledApps.value = jsonString
            }
        }
    }
    
    private func getDisabledApps() -> Set<String>? {
        guard let jsonDisabledAppsString = Defaults.disabledApps.value else { return nil }
        
        let decoder = JSONDecoder()
        guard let jsonDisabledApps = jsonDisabledAppsString.data(using: .utf8) else { return nil }
        guard let disabledApps = try? decoder.decode(Set<String>.self, from: jsonDisabledApps) else { return nil }
        
        return disabledApps
    }

    public func disableFrontApp() {
        if let frontAppId = self.frontAppId {
            disabledApps.insert(frontAppId)
            saveDisabledApps()
        }
    }
    
    public func enableFrontApp() {
        if let frontAppId = self.frontAppId {
            disabledApps.remove(frontAppId)
            saveDisabledApps()
        }
    }
    
    public func isDisabled(bundleId: String) -> Bool {
        return disabledApps.contains(bundleId)
    }

    private func registerFrontAppChangeNote() {
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.receiveFrontAppChangeNote(_:)), name: NSWorkspace.didActivateApplicationNotification, object: nil)
    }
    
    @objc func receiveFrontAppChangeNote(_ notification: Notification) {
        if let application = notification.userInfo?["NSWorkspaceApplicationKey"] as? NSRunningApplication {
            self.frontAppId = application.bundleIdentifier
            self.frontAppName = application.localizedName
            if let frontAppId = application.bundleIdentifier {
                if isDisabled(bundleId: frontAppId) {
                    // Handle the case when the front app is disabled
                } else {
                    // Handle the case when the front app is enabled
                }
                Notification.Name.frontAppChanged.post()
            }
        }
    }
}
