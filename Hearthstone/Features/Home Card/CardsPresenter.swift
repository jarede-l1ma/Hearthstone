import Foundation
import Combine

final class CardsPresenter: CardsPresenterInterface {
    
    // MARK: - Properties
    var card: [Card] = []
    weak var view: CardsViewInterface?
    private var cancellable: AnyCancellable?
    var updateViewClosure: (() -> Void)?
    let interactor: CardsInteractorInterface
    var currentFaction: String = "Alliance"
    
    // MARK: - Initializers
    init(view: CardsViewInterface? = nil, interactor: CardsInteractorInterface) {
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
