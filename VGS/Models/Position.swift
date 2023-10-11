//
//  Postion.swift
//  VGS
//
//  Created by Huy Ong on 9/28/23.
//

import Foundation
import SwiftUI

enum Position: String, CaseIterable, Identifiable, Codable {
    var id: String { self.rawValue }
    case CB, CM, FW
    
    var color: Color {
        switch self {
        case .CB:
            return .green
        case .CM:
            return .blue
        case .FW:
            return .red
        }
    }
}
