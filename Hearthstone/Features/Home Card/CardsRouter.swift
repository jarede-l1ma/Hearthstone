import UIKit

@MainActor protocol CardsRouterInterface {
    func navigateToDetail(with card: Card)
}

@MainActor struct CardsRouter: CardsRouterInterface {
    
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    // MARK: - Methods
    func navigateToDetail(with card: Card) {
        let detailVC = CardDetailViewController(card: card)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
