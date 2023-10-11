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
    @State private var showAddNewPlayer = false
    var body: some View {
        NavigationStack {
            List {
//                VStack {
//                    HStack {
//                        TextField("Name", text: $name)
//                            .textInputAutocapitalization(.words)
//                        
//                        Button {
//                            if !name.isEmpty {
//                                let newPlayer = Player(name: name, position: position)
//                                viewModel.players.append(newPlayer)
//                                name = ""
//                            }
//                        } label: {
//                            Image(systemName: "arrow.down")
//                        }
//                    }
//                    
//                    Picker("Position", selection: $position) {
//                        ForEach(Position.allCases) { pos in
//                            HStack {
//                                Image(systemName: "circle.fill")
//                                    .imageScale(.small)
//                                    .foregroundStyle(pos.color)
//                                Text(pos.rawValue)
//                            }
//                            .tag(pos)
//                        }
//                    }
//                    .pickerStyle(.segmented)
//                    
//                }
                
                ForEach(Position.allCases) { position in
                    let players = viewModel.players.filter { $0.position == position }
                    Section("\(position.rawValue) (\(players.count))") {
                        ForEach($viewModel.players
                            .filter { player in
                                let playerPosition = player.wrappedValue.position
                                return playerPosition == position
                            }
                            .sorted { $0.wrappedValue.rank > $1.wrappedValue.rank }
                        ) { $player in
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
//                Button("JSON") {
//                    do {
//                        let encoder = JSONEncoder()
//                        encoder.outputFormatting = .prettyPrinted
//                        let encodedData = try encoder.encode(viewModel.players)
//                        if let json = String(data: encodedData, encoding: .utf8) {
//                            print(json)
//                        }
//                    } catch {
//                        print(error)
//                    }
//                }
                
                Button("Add") {
                    showAddNewPlayer = true
                }
                .sheet(isPresented: $showAddNewPlayer) {
                    let player = Player(name: "", position: .CB)
                    EditPlayerView(player: player)
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
        .environmentObject(ViewModel())
}
