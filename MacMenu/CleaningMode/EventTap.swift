//
//  EventTap.swift
//  MacMenu
//
//  Created by Daniel Koller on 25.10.23.
//

import Carbon
import Foundation

class EventTap {
    var eventTapEnabled = false
    var eventTap: CFMachPort?

    // Toggle the eventTap on and off
    func toggleEventTap() {
        eventTapEnabled = !eventTapEnabled

        if eventTapEnabled {
            createTap()
            print("Event Tap Enabled")
        } else {
            // Disable the event tap (back to normal)
            if let tap = eventTap {
                CGEvent.tapEnable(tap: tap, enable: false)
                // No need to manually release eventTap in Swift
                eventTap = nil
            }
            print("Event Tap Disabled")
        }
    }

    func createTap() {
        if eventTap == nil {
            var runLoopSource: CFRunLoopSource?

            eventTap = CGEvent.tapCreate(
                tap: .cgSessionEventTap,
                place: .headInsertEventTap,
                options: .defaultTap,
                eventsOfInterest: CGEventMask(1 << CGEventType.keyDown.rawValue),
                callback: keyboardInputInterceptor,
                userInfo: nil
            )

            if eventTap == nil {
                print("Couldn't create event tap!")
                exit(1)
            }

            runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap!, 0)
            CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            CGEvent.tapEnable(tap: eventTap!, enable: true)
            // Note: No need to release runLoopSource or eventTap in Swift
            CFRunLoopRun()
        }
    }
}

// Custom event callback to intercept keyboard input
func keyboardInputInterceptor(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    // If any key (not mouse) is pressed, print its keycode in the console
    if type == .keyDown {
        print(event.getIntegerValueField(.keyboardEventKeycode))
        return nil
    }
    
    return Unmanaged.passRetained(event)
}

