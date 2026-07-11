import Testing
import Combine
import Foundation
@testable import Hearthstone

enum MockError: Error {
    case genericError
    case decodingError
    case httpError
}

@MainActor class MockCardsView: CardsViewInterface {
    var updateCardsCalled = false
    var showErrorCalled = false
    var cardsReceived: [Card] = []
    var errorReceived: Error?
    
    func updateCards(cards: [Card]) {
        updateCardsCalled = true
        cardsReceived = cards
    }
    
    func showError(error: Error) {
        showErrorCalled = true
        errorReceived = error
    }
}

class MockCardsInteractor: CardsInteractorInterface {
    var result: Result<[Card], Error> = .success([])
    
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error> {
        return result.publisher.eraseToAnyPublisher()
    }
}

class MockCardsRouter: CardsRouterInterface {
    var navigateToDetailCalled = false
    var cardPassed: Card?
    
    func navigateToDetail(with card: Card) {
        navigateToDetailCalled = true
        cardPassed = card
    }
}

@Suite @MainActor struct CardsPresenterTests {
    
    @Test func viewDidLoad_WhenSuccess_ShouldUpdateViewWithCards() async {
        // Given
        let mockView = MockCardsView()
        let mockInteractor = MockCardsInteractor()
        let mockRouter = MockCardsRouter()
        mockInteractor.result = .success([Card(name: "Test Card", img: nil, flavor: nil, text: nil, cardSet: nil, type: nil, faction: nil, rarity: nil, attack: nil, cost: nil, health: nil)])
        let presenter = CardsPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        
        // When
        presenter.viewDidLoad()
        
        // Yield to allow main queue blocks to run
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05s
        
        // Then
        #expect(mockView.updateCardsCalled)
        #expect(!mockView.showErrorCalled)
        #expect(mockView.cardsReceived.first?.name == "Test Card")
    }
    
    @Test func viewDidLoad_WhenFailure_ShouldShowError() async {
        // Given
        let mockView = MockCardsView()
        let mockInteractor = MockCardsInteractor()
        let mockRouter = MockCardsRouter()
        mockInteractor.result = .failure(MockError.decodingError)
        let presenter = CardsPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        
        // When
        presenter.viewDidLoad()
        
        // Yield to allow main queue blocks to run
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05s
        
        // Then
        #expect(!mockView.updateCardsCalled)
        #expect(mockView.showErrorCalled)
    }
    
    @Test func segmentValueChanged_ShouldUpdateViewWithCards() async {
        // Given
        let mockView = MockCardsView()
        let mockInteractor = MockCardsInteractor()
        let mockRouter = MockCardsRouter()
        mockInteractor.result = .success([Card(name: "Horde Card", img: nil, flavor: nil, text: nil, cardSet: nil, type: nil, faction: nil, rarity: nil, attack: nil, cost: nil, health: nil)])
        let presenter = CardsPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        
        // When
        presenter.segmentValueChanged(index: 1)
        
        // Yield to allow main queue blocks to run
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05s
        
        // Then
        #expect(mockView.updateCardsCalled)
        #expect(!mockView.showErrorCalled)
        #expect(mockView.cardsReceived.first?.name == "Horde Card")
    }
    
    @Test func segmentValueChanged_ShouldShowError() async {
        // Given
        let mockView = MockCardsView()
        let mockInteractor = MockCardsInteractor()
        let mockRouter = MockCardsRouter()
        mockInteractor.result = .failure(MockError.decodingError)
        let presenter = CardsPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        
        // When
        presenter.segmentValueChanged(index: 1)
        
        // Yield to allow main queue blocks to run
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05s
        
        // Then
        #expect(!mockView.updateCardsCalled)
        #expect(mockView.showErrorCalled)
    }
    
    @Test func didSelectCard_ShouldNavigateToDetail() {
        // Given
        let mockView = MockCardsView()
        let mockInteractor = MockCardsInteractor()
        let mockRouter = MockCardsRouter()
        let presenter = CardsPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        let selectedCard = Card(name: "Select Card", img: nil, flavor: nil, text: nil, cardSet: nil, type: nil, faction: nil, rarity: nil, attack: nil, cost: nil, health: nil)
        
        // When
        presenter.didSelectCard(selectedCard)
        
        // Then
        #expect(mockRouter.navigateToDetailCalled)
        #expect(mockRouter.cardPassed?.name == "Select Card")
    }
}
