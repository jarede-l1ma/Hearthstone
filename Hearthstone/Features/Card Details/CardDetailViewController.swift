import UIKit

final class CardDetailViewController: UIViewController {
    
    // MARK: - Properties
    let card: Card
    
    // MARK: - UI Components
    
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.showsHorizontalScrollIndicator = false
        s.showsVerticalScrollIndicator = false
        s.alwaysBounceHorizontal = false
        s.isDirectionalLockEnabled = true
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
        
        // Let's add a golden shadow or soft glow to the card image
        i.layer.shadowColor = UIColor(red: 244/255, green: 196/255, blue: 48/255, alpha: 0.3).cgColor
        i.layer.shadowOffset = .zero
        i.layer.shadowOpacity = 0.8
        i.layer.shadowRadius = 15
        
        return i
    }()
    
    lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        l.textColor = UIColor(red: 244/255, green: 196/255, blue: 48/255, alpha: 1.0) // Gold
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var flavorLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var cardSetLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var typeLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var factionLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var rarityLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var attackLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var costLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var healthLabel: UILabel = {
        let l = UILabel()
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
        view.backgroundColor = UIColor(red: 25/255, green: 20/255, blue: 18/255, alpha: 1.0) // Hearthstone dark background
        
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
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constraints),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constraints),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            cardImageView.heightAnchor.constraint(equalToConstant: 320) // Give the detail card image a premium size!
        ])
    }
    
    func updateUI() {
        nameLabel.text = card.name
        
        // Define common colors
        let goldColor = UIColor(red: 244/255, green: 196/255, blue: 48/255, alpha: 1.0)
        let lightColor = UIColor(red: 230/255, green: 220/255, blue: 210/255, alpha: 1.0)
        let secondaryGold = UIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 0.8)
        
        // Format and render labels with HTML converting to NSAttributedString
        flavorLabel.attributedText = "<i>\"\(card.flavor ?? "Unknown flavor text.")\"</i>"
            .htmlToAttributedString(fontSize: 16, color: secondaryGold)
            
        descriptionLabel.attributedText = "<b>Description:</b> \(card.text ?? "Normal card.")"
            .htmlToAttributedString(fontSize: 18, color: lightColor)
            
        cardSetLabel.attributedText = "<b>Set:</b> \(card.cardSet ?? "Unknown")"
            .htmlToAttributedString(fontSize: 18, color: lightColor)
            
        typeLabel.attributedText = "<b>Type:</b> \(card.type ?? "Unknown")"
            .htmlToAttributedString(fontSize: 18, color: lightColor)
            
        factionLabel.attributedText = "<b>Faction:</b> \(card.faction ?? "Unknown")"
            .htmlToAttributedString(fontSize: 18, color: lightColor)
            
        rarityLabel.attributedText = "<b>Rarity:</b> \(card.rarity ?? "Unknown")"
            .htmlToAttributedString(fontSize: 18, color: lightColor)
            
        attackLabel.attributedText = "<b>Attack:</b> \(card.attack.map { String($0) } ?? "Unknown")"
            .htmlToAttributedString(fontSize: 18, color: lightColor)
            
        costLabel.attributedText = "<b>Cost:</b> \(card.cost.map { String($0) } ?? "Unknown")"
            .htmlToAttributedString(fontSize: 18, color: lightColor)
            
        healthLabel.attributedText = "<b>Health:</b> \(card.health.map { String($0) } ?? "Unknown")"
            .htmlToAttributedString(fontSize: 18, color: lightColor)
            
        // Premium load image with caching and visual placeholder
        let placeholderImage = UIImage(systemName: "photo.artframe.circle.fill")?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            
        guard let imageUrlString = card.img, let imageUrl = URL(string: imageUrlString) else {
            self.cardImageView.image = placeholderImage
            return
        }
        
        ImageHelper.shared.loadImage(from: imageUrl) { [weak self] image in
            DispatchQueue.main.async {
                self?.cardImageView.image = image ?? placeholderImage
            }
        }
    }
}
