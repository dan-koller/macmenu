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
