//
//  CardTests.swift
//  HearthstoneTests
//
//  Created by Jarede Lima on 31/03/24.
//

import XCTest
@testable import Hearthstone

final class CardTests: XCTestCase {

    // Test decoding with invalid JSON data
    func testCard_WhenDecodedWithInvalidData_ShouldThrowError() {
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
        XCTAssertThrowsError(try JSONDecoder().decode(Card.self, from: invalidJSONData))
    }

    // Test decoding with missing fields
    func testCard_WhenDecodedWithMissingFields_ShouldReturnNilValues() {
        // Given
        let jsonString = """
            {
                "name": "Test Card",
                "type": "Minion"
            }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        do {
            let card = try JSONDecoder().decode(Card.self, from: jsonData)
            
            // Then
            XCTAssertEqual(card.name, "Test Card")
            XCTAssertNil(card.img)
            XCTAssertNil(card.flavor)
            XCTAssertNil(card.text)
            XCTAssertNil(card.cardSet)
            XCTAssertEqual(card.type, "Minion")
            XCTAssertNil(card.faction)
            XCTAssertNil(card.rarity)
            XCTAssertNil(card.attack)
            XCTAssertNil(card.cost)
            XCTAssertNil(card.health)
        } catch {
            XCTFail("Failed to decode Card: \(error)")
        }
    }
}
