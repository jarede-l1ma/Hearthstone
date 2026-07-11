import Foundation
import Combine

struct CardsService: CardsServiceInterface {
    
    // MARK: - Static In-Memory Cache
    private static var cachedCards: [Card] = []
    
    // MARK: - Disk Cache Configuration
    private static let cacheFileName = "hearthstone_cards_cache.json"
    
    private static var cacheFileURL: URL? {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(cacheFileName)
    }
    
    // MARK: - CardsServiceInterface
    
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error> {
        // 1. Memory cache hit → instant return
        if !Self.cachedCards.isEmpty {
            let filtered = filter(cards: Self.cachedCards, for: faction)
            return Just(filtered)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        // 2. Disk cache hit → load from file, populate memory, return
        if let diskCards = Self.loadFromDisk(), !diskCards.isEmpty {
            Self.cachedCards = diskCards
            let filtered = filter(cards: diskCards, for: faction)
            
            // Silently refresh from network in background
            refreshFromNetwork()
            
            return Just(filtered)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        // 3. No cache → fetch from network
        return fetchFromNetwork(faction: faction)
    }
    
    // MARK: - Network
    
    private func fetchFromNetwork(faction: String) -> AnyPublisher<[Card], Error> {
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
                Self.saveToDisk(cards)
            })
            .map { cards in
                self.filter(cards: cards, for: faction)
            }
            .catch { _ -> AnyPublisher<[Card], Error> in
                return Just(self.mockCards(for: faction))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    /// Silently refreshes the disk cache from the network without blocking the UI.
    private func refreshFromNetwork() {
        let urlString = "https://api.hearthstonejson.com/v1/latest/enUS/cards.collectible.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            if let freshCards = try? JSONDecoder().decode([Card].self, from: data) {
                Self.cachedCards = freshCards
                Self.saveToDisk(freshCards)
            }
        }.resume()
    }
    
    // MARK: - Disk Persistence
    
    private static func saveToDisk(_ cards: [Card]) {
        guard let fileURL = cacheFileURL else { return }
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("[CardsService] Failed to save cache to disk: \(error)")
        }
    }
    
    private static func loadFromDisk() -> [Card]? {
        guard let fileURL = cacheFileURL,
              FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            
            // Decode using EncodingKeys format (cardSet, img directly)
            struct DiskCard: Decodable {
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
            
            let diskCards = try JSONDecoder().decode([DiskCard].self, from: data)
            return diskCards.map {
                Card(name: $0.name, img: $0.img, flavor: $0.flavor, text: $0.text,
                     cardSet: $0.cardSet, type: $0.type, faction: $0.faction,
                     rarity: $0.rarity, attack: $0.attack, cost: $0.cost, health: $0.health)
            }
        } catch {
            print("[CardsService] Failed to load cache from disk: \(error)")
            return nil
        }
    }
    
    // MARK: - Filtering (no pagination limit — handled by Interactor)
    
    private func filter(cards: [Card], for faction: String) -> [Card] {
        if faction.lowercased() == "alliance" {
            return cards.filter { $0.faction?.lowercased() == "alliance" }
        } else if faction.lowercased() == "horde" {
            return cards.filter { $0.faction?.lowercased() == "horde" }
        } else {
            return cards.filter { $0.faction == nil }
        }
    }
    
    // MARK: - Mock Fallback
    
    private func mockCards(for faction: String) -> [Card] {
        switch faction.lowercased() {
        case "alliance":
            return [
                Card(name: "Tirion Fordring",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_383.png",
                     flavor: "If you cut him, does he not bleed... gold?",
                     text: "Divine Shield. Taunt. Deathrattle: Equip a 5/3 Ashbringer.",
                     cardSet: "Classic", type: "Minion", faction: "Alliance",
                     rarity: "Legendary", attack: 6, cost: 8, health: 6),
                Card(name: "Jaina Proudmoore",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/HERO_08.png",
                     flavor: "The ruler of Theramore and archmage of the Kirin Tor.",
                     text: "Summon a Water Elemental.",
                     cardSet: "Core", type: "Hero", faction: "Alliance",
                     rarity: "Legendary", attack: 0, cost: 8, health: 30)
            ]
        case "horde":
            return [
                Card(name: "Garrosh Hellscream",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_414.png",
                     flavor: "The Warchief of the Horde is fierce, proud, and uncompromising.",
                     text: "Charge. Has +6 Attack while damaged.",
                     cardSet: "Classic", type: "Minion", faction: "Horde",
                     rarity: "Legendary", attack: 4, cost: 8, health: 9),
                Card(name: "Thrall",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/HERO_02.png",
                     flavor: "The former Warchief of the Horde and Earthwarden of Azeroth.",
                     text: "Totem Call: Summon a random Totem.",
                     cardSet: "Core", type: "Hero", faction: "Horde",
                     rarity: "Legendary", attack: 0, cost: 5, health: 30)
            ]
        default:
            return [
                Card(name: "Ragnaros the Firelord",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_298.png",
                     flavor: "Ragnaros was summoned by the Dark Iron Dwarves.",
                     text: "Can't attack. At the end of your turn, deal 8 damage to a random enemy.",
                     cardSet: "Classic", type: "Minion", faction: "Neutral",
                     rarity: "Legendary", attack: 8, cost: 8, health: 8),
                Card(name: "Ysera",
                     img: "https://art.hearthstonejson.com/v1/render/latest/enUS/512x/EX1_572.png",
                     flavor: "Ysera rules the Emerald Dream.",
                     text: "At the end of your turn, add a Dream Card to your hand.",
                     cardSet: "Classic", type: "Minion", faction: "Neutral",
                     rarity: "Legendary", attack: 4, cost: 9, health: 12)
            ]
        }
    }
}
