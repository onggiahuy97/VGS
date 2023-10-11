//
//  Team.swift
//  VGS
//
//  Created by Huy Ong on 9/29/23.
//

import Foundation

struct Team: Identifiable {
    var id = UUID()
    var name: String
    var players: [Player]
    var CBPositions: [CGPoint] = []
    var CMPositions: [CGPoint] = []
    var FWPositions: [CGPoint] = []
    
    var totalRank: Int {
        return players.map(\.rank).reduce(0, +)
    }
    
    var sortedPlayersByPosition: [Player] {
        let positions = Position.allCases.map { $0.rawValue }
        let sortedPlayer = self.players.sorted { p1, p2 in
            guard let index1 = positions.firstIndex(of: p1.position.rawValue),
                  let index2 = positions.firstIndex(of: p2.position.rawValue) else {
                return false
            }
            return index1 < index2
        }
        return sortedPlayer
    }
}
