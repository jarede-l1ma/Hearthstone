import UIKit

final class CardsViewController: UIViewController {
    
    //MARK: - Properties
    var presenter: CardsPresenter?
    var interactor = CardsInteractor()
    lazy var currentFaction: String = "Alliance"
    
    lazy var activity: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView(style: .large)
        a.hidesWhenStopped = true
        a.startAnimating()
        
        return a
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let s = UISegmentedControl(items: ["Alliance", "Horde", "Neutral"])
        s.selectedSegmentIndex = 0
        s.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 150
        tableView.register(CardsTableViewCell.self, forCellReuseIdentifier: CardsTableViewCell.reusableIdentifier)
        tableView.backgroundView = self.activity
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelection = false
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CardsPresenter(view: self,
                                   interactor: interactor)
        CardsViewConfigurator().configureView(for: self)
        presenter?.viewDidLoad()
        presenter?.updateViewClosure = {
            DispatchQueue.main.async {
                UIView.transition(with: self.view,
                                  duration: 1.0,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.isHidden = false
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 2.0) {
                self?.view.isHidden = true
            }
        }
    }
}

//MARK: - User Interaction
extension CardsViewController {
    
    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        presenter?.card = []
        tableView.reloadData()
        activity.startAnimating()
        presenter?.segmentValueChanged(index: sender.selectedSegmentIndex)
    }
}

//MARK: - View Update
extension CardsViewController: CardsViewInterface {
    func updateCards(cards: [Card]) {
        DispatchQueue.main.async {
            self.presenter?.card = cards
            self.activity.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func showError(error: Error) {
        self.activity.stopAnimating()
        AlertHelper.showErrorAlert(on: self,
                                   with: error.localizedDescription)
    }
}

//MARK: - Delegate and DataSource
extension CardsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.card.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardsTableViewCell.reusableIdentifier, for: indexPath) as? CardsTableViewCell else { return UITableViewCell() }
        if let card = presenter?.card[indexPath.row] {
            cell.configure(with: card)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCard = presenter?.card[indexPath.row] {
            let cardDetailVC = CardDetailViewController(card: selectedCard)
            navigationController?.pushViewController(cardDetailVC, animated: true)
        }
    }
}
