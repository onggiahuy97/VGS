//
//  PlayerView.swift
//  VGS
//
//  Created by Huy Ong on 9/29/23.
//

import SwiftUI

struct PlayerView: View {
    @Binding var player: Player
    
    @State private var showEdit = false
    
    var body: some View {
        HStack {
            Image(systemName: "\(player.number).circle.fill")
                .imageScale(.large)
            Text(player.name)
                .bold()
            
            Spacer()
                .frame(maxWidth: .infinity)
                
            Text(player.position.rawValue)
        }
        .contentShape(Circle())
        .onTapGesture {
            self.showEdit.toggle()
        }
        .sheet(isPresented: $showEdit) {
            EditPlayerView(player: player)
        }
    }
}

struct StaticPlayerView: View {
    var player: Player
    
    var body: some View {
        HStack {
            Text(player.name)
                .bold()
            Spacer()
            Text(player.position.rawValue)
                .italic()
        }
        .buttonStyle(.plain)
    }
}

