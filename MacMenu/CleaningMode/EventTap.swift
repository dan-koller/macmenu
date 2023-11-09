//
//  EventTap.swift
//  MacMenu
//
//  Created by Daniel Koller on 25.10.23.
//

import Foundation
import SwiftUI

enum EventTapResult {
    case pass
    case block
}

typealias Callback = (_ type: CGEventType) -> EventTapResult

private let timerInterval = 15.0
private var lastEventTime: Double = 0
private var eventTap: CFMachPort?
private var callbacks: [Callback] = []
private var isSetup = false
private let eventMask = 1 << CGEventType.keyDown.rawValue
    | 1 << CGEventType.keyUp.rawValue
    | 1 << CGEventType.mouseMoved.rawValue
    | 1 << CGEventType.leftMouseUp.rawValue
    | 1 << CGEventType.leftMouseDown.rawValue
    | 1 << CGEventType.leftMouseDragged.rawValue
    | 1 << NX_SYSDEFINED;

// Disable xcode sandbox when developing to get a accessibilty prompt
func createInputTap(_ callback: @escaping Callback) -> Bool {
    let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString
    let options = [checkOptPrompt: true]
    let isAppTrusted = AXIsProcessTrustedWithOptions(options as CFDictionary?)

    if !isAppTrusted {
        return false
    }

    if !isSetup {
        initEventTap()
        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            initEventTap()
        }
        isSetup = true
    }

    callbacks.append(callback)
    return true
}

func currentTime() -> TimeInterval {
    NSDate().timeIntervalSince1970
}

func initEventTap() {
    if lastEventTime > currentTime() - timerInterval {
        return
    }

    if let eventTap = eventTap {
        // Detach current event tap
        CFMachPortInvalidate(eventTap)
    }

    eventTap = CGEvent.tapCreate(
        tap: .cghidEventTap,
        place: .headInsertEventTap,
        options: .defaultTap,
        eventsOfInterest: CGEventMask(eventMask),
        callback: { (proxy, type, event, userData) -> Optional<Unmanaged<CGEvent>> in
            lastEventTime = currentTime()
            var shouldPass = true
            for callback in callbacks {
                shouldPass = callback(type) == .pass && shouldPass
            }
            return !shouldPass ? Optional.none : Optional.some(Unmanaged.passUnretained(event))
        },
        userInfo: nil
    )

    let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
    CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .commonModes)
}
