import XCTest
@testable import Hearthstone

final class CardDetailViewControllerTests: XCTestCase {

    var sut: CardDetailViewController!

    override func setUp() {
        super.setUp()
        let card = Card(name: "Test Card",
                        img: nil,
                        flavor: "Flavor text",
                        text: "Card description",
                        cardSet: "Test Set",
                        type: "Minion",
                        faction: "Neutral",
                        rarity: "Common",
                        attack: 3,
                        cost: 2,
                        health: 4)
        sut = CardDetailViewController(card: card)
        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCardDetailViewController_WhenLoaded_ImageViewExists() {
        XCTAssertNotNil(sut.cardImageView)
    }

    func testCardDetailViewController_WhenLoaded_NameLabelExists() {
        XCTAssertNotNil(sut.nameLabel)
    }

    func testCardDetailViewController_WhenLoaded_FlavorLabelExists() {
        XCTAssertNotNil(sut.flavorLabel)
    }

    func testCardDetailViewController_WhenLoaded_DescriptionLabelExists() {
        XCTAssertNotNil(sut.descriptionLabel)
    }

    func testCardDetailViewController_WhenLoaded_CardSetLabelExists() {
        XCTAssertNotNil(sut.cardSetLabel)
    }

    func testCardDetailViewController_WhenLoaded_TypeLabelExists() {
        XCTAssertNotNil(sut.typeLabel)
    }

    func testCardDetailViewController_WhenLoaded_FactionLabelExists() {
        XCTAssertNotNil(sut.factionLabel)
    }

    func testCardDetailViewController_WhenLoaded_RarityLabelExists() {
        XCTAssertNotNil(sut.rarityLabel)
    }

    func testCardDetailViewController_WhenLoaded_AttackLabelExists() {
        XCTAssertNotNil(sut.attackLabel)
    }

    func testCardDetailViewController_WhenLoaded_CostLabelExists() {
        XCTAssertNotNil(sut.costLabel)
    }

    func testCardDetailViewController_WhenLoaded_HealthLabelExists() {
        XCTAssertNotNil(sut.healthLabel)
    }
}
