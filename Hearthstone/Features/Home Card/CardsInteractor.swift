//
//  CardInteractor.swift
//  Hearthstone
//
//  Created by Jarede Lima on 29/03/24.
//

import Foundation

struct CardsInteractor: CardsInteractorProtocol {
    
    //MARK: - Properties
    let service: CardsServiceProtocol
    
    // MARK: - Initializers
    init(service: CardsServiceProtocol = CardsService()) {
        self.service = service
    }
    
    // MARK: - Methods
    func fetchCards(faction: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        service.fetchCards(faction: faction, completion: completion)
    }
}
