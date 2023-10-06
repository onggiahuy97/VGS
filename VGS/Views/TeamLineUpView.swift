//
//  TeamLineUpView.swift
//  VGS
//
//  Created by Huy Ong on 10/5/23.
//

import SwiftUI

struct TeamLineUpView: View {
    @Binding var team: Team
    var color: Color
    
    var body: some View {
        ForEach($team.players) { $player in
            VStack {
                Circle()
                    .fill(color)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(player.iniName)
                            .bold()
                            .foregroundStyle(.white)
                    )
                
                Text("\(player.position.rawValue) · \(player.name)")
                    .padding(3)
                    .background(.thickMaterial)
                    .clipShape(.rect(cornerRadius: 5))
                    .font(.caption)
                
            }
            .position(player.offset)
            .scaleEffect(player.isDragging ? 1.1 : 1)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(.spring) {
                            player.isDragging = true
                        }
                        player.offset = value.location
                    }
                    .onEnded { _ in
                        withAnimation(.spring) {
                            player.isDragging = false
                        }
                    }
            )
            
        }
    }
}
