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
    var number: Int = (0...50).randomElement()!
    var rank: Int = 1
    
    var offset: CGPoint = .zero
    var isDragging: Bool = false
    
    var iniName: String {
        createInitials(from: name)
    }
}

func createInitials(from name: String) -> String {
    let components = name.split { $0.isWhitespace || $0.isNewline }
    
    if components.count >= 2 {
        let firstName = components[0]
        let lastName = components[components.count - 1]
        
        if let firstInitial = firstName.first, let lastInitial = lastName.first {
            return "\(firstInitial)\(lastInitial)".uppercased()
        } else {
            // Handle the case where first or last name is an empty string
            return name.uppercased()
        }
    } else {
        // Handle the case where there are no whitespace-separated components
        return name.uppercased()
    }
}
