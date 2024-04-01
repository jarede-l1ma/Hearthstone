//
//  CardPresenter.swift
//  Hearthstone
//
//  Created by Jarede Lima on 29/03/24.
//

import Foundation

final class CardsPresenter: CardsPresenterProtocol {
    
    // MARK: - Properties
    weak var view: CardsViewProtocol?
    var updateViewClosure: (() -> Void)?
    let interactor: CardsInteractorProtocol
    var currentFaction: String = "Alliance"
    
    // MARK: - Initializers
    init(view: CardsViewProtocol? = nil, interactor: CardsInteractorProtocol, currentFaction: String) {
        self.view = view
        self.interactor = interactor
        self.currentFaction = currentFaction
    }
    
    // MARK: - Methods
    func viewDidLoad() {
        interactor.fetchCards(faction: currentFaction) { [weak self] result in
            switch result {
            case .success(let cards):
                self?.view?.updateCards(cards: cards)
            case .failure(let error):
                self?.view?.showError(error: error)
            }
        }
    }
    
    func segmentValueChanged(index: Int) {
        switch index {
        case 0: currentFaction = Faction.alliance.rawValue
        case 1: currentFaction = Faction.horde.rawValue
        case 2: currentFaction = Faction.neutral.rawValue
        default: break
        }
        
        interactor.fetchCards(faction: currentFaction) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let cards):
                self.view?.updateCards(cards: cards)
                updateViewClosure?()
            case .failure(let error):
                self.view?.showError(error: error)
            }
        }
    }
}
