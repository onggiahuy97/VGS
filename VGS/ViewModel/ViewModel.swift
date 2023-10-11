//
//  ViewModel.swift
//  VGS
//
//  Created by Huy Ong on 9/28/23.
//

import Foundation
import UIKit

class ViewModel: ObservableObject {
    @Published var tabSelection: String? = PlayersList.tag
    @Published var players: [Player] = []
    @Published var teams: [Team] = [] {
        didSet {
            if teams.count >= 2 {
                team1 = teams[0]
                team2 = teams[1]
            }
        }
    }
    @Published var numberOfTeam = 2 {
        didSet {
            splitTeam()
        }
    }
    
    @Published var team1: Team = .init(name: "", players: [])
    @Published var team2: Team = .init(name: "", players: [])
    
    @Published var screenSize: CGSize = .init()
        
    init() {
        checkIfFirstTime()
    }
    
    func swapPlayers(fromTeam: inout Team, fromPlayer: Player, toTeam: inout Team, toPlayer: Player) {
        let fromTeamPlayerOffset = fromPlayer.offset
        let toTeamPlayerOffset = toPlayer.offset
        
        guard let fromTeamPlayerIndex = fromTeam.players.firstIndex(where: { $0.id == fromPlayer.id })  else {
            return
        }
        
        guard let toTeamPlayerIndex = toTeam.players.firstIndex(where: { $0.id == toPlayer.id }) else {
            return
        }
        
        let tempPlayer = fromTeam.players[fromTeamPlayerIndex]
        
        fromTeam.players[fromTeamPlayerIndex] = toTeam.players[toTeamPlayerIndex]
        fromTeam.players[fromTeamPlayerIndex].offset = fromTeamPlayerOffset
        
        toTeam.players[toTeamPlayerIndex] = tempPlayer
        toTeam.players[toTeamPlayerIndex].offset = toTeamPlayerOffset
    }
    
    func checkIfFirstTime() {
        if UserDefaults.standard.object(forKey: "isFirstTime") == nil {
            players = Self.samplePlayers
            UserDefaults.standard.set(true, forKey: "isFirstTime")
        } else {
            decodeData()
            UserDefaults.standard.set(false, forKey: "isFirstTime")
        }
    }
    
    func saveData() {
        if let encodedData = try? JSONEncoder().encode(players) {
            UserDefaults.standard.set(encodedData, forKey: "players")
        }
    }
    
    func decodeData() {
        if let data = UserDefaults.standard.data(forKey: "players") {
            if let players = try? JSONDecoder().decode([Player].self, from: data) {
                self.players = players
            }
        }
    }
    
    func splitTeam() {
        
        teams = (0..<numberOfTeam).map { Team(name: "Team \($0 + 1)", players: []) }
        
        // For each position
//        for position in Position.allCases {
//
//            // Players with the same position
//            var playersWithPosition = players.filter { $0.position == position }
//
//            // Splitting players
//            var currentTeamIndex = 0
//            while !playersWithPosition.isEmpty {
//                let randomIndex = Int.random(in: 0..<playersWithPosition.count)
//                let randomPlayer = playersWithPosition.remove(at: randomIndex)
//                teams[currentTeamIndex].players.append(randomPlayer)
//                currentTeamIndex = currentTeamIndex == numberOfTeam - 1 ? 0 : currentTeamIndex + 1
//            }
//        }
        
        for position in Position.allCases {
            // Filter players based on their position.
            var playersOfPosition = players.filter { $0.position == position }
            playersOfPosition.sort(by: { $0.rank > $1.rank })

            // Distribute the highest rank players to teams.
            while !playersOfPosition.isEmpty {
                for i in 0..<numberOfTeam {
                    if !playersOfPosition.isEmpty {
                        var team = teams[i]
                        team.players.append(playersOfPosition.removeFirst())
                        teams[i] = team
                    }
                }
                
                // If players still remain, distribute them based on team rank sum.
                // This ensures that teams are balanced in terms of player ranks.
                while !playersOfPosition.isEmpty {
                    //ChatGPT :)))
                    if let minRankSumIndex = teams.enumerated().min(by: { $0.element.rankSum < $1.element.rankSum })?.offset {
                        var team = teams[minRankSumIndex]
                        team.players.append(playersOfPosition.removeFirst())
                        teams[minRankSumIndex] = team
                    }
                }
            }
        }
        
        team1 = teams[0]
        team2 = teams[1]
        
    }
    
