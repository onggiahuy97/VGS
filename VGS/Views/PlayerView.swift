//
//  PlayerView.swift
//  VGS
//
//  Created by Huy Ong on 9/29/23.
//

import SwiftUI

struct PlayerView: View {
    @Binding var player: Player
    
    var body: some View {
        HStack {
            Text(player.name)
                .bold()
            Spacer()
            Picker("", selection: $player.position) {
                ForEach(Position.allCases) { position in
                    Text(position.rawValue)
                        .tag(position)
                        .italic()
                }
            }
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

