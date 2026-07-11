import UIKit

final class CardsViewController: UIViewController {
    
    //MARK: - Properties
    var presenter: CardsPresenter?
    
    lazy var activity: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView(style: .large)
        a.color = UIColor(red: 244/255, green: 196/255, blue: 48/255, alpha: 1.0)
        a.hidesWhenStopped = true
        a.startAnimating()
        return a
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let s = UISegmentedControl(items: ["Alliance", "Horde", "Neutral"])
        s.selectedSegmentIndex = 0
        s.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = UIColor(red: 38/255, green: 30/255, blue: 26/255, alpha: 1.0)
        s.selectedSegmentTintColor = UIColor(red: 244/255, green: 196/255, blue: 48/255, alpha: 1.0)
        s.setTitleTextAttributes([.foregroundColor: UIColor(red: 25/255, green: 20/255, blue: 18/255, alpha: 1.0),
                                  .font: UIFont.systemFont(ofSize: 14, weight: .bold)], for: .selected)
        s.setTitleTextAttributes([.foregroundColor: UIColor(white: 0.8, alpha: 1.0),
                                  .font: UIFont.systemFont(ofSize: 14, weight: .medium)], for: .normal)
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
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 25/255, green: 20/255, blue: 18/255, alpha: 1.0)
        title = "Hearthstone"
        
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = UIColor(red: 25/255, green: 20/255, blue: 18/255, alpha: 1.0)
            navigationBar.tintColor = UIColor(red: 244/255, green: 196/255, blue: 48/255, alpha: 1.0)
            navigationBar.titleTextAttributes = [
                .foregroundColor: UIColor(red: 244/255, green: 196/255, blue: 48/255, alpha: 1.0),
                .font: UIFont.systemFont(ofSize: 22, weight: .bold)
            ]
        }
        
        CardsViewConfigurator().configureView(for: self)
        presenter?.viewDidLoad()
        presenter?.updateViewClosure = { [weak self] in
            guard let self else { return }
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
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            presenter?.didSelectCard(selectedCard)
        }
    }
}
