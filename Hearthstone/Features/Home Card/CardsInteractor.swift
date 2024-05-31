import Foundation
import Combine

struct CardsInteractor: CardsInteractorProtocol {
    
    //MARK: - Properties
    let service: CardsServiceProtocol
    
    // MARK: - Initializers
    init(service: CardsServiceProtocol = CardsService()) {
        self.service = service
    }
    
    // MARK: - Methods
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error>  {
        return service.fetchCards(faction: faction)
            .eraseToAnyPublisher()
    }
}
