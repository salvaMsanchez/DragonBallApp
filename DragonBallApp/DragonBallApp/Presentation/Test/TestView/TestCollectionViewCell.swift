//
//  TestView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 21/10/23.
//

import UIKit

final class TestCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TestCollectionViewCell"
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBrown
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = cardView.bounds
    }
    
    // MARK: - Functions -
    private func setup() {
        addViews()
        applyConstraints()
    }
    
    private func addViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(heroImageView)
    }
    
    private func applyConstraints() {
        let cardViewConstraints = [
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ]
        
        NSLayoutConstraint.activate(cardViewConstraints)
    }
    
    func configure(image: UIImage!) {
        heroImageView.image = image
    }

}
