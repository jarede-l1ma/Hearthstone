import XCTest
@testable import Hearthstone

final class CardsViewProtocolTests: XCTestCase {

    class MockCardsView: CardsViewProtocol {
        var updateCardsCalled = false
        var showErrorCalled = false
        
        func updateCards(cards: [Card]) {
            updateCardsCalled = true
        }
        
        func showError(error: Error) {
            showErrorCalled = true
        }
    }

    func testUpdateCards_WhenCalled_ShouldSetUpdateCardsCalledToTrue() {
        // Given
        let mockView = MockCardsView()
        
        // When
        mockView.updateCards(cards: [])
        
        // Then
        XCTAssertTrue(mockView.updateCardsCalled)
    }
    
    func testShowError_WhenCalled_ShouldSetShowErrorCalledToTrue() {
        // Given
        let mockView = MockCardsView()
        
        // When
        mockView.showError(error: NSError(domain: "", code: 0, userInfo: nil))
        
        // Then
        XCTAssertTrue(mockView.showErrorCalled)
    }
}

class CardsPresenterProtocolTests: XCTestCase {

    class MockCardsInteractor: CardsInteractorProtocol {
        func fetchCards(faction: String, completion: @escaping (Result<[Card], Error>) -> Void) {
            
        }
    }

    class MockCardsView: CardsViewProtocol {
        func updateCards(cards: [Hearthstone.Card]) {
            
        }
        
        func showError(error: Error) {
            
        }
        
    }

    func testViewDidLoad_WhenCalled_ShouldNotCrash() {
        // Given
        let interactor = MockCardsInteractor()
        let view = MockCardsView()
        let presenter = CardsPresenter(view: view, interactor: interactor, currentFaction: "")
        
        // When
        presenter.viewDidLoad()
        
        // Then
        // Se não houver crashes, o teste é bem-sucedido
    }
    
    func testSegmentValueChanged_WhenCalled_ShouldNotCrash() {
        // Given
        let interactor = MockCardsInteractor()
        let view = MockCardsView()
        let presenter = CardsPresenter(view: view, interactor: interactor, currentFaction: "")
        
        // When
        presenter.segmentValueChanged(index: 0)
        
        // Then
        // Se não houver crashes, o teste é bem-sucedido
    }
}

class CardsInteractorProtocolTests: XCTestCase {

    class MockCardsInteractor: CardsInteractorProtocol {
        func fetchCards(faction: String, completion: @escaping (Result<[Card], Error>) -> Void) {
            
        }
    }

    func testFetchCards_WhenCalled_ShouldNotCrash() {
        // Given
        let interactor = MockCardsInteractor()
        
        // When
        interactor.fetchCards(faction: "Alliance") { _ in
            
        }
        
        // Then
        
    }
}
