import Foundation
import Combine

struct CardsInteractor: CardsInteractorInterface {
    
    //MARK: - Properties
    let service: CardsServiceInterface
    
    // MARK: - Initializers
    init(service: CardsServiceInterface = CardsService()) {
        self.service = service
    }
    
    // MARK: - Methods
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error>  {
        return service.fetchCards(faction: faction)
            .eraseToAnyPublisher()
    }
}
