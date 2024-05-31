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
    
    lazy var backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.showsHorizontalScrollIndicator = false
        s.showsVerticalScrollIndicator = false
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
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constraints),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constraints),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func updateUI() {
        nameLabel.text = card.name
        flavorLabel.text = "Flavor: \(card.flavor ?? "Unknown")"
        descriptionLabel.text = "Description: \(card.text ?? "Unknown")"
        cardSetLabel.text = "Set: \(card.cardSet ?? "Unknown")"
        typeLabel.text = "Type: \(card.type ?? "Unknown")"
        factionLabel.text = "Faction: \(card.faction ?? "Unknown")"
        rarityLabel.text = "Rarity: \(card.rarity ?? "Unknown")"
        attackLabel.text = "Attack: \(card.attack.map { String($0) } ?? "Unknown")"
        costLabel.text = "Cost: \(card.cost.map { String($0) } ?? "Unknown")"
        healthLabel.text = "Health: \(card.health.map { String($0) } ?? "Unknown")"
        
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
