//
//  CardPresenter.swift
//  Hearthstone
//
//  Created by Jarede Lima on 29/03/24.
//

import Foundation
import Combine

final class CardsPresenter: CardsPresenterProtocol {
    
    // MARK: - Properties
    var card: [Card] = []
    weak var view: CardsViewProtocol?
    private var cancellable: AnyCancellable?
    var updateViewClosure: (() -> Void)?
    let interactor: CardsInteractorProtocol
    var currentFaction: String = "Alliance"
    
    // MARK: - Initializers
    init(view: CardsViewProtocol? = nil, interactor: CardsInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    // MARK: - Methods
    func viewDidLoad() {
        cancellable = interactor.fetchCards(faction: currentFaction)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    updateViewClosure?()
                case .failure(let error):
                    self.view?.showError(error: error)
                }
            }, receiveValue: { [weak self] cards in
                guard let self else { return }
                self.view?.updateCards(cards: cards)
            })
    }
    
    func segmentValueChanged(index: Int) {
        switch index {
        case 0: currentFaction = Faction.alliance.rawValue
        case 1: currentFaction = Faction.horde.rawValue
        case 2: currentFaction = Faction.neutral.rawValue
        default: break
        }
        
        cancellable?.cancel()
        
        cancellable = interactor.fetchCards(faction: currentFaction)
            .sink(receiveCompletion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .finished:
                    updateViewClosure?()
                case .failure(let error):
                    self.view?.showError(error: error)
                }
            }, receiveValue: { [weak self] cards in
                guard let self else { return }
                self.view?.updateCards(cards: cards)
            })
    }
}
