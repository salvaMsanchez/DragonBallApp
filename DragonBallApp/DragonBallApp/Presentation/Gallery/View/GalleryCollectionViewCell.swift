//
//  GalleryView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit

final class GalleryCollectionViewCell: UICollectionViewCell {
    // MARK: - Static properties -
    static let identifier = "GalleryCollectionViewCell"
    // MARK: - Private properties -
    private var gradientAdded = false
    
    // MARK: - UI components -
    private let shadowView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemOrange.withAlphaComponent(0.5)
        uiView.layer.cornerRadius = 20
        uiView.layer.shadowColor = UIColor.systemOrange.cgColor
        uiView.layer.shadowOpacity = 1
        uiView.layer.shadowOffset = CGSize(width: 0, height: 0)
        uiView.layer.shadowRadius = 10
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    private let cardView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemGray
        uiView.layer.cornerRadius = 20
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: "goku")
        return imageView
    }()
    
    private let heroNameLabel: UILabel = {
        let label = UILabel()
        label.text = "GOKU"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.systemOrange.cgColor
        ]
        gradientLayer.locations = [0.01, 0.1, 0.7, 1.0]
        gradientLayer.frame = cardView.bounds
        gradientLayer.cornerRadius = 20
        cardView.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Initializers -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemBlue
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = cardView.bounds
        
        if !gradientAdded && cardView.bounds != .zero {
            addGradient()
            cardView.addSubview(heroNameLabel)
            gradientAdded = true
        }
    }
    
    // MARK: - Functions -
    private func setup() {
        addViews()
        applyConstraints()
    }
    
    private func addViews() {
        shadowView.addSubview(cardView)
        cardView.addSubview(heroImageView)
        contentView.addSubview(shadowView)
        cardView.addSubview(heroNameLabel)
    }
    
    private func applyConstraints() {
        let shadowViewConstraints = [
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ]
        
        let cardViewConstraints = [
            cardView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 2),
            cardView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 2),
            cardView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -2),
            cardView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -2)
        ]
        
        let heroNameLabelConstraints = [
            heroNameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -6),
            heroNameLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(shadowViewConstraints)
        NSLayoutConstraint.activate(cardViewConstraints)
        NSLayoutConstraint.activate(heroNameLabelConstraints)
    }
}
