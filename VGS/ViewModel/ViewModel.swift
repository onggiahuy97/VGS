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
    @Published var teams: [Team] = [] 
    @Published var numberOfTeam = 2 {
        didSet {
            splitTeam()
        }
    }
    
    @Published var team1: Team = .init(name: "", players: [])
    @Published var team2: Team = .init(name: "", players: [])
    
    @Published var screenSize: CGSize = .init()
        
    init() {
        decodeData()
    }
    
//    func printJSON() {
//        do {
//            struct PlayerJSON: Codable {
//                var id: String
//                var name: String
//                var position: String
//                var number: Int
//                var rank: Int
//            }
//            
//            let jsonPlayers = players.map { PlayerJSON(id: $0.id.uuidString, name: $0.name, position: $0.position.rawValue, number: $0.number, rank: $0.rank) }
//            
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            let jsonData = try encoder.encode(jsonPlayers)
//            if let string = String(data: jsonData, encoding: .utf8) {
//                print(string)
//            }
//            
//        } catch {
//            print(error)
//        }
//    }
//    
//    func getPlayersFromCloud() {
//        guard let url = URL(string: "http://localhost:3000/players") else {
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse else {
//                print("Invalid response")
//                return
//            }
//            
//            if httpResponse.statusCode == 200 {
//                if let data = data {
//                    do {
//                        // Assuming your response data is JSON, you can parse it here
//                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                        print(json)
//                    } catch {
//                        print("Error parsing JSON: \(error)")
//                    }
//                }
//            } else {
//                print("HTTP status code: \(httpResponse.statusCode)")
//            }
//        }.resume()
//    }

    
    func updatePlayersAndTeams() {

        if teams.count >= 2 {
            team1 = teams[0]
            team2 = teams[1]
            
            lineupPlayers()
        }
        
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
        
        if let indexToTeam = teams.firstIndex(where: { $0.id == toTeam.id }) {
            teams[indexToTeam] = toTeam
        }
        
        if let indexFromTeam = teams.firstIndex(where: { $0.id == fromTeam.id }) {
            teams[indexFromTeam] = fromTeam
        }
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
        
        for position in Position.allCases {
            var playersOfPosition = players.filter { $0.position == position }
            playersOfPosition.sort(by: { $0.rank > $1.rank })
            
            // Shuffle players by their rank
            var shufflePlayers = [Player]()
            
            for rank in 1...3 {
                let shufflePlayersOfPosition = playersOfPosition.filter { $0.rank == rank }.shuffled()
                shufflePlayers.append(contentsOf: shufflePlayersOfPosition)
            }
            
            while !shufflePlayers.isEmpty {
                if let minRankSumTeam = teams.min(by: { $0.totalRank < $1.totalRank }),
                   let minRankSumTeamIndex = teams.firstIndex(where: { $0.id == minRankSumTeam.id }) {
                    teams[minRankSumTeamIndex].players.append(shufflePlayers.removeFirst())
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
        Player(name: "Huy Ong",         position: .CM, rank: 2),
        Player(name: "Ha Tran",         position: .CM, rank: 3),
        Player(name: "Quan Nho",        position: .CM, rank: 3),
        Player(name: "Tri Le",          position: .CB, rank: 3),
        Player(name: "Cuong Le",        position: .CB, rank: 3),
        Player(name: "Khang Nguyen",    position: .CB, rank: 3),
        Player(name: "Hieu Nguyen",     position: .CB, rank: 2),
        Player(name: "Ba Huy",          position: .CB, rank: 1),
        Player(name: "Lam Le",          position: .CB, rank: 1),
        Player(name: "Phap Le",         position: .FW, rank: 3),
        Player(name: "Luan Le",         position: .FW, rank: 2),
        Player(name: "Duong Cao",       position: .FW, rank: 2),
        Player(name: "Luc Le",          position: .FW, rank: 3),
        Player(name: "Hung Tran",       position: .FW, rank: 2),
        Player(name: "Nhan Ton",        position: .FW, rank: 2),
    ]
}
