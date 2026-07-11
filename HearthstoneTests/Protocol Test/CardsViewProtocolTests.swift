import Testing
import Combine
import Foundation
@testable import Hearthstone

@Suite @MainActor struct CardsViewProtocolTests {

    class MockCardsView: CardsViewInterface {
        var updateCardsCalled = false
        var appendCardsCalled = false
        var showErrorCalled = false
        
        func updateCards(cards: [Card]) {
            updateCardsCalled = true
        }
        
        func appendCards(cards: [Card], startIndex: Int) {
            appendCardsCalled = true
        }
        
        func showError(error: Error) {
            showErrorCalled = true
        }
    }

    @Test func updateCards_WhenCalled_ShouldSetUpdateCardsCalledToTrue() {
        // Given
        let mockView = MockCardsView()
        
        // When
        mockView.updateCards(cards: [])
        
        // Then
        #expect(mockView.updateCardsCalled)
    }
    
    @Test func appendCards_WhenCalled_ShouldSetAppendCardsCalledToTrue() {
        // Given
        let mockView = MockCardsView()
        
        // When
        mockView.appendCards(cards: [], startIndex: 0)
        
        // Then
        #expect(mockView.appendCardsCalled)
    }
    
    @Test func showError_WhenCalled_ShouldSetShowErrorCalledToTrue() {
        // Given
        let mockView = MockCardsView()
        
        // When
        mockView.showError(error: NSError(domain: "", code: 0, userInfo: nil))
        
        // Then
        #expect(mockView.showErrorCalled)
    }
}

@Suite @MainActor struct CardsPresenterProtocolTests {

    class MockCardsInteractor: CardsInteractorInterface {
        func fetchCards(faction: String) -> AnyPublisher<[Card], Error> {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        func loadNextPage(faction: String) -> [Card]? { return nil }
        func resetPagination() {}
        func setFullCardList(_ cards: [Card]) {}
    }

    class MockCardsView: CardsViewInterface {
        func updateCards(cards: [Hearthstone.Card]) {}
        func appendCards(cards: [Card], startIndex: Int) {}
        func showError(error: Error) {}
    }
    
    @MainActor class MockCardsRouter: CardsRouterInterface {
        func navigateToDetail(with card: Card) {}
    }

    @Test func viewDidLoad_WhenCalled_ShouldNotCrash() {
        // Given
        let interactor = MockCardsInteractor()
        let view = MockCardsView()
        let router = MockCardsRouter()
        let presenter = CardsPresenter(view: view, interactor: interactor, router: router)
        
        // When
        presenter.viewDidLoad()
    }
    
    @Test func segmentValueChanged_WhenCalled_ShouldNotCrash() {
        // Given
        let interactor = MockCardsInteractor()
        let view = MockCardsView()
        let router = MockCardsRouter()
        let presenter = CardsPresenter(view: view, interactor: interactor, router: router)
        
        // When
        presenter.segmentValueChanged(index: 0)
    }
}

@Suite struct CardsInteractorProtocolTests {

    class MockCardsInteractor: CardsInteractorInterface {
        func fetchCards(faction: String) -> AnyPublisher<[Card], Error> {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        func loadNextPage(faction: String) -> [Card]? { return nil }
        func resetPagination() {}
        func setFullCardList(_ cards: [Card]) {}
    }

    @Test func fetchCards_WhenCalled_ShouldNotCrash() {
        // Given
        let interactor = MockCardsInteractor()
        
        // When
        _ = interactor.fetchCards(faction: "Alliance")
    }
}
