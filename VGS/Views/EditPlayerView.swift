//
//  EditPlayerView.swift
//  VGS
//
//  Created by Huy Ong on 10/10/23.
//

import SwiftUI

struct EditPlayerView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var player: Player
    
    init(player: Player) {
        _player = .init(initialValue: player)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Circle()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(height: 100)
                        .foregroundStyle(.secondary)
                        .overlay(
                            Text(player.iniName)
                                .font(.title)
                                .bold()
                                .foregroundStyle(.white)
                        )
                }
                
                Section {
                    TextField("Name", text: $player.name)
                }
                
                Section {
                    Picker(selection: $player.number) {
                        ForEach(0...50, id: \.self) { number in
                            Text("\(number)")
                                .tag(number)
                        }
                    } label: {
                        Text("Number")
                    }
                    .pickerStyle(.menu)
                }
                
                Section {
                    Picker("Rank", selection: $player.rank) {
                        ForEach(1...3, id: \.self) { star in
                            Text("\(star)")
                                .tag(star)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section {
                    Picker(selection: $player.position) {
                        ForEach(Position.allCases) { position in
                            Text(position.rawValue)
                                .tag(position)
                        }
                    } label: {
                        Text("Position")
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        ForEach(Position.allCases) { position in
                            HStack {
                                Spacer()
                                Image(systemName: "circle.fill")
                                    .foregroundStyle(position.color)
                                Spacer()
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden, edges: .all)
                
            }
            .navigationTitle("Edit Player")
            .toolbar {
                Button("Save") {
                    if let index = viewModel.players.firstIndex(where: { $0.id == player.id }) {
                        viewModel.players[index] = self.player
                    } else {
                        viewModel.players.append(self.player)
                    }
                    dismiss()
                }
            }
        }
    }
}
