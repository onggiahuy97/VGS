//
//  TeamsList.swift
//  VGS
//
//  Created by Huy Ong on 9/29/23.
//

import SwiftUI

struct TeamsList: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    ForEach(Position.allCases) { position in
                        Spacer()
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundStyle(position.color)
                            Text(position.rawValue)
                        }
                        Spacer()
                    }
                }
                
                ForEach(viewModel.teams) { team in
                    Section("\(team.name) - \(team.players.count) players - \(team.totalRank) ranks") {
                        ForEach(team.sortedPlayersByPosition) { player in
                            Menu {
                                ForEach(viewModel.teams) { t in
                                    Button {
                                        let newTeamIndex = viewModel.teams.firstIndex(where: { $0.id == t.id })
                                        let currentTeamIndex = viewModel.teams.firstIndex(where: { $0.id == team.id })
                                        viewModel.teams[newTeamIndex!].players.append(player)
                                        viewModel.teams[currentTeamIndex!].players.removeAll(where: { $0.id == player.id })
                                        viewModel.updatePlayersAndTeams()
                                    } label: {
                                        let currentPlayerTeam = t.players.contains(where: { $0.id == player.id })
                                        Label(t.name, systemImage: currentPlayerTeam ? "checkmark" : "")
                                    }
                                }
                            } label: {
                                StaticPlayerView(player: player)
                                    .foregroundStyle(scheme == .dark ? .white : .black)
                            }
                        }
                    }
                }
            }
            .overlay(
                VStack(alignment: .center) {
                    Text("There is no team yet!")
                    Button("Random Team") {
                        viewModel.splitTeam()
                    }
                    .buttonStyle(.bordered)
                }
                    .opacity(viewModel.teams.isEmpty ? 1 : 0)
            )
            .navigationTitle("Teams")
            .toolbar {
                ToolbarItem {
                    Menu("Option", systemImage: "person.line.dotted.person.fill") {
                        Button {
                            viewModel.splitTeam()
                        } label: {
                            Label("Random Players", systemImage: "person.2")
                        }
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

extension TeamsList {
    static let tag: String? = "TeamsList"
}

#Preview {
    TeamsList()
        .environmentObject(ViewModel())
}
