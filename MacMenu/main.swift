//
//  main.swift
//  MacMenu
//
//  Created by Daniel Koller on 31.08.23.
//

import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
