import Testing
import UIKit
@testable import Hearthstone

@Suite @MainActor struct CardsTableViewCellTests {
    
    let cell: CardsTableViewCell
    
    init() {
        cell = CardsTableViewCell(style: .default, reuseIdentifier: "Cell")
    }
    
    @Test func configureWithCard() {
        // Given
        let card = Card(name: "Test Card", img: "test_image_url", flavor: "Test Flavor", text: "Test Text", cardSet: "Test Set", type: "Test Type", faction: "Test Faction", rarity: "Test Rarity", attack: 1, cost: 1, health: 1)
        
        // When
        cell.configure(with: card)
        
        // Then
        #expect(cell.cardNameLabel.text == "Test Card")
        #expect(cell.activityIndicator.isAnimating)
    }
    
    @Test func prepareForReuse() {
        // Given
        cell.cardNameLabel.text = "Test"
        cell.cardImageView.image = UIImage(systemName: "photo")
        
        // When
        cell.prepareForReuse()
        
        // Then
        #expect(cell.cardNameLabel.text == "")
        #expect(cell.cardImageView.image == nil)
    }
}
