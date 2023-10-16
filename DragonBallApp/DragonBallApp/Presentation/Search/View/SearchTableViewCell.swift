//
//  SearchView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {
    // MARK: - Static properties -
    static let identifier = "SearchTableViewCell"
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
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
            gradientAdded = true
        }
    }
    
    // MARK: - Functions -
    public func cellPressedAnimation() {
        zoomIn()
        zoomOut()
    }
    
    private func setup() {
        addViews()
        applyConstraints()
    }
    
    private func addViews() {
        shadowView.addSubview(cardView)
        cardView.addSubview(heroImageView)
        contentView.addSubview(shadowView)
    }
    
    private func applyConstraints() {
        let shadowViewConstraints = [
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ]
        
        let cardViewConstraints = [
            cardView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 2),
            cardView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 2),
            cardView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -2),
            cardView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -2)
        ]
        
        NSLayoutConstraint.activate(shadowViewConstraints)
        NSLayoutConstraint.activate(cardViewConstraints)
    }
    
}

// MARK: - Animations -
extension SearchTableViewCell {
    func zoomIn() {
        UIView.animate(
            withDuration: 0.50,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.5
        ) { [weak self] in
            self?.shadowView.transform = .identity.scaledBy(x: 0.94, y: 0.94)
        }
    }

    func zoomOut() {
        UIView.animate(
            withDuration: 0.50,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 2
        ) { [weak self] in
            self?.shadowView.transform = .identity
        }
    }
}
