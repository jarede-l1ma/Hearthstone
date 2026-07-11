import Foundation
import Combine

struct CardsInteractor: CardsInteractorInterface {
    
    //MARK: - Properties
    let service: CardsServiceInterface
    
    /// Full unfiltered result set for the current faction, used for local pagination.
    private var allFilteredCards: [Card] = []
    
    /// How many cards have been delivered so far for the current faction.
    private var currentOffset: Int = 0
    
    /// Number of cards per page.
    static let pageSize: Int = 40
    
    // MARK: - Initializers
    init(service: CardsServiceInterface = CardsService()) {
        self.service = service
    }
    
    // MARK: - Methods
    
    /// Fetches the first page of cards for a faction. Resets pagination state.
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error> {
        return service.fetchCards(faction: faction)
            .eraseToAnyPublisher()
    }
    
    /// Stores the full result set and returns the first page.
    mutating func resetPagination() {
        allFilteredCards = []
        currentOffset = 0
    }
    
    /// Returns the next page of cards from the stored result set, or nil if exhausted.
    mutating func loadNextPage(faction: String) -> [Card]? {
        guard currentOffset < allFilteredCards.count else { return nil }
        
        let endIndex = min(currentOffset + Self.pageSize, allFilteredCards.count)
        let page = Array(allFilteredCards[currentOffset..<endIndex])
        currentOffset = endIndex
        return page
    }
    
    /// Call this after receiving the full card list from `fetchCards` to seed the paginator.
    mutating func setFullCardList(_ cards: [Card]) {
        allFilteredCards = cards
        currentOffset = Self.pageSize  // First page already delivered
    }
}
