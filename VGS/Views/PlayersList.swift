//
//  PlayersList.swift
//  VGS
//
//  Created by Huy Ong on 9/28/23.
//

import SwiftUI

struct PlayersList: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var name: String = ""
    @State private var position: Position = .CB
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    TextField("Name", text: $name)
                        .textInputAutocapitalization(.words)
                    HStack {
                        Picker("Position", selection: $position) {
                            ForEach(Position.allCases) { pos in
                                Text(pos.rawValue)
                                    .tag(pos)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    Button {
                        if !name.isEmpty {
                            let newPlayer = Player(name: name, position: position)
                            viewModel.players.append(newPlayer)
                            name = ""
                        }
                    } label: {
                        Image(systemName: "arrow.down")
                    }
                }
                
                ForEach(Position.allCases) { position in
                    let players = viewModel.players.filter { $0.position == position }
                    Section("\(position.rawValue) (\(players.count))") {
                        ForEach($viewModel.players.filter { player in
                            let playerPosition = player.wrappedValue.position
                            return playerPosition == position
                        }) { $player in
                            PlayerView(player: $player)
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                let player = players[index]
                                viewModel.players.removeAll(where: { $0.id == player.id })
                                viewModel.teams.removeAll { team in
                                    team.players.contains(where: { $0.id == player.id })
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Players")
            .toolbar {
                ToolbarItem {
                    Button("Random") {
                        viewModel.splitTeam()
                        viewModel.tabSelection = TeamsList.tag
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Picker("", selection: $viewModel.numberOfTeam) {
                        ForEach(2...4, id: \.self) { number in
                            Text("\(number) Teams")
                                .tag(number)
                            
                        }
                    }
                }
            }
        }
    }
}

extension PlayersList {
    static let tag: String? = "PlayersList"
}

#Preview {
    PlayersList()
}
