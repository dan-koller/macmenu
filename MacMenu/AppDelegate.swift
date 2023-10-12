//
//  AppDelegate.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import Cocoa
import SwiftUI
import SISwift

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var popover: NSPopover!
    var statusBar: NSStatusItem!
    
    static let windowHistory = WindowHistory()
    
    private var windowManager: WindowManager!
    private var snappingManager: SnappingManager!
    private var shortcutManager: ShortcutManager!

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
    
    // Disable xcode sandbox when developing to get an accessibilty prompt when developing
    func requestAccessibilityPermissions() {
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
    }

    func toggleWindowManager(_ isListening: Bool) {
        snappingManager.toggleListening(isListening)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

}

enum GaugeType {
    case cpuLoad
    case ramUsage
    case diskUsage
    
    var symbol: String {
        switch self {
            case .cpuLoad: return "cpu"
            case .ramUsage: return "memorychip"
            case .diskUsage: return "server.rack"
        }
    }
}

struct GaugeView: View {
    var title: String
    var gaugeType: GaugeType
    var value: Float
    
    var body: some View {
        VStack {
            Gauge(title: title, gaugeType: gaugeType, value: value)
                .frame(width: 70, height: 70)
        }
    }
}

struct Gauge: View {
    let title: String
    let gaugeType: GaugeType
    let value: Float // Value between 0 and 1

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0, to: CGFloat(min(value, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.blue)
                .rotationEffect(Angle(degrees: -90))
            
            VStack {
                Text(Image(systemName: gaugeType.symbol))
                    .font(.system(size: 18))
                Text(title)
                    .font(.caption)
            }
        }
    }
}

class SystemInfoViewModel: ObservableObject {
    @Published var cpuLoad: Float = 0.0
    @Published var ramUsage: Float = 0.0
    @Published var diskUsage: Float = 0.0
    
    init() {
        // Initialize data
        updateData()
    }
    
    func updateData() {
        cpuLoad = SISystemInfo.getCpuLoad()
        ramUsage = SISystemInfo.getMemoryUsage()
        diskUsage = SISystemInfo.getDiskUsage()
    }
    
    func startUpdatingData() {
        // Start a timer to update the data every 2 seconds
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.updateData()
        }
    }
}

struct SystemInfoView: View {
    @ObservedObject private var viewModel: SystemInfoViewModel = SystemInfoViewModel()
    
    var body: some View {
        HStack(spacing: 20) {
            GaugeView(title: "CPU", gaugeType: .cpuLoad, value: viewModel.cpuLoad)
            GaugeView(title: "MEM", gaugeType: .ramUsage, value: viewModel.ramUsage)
            GaugeView(title: "DISK",gaugeType: .diskUsage, value: viewModel.diskUsage)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
        .onAppear {
            viewModel.startUpdatingData()
        }
    }
}

struct CleaningModeView: View {
    @State private var isCleaningEnabled = false

    var body: some View {
        HStack {
            Text("Cleaning mode")
                .font(.headline)
            
            Spacer()
            
            Toggle("", isOn: $isCleaningEnabled)
                .toggleStyle(SwitchToggleStyle())
            // Event listener for changes
                .onChange(of: isCleaningEnabled) { newValue in
                    print("Cleaning mode Enabled: \(newValue)")
                }
        }
        .padding(5)
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
    }
}

struct WindowManagerView: View {
    @State private var isWindowManagerEnabled = true

    init() {
        print("Initializing WindowManagerView...")
    }

    var body: some View {
        let appDelegate = NSApp.delegate as! AppDelegate
        HStack {
            Text("Window manager")
                .font(.headline)
            
            Spacer()
            
            Toggle("", isOn: $isWindowManagerEnabled)
                .toggleStyle(SwitchToggleStyle())
                .onChange(of: isWindowManagerEnabled) { listening in
                    appDelegate.toggleWindowManager(listening)
                }
        }
        .padding(5)
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
    }
}

struct PopoverView: View {
    let systemInfoView: SystemInfoView
    let keyboardCleaningView: CleaningModeView
    let windowManagerView: WindowManagerView
    
    var body: some View {
        VStack(spacing: 0) {
            systemInfoView.padding()
            Divider()
            VStack {
                keyboardCleaningView
                windowManagerView
                Button(action: {
                    NSApplication.shared.terminate(self)
                }) {
                    Text("Quit")
                        .frame(maxWidth: .infinity)
                }.frame(maxWidth: .infinity)
            }.padding()
        }
    }
}

