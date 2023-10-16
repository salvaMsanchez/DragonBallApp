//
//  DetailView.swift
//  DragonBallApp
//
//  Created by Salva Moreno on 16/10/23.
//

import UIKit

final class DetailView: UIView {
    // MARK: - UI components -
    private let heroImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "goku")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionHeroUiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .systemRed
        uiView.layer.cornerRadius = 20
        uiView.layer.borderColor = UIColor.blue.cgColor
        uiView.layer.borderWidth = 3
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    // MARK: - Initializers -
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemMint
        
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
        addSubview(heroImage)
        addSubview(descriptionHeroUiView)
    }
    
    private func applyConstraints() {
        
        let heroImageConstraints = [
            heroImage.topAnchor.constraint(equalTo: topAnchor, constant: 104),
            heroImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            heroImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            heroImage.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        let descriptionHeroUiViewConstraints = [
            descriptionHeroUiView.topAnchor.constraint(equalTo: heroImage.bottomAnchor, constant: 16),
            descriptionHeroUiView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionHeroUiView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionHeroUiView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
        ]
        
        NSLayoutConstraint.activate(heroImageConstraints)
        NSLayoutConstraint.activate(descriptionHeroUiViewConstraints)
    }
    
}
