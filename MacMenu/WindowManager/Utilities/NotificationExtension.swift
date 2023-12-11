//
//  NotificationExtension.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Cocoa

extension Notification.Name {
  
    static let configImported = Notification.Name("configImported")
    static let windowSnapping = Notification.Name("windowSnapping")
    static let frontAppChanged = Notification.Name("frontAppChanged")
    static let allowAnyShortcut = Notification.Name("allowAnyShortcutToggle")
    static let changeDefaults = Notification.Name("changeDefaults")
    static let appWillBecomeActive = Notification.Name("appWillBecomeActive")
    static let missionControlDragging = Notification.Name("missionControlDragging")
    static let menuBarIconHidden = Notification.Name("menuBarIconHidden")
    static let windowTitleBar = Notification.Name("windowTitleBar")
    static let defaultSnapAreas = Notification.Name("defaultSnapAreas")

    func post(
        center: NotificationCenter = NotificationCenter.default,
        object: Any? = nil,
        userInfo: [AnyHashable : Any]? = nil) {
        
        center.post(name: self, object: object, userInfo: userInfo)
    }
    
    @discardableResult
    func onPost(
        center: NotificationCenter = NotificationCenter.default,
        object: Any? = nil,
        queue: OperationQueue? = nil,
        using: @escaping (Notification) -> Void)
    -> NSObjectProtocol {
        
        return center.addObserver(
            forName: self,
            object: object,
            queue: queue,
            using: using)
    }

}
