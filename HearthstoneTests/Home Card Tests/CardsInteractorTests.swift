//
//  CardsInteractorTests.swift
//  HearthstoneTests
//
//  Created by Jarede Lima on 31/03/24.
//

import XCTest
@testable import Hearthstone

final class CardsInteractorTests: XCTestCase {
    
    var interactor: CardsInteractor!
    
    override func setUp() {
        super.setUp()
        interactor = CardsInteractor()
    }
    
    override func tearDown() {
        interactor = nil
        super.tearDown()
    }
    
    func testFetchCardsSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetching cards succeeds")
        
        // When
        interactor.fetchCards(faction: "Alliance") { result in
            // Then
            switch result {
            case .success(let cards):
                XCTAssertFalse(cards.isEmpty)
                expectation.fulfill()
            case .failure:
                XCTFail("Fetching cards failed unexpectedly")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchCardsFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Fetching cards fails")
        
        // When
        interactor.fetchCards(faction: "InvalidFaction") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Fetching cards succeeded unexpectedly")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchCardsEmptyFaction() {
        // Given
        let expectation = XCTestExpectation(description: "Fetching cards with empty faction fails")
        
        // When
        interactor.fetchCards(faction: "") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Fetching cards with empty faction succeeded unexpectedly")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 8.0)
    }
    
    func testFetchCardsInvalidURL() {
        // Given
        let expectation = XCTestExpectation(description: "Fetching cards with invalid URL fails")
        
        // When
        interactor.fetchCards(faction: "InvalidFaction") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Fetching cards with invalid URL succeeded unexpectedly")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchCardsInvalidResponse() {
        // Given
        let expectation = XCTestExpectation(description: "Fetching cards with invalid response fails")
        
        // When
        interactor.fetchCards(faction: "InvalidFaction") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Fetching cards with invalid response succeeded unexpectedly")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchCardsNoData() {
        // Given
        let expectation = XCTestExpectation(description: "Fetching cards with no data fails")
        
        // When
        interactor.fetchCards(faction: "InvalidFaction") { result in
            // Then
            switch result {
            case .success:
                XCTFail("Fetching cards with no data succeeded unexpectedly")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
