//
//  ContentView.swift
//  VGS
//
//  Created by Huy Ong on 9/28/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        TabView(selection: $viewModel.tabSelection) {
            
            PlayersList()
                .tag(PlayersList.tag)
                .tabItem {
                    Label("Players", systemImage: "person.text.rectangle")
                }
            
            TeamsList() 
                .tag(TeamsList.tag)
                .tabItem {
                    Label("Teams", systemImage: "person.3.fill")
                }
            
            LineUpView()
                .tag(LineUpView.tag)
                .tabItem {
                    Label("Lineup", systemImage: "clipboard")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}

