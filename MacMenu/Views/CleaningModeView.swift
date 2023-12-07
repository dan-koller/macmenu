//
//  CleaningModeView.swift
//  MacMenu
//
//  Created by Daniel Koller on 18.10.23.
//

import SwiftUI

struct CleaningModeView: View {
    @State private var isCleaningEnabled = false
    @State private var remainingTime = 20 // Initial value for demonstration purposes
    @State private var timer: Timer?

    // The cleaning mode gets automatically disabled after 20 seconds, to handle edge cases
    // where the user has no access to the mouse and therefore couldn't toggle off the
    // keyboard input interception.
    var body: some View {
        let appDelegate = NSApp.delegate as! AppDelegate

        HStack {
            Text("Cleaning mode" + (isCleaningEnabled ? " (\(remainingTime) seconds...)" : ""))
                .font(.headline)

            Spacer()

            Toggle("", isOn: $isCleaningEnabled)
                .toggleStyle(SwitchToggleStyle())
                .onChange(of: isCleaningEnabled) { listening in
                    appDelegate.toggleCleaningMode(listening)

                    if listening {
                        startTimer()
                    } else {
                        stopTimer()
                    }
                }
        }
        .padding(5)
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                resetCleaningMode()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        remainingTime = 20 // Reset the remaining time for the next use
    }

    private func resetCleaningMode() {
        isCleaningEnabled = false
        stopTimer()
        remainingTime = 20 // Reset the remaining time for the next use
    }
}

