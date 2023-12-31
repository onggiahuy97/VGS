//
//  TeamLineUpView.swift
//  VGS
//
//  Created by Huy Ong on 10/5/23.
//

import SwiftUI

struct TeamLineUpView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Binding var team: Team
    var color: Color
    
    @State private var showChangePlayer = false
    @State private var currentPlayer: Player?
    
    var body: some View {
        ForEach($team.players) { $player in
            VStack(spacing: 3) {
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
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        self.currentPlayer = player
                        showChangePlayer.toggle()
                    }
            )
            .sheet(isPresented: $showChangePlayer) {
                if let currentPlayer {
                    NavigationStack {
                        let isFromTeam1 = viewModel.team1.players.contains(where: { $0.id == currentPlayer.id })
                        let toTeam = viewModel
                            .team1.players.contains(where: { $0.id == currentPlayer.id }) ? viewModel.team2 : viewModel.team1
                        List {
                            Section(toTeam.name) {
                                
                                ForEach(toTeam.sortedPlayersByPosition) { toPlayer in
                                    Button {
                                        if isFromTeam1 {
                                            viewModel.swapPlayers(
                                                fromTeam: &viewModel.team1,
                                                fromPlayer: currentPlayer,
                                                toTeam: &viewModel.team2,
                                                toPlayer: toPlayer
                                            )
                                        } else {
                                            viewModel.swapPlayers(
                                                fromTeam: &viewModel.team2,
                                                fromPlayer: currentPlayer,
                                                toTeam: &viewModel.team1,
                                                toPlayer: toPlayer
                                            )
                                        }
                                        
                                        showChangePlayer = false
                                    } label: {
                                        StaticPlayerView(player: toPlayer)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            Section {
                                Button("Move \(currentPlayer.name) to \(toTeam.name)") {
                                    guard let indexFromTeam = viewModel.teams.firstIndex(where: { t in
                                        return t.players.contains(where: { $0.id == currentPlayer.id })
                                    }) else {
                                        return
                                    }
                                    
                                    guard let indexToTeam = viewModel.teams.firstIndex(where: { $0.id == toTeam.id }) else {
                                        return
                                    }
                                    
                                    viewModel.teams[indexToTeam].players.append(currentPlayer)
                                    viewModel.teams[indexFromTeam].players.removeAll(where: { $0.id == currentPlayer.id })
                                    viewModel.updatePlayersAndTeams()
                                    viewModel.lineupPlayers()
                                    
                                    showChangePlayer = false
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                        .navigationTitle("Swap Player")
                        .toolbar {
                            Button("Done") {
                                showChangePlayer = false
                            }
                        }
                    }
                }
            }
        }
    }
}
