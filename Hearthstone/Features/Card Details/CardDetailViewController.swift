//
//  CardDetailViewController.swift
//  Hearthstone
//
//  Created by Jarede Lima on 31/03/24.
//

import UIKit

final class CardDetailViewController: UIViewController {
    // MARK: - Properties
    let card: Card
    
    // MARK: - UI Components
    
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.showsHorizontalScrollIndicator = false
        s.alwaysBounceHorizontal = false
        s.isDirectionalLockEnabled = true
        s.contentSize = CGSize(width: view.frame.width,
                               height: view.frame.height)
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
    }()
    
    lazy var stackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 16
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
    }()
    
    lazy var cardImageView: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        i.translatesAutoresizingMaskIntoConstraints = false
        
        return i
    }()
    
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        l.textAlignment = .left
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    lazy var flavorLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .left
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .left
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    lazy var cardSetLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .left
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    lazy var typeLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .left
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    lazy var factionLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .left
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    lazy var rarityLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .left
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    lazy var attackLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .left
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    lazy var costLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .left
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    lazy var healthLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .left
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    // MARK: - Initialization
    init(card: Card) {
        self.card = card
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        updateUI()
    }
    
    // MARK: - View Configuration
    func configureView() {
        let constraints: CGFloat = 20.0
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(cardImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(flavorLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(cardSetLabel)
        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(factionLabel)
        stackView.addArrangedSubview(rarityLabel)
        stackView.addArrangedSubview(attackLabel)
        stackView.addArrangedSubview(costLabel)
        stackView.addArrangedSubview(healthLabel)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: constraints),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -constraints),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    func updateUI() {
        nameLabel.text = card.name ?? "Empty name"
        flavorLabel.text = "Flavor: \(card.flavor ?? "Empty flavor")"
        descriptionLabel.text = "Description: \(card.text ?? "Empty description")"
        cardSetLabel.text = "Set: \(card.cardSet ?? "Empty set")"
        typeLabel.text = "Type: \(card.type ?? "Empty type")"
        factionLabel.text = "Faction: \(card.faction ?? "Empty faction")"
        rarityLabel.text = "Rarity: \(card.rarity ?? "Empty rarity")"
        attackLabel.text = "Attack: \(card.attack ?? 0)"
        costLabel.text = "Cost: \(card.cost ?? 0)"
        healthLabel.text = "Health: \(card.health ?? 0)"
        
        if let imageUrlString = card.img,
           let imageUrl = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        self.cardImageView.image = UIImage(data: imageData)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.cardImageView.image = UIImage(systemName: "photo.artframe.circle.fill")?
                            .withRenderingMode(.alwaysOriginal)
                            .withTintColor(.systemGray)
                            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 200,
                                                                           weight: .regular))
                    }
                }
            }
        } else {
            self.cardImageView.image = UIImage(systemName: "photo.artframe.circle.fill")?
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(.systemGray)
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 200,
                                                               weight: .regular))
        }
    }
}
