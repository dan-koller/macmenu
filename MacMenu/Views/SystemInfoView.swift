//
//  SystemInfoView.swift
//  MacMenu
//
//  Created by Daniel Koller on 18.10.23.
//

import SwiftUI
import SISwift

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
