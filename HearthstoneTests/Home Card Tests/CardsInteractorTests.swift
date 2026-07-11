import Testing
import Combine
import Foundation
@testable import Hearthstone

struct CardsInteractorTests {
    
    @Test func fetchCardsSuccess() async {
        // Given
        let interactor = CardsInteractor()
        var cancellables = Set<AnyCancellable>()
        
        // When
        let cards: [Card]? = await withCheckedContinuation { continuation in
            interactor.fetchCards(faction: "Alliance")
                .sink(receiveCompletion: { completion in
                    if case .failure = completion {
                        continuation.resume(returning: nil)
                    }
                }, receiveValue: { resultCards in
                    continuation.resume(returning: resultCards)
                })
                .store(in: &cancellables)
        }
        
        // Then
        #expect(cards != nil)
        #expect(cards?.isEmpty == false)
        #expect(cards?.first?.faction == "Alliance".uppercased())
    }
    
    @Test func fetchCardsFailure_ReturnsFallbackData() async {
        // Given
        let interactor = CardsInteractor()
        var cancellables = Set<AnyCancellable>()
        
        // When
        let cards: [Card]? = await withCheckedContinuation { continuation in
            interactor.fetchCards(faction: "InvalidFaction")
                .sink(receiveCompletion: { completion in
                    if case .failure = completion {
                        continuation.resume(returning: nil)
                    }
                }, receiveValue: { resultCards in
                    continuation.resume(returning: resultCards)
                })
                .store(in: &cancellables)
        }
        
        // Then
        #expect(cards != nil)
        #expect(cards?.isEmpty == false)
    }
    
    @Test func fetchCardsEmptyFaction_ReturnsFallbackData() async {
        // Given
        let interactor = CardsInteractor()
        var cancellables = Set<AnyCancellable>()
        
        // When
        let cards: [Card]? = await withCheckedContinuation { continuation in
            interactor.fetchCards(faction: "")
                .sink(receiveCompletion: { completion in
                    if case .failure = completion {
                        continuation.resume(returning: nil)
                    }
                }, receiveValue: { resultCards in
                    continuation.resume(returning: resultCards)
                })
                .store(in: &cancellables)
        }
        
        // Then
        #expect(cards != nil)
        #expect(cards?.isEmpty == false)
    }
}
