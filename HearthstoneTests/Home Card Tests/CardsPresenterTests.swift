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
    var appendCardsCalled = false
    var showErrorCalled = false
    var cardsReceived: [Card] = []
    var appendStartIndex: Int = 0
    var errorReceived: Error?
    
    func updateCards(cards: [Card]) {
        updateCardsCalled = true
        cardsReceived = cards
    }
    
    func appendCards(cards: [Card], startIndex: Int) {
        appendCardsCalled = true
        cardsReceived = cards
        appendStartIndex = startIndex
    }
    
    func showError(error: Error) {
        showErrorCalled = true
        errorReceived = error
    }
}

class MockCardsInteractor: CardsInteractorInterface {
    var result: Result<[Card], Error> = .success([])
    var resetPaginationCalled = false
    var setFullCardListCalled = false
    var storedCards: [Card] = []
    private var nextPageCards: [Card]? = nil
    
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error> {
        return result.publisher.eraseToAnyPublisher()
    }
    
    func loadNextPage(faction: String) -> [Card]? {
        return nextPageCards
    }
    
    func resetPagination() {
        resetPaginationCalled = true
    }
    
    func setFullCardList(_ cards: [Card]) {
        setFullCardListCalled = true
        storedCards = cards
    }
    
    func setNextPageCards(_ cards: [Card]?) {
        nextPageCards = cards
    }
}

@MainActor class MockCardsRouter: CardsRouterInterface {
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
        #expect(mockInteractor.setFullCardListCalled)
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
        #expect(mockInteractor.resetPaginationCalled)
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
    
    @Test func scrolledToBottom_ShouldAppendCards() {
        // Given
        let mockView = MockCardsView()
        let mockInteractor = MockCardsInteractor()
        let mockRouter = MockCardsRouter()
        let presenter = CardsPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        
        // Seed initial cards
        presenter.card = [Card(name: "Card 1", img: nil, flavor: nil, text: nil, cardSet: nil, type: nil, faction: nil, rarity: nil, attack: nil, cost: nil, health: nil)]
        
        // Set up next page
        let nextPageCard = Card(name: "Page 2 Card", img: nil, flavor: nil, text: nil, cardSet: nil, type: nil, faction: nil, rarity: nil, attack: nil, cost: nil, health: nil)
        mockInteractor.setNextPageCards([nextPageCard])
        
        // When
        presenter.scrolledToBottom()
        
        // Then
        #expect(mockView.appendCardsCalled)
        #expect(presenter.card.count == 2)
        #expect(presenter.card.last?.name == "Page 2 Card")
    }
    
    @Test func scrolledToBottom_WhenNoPagesLeft_ShouldNotAppend() {
        // Given
        let mockView = MockCardsView()
        let mockInteractor = MockCardsInteractor()
        let mockRouter = MockCardsRouter()
        let presenter = CardsPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
        mockInteractor.setNextPageCards(nil) // No more pages
        
        // When
        presenter.scrolledToBottom()
        
        // Then
        #expect(!mockView.appendCardsCalled)
    }
}
