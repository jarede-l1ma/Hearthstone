//
//  Card.swift
//  Hearthstone
//
//  Created by Jarede Lima on 29/03/24.
//

import Foundation

//// MARK: - Card

struct Card: Decodable {
    let name: String?
    let img: String?
    let flavor: String?
    let text: String?
    let cardSet: String?
    let type: String?
    let faction: String?
    let rarity: String?
    let attack: Int?
    let cost: Int?
    let health: Int?
}

enum Faction: String {
    case alliance = "Alliance"
    case horde = "Horde"
    case neutral = "Neutral"
}
