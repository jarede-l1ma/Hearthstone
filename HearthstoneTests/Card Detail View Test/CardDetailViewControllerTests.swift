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

    @Test func cardDetailViewController_WhenLoaded_ShouldConfigureViewWithCardData() {
        #expect(sut.nameLabel.text == "Test Card")
        
        let flavorText = sut.flavorLabel.attributedText?.string ?? ""
        #expect(flavorText.contains("Flavor text"))
        
        let descriptionText = sut.descriptionLabel.attributedText?.string ?? ""
        #expect(descriptionText.contains("Card description"))
        
        let cardSetText = sut.cardSetLabel.attributedText?.string ?? ""
        #expect(cardSetText.contains("Test Set"))
        
        let typeText = sut.typeLabel.attributedText?.string ?? ""
        #expect(typeText.contains("Minion"))
        
        let factionText = sut.factionLabel.attributedText?.string ?? ""
        #expect(factionText.contains("Neutral"))
        
        let rarityText = sut.rarityLabel.attributedText?.string ?? ""
        #expect(rarityText.contains("Common"))
        
        let attackText = sut.attackLabel.attributedText?.string ?? ""
        #expect(attackText.contains("3"))
        
        let costText = sut.costLabel.attributedText?.string ?? ""
        #expect(costText.contains("2"))
        
        let healthText = sut.healthLabel.attributedText?.string ?? ""
        #expect(healthText.contains("4"))
    }
}
