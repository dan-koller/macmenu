//
//  SystemInfo.swift
//  MacMenu
//
//  Created by Daniel Koller on 12.09.23.
//

import Foundation

class SystemInfo {
    func getArchitecture() -> String? {
        guard let cpuArchitecture = getCPUArchitecture() else {
            return nil
        }
        let arch = String(cString: cpuArchitecture)
        free(UnsafeMutablePointer(mutating: cpuArchitecture))
        return arch
    }
    
    func DEBUG_CPU_LOAD() -> Float {
        let load = getCPULoad()
        return load
    }
    
    func DEBUG_MEMORY_USAGE() -> Float {
        let usage = getSystemMemoryUsagePercentage()
        return usage
    }
    
    func getDisk() -> Float {
        let ratio = getDiskUsage()
        return ratio
    }

    // This function is just meant to be used for debugging
    func printSystemInfo() {
        func printInfo(_ label: String, value: Float?, unit: String = "%") {
            if let value = value {
                print("\(label): \(String(format: "%.2f\(unit)", value * 100.0))")
            } else {
                print("Failed to retrieve \(label.lowercased())")
            }
        }

        if let cpuArchitecture = getCPUArchitecture() {
            print("CPU Architecture: \(String(cString: cpuArchitecture))")
            free(UnsafeMutablePointer(mutating: cpuArchitecture))
        } else {
            print("Failed to retrieve CPU architecture.")
        }

        printInfo("CPU Usage", value: getCPULoad())
        printInfo("System Memory Ratio", value: getSystemMemoryUsagePercentage())
        printInfo("Disk Usage", value: getDiskUsage())
    }
}

