//
//  VGSApp.swift
//  VGS
//
//  Created by Huy Ong on 9/28/23.
//

import SwiftUI

@main
struct VGSApp: App {
    @StateObject var viewModel = ViewModel()
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { proxy in
                ContentView()
                    .environmentObject(viewModel)
                    .onAppear {
                        viewModel.screenSize = proxy.size
                    }
            }
            
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .background || newValue == .inactive {
                print("Data is being saved")
                viewModel.saveData()
            }
        }
    }
}


