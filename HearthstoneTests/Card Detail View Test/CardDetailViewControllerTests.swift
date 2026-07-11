import Testing
import UIKit
@testable import Hearthstone

@Suite @MainActor struct CardDetailViewControllerTests {

    let sut: CardDetailViewController

    init() {
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

    @Test func cardDetailViewController_WhenLoaded_ImageViewExists() {
        #expect(sut.cardImageView != nil)
    }

    @Test func cardDetailViewController_WhenLoaded_NameLabelExists() {
        #expect(sut.nameLabel != nil)
    }

    @Test func cardDetailViewController_WhenLoaded_FlavorLabelExists() {
        #expect(sut.flavorLabel != nil)
    }

    @Test func cardDetailViewController_WhenLoaded_DescriptionLabelExists() {
        #expect(sut.descriptionLabel != nil)
    }

    @Test func cardDetailViewController_WhenLoaded_CardSetLabelExists() {
        #expect(sut.cardSetLabel != nil)
    }

    @Test func cardDetailViewController_WhenLoaded_TypeLabelExists() {
        #expect(sut.typeLabel != nil)
    }

    @Test func cardDetailViewController_WhenLoaded_FactionLabelExists() {
        #expect(sut.factionLabel != nil)
    }

    @Test func cardDetailViewController_WhenLoaded_RarityLabelExists() {
        #expect(sut.rarityLabel != nil)
    }

    @Test func cardDetailViewController_WhenLoaded_AttackLabelExists() {
        #expect(sut.attackLabel != nil)
    }

    @Test func cardDetailViewController_WhenLoaded_CostLabelExists() {
        #expect(sut.costLabel != nil)
    }

    @Test func cardDetailViewController_WhenLoaded_HealthLabelExists() {
        #expect(sut.healthLabel != nil)
    }
}
