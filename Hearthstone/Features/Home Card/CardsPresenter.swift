import Foundation
import Combine

final class CardsPresenter: CardsPresenterInterface {
    
    // MARK: - Properties
    var card: [Card] = []
    weak var view: CardsViewInterface?
    private var cancellable: AnyCancellable?
    var updateViewClosure: (() -> Void)?
    let interactor: CardsInteractorInterface
    let router: CardsRouterInterface
    var currentFaction: String = "Alliance"
    
    // MARK: - Initializers
    init(view: CardsViewInterface? = nil, interactor: CardsInteractorInterface, router: CardsRouterInterface) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Methods
    func viewDidLoad() {
        fetchCards()
    }
    
    func segmentValueChanged(index: Int) {
        switch index {
        case 0: currentFaction = Faction.alliance.rawValue
        case 1: currentFaction = Faction.horde.rawValue
        case 2: currentFaction = Faction.neutral.rawValue
        default: break
        }
        
        fetchCards()
    }
    
    func didSelectCard(_ card: Card) {
        router.navigateToDetail(with: card)
    }
    
    private func fetchCards() {
        cancellable?.cancel()
        
        cancellable = interactor.fetchCards(faction: currentFaction)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    self.updateViewClosure?()
                case .failure(let error):
                    self.view?.showError(error: error)
                }
            }, receiveValue: { [weak self] cards in
                guard let self else { return }
                self.view?.updateCards(cards: cards)
            })
    }
}
