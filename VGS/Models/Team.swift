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
}
