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
        HStack(alignment: .center) {
            Image(systemName: "\(player.number).circle.fill")
                .font(.title)
            
            Text(player.name)
                .bold()
            
            Spacer()
                .frame(maxWidth: .infinity)
                
            VStack(alignment: .trailing) {
                Text(player.position.rawValue)
                
                HStack(spacing: 3) {
                    ForEach(1...3, id: \.self) { star in
                        Image(systemName: player.rank >= star ? "circle.fill" : "circle")
                            .font(.system(size: 6))
                    }
                }
            }
        }
        .padding(.vertical, 3)
        .contentShape(Rectangle())
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
        HStack(alignment: .center) {
            Image(systemName: "\(player.number).circle.fill")
                .font(.title)
            
            Text(player.name)
                .bold()
            
            Spacer()
                .frame(maxWidth: .infinity)
            
            VStack(alignment: .trailing) {
                Text(player.position.rawValue)

                HStack(spacing: 3) {
                    ForEach(1...3, id: \.self) { star in
                        Image(systemName: player.rank >= star ? "circle.fill" : "circle")
                            .font(.system(size: 6))
                    }
                }
            }
        }
        .padding(.vertical, 3)
    }
}

