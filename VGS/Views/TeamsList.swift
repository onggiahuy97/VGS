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
                ForEach(viewModel.teams) { team in
                    Section("\(team.name) - \(team.players.count) players") {
                        let positions = Position.allCases.map { $0.rawValue }
                        let sortedPlayer = team.players.sorted { p1, p2 in
                            guard let index1 = positions.firstIndex(of: p1.position.rawValue),
                                  let index2 = positions.firstIndex(of: p2.position.rawValue) else {
                                return false
                            }
                            return index1 < index2
                        }
                        
                        ForEach(sortedPlayer) { player in
                            Menu {
                                ForEach(viewModel.teams) { t in
                                    Button {
                                        let newTeamIndex = viewModel.teams.firstIndex(where: { $0.id == t.id })
                                        let currentTeamIndex = viewModel.teams.firstIndex(where: { $0.id == team.id })
                                        viewModel.teams[newTeamIndex!].players.append(player)
                                        viewModel.teams[currentTeamIndex!].players.removeAll(where: { $0.id == player.id })
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
