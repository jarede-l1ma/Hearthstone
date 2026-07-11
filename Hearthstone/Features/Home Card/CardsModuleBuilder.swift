import UIKit

struct CardsModuleBuilder {
    
    static func build() -> UIViewController {
        let service = CardsService()
        let interactor = CardsInteractor(service: service)
        let viewController = CardsViewController()
        let router = CardsRouter(viewController: viewController)
        let presenter = CardsPresenter(view: viewController, interactor: interactor, router: router)
        
        viewController.presenter = presenter
        
        return viewController
    }
}
