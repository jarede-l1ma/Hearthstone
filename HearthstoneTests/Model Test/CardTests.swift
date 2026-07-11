import Testing
import Foundation
@testable import Hearthstone

struct CardTests {

    // Test decoding with invalid JSON data
    @Test func card_WhenDecodedWithInvalidData_ShouldThrowError() {
        // Given
        let invalidJSONString = """
            {
                "name": 123, // Invalid type for name
                "img": "https://example.com/image.png",
                "flavor": "Flavor text",
                "text": "Card description",
                "cardSet": "Test Set",
                "type": "Minion",
                "faction": "Neutral",
                "rarity": "Common",
                "attack": 3,
                "cost": 2,
                "health": 4
            }
        """
        let invalidJSONData = invalidJSONString.data(using: .utf8)!
        
        // When & Then
        #expect(throws: Error.self) {
            try JSONDecoder().decode(Card.self, from: invalidJSONData)
        }
    }

    // Test decoding with missing fields
    @Test func card_WhenDecodedWithMissingFields_ShouldReturnNilValues() throws {
        // Given
        let jsonString = """
            {
                "name": "Test Card",
                "type": "Minion"
            }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        let card = try JSONDecoder().decode(Card.self, from: jsonData)
        
        // Then
        #expect(card.name == "Test Card")
        #expect(card.img == nil)
        #expect(card.flavor == nil)
        #expect(card.text == nil)
        #expect(card.cardSet == nil)
        #expect(card.type == "Minion")
        #expect(card.faction == nil)
        #expect(card.rarity == nil)
        #expect(card.attack == nil)
        #expect(card.cost == nil)
        #expect(card.health == nil)
    }
}
