//
//  CardsTableViewCell.swift
//  Hearthstone
//
//  Created by Jarede Lima on 29/03/24.
//

import UIKit

final class CardsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var cameraImage = "\(String(describing: UIImage(systemName: "camera")))"
    
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
        let cardImageSize: CGFloat = 100.0
        let constraints: CGFloat = 16.0
        
        contentView.addSubview(cardImageView)
        contentView.addSubview(cardNameLabel)
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            cardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraints),
            cardImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cardImageView.heightAnchor.constraint(equalToConstant: cardImageSize),
            cardImageView.widthAnchor.constraint(equalToConstant: cardImageSize),
            
            cardNameLabel.leadingAnchor.constraint(equalTo: cardImageView.trailingAnchor, constant: constraints),
            cardNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constraints),
            cardNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constraints),
            cardNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constraints),
            
            activityIndicator.centerXAnchor.constraint(equalTo: cardImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: cardImageView.centerYAnchor)
        ])
    }
    
    func configure(with card: Card) {
        cardNameLabel.text = card.name
        activityIndicator.startAnimating()
        
        guard let imageURL = URL(string: card.img ?? cameraImage) else {
            activityIndicator.stopAnimating()
            cardImageView.image = UIImage(systemName: "photo.artframe.circle.fill")
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
