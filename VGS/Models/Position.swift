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
    
    static let opacity: CGFloat = 0.8
    
    var color: Color {
        switch self {
        case .CB:
            return .teal.opacity(Self.opacity)
        case .CM:
            return .brown.opacity(Self.opacity)
        case .FW:
            return .pink.opacity(Self.opacity)
        }
    }
}
