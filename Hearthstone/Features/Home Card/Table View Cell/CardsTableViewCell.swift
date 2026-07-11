import UIKit

final class CardsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    lazy var cardContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 38/255, green: 30/255, blue: 26/255, alpha: 1.0) // Deep warm brown
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor(red: 184/255, green: 134/255, blue: 11/255, alpha: 0.4).cgColor // Soft goldenrod border
        view.layer.borderWidth = 1.5
        
        // Shadow
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.35
        view.layer.shadowRadius = 4
        
        return view
    }()
    
    lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 244/255, green: 196/255, blue: 48/255, alpha: 1.0) // Hearthstone Gold
        label.numberOfLines = 2
        return label
    }()
    
    lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = UIColor(red: 244/255, green: 196/255, blue: 48/255, alpha: 1.0)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardNameLabel.text = ""
        cardImageView.image = nil
    }
    
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardContainerView)
        cardContainerView.addSubview(cardImageView)
        cardContainerView.addSubview(cardNameLabel)
        cardContainerView.addSubview(activityIndicator)
        
        let containerPadding: CGFloat = 8.0
        let cardImageSize: CGFloat = 100.0
        let constraints: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            // Container Constraints
            cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: containerPadding),
            cardContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -containerPadding),
            cardContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraints),
            cardContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constraints),
            
            // Subviews inside container
            cardImageView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: constraints),
            cardImageView.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor),
            cardImageView.heightAnchor.constraint(equalToConstant: cardImageSize),
            cardImageView.widthAnchor.constraint(equalToConstant: cardImageSize),
            
            cardNameLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: constraints),
            cardNameLabel.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -constraints),
            cardNameLabel.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: constraints),
            cardNameLabel.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -constraints),
            
            activityIndicator.centerXAnchor.constraint(equalTo: cardImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor)
        ])
    }
    
    func configure(with card: Card) {
        cardNameLabel.text = card.name
        activityIndicator.startAnimating()
        
        guard let imageUrlString = card.img, let imageURL = URL(string: imageUrlString) else {
            activityIndicator.stopAnimating()
            cardImageView.image = UIImage(systemName: "photo.artframe.circle.fill")?
                .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            return
        }
        
        ImageHelper.shared.loadImage(from: imageURL) { [weak self] image in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.cardImageView.image = image
            }
        }
    }
}
