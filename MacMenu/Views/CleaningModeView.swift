//
//  CleaningModeView.swift
//  MacMenu
//
//  Created by Daniel Koller on 18.10.23.
//

import SwiftUI

struct CleaningModeView: View {
    @State private var isCleaningEnabled = false

    var body: some View {
        let appDelegate = NSApp.delegate as! AppDelegate
        HStack {
            Text("Cleaning mode")
                .font(.headline)
            
            Spacer()
            
            Toggle("", isOn: $isCleaningEnabled)
                .toggleStyle(SwitchToggleStyle())
                .onChange(of: isCleaningEnabled) { listening in
                    appDelegate.toggleCleaningMode(listening)
                }
        }
        .padding(5)
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
    }
}
