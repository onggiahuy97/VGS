//
//  Player.swift
//  VGS
//
//  Created by Huy Ong on 9/28/23.
//

import Foundation
import UIKit

struct Player: Identifiable, Codable {
    var id = UUID()
    var name: String
    var position: Position
    
    var offset: CGPoint = .zero
    var isDragging: Bool = false
    var iniName: String {
        let components = name.components(separatedBy: .whitespacesAndNewlines)
        let fName = String(components.first?.first ?? Character("")).uppercased()
        let lName = String(components.last?.first ?? Character("")).uppercased()
        return fName + lName
    }
}
