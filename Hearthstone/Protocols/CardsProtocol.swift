import Foundation
import Combine

//MARK: - View Protocols
@MainActor
protocol CardsViewInterface: AnyObject {
    func updateCards(cards: [Card])
    func appendCards(cards: [Card], startIndex: Int)
    func showError(error: Error)
}

//MARK: - Presenter Protocols
@MainActor
protocol CardsPresenterInterface {
    var card: [Card] { get }
    
    func viewDidLoad()
    func segmentValueChanged(index: Int)
    func didSelectCard(_ card: Card)
    func scrolledToBottom()
}

//MARK: - Interactor Protocols
protocol CardsInteractorInterface {
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error>
    mutating func loadNextPage(faction: String) -> [Card]?
    mutating func resetPagination()
    mutating func setFullCardList(_ cards: [Card])
}

//MARK: - Service Protocols
protocol CardsServiceInterface {
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error>
}
