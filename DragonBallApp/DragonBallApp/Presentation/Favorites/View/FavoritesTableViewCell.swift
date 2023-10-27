//
//  FavoritesView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 14/10/23.
//

import UIKit

final class FavoritesTableViewCell: UITableViewCell {
    // MARK: - Static properties -
    static let identifier = "FavoritesTableViewCell"
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let alphaBlackView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .black.withAlphaComponent(0.65)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    private let heroNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    private func setup() {
        addViews()
        applyConstraints()
    }
    
    private func addViews() {
        contentView.addSubview(heroImageView)
        contentView.addSubview(alphaBlackView)
        contentView.addSubview(heroNameLabel)
    }
    
    private func applyConstraints() {
        let heroImageViewConstraints = [
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let alphaBlackViewConstraints = [
            alphaBlackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            alphaBlackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            alphaBlackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            alphaBlackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let heroNameLabelConstraints = [
            heroNameLabel.centerXAnchor.constraint(equalTo: heroImageView.centerXAnchor),
            heroNameLabel.centerYAnchor.constraint(equalTo: heroImageView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(heroImageViewConstraints)
        NSLayoutConstraint.activate(alphaBlackViewConstraints)
        NSLayoutConstraint.activate(heroNameLabelConstraints)
    }
    
    func configure(with model: Hero, index: Int) {
        heroNameLabel.text = model.name
        heroImageView.kf.setImage(with: model.photo)
    }
}
