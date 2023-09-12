//
//  FootprintWindow.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Cocoa

class FootprintWindow: NSWindow {
    private var orderOutCanceled = false
    
    init() {
        let initialRect = NSRect(x: 0, y: 0, width: 0, height: 0)
        super.init(contentRect: initialRect, styleMask: .titled, backing: .buffered, defer: false)

        title = "Rectangle"
        isOpaque = false
        level = .modalPanel
        hasShadow = false
        isReleasedWhenClosed = false
        alphaValue = Constants.footprintFade.userDisabled
            ? CGFloat(Constants.footprintAlpha.value)
            : 0
  
        styleMask.insert(.fullSizeContentView)
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        collectionBehavior.insert(.transient)
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        standardWindowButton(.toolbarButton)?.isHidden = true
        
        let boxView = NSBox()
        boxView.boxType = .custom
        boxView.borderColor = .lightGray
        boxView.borderType = .lineBorder
        boxView.borderWidth = CGFloat(Constants.footprintBorderWidth.value)
        
        if #available(macOS 11.0, *) {
            boxView.cornerRadius = 10
        } else {
            boxView.cornerRadius = 5
        }
        boxView.wantsLayer = true
        boxView.fillColor = Constants.footprintColor.typedValue?.nsColor ?? NSColor.black
        
        contentView = boxView
    }
    
    override var isVisible: Bool {
        // Workaround for footprint getting pushed off of Stage Manager
        if StageUtil.stageCapable && StageUtil.stageEnabled && StageUtil.stageStripShow && StageUtil.isStageStripVisible() {
            return true
        }
        return realIsVisible
    }
    
    var realIsVisible: Bool {
        if Constants.footprintFade.userDisabled {
            return super.isVisible
        } else {
            return alphaValue == Constants.footprintAlpha.cgFloat
        }
    }
    
    override func orderFront(_ sender: Any?) {
        if Constants.footprintFade.userDisabled {
            super.orderFront(sender)
        } else {
            orderOutCanceled = true
            super.orderFront(sender)
            animator().alphaValue = Constants.footprintAlpha.cgFloat
        }
    }
    
    override func orderOut(_ sender: Any?) {
        if Constants.footprintFade.userDisabled {
            super.orderOut(nil)
        } else {
            orderOutCanceled = false
            NSAnimationContext.runAnimationGroup { changes in
                animator().alphaValue = 0.0
            } completionHandler: {
                if !self.orderOutCanceled {
                    super.orderOut(nil)
                }
            }
        }
    }
}
