//
//  WindowManagerView.swift
//  MacMenu
//
//  Created by Daniel Koller on 18.10.23.
//

import SwiftUI

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
