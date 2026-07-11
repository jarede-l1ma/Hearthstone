import Testing
import UIKit
@testable import Hearthstone

@MainActor class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

@Suite @MainActor struct CardsRouterTests {
    
    @Test func navigateToDetail_ShouldPushCardDetailViewController() {
        // Given
        let rootVC = UIViewController()
        let mockNav = MockNavigationController(rootViewController: rootVC)
        let router = CardsRouter(viewController: rootVC)
        let card = Card(name: "Test Router Card", img: nil, flavor: nil, text: nil, cardSet: nil, type: nil, faction: nil, rarity: nil, attack: nil, cost: nil, health: nil)
        
        // When
        router.navigateToDetail(with: card)
        
        // Then
        #expect(mockNav.pushedViewController != nil)
        #expect(mockNav.pushedViewController is CardDetailViewController)
        let detailVC = mockNav.pushedViewController as? CardDetailViewController
        #expect(detailVC?.card.name == "Test Router Card")
    }
}
