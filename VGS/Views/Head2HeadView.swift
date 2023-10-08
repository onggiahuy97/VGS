//
//  LineUpTeamList.swift
//  VGS
//
//  Created by Huy Ong on 9/29/23.
//

import SwiftUI

struct Head2HeadView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    HStack {
                        Menu(viewModel.team1.name) {
                            ForEach(viewModel.teams) { team in
                                Button(team.name) {
                                    viewModel.team1 = team
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Image(systemName: "soccerball")
                        
                        Spacer()
                        
                        Menu(viewModel.team2.name) {
                            ForEach(viewModel.teams) { team in
                                Button(team.name) {
                                    viewModel.team2 = team
                                }
                            }
                        }

                    }
                    .bold()
                    .foregroundStyle(.blue)
                    .italic()
                    .foregroundStyle(.secondary)
                    
                    ForEach(Position.allCases) { position in
                        Divider()
                        Text(position.rawValue)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .italic()
                            .foregroundStyle(.secondary)
                        
                        
                        HStack {
                            VStack(alignment: .leading) {
                                let playersTeam1 = viewModel.team1.players.filter { $0.position == position }
                                ForEach(playersTeam1) { player in
                                    Text(player.name)
                                }
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                let playersTeam2 = viewModel.team2.players.filter { $0.position == position }
                                ForEach(playersTeam2) { player in
                                    Text(player.name)
                                }
                            }
                        }
                        .bold()
                    }
                }
                .padding()
            }
            .navigationTitle("Head to Head")
//            .toolbar {
//                ToolbarItem {
//                    Button("Random") {
//                        viewModel.splitTeam()
//                    }
//                }
//                
//                ToolbarItem(placement: .topBarLeading) {
//                    Picker("", selection: $viewModel.numberOfTeam) {
//                        ForEach(2...4, id: \.self) { number in
//                            Text("\(number) Teams")
//                                .tag(number)
//                            
//                        }
//                    }
//                }
//            }
        }
    }
}

extension Head2HeadView {
    static let tag: String? = "LineUpTeamList"
}

#Preview {
    Head2HeadView()
}
