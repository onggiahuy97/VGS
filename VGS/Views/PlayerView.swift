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
            Spacer()
            Picker("", selection: $player.rank) {
                ForEach(1...5, id:\.self) { number in
                    Text("\(number)").tag(number)
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
            Spacer()
            Text("\(player.rank)")
        }
        .buttonStyle(.plain)
    }
}

