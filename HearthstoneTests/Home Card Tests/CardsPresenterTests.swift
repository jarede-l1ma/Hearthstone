//
//  CardsPresenterTests.swift
//  HearthstoneTests
//
//  Created by Jarede Lima on 31/03/24.
//

import XCTest
@testable import Hearthstone

enum MockError: Error {
    case genericError
    case decodingError
    case httpError
}

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

class MockCardsInteractor: CardsInteractorProtocol {
    var fetchCardsStub: Result<[Card], Error> = .success([])
    
    func fetchCards(faction: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        completion(fetchCardsStub)
    }
    
}

final class CardsPresenterTests: XCTestCase {
    
    func testViewDidLoad_WhenSuccess_ShouldUpdateViewWithCards() {
        // Given
        let mockView = MockCardsView()
        let mockInteractor = MockCardsInteractor()
        let presenter = CardsPresenter(view: mockView, interactor: mockInteractor, currentFaction: "Alliance")
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.updateCardsCalled, "Update cards should be called")
        XCTAssertFalse(mockView.showErrorCalled, "Show error should not be called")
    }
    
    func testViewDidLoad_WhenFailure_ShouldShowError() {
        // Given
        let mockView = MockCardsView()
        let mockInteractor = MockCardsInteractor()
        let presenter = CardsPresenter(view: mockView, interactor: mockInteractor, currentFaction: "Alliance")
        mockInteractor.fetchCardsStub = .failure(MockError.decodingError)
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertFalse(mockView.updateCardsCalled, "Update cards should not be called")
        XCTAssertTrue(mockView.showErrorCalled, "Show error should be called")
    }
    
    func testSegmentValueChanged_ShouldUpdateViewWithCards() {
        // Given
        let mockView = MockCardsView()
        let mockInteractor = MockCardsInteractor()
        let presenter = CardsPresenter(view: mockView, interactor: mockInteractor, currentFaction: "Alliance")
        
        // When
        presenter.segmentValueChanged(index: 1)
        
        // Then
        XCTAssertTrue(mockView.updateCardsCalled, "Update cards should be called")
        XCTAssertFalse(mockView.showErrorCalled, "Show error should not be called")
    }
    
    func testSegmentValueChanged_ShouldShowError() {
        // Given
        let mockView = MockCardsView()
        let mockInteractor = MockCardsInteractor()
        let presenter = CardsPresenter(view: mockView, interactor: mockInteractor, currentFaction: "Alliance")
        mockInteractor.fetchCardsStub = .failure(MockError.decodingError)
        
        // When
        presenter.segmentValueChanged(index: 1)
        
        // Then
        XCTAssertFalse(mockView.updateCardsCalled, "Update cards should not be called")
        XCTAssertTrue(mockView.showErrorCalled, "Show error should be called")
    }
}
