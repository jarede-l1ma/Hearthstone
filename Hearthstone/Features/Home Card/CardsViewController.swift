//
//  CardsViewController.swift
//  Hearthstone
//
//  Created by Jarede Lima on 29/03/24.
//

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
        tableView.register(CardsTableViewCell.self, forCellReuseIdentifier: String(describing: CardsTableViewCell.self))
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
        configureView()
        presenter?.viewDidLoad()
        presenter?.updateViewClosure = {
            DispatchQueue.main.async {
                UIView.transition(with: self.view,
                                  duration: 0.6,
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

//MARK: - View Configuration
extension CardsViewController {
    private func configureView() {
        view.addSubview(segmentControl)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        presenter?.card = []
        tableView.reloadData()
        activity.startAnimating()
        presenter?.segmentValueChanged(index: sender.selectedSegmentIndex)
    }
}

//MARK: - View Update
extension CardsViewController: CardsViewProtocol {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardsTableViewCell", for: indexPath) as? CardsTableViewCell else { return UITableViewCell() }
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
