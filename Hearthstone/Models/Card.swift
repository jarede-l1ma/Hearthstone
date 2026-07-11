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
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case flavor
        case text
        case set
        case type
        case faction
        case rarity
        case attack
        case cost
        case health
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.flavor = try container.decodeIfPresent(String.self, forKey: .flavor)
        self.text = try container.decodeIfPresent(String.self, forKey: .text)
        self.cardSet = try container.decodeIfPresent(String.self, forKey: .set)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.faction = try container.decodeIfPresent(String.self, forKey: .faction)
        self.rarity = try container.decodeIfPresent(String.self, forKey: .rarity)
        self.attack = try container.decodeIfPresent(Int.self, forKey: .attack)
        self.cost = try container.decodeIfPresent(Int.self, forKey: .cost)
        self.health = try container.decodeIfPresent(Int.self, forKey: .health)
        
        if let cardId = try container.decodeIfPresent(String.self, forKey: .id) {
            self.img = "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/\(cardId).png"
        } else {
            self.img = nil
        }
    }
    
    init(name: String?, img: String?, flavor: String?, text: String?, cardSet: String?, type: String?, faction: String?, rarity: String?, attack: Int?, cost: Int?, health: Int?) {
        self.name = name
        self.img = img
        self.flavor = flavor
        self.text = text
        self.cardSet = cardSet
        self.type = type
        self.faction = faction
        self.rarity = rarity
        self.attack = attack
        self.cost = cost
        self.health = health
    }
}

enum Faction: String {
    case alliance = "Alliance"
    case horde = "Horde"
    case neutral = "Neutral"
}
