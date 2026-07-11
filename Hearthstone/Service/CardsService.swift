import Foundation
import Combine

struct CardsService: CardsServiceInterface {
    
    private static var cachedCards: [Card] = []
    
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error> {
        // Return filtered cached cards immediately if cache is populated
        if !Self.cachedCards.isEmpty {
            let filtered = filter(cards: Self.cachedCards, for: faction)
            return Just(filtered)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let urlString = "https://api.hearthstonejson.com/v1/latest/enUS/cards.collectible.json"
        guard let url = URL(string: urlString) else {
            return Just(mockCards(for: faction))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Card].self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { cards in
                Self.cachedCards = cards
            })
            .map { cards in
                self.filter(cards: cards, for: faction)
            }
            .catch { error -> AnyPublisher<[Card], Error> in
                // Fallback to local mock cards on network failure
                return Just(self.mockCards(for: faction))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func filter(cards: [Card], for faction: String) -> [Card] {
        let filtered: [Card]
        if faction.lowercased() == "alliance" {
            filtered = cards.filter { $0.faction?.lowercased() == "alliance" }
        } else if faction.lowercased() == "horde" {
            filtered = cards.filter { $0.faction?.lowercased() == "horde" }
        } else {
            // Neutral (collectible cards without Alliance or Horde faction)
            filtered = cards.filter { $0.faction == nil }
        }
        // Limit to 40 cards to keep UI lightweight and fast
        return Array(filtered.prefix(40))
    }
    
    private func mockCards(for faction: String) -> [Card] {
        switch faction.lowercased() {
        case "alliance":
            return [
                Card(name: "Tirion Fordring",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_383.png",
                     flavor: "If you cut him, does he not bleed... gold?",
                     text: "Divine Shield. Taunt. Deathrattle: Equip a 5/3 Ashbringer.",
                     cardSet: "Classic",
                     type: "Minion",
                     faction: "Alliance",
                     rarity: "Legendary",
                     attack: 6,
                     cost: 8,
                     health: 6),
                Card(name: "Jaina Proudmoore",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/HERO_08.png",
                     flavor: "The ruler of Theramore and archmage of the Kirin Tor.",
                     text: "Summon a Water Elemental.",
                     cardSet: "Core",
                     type: "Hero",
                     faction: "Alliance",
                     rarity: "Legendary",
                     attack: 0,
                     cost: 8,
                     health: 30),
                Card(name: "Anduin Wrynn",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/HERO_09.png",
                     flavor: "The young prince of Stormwind is wise beyond his years.",
                     text: "Lesser Heal: Restore 2 Health.",
                     cardSet: "Core",
                     type: "Hero",
                     faction: "Alliance",
                     rarity: "Legendary",
                     attack: 0,
                     cost: 5,
                     health: 30),
                Card(name: "Bolvar Fordragon",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/GVG_063.png",
                     flavor: "Bolvar leads the Alliance forces in the battle against the Scourge.",
                     text: "Whenever a friendly minion dies while this is in your hand, gain +1 Attack.",
                     cardSet: "Goblins vs Gnomes",
                     type: "Minion",
                     faction: "Alliance",
                     rarity: "Legendary",
                     attack: 1,
                     cost: 5,
                     health: 7),
                Card(name: "Varian Wrynn",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/AT_072.png",
                     flavor: "Leader of the Alliance. Father of Anduin. Lover of giant shoulderpads.",
                     text: "Battlecry: Draw 3 cards. Put any minions you drew directly into the battlefield.",
                     cardSet: "The Grand Tournament",
                     type: "Minion",
                     faction: "Alliance",
                     rarity: "Legendary",
                     attack: 7,
                     cost: 10,
                     health: 7)
            ]
        case "horde":
            return [
                Card(name: "Garrosh Hellscream",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_414.png",
                     flavor: "The Warchief of the Horde is fierce, proud, and uncompromising.",
                     text: "Charge. Has +6 Attack while damaged.",
                     cardSet: "Classic",
                     type: "Minion",
                     faction: "Horde",
                     rarity: "Legendary",
                     attack: 4,
                     cost: 8,
                     health: 9),
                Card(name: "Thrall",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/HERO_02.png",
                     flavor: "The former Warchief of the Horde and Earthwarden of Azeroth.",
                     text: "Totem Call: Summon a random Totem.",
                     cardSet: "Core",
                     type: "Hero",
                     faction: "Horde",
                     rarity: "Legendary",
                     attack: 0,
                     cost: 5,
                     health: 30),
                Card(name: "Cairne Bloodhoof",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_162.png",
                     flavor: "Cairne was the Chief of the United Tauren Tribes.",
                     text: "Deathrattle: Summon a 4/5 Baine Bloodhoof.",
                     cardSet: "Classic",
                     type: "Minion",
                     faction: "Horde",
                     rarity: "Legendary",
                     attack: 4,
                     cost: 6,
                     health: 5),
                Card(name: "Vol'jin",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/GVG_014.png",
                     flavor: "Vol'jin was the leader of the Darkspear Trolls and Warchief of the Horde.",
                     text: "Battlecry: Swap Health with another minion.",
                     cardSet: "Goblins vs Gnomes",
                     type: "Minion",
                     faction: "Horde",
                     rarity: "Legendary",
                     attack: 6,
                     cost: 5,
                     health: 2)
            ]
        default: // neutral
            return [
                Card(name: "Ragnaros the Firelord",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_298.png",
                     flavor: "Ragnaros was summoned by the Dark Iron Dwarves, who were then enslaved by him.",
                     text: "Can't attack. At the end of your turn, deal 8 damage to a random enemy.",
                     cardSet: "Classic",
                     type: "Minion",
                     faction: "Neutral",
                     rarity: "Legendary",
                     attack: 8,
                     cost: 8,
                     health: 8),
                Card(name: "Ysera",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_572.png",
                     flavor: "Ysera rules the Emerald Dream.",
                     text: "At the end of your turn, add a Dream Card to your hand.",
                     cardSet: "Classic",
                     type: "Minion",
                     faction: "Neutral",
                     rarity: "Legendary",
                     attack: 4,
                     cost: 9,
                     health: 12),
                Card(name: "Alexstrasza",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_561.png",
                     flavor: "Alexstrasza the Life-Binder brings life and hope.",
                     text: "Battlecry: Set a hero's remaining Health to 15.",
                     cardSet: "Classic",
                     type: "Minion",
                     faction: "Neutral",
                     rarity: "Legendary",
                     attack: 8,
                     cost: 9,
                     health: 8),
                Card(name: "Leeroy Jenkins",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_116.png",
                     flavor: "At least he has chicken.",
                     text: "Charge. Battlecry: Summon two 1/1 Whelps for your opponent.",
                     cardSet: "Classic",
                     type: "Minion",
                     faction: "Neutral",
                     rarity: "Legendary",
                     attack: 6,
                     cost: 5,
                     health: 2),
                Card(name: "Malygos",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_563.png",
                     flavor: "Malygos is the Aspect of Magic.",
                     text: "Spell Damage +5",
                     cardSet: "Classic",
                     type: "Minion",
                     faction: "Neutral",
                     rarity: "Legendary",
                     attack: 4,
                     cost: 9,
                     health: 12)
            ]
        }
    }
}
