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
    // 'rankSum' that calculates the total rank of all players in the team.
    var rankSum: Int{
        return players.reduce(0, { $0 + $1.rank })
    }
    var CBPositions: [CGPoint] = []
    var CMPositions: [CGPoint] = []
    var FWPositions: [CGPoint] = []
}
