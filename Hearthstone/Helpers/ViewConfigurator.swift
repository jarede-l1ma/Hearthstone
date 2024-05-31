import UIKit

struct CardsViewConfigurator: ViewConfiguratorInterface {
  func configureView(for viewController: CardsViewController) {
    viewController.view.addSubview(viewController.segmentControl)
    viewController.view.addSubview(viewController.tableView)

    NSLayoutConstraint.activate([
      viewController.segmentControl.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor),
      viewController.segmentControl.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16.0),
      viewController.segmentControl.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -16.0),

      viewController.tableView.topAnchor.constraint(equalTo: viewController.segmentControl.bottomAnchor, constant: 16.0),
      viewController.tableView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
      viewController.tableView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
      viewController.tableView.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
