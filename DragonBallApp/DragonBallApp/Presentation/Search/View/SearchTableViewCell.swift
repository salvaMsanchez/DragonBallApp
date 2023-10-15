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
    
    private let cardView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 20
//        uiView.backgroundColor = UIColor(named: "homeCardBackground")
        uiView.backgroundColor = .systemGray
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBlue
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func cellPressedAnimation() {
        zoomIn()
        zoomOut()
    }
    
    private func setup() {
        addViews()
        applyConstraints()
    }
    
    private func addViews() {
        contentView.addSubview(cardView)
    }
    
    private func applyConstraints() {
        let cardViewConstraints = [
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(cardViewConstraints)
    }
    
}

// MARK: Animations
extension SearchTableViewCell {
    func zoomIn() {
        UIView.animate(
            withDuration: 0.50,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.5
        ) { [weak self] in
            self?.cardView.transform = .identity.scaledBy(x: 0.94, y: 0.94)
        }
    }

    func zoomOut() {
        UIView.animate(
            withDuration: 0.50,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 2
        ) { [weak self] in
            self?.cardView.transform = .identity
        }
    }
}
