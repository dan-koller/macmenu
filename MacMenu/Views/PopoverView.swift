//
//  PopoverView.swift
//  MacMenu
//
//  Created by Daniel Koller on 18.10.23.
//

import SwiftUI

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
