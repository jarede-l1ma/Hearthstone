import Testing
import UIKit
@testable import Hearthstone

@Suite @MainActor struct CardsModuleBuilderTests {
    
    @Test func build_ShouldConfigureAndReturnViewController() {
        // When
        let viewController = CardsModuleBuilder.build()
        
        // Then
        #expect(viewController is CardsViewController)
        guard let cardsVC = viewController as? CardsViewController else {
            Issue.record("Builder should return CardsViewController")
            return
        }
        
        cardsVC.loadViewIfNeeded()
        
        #expect(cardsVC.presenter != nil)
        #expect(cardsVC.presenter?.view != nil)
        #expect(cardsVC.presenter?.interactor != nil)
        #expect(cardsVC.presenter?.router != nil)
    }
}
