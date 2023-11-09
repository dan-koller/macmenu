//
//  ShortcutManager.swift
//  MacMenu, Ported from Rectangle
//
//  Created by Daniel Koller on 23.09.23.
//

import Foundation
import MASShortcut

class ShortcutManager {
    
    let windowManager: WindowManager
    
    init(windowManager: WindowManager) {
        self.windowManager = windowManager
        
        MASShortcutBinder.shared()?.bindingOptions = [NSBindingOption.valueTransformerName: MASDictionaryTransformerName]
        
        registerDefaults()

        bindShortcuts()
        
        // subscribe
        Notification.Name.changeDefaults.onPost { _ in self.registerDefaults() }
    }
    
    deinit {
        // unsubscribe
//        NotificationCenter.default.removeObserver(self)
        unsubscribe()
    }
    
    public func bindShortcuts() {
        for action in WindowAction.active {
            MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: action.name, toAction: action.post)
        }
    }
    
    public func unbindShortcuts() {
        for action in WindowAction.active {
            MASShortcutBinder.shared()?.breakBinding(withDefaultsKey: action.name)
        }
    }
    
//    public func getKeyEquivalent(action: WindowAction) -> (String?, NSEvent.ModifierFlags)? {
//        guard let masShortcut = MASShortcutBinder.shared()?.value(forKey: action.name) as? MASShortcut else { return nil }
//        return (masShortcut.keyCodeStringForKeyEquivalent, masShortcut.modifierFlags)
//    }
    
    private func registerDefaults() {
        let defaultShortcuts = WindowAction.active.reduce(into: [String: MASShortcut]()) { dict, windowAction in
            guard let defaultShortcut = windowAction.defaultShortcuts
            else { return }
            let shortcut = MASShortcut(keyCode: defaultShortcut.keyCode, modifierFlags: NSEvent.ModifierFlags(rawValue: defaultShortcut.modifierFlags))
            dict[windowAction.name] = shortcut
        }

        MASShortcutBinder.shared()?.registerDefaultShortcuts(defaultShortcuts)
    }
    
    @objc func windowActionTriggered(notification: NSNotification) {
        guard let parameters = notification.object as? ExecutionParameters else { return }
        windowManager.execute(parameters)
    }
    
    private func unsubscribe() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func subscribe(notification: WindowAction, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification.notificationName, object: nil)
    }
    
    private func subscribeAll(selector: Selector) {
        for windowAction in WindowAction.active {
            subscribe(notification: windowAction, selector: selector)
        }
    }
    
    public func disableShortcuts() {
        unsubscribe()
        unbindShortcuts()
    }
    
    public func reloadShortcuts() {
        unsubscribe()
        unbindShortcuts()
        registerDefaults()
        bindShortcuts()
        subscribeAll(selector: #selector(windowActionTriggered))
    }
    
    /// Used directly in the toggle switch of the WindowManagerView in the AppDelegate
    func toggleListening(_ isListening: Bool) {
        if isListening {
            reloadShortcuts()
        } else {
            disableShortcuts()
        }
    }
}

