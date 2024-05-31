import Foundation
import Combine

//MARK: - View Protocols
protocol CardsViewInterface: AnyObject {
    func updateCards(cards: [Card])
    func showError(error: Error)
}

//MARK: - Presenter Protocols
protocol CardsPresenterInterface {
    var card: [Card] { get }
    
    func viewDidLoad()
    func segmentValueChanged(index: Int)
}

//MARK: - Interactor Protocols
protocol CardsInteractorInterface {
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error> 
}

//MARK: - Service Protocols
protocol CardsServiceInterface {
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error>
}
