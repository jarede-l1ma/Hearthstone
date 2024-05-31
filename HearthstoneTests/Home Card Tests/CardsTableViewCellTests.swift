import XCTest
@testable import Hearthstone

final class CardsTableViewCellTests: XCTestCase {
    
    var cell: CardsTableViewCell!
    
    override func setUp() {
        super.setUp()
        cell = CardsTableViewCell(style: .default, reuseIdentifier: "Cell")
    }
    
    override func tearDown() {
        cell = nil
        super.tearDown()
    }
    
    func testConfigureWithCard() {
        // Given
        let card = Card(name: "Test Card", img: "test_image_url", flavor: "Test Flavor", text: "Test Text", cardSet: "Test Set", type: "Test Type", faction: "Test Faction", rarity: "Test Rarity", attack: 1, cost: 1, health: 1)
        
        // When
        cell.configure(with: card)
        
        // Then
        XCTAssertEqual(cell.cardNameLabel.text, "Test Card")
        XCTAssertEqual(cell.activityIndicator.isAnimating, true)
    }
    
    func testPrepareForReuse() {
        // Given
        cell.cardNameLabel.text = "Test"
        cell.cardImageView.image = UIImage(named: "test_image")
        
        // When
        cell.prepareForReuse()
        
        // Then
        XCTAssertEqual(cell.cardNameLabel.text, "")
        XCTAssertEqual(cell.cardImageView.image, nil)
    }
}
