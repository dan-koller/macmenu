//
//  EventMonitor.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Cocoa

protocol EventMonitor {
    var running: Bool { get }
    
    func start()
    func stop()
}

public class PassiveEventMonitor: EventMonitor {
    private var localMonitor: Any?
    private var globalMonitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent) -> Void

    var running: Bool { localMonitor != nil && globalMonitor != nil }
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent) -> Void) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: mask) { event in
            self.handler(event)
            return event
        }
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    public func stop() {
        if localMonitor != nil {
            NSEvent.removeMonitor(localMonitor!)
            localMonitor = nil
        }
        if globalMonitor != nil {
            NSEvent.removeMonitor(globalMonitor!)
            globalMonitor = nil
        }
    }
}

public class ActiveEventMonitor: EventMonitor {
    private var tap: CFMachPort?
    private var thread: RunLoopThread?
    private let mask: NSEvent.EventTypeMask
    public let filterer: (NSEvent) -> Bool
    public let handler: (NSEvent) -> Void

    var running: Bool { tap != nil }
    
    public init(mask: NSEvent.EventTypeMask, filterer: @escaping (NSEvent) -> Bool, handler: @escaping (NSEvent) -> Void) {
        self.mask = mask
        self.filterer = filterer
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        tap = CGEvent.tapCreate(tap: .cgSessionEventTap, place: .headInsertEventTap, options: .defaultTap, eventsOfInterest: mask.rawValue, callback: tapCallback, userInfo: CUtil.bridge(obj: self))
        if let tap = tap {
            thread = RunLoopThread(mode: .default, qualityOfService: .userInteractive, start: true)
            thread!.runLoop!.add(tap, forMode: .default)
        }
    }
    
    public func stop() {
        if let tap = tap {
            thread!.runLoop!.remove(tap, forMode: .default)
            thread!.cancel()
            thread = nil
            CGEvent.tapEnable(tap: tap, enable: false)
        }
        tap = nil
    }
}

fileprivate func tapCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    var filtered = false
    if let ptr = refcon {
        let eventMonitor = CUtil.bridge(ptr: ptr) as ActiveEventMonitor
        if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
            eventMonitor.stop()
            eventMonitor.start()
        } else {
            if let nsEvent = NSEvent(cgEvent: event) {
                filtered = eventMonitor.filterer(nsEvent)
                DispatchQueue.main.async { eventMonitor.handler(nsEvent) }
            }
        }
    }
    return filtered ? nil : Unmanaged.passUnretained(event)
}
