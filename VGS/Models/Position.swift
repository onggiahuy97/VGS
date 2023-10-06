//
//  Postion.swift
//  VGS
//
//  Created by Huy Ong on 9/28/23.
//

import Foundation

enum Position: String, CaseIterable, Identifiable, Codable {
    var id: String { self.rawValue }
    case CB, CM, FW
}