    private func layoutTeam1Players(layouts: [TeamPostionLayout]) {
        for layout in layouts {
            let count = team1.players.filter { $0.position == layout.position }.count
            
            let positions = (0..<count).map { index -> CGPoint in
                let offset = Int(layout.rect.width) / count
                let x = CGFloat((offset * (index + 1)) - (offset / 2))
                let y = CGFloat(layout.rect.midY)
                return CGPoint(x: x, y: y)
            }
            
            switch layout.position {
            case .CB:
                team1.CBPositions = positions
            case .CM:
                team1.CMPositions = positions
            case .FW:
                team1.FWPositions = positions
            }
        }
        
        for i in 0..<team1.players.count {
            switch team1.players[i].position {
            case .CB:
                if !team1.CBPositions.isEmpty {
                    team1.players[i].offset = team1.CBPositions.removeFirst()
                }
            case .CM:
                if !team1.CMPositions.isEmpty {
                    team1.players[i].offset = team1.CMPositions.removeFirst()
                }
            case .FW:
                if !team1.FWPositions.isEmpty {
                    team1.players[i].offset = team1.FWPositions.removeFirst()
                }
            }
        }
    }
    
    private func layoutTeam2Players(layouts: [TeamPostionLayout]) {
        for layout in layouts {
            let count = team2.players.filter { $0.position == layout.position }.count
            
            let positions = (0..<count).map { index -> CGPoint in
                let offset = Int(layout.rect.width) / count
                let x = CGFloat((offset * (index + 1)) - (offset / 2))
                let y = CGFloat(layout.rect.midY)
                return CGPoint(x: x, y: y)
            }
            
            switch layout.position {
            case .CB:
                team2.CBPositions = positions
            case .CM:
                team2.CMPositions = positions
            case .FW:
                team2.FWPositions = positions
            }
        }
        
        for i in 0..<team2.players.count {
            switch team2.players[i].position {
            case .CB:
                if !team2.CBPositions.isEmpty {
                    team2.players[i].offset = team2.CBPositions.removeFirst()
                }
            case .CM:
                if !team2.CMPositions.isEmpty {
                    team2.players[i].offset = team2.CMPositions.removeFirst()
                }
            case .FW:
                if !team2.FWPositions.isEmpty {
                    team2.players[i].offset = team2.FWPositions.removeFirst()
                }
            }
        }
    }
    
    func lineupPlayers() {
        let width = screenSize.width
        let height = screenSize.height
        let portionHeight = height / 2 / 3
        let padding: CGFloat = 20
        let team2CB = CGRect(x: 0, y: 0 + padding, width: width, height: portionHeight)
        let team2CM = CGRect(x: 0, y: team2CB.height, width: width, height: portionHeight)
        let team2FW = CGRect(x: 0, y: team2CB.height * 2, width: width, height: portionHeight - 30)
        let team1FW = CGRect(x: 0, y: team2CB.height * 2 + padding, width: width, height: portionHeight + 120)
        let team1CM = CGRect(x: 0, y: team2CB.height * 3, width: width, height: portionHeight + 100)
        let team1CB = CGRect(x: 0, y: team2CB.height * 4 - padding, width: width, height: portionHeight + 100)
        
        let team1Layouts: [TeamPostionLayout] = [
            TeamPostionLayout(rect: team1CB, position: .CB),
            TeamPostionLayout(rect: team1CM, position: .CM),
            TeamPostionLayout(rect: team1FW, position: .FW),
        ]
        
        let team2Layouts: [TeamPostionLayout] = [
            TeamPostionLayout(rect: team2FW, position: .FW),
            TeamPostionLayout(rect: team2CM, position: .CM),
            TeamPostionLayout(rect: team2CB, position: .CB),
        ]
        
        layoutTeam1Players(layouts: team1Layouts)
        layoutTeam2Players(layouts: team2Layouts)
    
    }
}

extension CGPoint {
    static func randomPoint(in rect: CGRect) -> CGPoint {
        let randomX = CGFloat.random(in: rect.minX..<rect.maxX)
        let randomY = CGFloat.random(in: rect.midY..<rect.midY + 5)
        return CGPoint(x: randomX, y: randomY)
    }
}
extension ViewModel {
    static let samplePlayers: [Player] = [
        Player(name: "Huy Ong",   rank: 4,      position: .CM),
        Player(name: "Ha Tran",     rank: 4,    position: .CM),
        Player(name: "Quan Nho",    rank: 5,    position: .CM),
        Player(name: "Tri Le",      rank: 5,    position: .CB),
        Player(name: "Cuong Le",    rank: 5,    position: .CB),
        Player(name: "Khang Nguyen", rank: 4,   position: .CB),
        Player(name: "Hieu Nguyen",  rank: 3,   position: .CB),
        Player(name: "Ba Huy",       rank: 2,   position: .CB),
        Player(name: "Lam Le",       rank: 2,   position: .CB),
        Player(name: "Phap Le",      rank: 4,   position: .FW),
        Player(name: "Luan Le",      rank: 3,   position: .CM),
        Player(name: "Duong Cao",   rank: 4,     position: .FW),
        Player(name: "Luc Le",       rank: 5,    position: .FW),
        Player(name: "Hung Tran",    rank: 4,    position: .FW),
        Player(name: "Nhan Ton",     rank: 3,    position: .FW),
    ]
}
