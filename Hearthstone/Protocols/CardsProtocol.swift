//
//  CardsProtocol.swift
//  Hearthstone
//
//  Created by Jarede Lima on 30/03/24.
//

import Foundation
import Combine

//MARK: - View Protocols
protocol CardsViewProtocol: AnyObject {
    func updateCards(cards: [Card])
    func showError(error: Error)
}

//MARK: - Presenter Protocols
protocol CardsPresenterProtocol {
    var card: [Card] { get }
    
    func viewDidLoad()
    func segmentValueChanged(index: Int)
}

//MARK: - Interactor Protocols
protocol CardsInteractorProtocol {
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error> 
}

//MARK: - Service Protocols
protocol CardsServiceProtocol {
    func fetchCards(faction: String) -> AnyPublisher<[Card], Error>
}
